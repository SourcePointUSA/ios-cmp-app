//
//  SourcepointClientCoordinator.swift
//  Pods
//
//  Created by Andre Herculano on 14.09.22.
//
// swiftlint:disable type_body_length file_length

import Foundation

typealias LoadMessagesReturnType = ([MessageToDisplay], SPUserData)
typealias MessagesAndConsentsHandler = (Result<LoadMessagesReturnType, SPError>) -> Void
typealias GDPRCustomConsentHandler = (Result<SPGDPRConsent, SPError>) -> Void

struct MessageToDisplay {
    let message: Message
    let metadata: MessageMetaData
    let url: URL
    let type: SPCampaignType
    let childPmId: String?
}

extension MessageToDisplay {
    init?(_ campaign: Campaign) {
        guard let message = campaign.message,
                let metadata = campaign.messageMetaData,
                let url = campaign.url
        else {
            return nil
        }

        self.message = message
        self.metadata = metadata
        self.url = url
        self.type = campaign.type
        // TODO: add childPMId if possible
        self.childPmId = nil
    }
}

protocol SPClientCoordinator {
    var authId: String? { get set }
    var userData: SPUserData { get }

    func loadMessages(_ handler: @escaping MessagesAndConsentsHandler)
    func reportAction(_ action: SPAction, handler: @escaping (Result<SPUserData, SPError>) -> Void)
    func reportIdfaStatus(status: SPIDFAStatus, osVersion: String)
    func logErrorMetrics(_ error: SPError, osVersion: String, deviceFamily: String)
    func deleteCustomConsentGDPR(
        vendors: [String],
        categories: [String],
        legIntCategories: [String],
        handler: @escaping (Result<SPGDPRConsent, SPError>) -> Void
    )
    func customConsentGDPR(
        vendors: [String],
        categories: [String],
        legIntCategories: [String],
        handler: @escaping GDPRCustomConsentHandler
    )
    func setRequestTimeout(_ timeout: TimeInterval)
}

class SourcepointClientCoordinator: SPClientCoordinator {
    static let sampleRate = 1

    struct State: Codable {
        struct GDPRMetaData: Codable {
            var additionsChangeDate, legalBasisChangeDate: SPDateCreated
        }

        struct AttCampaign: Codable {
            var lastMessage: LastMessageData?
        }

        var gdpr: SPGDPRConsent?
        var ccpa: SPCCPAConsent?
        var ios14: AttCampaign?
        var gdprMetadata: GDPRMetaData?
        var wasSampled: Bool?
        var localState: SPJson?
        var nonKeyedLocalState: SPJson?

        mutating func udpateGDPRStatus() {
            guard let gdpr = gdpr, let gdprMetadata = gdprMetadata else { return }
            var shouldUpdateConsentedAll = false
            if gdpr.dateCreated.date < gdprMetadata.additionsChangeDate.date {
                self.gdpr?.consentStatus.vendorListAdditions = true
                shouldUpdateConsentedAll = true
            }
            if gdpr.dateCreated.date < gdprMetadata.legalBasisChangeDate.date {
                self.gdpr?.consentStatus.legalBasisChanges = true
                shouldUpdateConsentedAll = true
            }
            if self.gdpr?.consentStatus.consentedAll == true, shouldUpdateConsentedAll {
                self.gdpr?.consentStatus.granularStatus?.previousOptInAll = true
                self.gdpr?.consentStatus.consentedAll = false
            }
        }
    }

    let accountId, propertyId: Int
    let propertyName: SPPropertyName
    var authId: String?
    let language: SPMessageLanguage
    var idfaStatus: SPIDFAStatus { SPIDFAStatus.current() }
    let campaigns: SPCampaigns
    var pubData: SPPublisherData

    let spClient: SourcePointProtocol
    var storage: SPLocalStorage

    var state: State

    var gdprUUID: String? { state.gdpr?.uuid }
    var ccpaUUID: String? { state.ccpa?.uuid }

    /// Checks if this user has data from the previous version of the SDK (v6).
    /// This check should only done once so we remove the data stored by the older SDK and return false after that.
    var migratingUser: Bool {
        if storage.localState == nil || storage.localState == .null {
            return false
        } else {
            storage.localState = nil
            return true
        }
    }

    var shouldCallConsentStatus: Bool {
        authId != nil || migratingUser
    }

