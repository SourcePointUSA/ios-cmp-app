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
typealias ActionHandler = (Result<SPUserData, SPError>) -> Void

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
    var deviceManager: SPDeviceManager { get set }
    var userData: SPUserData { get }
    var language: SPMessageLanguage { get set }

    func loadMessages(forAuthId: String?, _ handler: @escaping MessagesAndConsentsHandler)
    func reportAction(_ action: SPAction, handler: @escaping (Result<SPUserData, SPError>) -> Void)
    func reportIdfaStatus(status: SPIDFAStatus, osVersion: String)
    func logErrorMetrics(_ error: SPError)
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

protocol SPSampleable {
    var sampleRate: Float { get set }
    var wasSampled: Bool? { get set }
    var wasSampledAt: Float? { get set }
    mutating func updateSampleFields(_ newSampleRate: Float)
}

extension SPSampleable {
    mutating func updateSampleFields(_ newSampleRate: Float) {
        sampleRate = newSampleRate
        if sampleRate != wasSampledAt {
            wasSampledAt = sampleRate
            wasSampled = nil
        }
    }
}

class SourcepointClientCoordinator: SPClientCoordinator {
    struct State: Codable {
        struct GDPRMetaData: Codable, SPSampleable, Equatable {
            var additionsChangeDate = SPDateCreated.now()
            var legalBasisChangeDate = SPDateCreated.now()
            var sampleRate = Float(1)
            var wasSampled: Bool?
            var wasSampledAt: Float?
        }

        struct CCPAMetaData: Codable, SPSampleable, Equatable {
            var sampleRate = Float(1)
            var wasSampled: Bool?
            var wasSampledAt: Float?
        }

        struct AttCampaign: Codable {
            var lastMessage: LastMessageData?
            var status: SPIDFAStatus { SPIDFAStatus.current() }
        }

        var gdpr: SPGDPRConsent?
        var ccpa: SPCCPAConsent?
        var ios14: AttCampaign?
        var gdprMetaData: GDPRMetaData?
        var ccpaMetaData: CCPAMetaData?
        var localState: SPJson?
        var nonKeyedLocalState: SPJson?
        var storedAuthId: String?

        mutating func udpateGDPRStatus() {
            guard let gdpr = gdpr, let gdprMetadata = gdprMetaData else { return }
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
    var language: SPMessageLanguage
    var idfaStatus: SPIDFAStatus { SPIDFAStatus.current() }
    let campaigns: SPCampaigns
    var pubData: SPPublisherData

    var deviceManager: SPDeviceManager
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
            state.gdpr?.uuid = storage.localState?["gdpr"]?["uuid"]?.stringValue
            state.ccpa?.uuid = storage.localState?["ccpa"]?["uuid"]?.stringValue
            storage.localState = nil
            return true
        }
    }

    var shouldCallConsentStatus: Bool {
        authId != nil || migratingUser
    }

