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
    }
}

protocol SPClientCoordinator {
    var authId: String? { get set }
    var deviceManager: SPDeviceManager { get set }
    var userData: SPUserData { get }
    var language: SPMessageLanguage { get set }
    var spClient: SourcePointProtocol { get }

    func loadMessages(forAuthId: String?, pubData: SPPublisherData?, _ handler: @escaping MessagesAndConsentsHandler)
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
        static let version = 1

        struct GDPRMetaData: Codable, SPSampleable, Equatable {
            var additionsChangeDate = SPDate.now()
            var legalBasisChangeDate = SPDate.now()
            var sampleRate = Float(1)
            var wasSampled: Bool?
            var wasSampledAt: Float?
        }

        struct CCPAMetaData: Codable, SPSampleable, Equatable {
            var sampleRate = Float(1)
            var wasSampled: Bool?
            var wasSampledAt: Float?
        }

        struct UsNatMetaData: Codable, SPSampleable, Equatable {
            var additionsChangeDate = SPDate.now()
            var sampleRate = Float(1)
            var wasSampled: Bool?
            var wasSampledAt: Float?
            var vendorListId: String = ""
            var applicableSections: [Int] = []

            enum CodingKeys: String, CodingKey {
                case additionsChangeDate, sampleRate, wasSampled, wasSampledAt, applicableSections
                case vendorListId = "_id"
            }
        }

        struct AttCampaign: Codable {
            var lastMessage: LastMessageData?
            var status: SPIDFAStatus { SPIDFAStatus.current() }
        }

        var gdpr: SPGDPRConsent?
        var ccpa: SPCCPAConsent?
        var usnat: SPUSNatConsent?
        var ios14: AttCampaign?
        var gdprMetaData: GDPRMetaData?
        var ccpaMetaData: CCPAMetaData?
        var usNatMetaData: UsNatMetaData?
        var localState: SPJson?
        var nonKeyedLocalState: SPJson?
        var storedAuthId: String?

        var localVersion: Int?

        var hasGDPRLocalData: Bool { gdpr?.uuid != nil }
        var hasCCPALocalData: Bool { ccpa?.uuid != nil }
        var hasUSNatLocalData: Bool { usnat?.uuid != nil }

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