    var shouldCallMessages: Bool {
        (state.gdpr?.applies == true && state.gdpr?.consentStatus.consentedAll != true) ||
        state.ccpa?.applies == true ||
        campaigns.ios14 != nil
    }

    var metaDataParamsFromState: MetaDataBodyRequest {
        .init(
            gdpr: campaigns.gdpr != nil ?
                    .init(
                        hasLocalData: state.gdpr?.uuid != nil,
                        dateCreated: state.gdpr?.dateCreated,
                        uuid: state.gdpr?.uuid
                    ) :
                    nil,
            ccpa: campaigns.ccpa != nil ?
                .init(
                    hasLocalData: state.ccpa?.uuid != nil,
                    dateCreated: state.ccpa?.dateCreated,
                    uuid: state.ccpa?.uuid
                ) :
                nil
        )
    }

    var pvDataBodyFromState: PvDataRequestBody {
        var gdpr: PvDataRequestBody.GDPR?
        var ccpa: PvDataRequestBody.CCPA?
        if let stateGDPR = state.gdpr {
            gdpr = PvDataRequestBody.GDPR(
                applies: stateGDPR.applies,
                uuid: stateGDPR.uuid,
                accountId: accountId,
                siteId: propertyId,
                consentStatus: stateGDPR.consentStatus,
                pubData: pubData,
                sampleRate: SourcepointClientCoordinator.sampleRate,
                euconsent: stateGDPR.euconsent,
                msgId: stateGDPR.lastMessage?.id,
                categoryId: stateGDPR.lastMessage?.categoryId,
                subCategoryId: stateGDPR.lastMessage?.subCategoryId,
                prtnUUID: stateGDPR.lastMessage?.partitionUUID
            )
        }
        if let stateCCPA = state.ccpa {
            ccpa = .init(
                applies: stateCCPA.applies,
                uuid: stateCCPA.uuid,
                accountId: accountId,
                siteId: propertyId,
                consentStatus: stateCCPA.consentStatus,
                pubData: pubData,
                messageId: stateCCPA.lastMessage?.id,
                sampleRate: SourcepointClientCoordinator.sampleRate
            )
        }
        return .init(gdpr: gdpr, ccpa: ccpa)
    }

    var messagesParamsFromState: MessagesRequest {
        .init(
            body: .init(
                propertyHref: propertyName,
                accountId: accountId,
                campaigns: .init(
                    ccpa: campaigns.ccpa != nil ?
                    .init(
                        targetingParams: campaigns.gdpr?.targetingParams,
                        hasLocalData: state.ccpa?.uuid != nil,
                        status: state.ccpa?.status
                    ) : nil,
                    gdpr: campaigns.gdpr != nil ? .init(
                        targetingParams: campaigns.gdpr?.targetingParams,
                        hasLocalData: state.gdpr?.uuid != nil,
                        consentStatus: state.gdpr?.consentStatus
                    ) : nil,
                    ios14: campaigns.ios14 != nil ? .init(
                        targetingParams: campaigns.ios14?.targetingParams,
                        idfaSstatus: idfaStatus
                    ) : nil
                ),
                localState: state.localState,
                consentLanguage: language,
                campaignEnv: campaigns.environment,
                idfaStatus: idfaStatus
            ),
            metadata: .init(
                ccpa: .init(applies: state.ccpa?.applies),
                gdpr: .init(applies: state.gdpr?.applies)
            ),
            nonKeyedLocalState: state.nonKeyedLocalState
        )
    }

    var userData: SPUserData {
        SPUserData(
            gdpr: campaigns.gdpr != nil ?
                .init(consents: state.gdpr, applies: state.gdpr?.applies ?? false) :
                nil,
            ccpa: campaigns.ccpa != nil ?
                .init(consents: state.ccpa, applies: state.ccpa?.applies ?? false) :
                nil
        )
    }

    init(
        accountId: Int,
        propertyName: SPPropertyName,
        propertyId: Int,
        authId: String? = nil,
        language: SPMessageLanguage = .BrowserDefault,
        campaigns: SPCampaigns,
        pubData: SPPublisherData = SPPublisherData(),
        storage: SPLocalStorage = SPUserDefaults(),
        spClient: SourcePointProtocol? = nil
    ) {
        self.accountId = accountId
        self.propertyId = propertyId
        self.propertyName = propertyName
        self.authId = authId
        self.language = language
        self.campaigns = campaigns
        self.pubData = pubData
        self.storage = storage

        self.state = self.storage.spState ?? .init()
        if campaigns.gdpr != nil, self.state.gdpr == nil {
            self.state.gdpr = .empty()
        }
        if campaigns.ccpa != nil, self.state.ccpa == nil {
            self.state.ccpa = .empty()
        }
        if campaigns.ios14 != nil, self.state.ios14 == nil {
            self.state.ios14 = .init()
        }

        guard let spClient = spClient else {
            self.spClient = SourcePointClient(
                accountId: accountId,
                propertyName: propertyName,
                campaignEnv: campaigns.environment,
                timeout: SPConsentManager.DefaultTimeout
            )
            return
        }
        self.spClient = spClient
    }