    var shouldCallMessages: Bool {
        (campaigns.gdpr != nil && state.gdpr?.consentStatus.consentedAll != true) ||
        campaigns.ccpa != nil ||
        (campaigns.ios14 != nil && state.ios14?.status != .accepted)
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

    var ccpaPvDataBodyFromState: PvDataRequestBody {
        var ccpa: PvDataRequestBody.CCPA?
        if let stateCCPA = state.ccpa {
            ccpa = .init(
                applies: stateCCPA.applies,
                uuid: stateCCPA.uuid,
                accountId: accountId,
                siteId: propertyId,
                consentStatus: stateCCPA.consentStatus,
                pubData: pubData,
                messageId: stateCCPA.lastMessage?.id,
                sampleRate: state.ccpaMetaData?.sampleRate
            )
        }
        return .init(ccpa: ccpa)
    }
    var gdprPvDataBodyFromState: PvDataRequestBody {
        var gdpr: PvDataRequestBody.GDPR?
        if let stateGDPR = state.gdpr {
            gdpr = PvDataRequestBody.GDPR(
                applies: stateGDPR.applies,
                uuid: stateGDPR.uuid,
                accountId: accountId,
                siteId: propertyId,
                consentStatus: stateGDPR.consentStatus,
                pubData: pubData,
                sampleRate: state.gdprMetaData?.sampleRate,
                euconsent: stateGDPR.euconsent,
                msgId: stateGDPR.lastMessage?.id,
                categoryId: stateGDPR.lastMessage?.categoryId,
                subCategoryId: stateGDPR.lastMessage?.subCategoryId,
                prtnUUID: stateGDPR.lastMessage?.partitionUUID
            )
        }
        return .init(gdpr: gdpr)
    }

    var messagesParamsFromState: MessagesRequest {
        .init(
            body: .init(
                propertyHref: propertyName,
                accountId: accountId,
                campaigns: .init(
                    ccpa: campaigns.ccpa != nil ?
                    .init(
                        targetingParams: campaigns.ccpa?.targetingParams,
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
                consentLanguage: language,
                campaignEnv: campaigns.environment,
                idfaStatus: idfaStatus
            ),
            metadata: .init(
                ccpa: .init(applies: state.ccpa?.applies),
                gdpr: .init(applies: state.gdpr?.applies)
            ),
            localState: .init(localState: state.localState),
            nonKeyedLocalState: .init(nonKeyedLocalState: state.nonKeyedLocalState)
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
        language: SPMessageLanguage = .BrowserDefault,
        campaigns: SPCampaigns,
        pubData: SPPublisherData = SPPublisherData(),
        storage: SPLocalStorage = SPUserDefaults(),
        spClient: SourcePointProtocol? = nil,
        deviceManager: SPDeviceManager = SPDevice.standard
    ) {
        self.accountId = accountId
        self.propertyId = propertyId
        self.propertyName = propertyName
        self.language = language
        self.campaigns = campaigns
        self.pubData = pubData
        self.storage = storage
        self.spClient = spClient ?? SourcePointClient(
            accountId: accountId,
            propertyName: propertyName,
            campaignEnv: campaigns.environment,
            timeout: SPConsentManager.DefaultTimeout
        )
        self.deviceManager = deviceManager

        self.state = Self.setupState(from: storage, campaigns: campaigns)
        self.storage.spState = self.state
    }

    static func setupState(from localStorage: SPLocalStorage, campaigns localCampaigns: SPCampaigns) -> State {
        var localState = localStorage.spState ?? .init()
        if localCampaigns.gdpr != nil, localState.gdpr == nil {
            localState.gdpr = .empty()
            localState.gdprMetaData = .init()
        }
        if localCampaigns.ccpa != nil, localState.ccpa == nil {
            localState.ccpa = .empty()
            localState.ccpaMetaData = .init()
        }
        if localCampaigns.ios14 != nil, localState.ios14 == nil {
            localState.ios14 = .init()
        }
        return localState
    }

    /// Resets state if the authId has changed, except if the stored auth id was empty.
    func resetStateIfAuthIdChanged() {
        if state.storedAuthId == nil {
            state.storedAuthId = authId
        }

        if authId != nil, state.storedAuthId != authId {
            state.storedAuthId = authId
            if campaigns.gdpr != nil {
                state.gdpr = .empty()
                state.gdprMetaData = .init()
            }
            if campaigns.ccpa != nil {
                state.ccpa = .empty()
                state.ccpaMetaData = .init()
            }
        }

        storage.spState = state
    }

    func loadMessages(forAuthId authId: String?, _ handler: @escaping MessagesAndConsentsHandler) {
        self.authId = authId
        resetStateIfAuthIdChanged()
        metaData {
            self.consentStatus {
                self.state.udpateGDPRStatus()
                self.messages { messagesResponse in
                    self.pvData {
                        handler(messagesResponse)
                    }
                }
            }
        }
    }

    func handleMetaDataResponse(_ response: MetaDataResponse) {
        if let gdprMetaData = response.gdpr {
            state.gdpr?.applies = gdprMetaData.applies
            state.gdprMetaData?.additionsChangeDate = gdprMetaData.additionsChangeDate
            state.gdprMetaData?.legalBasisChangeDate = gdprMetaData.legalBasisChangeDate
            state.gdprMetaData?.updateSampleFields(gdprMetaData.sampleRate)
        }
        if let ccpaMetaData = response.ccpa {
            state.ccpa?.applies = ccpaMetaData.applies
            state.ccpaMetaData?.updateSampleFields(ccpaMetaData.sampleRate)
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
                    self.logErrorMetrics(error)
            }
            next()
        }
    }

    func consentStatusMetadataFromState(_ campaign: CampaignConsent?) -> ConsentStatusMetaData.Campaign? {
        guard let campaign = campaign else { return nil }
        return ConsentStatusMetaData.Campaign(
            hasLocalData: false, // campaign.uuid != nil,
            applies: campaign.applies,
            dateCreated: campaign.dateCreated,
            uuid: campaign.uuid
        )
    }

    func handleConsentStatusResponse(_ response: ConsentStatusResponse) {
        state.localState = response.localState
        if let gdpr = response.consentStatusData.gdpr {
            state.gdpr?.uuid = gdpr.uuid
            state.gdpr?.vendorGrants = gdpr.grants
            state.gdpr?.dateCreated = gdpr.dateCreated
            state.gdpr?.euconsent = gdpr.euconsent
            state.gdpr?.tcfData = gdpr.TCData
            state.gdpr?.consentStatus = gdpr.consentStatus
            state.gdpr?.childPmId = nil
            state.gdpr?.webConsentPayload = gdpr.webConsentPayload
        }
        if let ccpa = response.consentStatusData.ccpa {
            state.ccpa?.uuid = ccpa.uuid
            state.ccpa?.dateCreated = ccpa.dateCreated
            state.ccpa?.status = ccpa.status
            state.ccpa?.uspstring = ccpa.uspstring
            state.ccpa?.rejectedVendors = ccpa.rejectedVendors
            state.ccpa?.rejectedCategories = ccpa.rejectedCategories
            state.ccpa?.consentStatus = ConsentStatus(
                rejectedVendors: ccpa.rejectedVendors,
                rejectedCategories: ccpa.rejectedCategories
            )
            state.ccpa?.childPmId = nil
            state.ccpa?.webConsentPayload = ccpa.webConsentPayload
        }
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
                        self.logErrorMetrics(error)
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

        response.campaigns.forEach {
            if $0.type == .gdpr {
                switch $0.userConsent {
                    case .gdpr(let consents):
                        state.gdpr?.uuid = consents.uuid
                        state.gdpr?.dateCreated = consents.dateCreated
                        state.gdpr?.tcfData = consents.tcfData
                        state.gdpr?.vendorGrants = consents.vendorGrants
                        state.gdpr?.euconsent = consents.euconsent
                        state.gdpr?.consentStatus = consents.consentStatus
                        state.gdpr?.childPmId = consents.childPmId
                        state.gdpr?.webConsentPayload = $0.webConsentPayload
                    default: break
                }
            } else if $0.type == .ccpa {
                switch $0.userConsent {
                    case .ccpa(let consents):
                        state.ccpa?.uuid = consents.uuid
                        state.ccpa?.dateCreated = consents.dateCreated
                        state.ccpa?.status = consents.status
                        state.ccpa?.rejectedVendors = consents.rejectedVendors
                        state.ccpa?.rejectedCategories = consents.rejectedCategories
                        state.ccpa?.uspstring = consents.uspstring
                        state.ccpa?.childPmId = consents.childPmId
                        state.ccpa?.webConsentPayload = $0.webConsentPayload
                    default: break
                }
            }
        }

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

    /// rate is a float ranging from 0.0 to 1.0
    /// sample will generate a number from 1 to 100 and if that number
    /// is inside the given range 1...rate*100, it returns `true` otherwise `false`
    func sample(at rate: Float) -> Bool {
        1...Int(rate * 100) ~= Int.random(in: 1...100)
    }

    func handlePvDataResponse(_ response: Result<PvDataResponse, SPError>) {
        switch response {
            case .success(let pvDataData):
                if let gdpr = pvDataData.gdpr {
                    state.gdpr?.uuid = gdpr.uuid
                }
                if let ccpa = pvDataData.ccpa {
                    state.ccpa?.uuid = ccpa.uuid
                }

            case .failure(let error): logErrorMetrics(error)
        }
    }

    /// If campaign is not `nil`, sample it and call pvData in case the sampling was a hit.
    /// Returns `true` if it hit or `false` otherwise
    func sampleAndPvData(_ campaign: SPSampleable, body: PvDataRequestBody, handler: @escaping () -> Void) -> Bool {
        if campaign.wasSampled == nil {
            if sample(at: campaign.sampleRate) {
                spClient.pvData(body) {
                    self.handlePvDataResponse($0)
                    handler()
                }
                return true
            } else {
                handler()
                return false
            }
        } else if campaign.wasSampled == true {
            spClient.pvData(body) {
                self.handlePvDataResponse($0)
                handler()
            }
            return true
        } else {
            handler()
            return false
        }
    }

    func pvData(_ handler: @escaping () -> Void) {
        let pvDataGroup = DispatchGroup()
        if let gdprMetadata = state.gdprMetaData {
            pvDataGroup.enter()
            let sampled = sampleAndPvData(gdprMetadata, body: gdprPvDataBodyFromState) {
                pvDataGroup.leave()
            }
            state.gdprMetaData?.wasSampled = sampled
        }
        if let ccpaMetadata = state.ccpaMetaData {
            pvDataGroup.enter()
            let sampled = sampleAndPvData(ccpaMetadata, body: ccpaPvDataBodyFromState) {
                pvDataGroup.leave()
            }
            state.ccpaMetaData?.wasSampled = sampled
        }

        pvDataGroup.notify(queue: .main) {
            self.storage.spState = self.state
            handler()
        }
    }

    func handleGetChoices(_ response: ChoiceAllResponse, from campaign: SPCampaignType) {
        if let gdpr = response.gdpr, campaign == .gdpr {
            state.gdpr?.dateCreated = gdpr.dateCreated
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
                sendPVData: state.gdprMetaData?.wasSampled ?? false,
                propertyId: propertyId,
                sampleRate: state.gdprMetaData?.sampleRate,
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
                sendPVData: state.ccpaMetaData?.wasSampled ?? false,
                propertyId: propertyId,
                sampleRate: state.ccpaMetaData?.sampleRate
            )
        ) { handler($0) }
    }

    func reportGDPRAction(_ action: SPAction, _ getResponse: ChoiceAllResponse?, _ handler: @escaping ActionHandler) {
        postChoice(action, postPayloadFromGetCall: getResponse?.gdpr?.postPayload) { postResult in
            switch postResult {
                case .success(let response):
                    if action.type == .SaveAndExit {
                        self.state.gdpr?.tcfData = response.TCData
                    }
                    self.state.gdpr?.uuid = response.uuid
                    self.state.gdpr?.dateCreated = response.dateCreated
                    self.state.gdpr?.consentStatus = response.consentStatus ?? getResponse?.gdpr?.consentStatus ?? ConsentStatus()
                    self.state.gdpr?.euconsent = response.euconsent ?? getResponse?.gdpr?.euconsent ?? ""
                    self.state.gdpr?.vendorGrants = response.grants ?? getResponse?.gdpr?.grants ?? SPGDPRVendorGrants()
                    self.state.gdpr?.webConsentPayload = response.webConsentPayload ?? getResponse?.gdpr?.webConsentPayload
                    self.storage.spState = self.state

                    handler(Result.success(self.userData))

                case .failure(let error):
                    // flag to sync again later
                    handler(Result.failure(error))
            }
        }
    }

    func reportCCPAAction(_ action: SPAction, _ getResponse: ChoiceAllResponse?, _ handler: @escaping ActionHandler) {
        self.postChoice(action) { postResult in
            switch postResult {
                case .success(let response):
                    self.state.ccpa?.uuid = response.uuid
                    self.state.ccpa?.dateCreated = response.dateCreated
                    self.state.ccpa?.status = response.status ?? getResponse?.ccpa?.status ?? .RejectedAll
                    self.state.ccpa?.rejectedVendors = response.rejectedVendors ?? getResponse?.ccpa?.rejectedVendors ?? []
                    self.state.ccpa?.rejectedCategories = response.rejectedCategories ?? getResponse?.ccpa?.rejectedCategories ?? []
                    self.state.ccpa?.uspstring = response.uspstring ?? getResponse?.ccpa?.uspstring ?? ""
                    self.state.ccpa?.webConsentPayload = response.webConsentPayload ?? getResponse?.ccpa?.webConsentPayload
                    self.storage.spState = self.state
                    handler(Result.success(self.userData))

                case .failure(let error):
                    // flag to sync again later
                    handler(Result.failure(error))
            }
        }
    }

    func reportAction(_ action: SPAction, handler: @escaping ActionHandler) {
        getChoiceAll(action) { getResult in
            switch getResult {
                case .success(let getResponse):
                    if action.campaignType == .gdpr {
                        self.reportGDPRAction(action, getResponse, handler)
                    } else if action.campaignType == .ccpa {
                        self.reportCCPAAction(action, getResponse, handler)
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

    func logErrorMetrics(_ error: SPError) {
        spClient.errorMetrics(
            error,
            propertyId: propertyId,
            sdkVersion: SPConsentManager.VERSION,
            OSVersion: deviceManager.osVersion,
            deviceFamily: deviceManager.deviceFamily,
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