        mutating func udpateUSNatStatus() {
            guard let usnat = usnat, let usNatMetaData = usNatMetaData else { return }

            if usnat.dateCreated.date < usNatMetaData.additionsChangeDate.date {
                self.usnat?.consentStatus.vendorListAdditions = true
                if self.usnat?.consentStatus.consentedAll == true {
                    self.usnat?.consentStatus.granularStatus?.previousOptInAll = true
                    self.usnat?.consentStatus.consentedAll = false
                }
            }
        }
    }

    let accountId, propertyId: Int
    let propertyName: SPPropertyName
    var authId: String?
    var language: SPMessageLanguage
    var idfaStatus: SPIDFAStatus { SPIDFAStatus.current() }
    let campaigns: SPCampaigns

    var deviceManager: SPDeviceManager
    let spClient: SourcePointProtocol
    var storage: SPLocalStorage

    var state: State

    var gdprUUID: String? { state.gdpr?.uuid }
    var ccpaUUID: String? { state.ccpa?.uuid }
    var usnatUUID: String? { state.usnat?.uuid }

    let includeData: IncludeData

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

    var needsNewConsentData: Bool {
        migratingUser || needsNewUSNatData || transitionCCPAUSNat || (
            state.localVersion != nil && state.localVersion != State.version &&
            (
                state.gdpr?.uuid != nil ||
                state.ccpa?.uuid != nil ||
                state.usnat?.uuid != nil
            )
        )
    }

    /**
        Set to true if in the response of `/meta-data`, the applicableSections returned is different than the one stored.
        Used as part of the decision to call `/consent-status`
     */
    var needsNewUSNatData = false

    var authTransitionCCPAUSNat: Bool {
        authId != nil && campaigns.usnat?.transitionCCPAAuth == true
    }

    var transitionCCPAUSNat: Bool {
        ccpaUUID != nil &&
        usnatUUID == nil &&
        (state.ccpa?.status == .RejectedAll || state.ccpa?.status == .RejectedSome)
    }

    var shouldCallConsentStatus: Bool {
        needsNewConsentData || authId != nil
    }

    var shouldCallMessages: Bool {
        (campaigns.gdpr != nil && state.gdpr?.consentStatus.consentedAll != true) ||
        campaigns.ccpa != nil ||
        (campaigns.ios14 != nil && state.ios14?.status != .accepted) ||
        campaigns.usnat != nil
    }

    var metaDataParamsFromState: MetaDataQueryParam {
        .init(
            gdpr: campaigns.gdpr != nil ?
                .init(
                    groupPmId: campaigns.gdpr?.groupPmId
                ) :
                nil,
            ccpa: campaigns.ccpa != nil ?
                .init(
                    groupPmId: campaigns.ccpa?.groupPmId
                ) :
                nil,
            usnat: campaigns.usnat != nil ?
                .init(
                    groupPmId: campaigns.usnat?.groupPmId
                ) :
                nil
        )
    }

    var messagesParamsFromState: MessagesRequest {
        .init(
            body: .init(
                propertyHref: propertyName,
                accountId: accountId,
                campaigns: .init(
                    ccpa: campaigns.ccpa != nil ? .init(
                        targetingParams: campaigns.ccpa?.targetingParams,
                        hasLocalData: state.hasCCPALocalData,
                        status: state.ccpa?.status
                    ) : nil,
                    gdpr: campaigns.gdpr != nil ? .init(
                        targetingParams: campaigns.gdpr?.targetingParams,
                        hasLocalData: state.hasGDPRLocalData,
                        consentStatus: state.gdpr?.consentStatus
                    ) : nil,
                    ios14: campaigns.ios14 != nil ? .init(
                        targetingParams: campaigns.ios14?.targetingParams,
                        idfaSstatus: idfaStatus
                    ) : nil,
                    usnat: campaigns.usnat != nil ? .init(
                        targetingParams: campaigns.usnat?.targetingParams,
                        hasLocalData: state.hasUSNatLocalData,
                        consentStatus: state.usnat?.consentStatus ?? ConsentStatus()
                    ) : nil
                ),
                consentLanguage: language,
                campaignEnv: campaigns.environment,
                idfaStatus: idfaStatus,
                includeData: includeData
            ),
            metadata: .init(
                ccpa: .init(applies: state.ccpa?.applies),
                gdpr: .init(applies: state.gdpr?.applies),
                usnat: .init(applies: state.usnat?.applies)
            ),
            nonKeyedLocalState: .init(nonKeyedLocalState: state.nonKeyedLocalState),
            localState: state.localState
        )
    }

    var userData: SPUserData {
        SPUserData(
            gdpr: campaigns.gdpr != nil ?
                .init(consents: state.gdpr, applies: state.gdpr?.applies ?? false) :
                nil,
            ccpa: campaigns.ccpa != nil ?
                .init(consents: state.ccpa, applies: state.ccpa?.applies ?? false) :
                nil,
            usnat: campaigns.usnat != nil ?
                .init(consents: state.usnat, applies: state.usnat?.applies ?? false) :
                nil
        )
    }

    init(
        accountId: Int,
        propertyName: SPPropertyName,
        propertyId: Int,
        language: SPMessageLanguage = .BrowserDefault,
        campaigns: SPCampaigns,
        storage: SPLocalStorage = SPUserDefaults(),
        spClient: SourcePointProtocol? = nil,
        deviceManager: SPDeviceManager = SPDevice.standard
    ) {
        self.accountId = accountId
        self.propertyId = propertyId
        self.propertyName = propertyName
        self.language = language
        self.campaigns = campaigns
        self.includeData = .standard
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
            localState.gdpr = localStorage.userData.gdpr?.consents ?? .empty()
            localState.gdpr?.applies = localStorage.userData.gdpr?.applies ?? false
            localState.gdprMetaData = .init()
        }
        if localCampaigns.ccpa != nil, localState.ccpa == nil {
            localState.ccpa = localStorage.userData.ccpa?.consents ?? .empty()
            localState.ccpa?.applies = localStorage.userData.ccpa?.applies ?? false
            localState.ccpaMetaData = .init()
        }
        if localCampaigns.usnat != nil, localState.usnat == nil {
            localState.usnat = localStorage.userData.usnat?.consents ?? .empty()
            localState.usnat?.applies = localStorage.userData.usnat?.applies ?? false
            localState.usNatMetaData = .init()
        }
        if localCampaigns.ios14 != nil, localState.ios14 == nil {
            localState.ios14 = .init()
        }

        // Expire user consent if later than expirationDate
        if let gdprExpirationDate = localState.gdpr?.expirationDate.date,
           gdprExpirationDate < Date() {
            localState.gdpr = .empty()
        }
        if let ccpaExpirationDate = localState.ccpa?.expirationDate.date,
           ccpaExpirationDate < Date() {
            localState.ccpa = .empty()
        }
        if let usnatExpirationDate = localState.usnat?.expirationDate.date,
           usnatExpirationDate < Date() {
            localState.usnat = .empty()
        }

        return localState
    }

    func ccpaPvDataBody(from state: State, pubData: SPPublisherData?) -> PvDataRequestBody {
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

    func gdprPvDataBody(from state: State, pubData: SPPublisherData?) -> PvDataRequestBody {
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

    func usnatPvDataBody(from state: State, pubData: SPPublisherData?) -> PvDataRequestBody {
        var usnat: PvDataRequestBody.USNat?
        if let stateUsnat = state.usnat {
            usnat = PvDataRequestBody.USNat(
                applies: stateUsnat.applies,
                uuid: stateUsnat.uuid,
                accountId: accountId,
                siteId: propertyId,
                consentStatus: stateUsnat.consentStatus,
                pubData: pubData,
                sampleRate: state.gdprMetaData?.sampleRate,
                msgId: stateUsnat.lastMessage?.id,
                categoryId: stateUsnat.lastMessage?.categoryId,
                subCategoryId: stateUsnat.lastMessage?.subCategoryId,
                prtnUUID: stateUsnat.lastMessage?.partitionUUID
            )
        }
        return .init(usnat: usnat)
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

    func loadMessages(forAuthId authId: String?, pubData: SPPublisherData?, _ handler: @escaping MessagesAndConsentsHandler) {
        state = Self.setupState(from: storage, campaigns: campaigns)
        storage.spState = state

        self.authId = authId
        resetStateIfAuthIdChanged()
        metaData {
            self.consentStatus {
                self.state.udpateGDPRStatus()
                self.state.udpateUSNatStatus()
                self.messages { messagesResponse in
                    self.pvData(pubData: pubData) {
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
            if campaigns.gdpr?.groupPmId != gdprMetaData.childPmId {
                storage.gdprChildPmId = gdprMetaData.childPmId ?? ""
            }
        }
        if let ccpaMetaData = response.ccpa {
            state.ccpa?.applies = ccpaMetaData.applies
            state.ccpaMetaData?.updateSampleFields(ccpaMetaData.sampleRate)
        }
        if let usnatMetaData = response.usnat {
            let previousApplicableSections = state.usNatMetaData?.applicableSections ?? []
            state.usnat?.applies = usnatMetaData.applies
            state.usNatMetaData?.vendorListId = usnatMetaData.vendorListId
            state.usNatMetaData?.additionsChangeDate = usnatMetaData.additionsChangeDate
            state.usNatMetaData?.updateSampleFields(usnatMetaData.sampleRate)
            state.usNatMetaData?.applicableSections = usnatMetaData.applicableSections
            if previousApplicableSections.isNotEmpty() && previousApplicableSections != state.usNatMetaData?.applicableSections {
                needsNewUSNatData = true
            }
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

    func handleConsentStatusResponse(_ response: ConsentStatusResponse) {
        state.localState = response.localState
        if let gdpr = response.consentStatusData.gdpr {
            state.gdpr?.uuid = gdpr.uuid
            state.gdpr?.vendorGrants = gdpr.grants
            state.gdpr?.dateCreated = gdpr.dateCreated
            state.gdpr?.expirationDate = gdpr.expirationDate
            state.gdpr?.euconsent = gdpr.euconsent
            state.gdpr?.tcfData = gdpr.TCData
            state.gdpr?.consentStatus = gdpr.consentStatus
            state.gdpr?.childPmId = nil
            state.gdpr?.webConsentPayload = gdpr.webConsentPayload
            state.gdpr?.legIntCategories = gdpr.legIntCategories
            state.gdpr?.legIntVendors = gdpr.legIntVendors
            state.gdpr?.vendors = gdpr.vendors
            state.gdpr?.categories = gdpr.categories
            state.gdpr?.specialFeatures = gdpr.specialFeatures
        }
        if let ccpa = response.consentStatusData.ccpa {
            state.ccpa?.uuid = ccpa.uuid
            state.ccpa?.dateCreated = ccpa.dateCreated
            state.ccpa?.expirationDate = ccpa.expirationDate
            state.ccpa?.status = ccpa.status
            state.ccpa?.rejectedVendors = ccpa.rejectedVendors
            state.ccpa?.rejectedCategories = ccpa.rejectedCategories
            state.ccpa?.consentStatus = ConsentStatus(
                rejectedVendors: ccpa.rejectedVendors,
                rejectedCategories: ccpa.rejectedCategories
            )
            state.ccpa?.childPmId = nil
            state.ccpa?.webConsentPayload = ccpa.webConsentPayload
            state.ccpa?.GPPData = ccpa.GPPData ?? SPJson()
        }
        if let usnat = response.consentStatusData.usnat {
            state.usnat = SPUSNatConsent(
                uuid: usnat.uuid,
                applies: state.usnat?.applies ?? false,
                dateCreated: usnat.dateCreated,
                expirationDate: usnat.expirationDate,
                consentStrings: usnat.consentStrings,
                webConsentPayload: usnat.webConsentPayload,
                categories: usnat.categories,
                consentStatus: usnat.consentStatus,
                GPPData: usnat.GPPData
            )
        }

        state.localVersion = State.version
        storage.spState = state
    }

    func consentStatus(next: @escaping () -> Void) {
        if shouldCallConsentStatus {
            spClient.consentStatus(
                propertyId: propertyId,
                metadata: .init(
                    gdpr: .init(
                        state.gdpr,
                        campaign: campaigns.gdpr,
                        idfaStatus: SPIDFAStatus.current()
                    ),
                    ccpa: .init(
                        state.ccpa,
                        campaign: campaigns.ccpa,
                        idfaStatus: SPIDFAStatus.current()
                    ),
                    usnat: .init(
                        state.usnat,
                        campaign: campaigns.usnat,
                        idfaStatus: SPIDFAStatus.current(),
                        dateCreated: transitionCCPAUSNat ? state.ccpa?.dateCreated : state.usnat?.dateCreated,
                        optedOut: transitionCCPAUSNat
                    )
                ),
                authId: authId,
                includeData: includeData
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

        response.campaigns.forEach {
            switch $0.type {
                case .gdpr: state.gdpr = $0.userConsent.toConsent(
                    defaults: state.gdpr,
                    messageMetaData: $0.messageMetaData
                )

                case .ccpa: state.ccpa = $0.userConsent.toConsent(
                    defaults: state.ccpa,
                    messageMetaData: $0.messageMetaData
                )

                case .usnat: state.usnat = $0.userConsent.toConsent(
                    defaults: state.usnat,
                    messageMetaData: $0.messageMetaData
                )

                case .ios14: state.ios14?.lastMessage = LastMessageData(from: $0.messageMetaData)

                case .unknown: break
            }
        }

        storage.spState = state
        return (
            response.campaigns.compactMap { MessageToDisplay($0) },
            userData.copy() as? SPUserData ?? userData
        )
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
            handler(Result.success(([], userData.copy() as? SPUserData ?? userData)))
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
                if let usnat = pvDataData.usnat {
                    state.usnat?.uuid = usnat.uuid
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

    func pvData(pubData: SPPublisherData?, _ handler: @escaping () -> Void) {
        let pvDataGroup = DispatchGroup()
        if let gdprMetadata = state.gdprMetaData, campaigns.gdpr != nil {
            pvDataGroup.enter()
            let sampled = sampleAndPvData(gdprMetadata, body: gdprPvDataBody(from: state, pubData: pubData)) {
                pvDataGroup.leave()
            }
            state.gdprMetaData?.wasSampled = sampled
        }
        if let ccpaMetadata = state.ccpaMetaData, campaigns.ccpa != nil {
            pvDataGroup.enter()
            let sampled = sampleAndPvData(ccpaMetadata, body: ccpaPvDataBody(from: state, pubData: pubData)) {
                pvDataGroup.leave()
            }
            state.ccpaMetaData?.wasSampled = sampled
        }
        if let usNatMetadata = state.usNatMetaData, campaigns.usnat != nil {
            pvDataGroup.enter()
            let sampled = sampleAndPvData(usNatMetadata, body: usnatPvDataBody(from: state, pubData: pubData)) {
                pvDataGroup.leave()
            }
            state.usNatMetaData?.wasSampled = sampled
        }

        pvDataGroup.notify(queue: .main) {
            self.storage.spState = self.state
            handler()
        }
    }

    func handleGetChoices(_ response: ChoiceAllResponse, from campaign: SPCampaignType) {
        if let gdpr = response.gdpr, campaign == .gdpr {
            state.gdpr?.dateCreated = gdpr.dateCreated
            state.gdpr?.expirationDate = gdpr.expirationDate
            state.gdpr?.tcfData = gdpr.TCData
            state.gdpr?.vendorGrants = gdpr.grants
            state.gdpr?.euconsent = gdpr.euconsent
            state.gdpr?.consentStatus = gdpr.consentStatus
            state.gdpr?.childPmId = gdpr.childPmId
        }
        if let ccpa = response.ccpa, campaign == .ccpa {
            state.ccpa?.dateCreated = ccpa.dateCreated
            state.ccpa?.expirationDate = ccpa.expirationDate
            state.ccpa?.status = ccpa.status
            state.ccpa?.GPPData = ccpa.GPPData
        }
        storage.spState = state
    }

    func shouldCallGetChoice(for action: SPAction) -> Bool {
        (action.campaignType == .ccpa || action.campaignType == .gdpr) &&
        (action.type == .AcceptAll || action.type == .RejectAll)
    }

    func getChoiceAll(_ action: SPAction, handler: @escaping (Result<ChoiceAllResponse?, SPError>) -> Void) {
        if shouldCallGetChoice(for: action) {
            spClient.choiceAll(
                actionType: action.type,
                accountId: accountId,
                propertyId: propertyId,
                metadata: .init(
                    gdpr: campaigns.gdpr != nil ? .init(applies: state.gdpr?.applies ?? false) : nil,
                    ccpa: campaigns.ccpa != nil ? .init(applies: state.ccpa?.applies ?? false) : nil
                ),
                includeData: includeData
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
                pubData: action.encodablePubData,
                pmSaveAndExitVariables: action.pmPayload,
                sendPVData: state.gdprMetaData?.wasSampled ?? false,
                propertyId: propertyId,
                sampleRate: state.gdprMetaData?.sampleRate,
                idfaStatus: idfaStatus,
                granularStatus: postPayloadFromGetCall?.granularStatus,
                includeData: includeData
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
                pubData: action.encodablePubData,
                pmSaveAndExitVariables: action.pmPayload,
                sendPVData: state.ccpaMetaData?.wasSampled ?? false,
                propertyId: propertyId,
                sampleRate: state.ccpaMetaData?.sampleRate,
                includeData: includeData
            )
        ) { handler($0) }
    }

    func postChoice(
        _ action: SPAction,
        handler: @escaping (Result<USNatChoiceResponse, SPError>) -> Void
    ) {
        spClient.postUSNatAction(
            actionType: action.type,
            body: .init(
                authId: authId,
                uuid: state.usnat?.uuid,
                messageId: String(state.usnat?.lastMessage?.id ?? 0),
                vendorListId: state.usNatMetaData?.vendorListId,
                pubData: action.encodablePubData,
                pmSaveAndExitVariables: action.pmPayload,
                sendPVData: state.usNatMetaData?.wasSampled ?? false,
                propertyId: propertyId,
                sampleRate: state.usNatMetaData?.sampleRate,
                idfaStatus: idfaStatus,
                granularStatus: state.usnat?.consentStatus.granularStatus,
                includeData: includeData
            ),
            handler: handler
        )
    }

    func handleGPDRPostChoice(
        _ action: SPAction,
        _ getResponse: ChoiceAllResponse?,
        _ postResponse: GDPRChoiceResponse
    ) {
        if action.type == .SaveAndExit {
            state.gdpr?.tcfData = postResponse.TCData
        }
        state.gdpr?.uuid = postResponse.uuid
        state.gdpr?.dateCreated = postResponse.dateCreated
        state.gdpr?.expirationDate = postResponse.expirationDate
        state.gdpr?.consentStatus = postResponse.consentStatus ?? getResponse?.gdpr?.consentStatus ?? ConsentStatus()
        state.gdpr?.euconsent = postResponse.euconsent ?? getResponse?.gdpr?.euconsent ?? ""
        state.gdpr?.vendorGrants = postResponse.grants ?? getResponse?.gdpr?.grants ?? SPGDPRVendorGrants()
        state.gdpr?.webConsentPayload = postResponse.webConsentPayload ?? getResponse?.gdpr?.webConsentPayload
        state.gdpr?.legIntCategories = postResponse.legIntCategories ?? getResponse?.gdpr?.legIntCategories
        state.gdpr?.legIntVendors = postResponse.legIntVendors ?? getResponse?.gdpr?.legIntVendors
        state.gdpr?.vendors = postResponse.vendors ?? getResponse?.gdpr?.vendors
        state.gdpr?.categories = postResponse.categories ?? getResponse?.gdpr?.categories
        state.gdpr?.specialFeatures = postResponse.specialFeatures ?? getResponse?.gdpr?.specialFeatures
        storage.spState = state
    }

    func reportGDPRAction(_ action: SPAction, _ getResponse: ChoiceAllResponse?, _ handler: @escaping ActionHandler) {
        postChoice(action, postPayloadFromGetCall: getResponse?.gdpr?.postPayload) { postResult in
            switch postResult {
                case .success(let response):
                    self.handleGPDRPostChoice(action, getResponse, response)
                    handler(Result.success(self.userData))

                case .failure(let error):
                    // flag to sync again later
                    handler(Result.failure(error))
            }
        }
    }

    func handleCCPAPostChoice(
        _ action: SPAction,
        _ getResponse: ChoiceAllResponse?,
        _ postResponse: CCPAChoiceResponse
    ) {
        if action.type == .SaveAndExit {
            state.ccpa?.GPPData = postResponse.GPPData
        }
        state.ccpa?.uuid = postResponse.uuid
        state.ccpa?.dateCreated = postResponse.dateCreated
        state.ccpa?.status = postResponse.status ?? getResponse?.ccpa?.status ?? .RejectedAll
        state.ccpa?.rejectedVendors = postResponse.rejectedVendors ?? getResponse?.ccpa?.rejectedVendors ?? []
        state.ccpa?.rejectedCategories = postResponse.rejectedCategories ?? getResponse?.ccpa?.rejectedCategories ?? []
        state.ccpa?.webConsentPayload = postResponse.webConsentPayload ?? getResponse?.ccpa?.webConsentPayload
        storage.spState = state
    }

    func reportCCPAAction(_ action: SPAction, _ getResponse: ChoiceAllResponse?, _ handler: @escaping ActionHandler) {
        self.postChoice(action) { postResult in
            switch postResult {
                case .success(let response):
                    self.handleCCPAPostChoice(action, getResponse, response)
                    handler(Result.success(self.userData))

                case .failure(let error):
                    // flag to sync again later
                    handler(Result.failure(error))
            }
        }
    }

    func handleUSNatPostChoice(
        _ action: SPAction,
        _ postResponse: USNatChoiceResponse
    ) {
        state.usnat = SPUSNatConsent(
            uuid: postResponse.uuid,
            applies: state.usnat?.applies ?? false,
            dateCreated: postResponse.dateCreated,
            expirationDate: postResponse.expirationDate,
            consentStrings: postResponse.consentStrings,
            webConsentPayload: postResponse.webConsentPayload,
            categories: postResponse.categories,
            consentStatus: postResponse.consentStatus,
            GPPData: postResponse.GPPData
        )

        storage.spState = state
    }

    func reportUSNatAction(_ action: SPAction, _ handler: @escaping ActionHandler) {
        self.postChoice(action) { postResult in
            switch postResult {
                case .success(let response):
                    self.handleUSNatPostChoice(action, response)
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
                    switch action.campaignType {
                        case .gdpr: self.reportGDPRAction(action, getResponse, handler)
                        case .ccpa: self.reportCCPAAction(action, getResponse, handler)
                        case .usnat: self.reportUSNatAction(action, handler)
                        default: break
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
        if let usNatUUID = usnatUUID, usNatUUID.isNotEmpty() {
            uuid = usNatUUID
            uuidType = .usnat
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