    func loadMessages(_ handler: @escaping MessagesAndConsentsHandler) {
        metaData {
            self.consentStatus {
                self.state.udpateGDPRStatus()
                self.messages(handler)
            }
        }
        pvData()
    }

    func handleMetaDataResponse(_ response: MetaDataResponse) {
        if let gdprMetaData = response.gdpr {
            state.gdpr?.applies = gdprMetaData.applies
            state.gdprMetadata = .init(
                additionsChangeDate: gdprMetaData.additionsChangeDate,
                legalBasisChangeDate: gdprMetaData.legalBasisChangeDate
            )
        }
        if let ccpaMetaData = response.ccpa {
            state.ccpa?.applies = ccpaMetaData.applies
        }
        storage.spState = state
    }

    func metaData(next: @escaping () -> Void) {
        spClient.metaData(
            accountId: accountId,
            propertyId: propertyId,
            metadata: metaDataParamsFromState
        ) { result in
            switch result {
                case .success(let response):
                    self.handleMetaDataResponse(response)
                case .failure(let error):
                    print(error)
            }
            next()
        }
    }

    func consentStatusMetadataFromState(_ campaign: CampaignConsent?) -> ConsentStatusMetaData.Campaign? {
        guard let campaign = campaign else { return nil }
        return ConsentStatusMetaData.Campaign(
            hasLocalData: true,
            applies: campaign.applies,
            dateCreated: campaign.dateCreated,
            uuid: campaign.uuid
        )
    }

    func handleConsentStatusResponse(_ response: ConsentStatusResponse) {
        state.localState = response.localState
        state.gdpr = SPGDPRConsent(from: response.consentStatusData.gdpr)
        state.ccpa = SPCCPAConsent(from: response.consentStatusData.ccpa)
        storage.spState = state
    }

    func consentStatus(next: @escaping () -> Void) {
        if shouldCallConsentStatus {
            spClient.consentStatus(
                propertyId: propertyId,
                metadata: .init(
                    gdpr: consentStatusMetadataFromState(state.gdpr),
                    ccpa: consentStatusMetadataFromState(state.ccpa)
                ),
                authId: authId
            ) { result in
                switch result {
                    case .success(let response):
                        self.handleConsentStatusResponse(response)
                    case .failure(let error):
                        print(error)
                }
                next()
            }
        } else {
            next()
        }
    }

    func handleMessagesResponse(_ response: MessagesResponse) -> LoadMessagesReturnType {
        state.localState = response.localState
        state.nonKeyedLocalState = response.nonKeyedLocalState
        let messages = response.campaigns.compactMap { MessageToDisplay($0) }
        messages.forEach {
            if $0.type == .gdpr {
                state.gdpr?.lastMessage = LastMessageData(from: $0.metadata)
            } else if $0.type == .ccpa {
                state.ccpa?.lastMessage = LastMessageData(from: $0.metadata)
            } else if $0.type == .ios14 {
                state.ios14?.lastMessage = LastMessageData(from: $0.metadata)
            }
        }
        // TODO: store consents if any comes in the response
        storage.spState = state
        return (messages, userData)
    }

    func messages(_ handler: @escaping MessagesAndConsentsHandler) {
        if shouldCallMessages {
            spClient.getMessages(messagesParamsFromState) { result in
                switch result {
                    case .success(let response):
                        handler(Result.success(self.handleMessagesResponse(response)))
                    case .failure(let error):
                        handler(Result.failure(error))
                }
            }
        } else {
            handler(Result.success(([], userData)))
        }
    }

    func sample(_ lambda: (Bool) -> Void, at percentage: Int = sampleRate) {
        let hit = 1...percentage ~= Int.random(in: 1...100)
        lambda(hit)
    }

    func pvData() {
        guard let wasSampled = state.wasSampled else {
            sample { hit in
                if hit {
                    spClient.pvData(pvDataBodyFromState)
                }
                state.wasSampled = hit
            }
            return
        }

        if wasSampled {
            spClient.pvData(pvDataBodyFromState)
        }
    }

    func handleGetChoices(_ response: ChoiceAllResponse, from campaign: SPCampaignType) {
        if let gdpr = response.gdpr, campaign == .gdpr {
            state.gdpr?.dateCreated = gdpr.dateCreated ?? (state.gdpr?.dateCreated ?? SPDateCreated.now()) // TODO: remove once response.gdpr contains date created
            state.gdpr?.tcfData = gdpr.TCData
            state.gdpr?.vendorGrants = gdpr.grants
            state.gdpr?.euconsent = gdpr.euconsent
            state.gdpr?.consentStatus = gdpr.consentStatus
            state.gdpr?.childPmId = gdpr.childPmId
        }
        if let ccpa = response.ccpa, campaign == .ccpa {
            state.ccpa?.dateCreated = ccpa.dateCreated
            state.ccpa?.status = ccpa.status
        }
        storage.spState = state
    }

    func getChoiceAll(_ action: SPAction, handler: @escaping (Result<ChoiceAllResponse?, SPError>) -> Void) {
        if action.type == .AcceptAll || action.type == .RejectAll {
            spClient.choiceAll(
                actionType: action.type,
                accountId: accountId,
                propertyId: propertyId,
                metadata: .init(
                    gdpr: campaigns.gdpr != nil ? .init(applies: state.gdpr?.applies ?? false) : nil,
                    ccpa: campaigns.ccpa != nil ? .init(applies: state.ccpa?.applies ?? false) : nil
                )
            ) { result in
                switch result {
                    case .success(let response):
                        self.handleGetChoices(response, from: action.campaignType)
                        handler(Result.success(response))
                    case .failure(let error):
                        handler(Result.failure(error))
                }
            }
        } else {
            handler(Result.success(nil))
        }
    }

    func postChoice(
        _ action: SPAction,
        postPayloadFromGetCall: ChoiceAllResponse.GDPR.PostPayload?,
        handler: @escaping (Result<GDPRChoiceResponse, SPError>) -> Void
    ) {
        spClient.postGDPRAction(
            actionType: action.type,
            body: GDPRChoiceBody(
                authId: authId,
                uuid: state.gdpr?.uuid,
                messageId: String(state.gdpr?.lastMessage?.id ?? 0),
                consentAllRef: postPayloadFromGetCall?.consentAllRef,
                vendorListId: postPayloadFromGetCall?.vendorListId,
                pubData: action.publisherData,
                pmSaveAndExitVariables: action.pmPayload,
                propertyId: propertyId,
                sampleRate: SourcepointClientCoordinator.sampleRate,
                idfaStatus: idfaStatus,
                granularStatus: postPayloadFromGetCall?.granularStatus
            )
        ) { handler($0) }
    }

    func postChoice(
        _ action: SPAction,
        handler: @escaping (Result<CCPAChoiceResponse, SPError>) -> Void
    ) {
        spClient.postCCPAAction(
            actionType: action.type,
            body: .init(
                authId: authId,
                uuid: state.ccpa?.uuid,
                messageId: String(state.ccpa?.lastMessage?.id ?? 0),
                pubData: action.publisherData,
                pmSaveAndExitVariables: action.pmPayload,
                propertyId: propertyId,
                sampleRate: SourcepointClientCoordinator.sampleRate
            )
        ) { handler($0) }
    }

    func reportAction(_ action: SPAction, handler: @escaping (Result<SPUserData, SPError>) -> Void) {
        getChoiceAll(action) { getResult in
            switch getResult {
                case .success(let getResponse):
                    if action.campaignType == .gdpr {
                        self.postChoice(action, postPayloadFromGetCall: getResponse?.gdpr?.postPayload) { postResult in
                            switch postResult {
                                case .success(let response):
                                    self.state.gdpr?.uuid = response.uuid
                                    self.state.gdpr?.dateCreated = response.dateCreated
                                    self.state.gdpr?.tcfData = response.TCData
                                    self.state.gdpr?.consentStatus = response.consentStatus ?? getResponse?.gdpr?.consentStatus ?? ConsentStatus()
                                    self.state.gdpr?.euconsent = response.euconsent ?? getResponse?.gdpr?.euconsent ?? ""
                                    self.state.gdpr?.vendorGrants = response.grants ?? getResponse?.gdpr?.grants ?? SPGDPRVendorGrants()
                                    self.storage.spState = self.state
                                    handler(Result.success(self.userData))
                                case .failure(let error):
                                    // flag to sync again later
                                    handler(Result.failure(error))
                            }
                        }
                    } else if action.campaignType == .ccpa {
                        self.postChoice(action) { postResult in
                            switch postResult {
                                case .success(let response):
                                    self.state.ccpa?.uuid = response.uuid
                                    self.state.ccpa?.dateCreated = response.dateCreated
                                    self.state.ccpa?.status = response.status ?? getResponse?.ccpa?.status ?? .RejectedAll
                                    self.state.ccpa?.rejectedVendors = response.rejectedVendors ?? getResponse?.ccpa?.rejectedVendors ?? []
                                    self.state.ccpa?.rejectedCategories = response.rejectedCategories ?? getResponse?.ccpa?.rejectedCategories ?? []
                                    self.state.ccpa?.uspstring = response.uspstring ?? getResponse?.ccpa?.uspstring ?? ""

//                                    self.state.ccpa?.consentStatus
                                    self.storage.spState = self.state
                                    handler(Result.success(self.userData))
                                case .failure(let error):
                                    // flag to sync again later
                                    handler(Result.failure(error))
                            }
                        }
                    }
                case .failure(let error):
                    handler(Result.failure(error))
            }
        }
    }

    func reportIdfaStatus(status: SPIDFAStatus, osVersion: String) {
        var uuid = ""
        var uuidType: SPCampaignType?
        if let gdprUUID = gdprUUID, gdprUUID.isNotEmpty() {
            uuid = gdprUUID
            uuidType = .gdpr
        }
        if let ccpaUUID = ccpaUUID, ccpaUUID.isNotEmpty() {
            uuid = ccpaUUID
            uuidType = .ccpa
        }
        spClient.reportIdfaStatus(
            propertyId: propertyId,
            uuid: uuid,
            uuidType: uuidType,
            messageId: state.ios14?.lastMessage?.id,
            idfaStatus: status,
            iosVersion: osVersion,
            partitionUUID: state.ios14?.lastMessage?.partitionUUID
        )
    }

    func logErrorMetrics(_ error: SPError, osVersion: String, deviceFamily: String) {
        spClient.errorMetrics(
            error,
            propertyId: propertyId,
            sdkVersion: SPConsentManager.VERSION,
            OSVersion: osVersion,
            deviceFamily: deviceFamily,
            campaignType: error.campaignType
        )
    }

    func handleAddOrDeleteCustomConsentResponse(
        _ result: Result<AddOrDeleteCustomConsentResponse, SPError>,
        handler: @escaping GDPRCustomConsentHandler
    ) {
        switch result {
            case .success(let consents):
                state.gdpr?.vendorGrants = consents.grants
                storage.spState = state
                handler(Result.success(state.gdpr ?? .empty()))
            case .failure(let error):
                handler(Result.failure((error)))
        }
    }

    func deleteCustomConsentGDPR(
        vendors: [String],
        categories: [String],
        legIntCategories: [String],
        handler: @escaping GDPRCustomConsentHandler
    ) {
        guard let gdprUUID = self.gdprUUID, gdprUUID.isNotEmpty() else {
            handler(Result.failure(PostingConsentWithoutConsentUUID()))
            return
        }
        spClient.deleteCustomConsentGDPR(
            toConsentUUID: gdprUUID,
            vendors: vendors,
            categories: categories,
            legIntCategories: legIntCategories,
            propertyId: propertyId
        ) {
            self.handleAddOrDeleteCustomConsentResponse($0, handler: handler)
        }
    }

    func customConsentGDPR(
        vendors: [String],
        categories: [String],
        legIntCategories: [String],
        handler: @escaping GDPRCustomConsentHandler
    ) {
        guard let gdprUUID = self.gdprUUID, gdprUUID.isNotEmpty() else {
            handler(Result.failure(PostingConsentWithoutConsentUUID()))
        return
        }
        spClient.customConsentGDPR(
            toConsentUUID: gdprUUID,
            vendors: vendors,
            categories: categories,
            legIntCategories: legIntCategories,
            propertyId: propertyId
        ) {
            self.handleAddOrDeleteCustomConsentResponse($0, handler: handler)
        }
    }

    func setRequestTimeout(_ timeout: TimeInterval) {
        spClient.setRequestTimeout(timeout)
    }
}
