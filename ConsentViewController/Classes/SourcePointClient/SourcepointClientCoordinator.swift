//
//  SourcepointClientCoordinator.swift
//  Pods
//
//  Created by Andre Herculano on 14.09.22.
//
// swiftlint:disable type_body_length file_length

import Foundation
import SPMobileCore

typealias CoreCoordinator = SPMobileCore.Coordinator

typealias ErrorHandler = (SPError) -> Void
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
        static let version = 4

        struct GDPRMetaData: Codable, SPSampleable, Equatable {
            var additionsChangeDate = SPDate.now()
            var legalBasisChangeDate: SPDate?
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
            var status: SPIDFAStatus { SPIDFAStatus.current() }
            var messageId: String?
            var partitionUUID: String?
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
            if let legalBasisChangeDate = gdprMetadata.legalBasisChangeDate, gdpr.dateCreated.date < legalBasisChangeDate.date {
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
    let coreCoordinator: CoreCoordinator
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
        migratingUser || needsNewUSNatData || transitionCCPAOptedOut || (
            state.localVersion != State.version && (
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

    var transitionCCPAOptedOut: Bool {
        campaigns.usnat != nil &&
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

    var metaDataParamsFromState: SPMobileCore.MetaDataRequest.Campaigns {
        .init(
            gdpr: campaigns.gdpr != nil ?
                .init(
                    groupPmId: campaigns.gdpr?.groupPmId
                ) :
                nil,
            usnat: campaigns.usnat != nil ?
                .init(
                    groupPmId: campaigns.usnat?.groupPmId
                ) :
                nil,
            ccpa: campaigns.ccpa != nil ?
                .init(
                    groupPmId: campaigns.ccpa?.groupPmId
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
        self.includeData = IncludeData(
            gppConfig: campaigns.ccpa?.GPPConfig ??
                SPGPPConfig(uspString: campaigns.usnat?.supportLegacyUSPString)
        )
        self.storage = storage
        self.spClient = spClient ?? SourcePointClient(
            accountId: accountId,
            propertyName: propertyName,
            propertyId: propertyId,
            campaignEnv: campaigns.environment,
            timeout: SPConsentManager.DefaultTimeout
        )
        self.coreCoordinator = CoreCoordinator(
            accountId: Int32(accountId),
            propertyId: Int32(propertyId),
            propertyName: propertyName.rawValue
        )
        self.deviceManager = deviceManager

        self.state = Self.setupState(from: storage, campaigns: campaigns)
        self.storage.spState = self.state
    }

    static func setupState(from localStorage: SPLocalStorage, campaigns localCampaigns: SPCampaigns) -> State {
        var spState = localStorage.spState ?? .init()
        if localCampaigns.gdpr != nil, spState.gdpr == nil {
            spState.gdpr = localStorage.userData.gdpr?.consents ?? .empty()
            spState.gdpr?.applies = localStorage.userData.gdpr?.applies ?? false
            spState.gdprMetaData = .init()
        }
        if localCampaigns.ccpa != nil, spState.ccpa == nil {
            spState.ccpa = localStorage.userData.ccpa?.consents ?? .empty()
            spState.ccpa?.applies = localStorage.userData.ccpa?.applies ?? false
            spState.ccpaMetaData = .init()
        }
        if localCampaigns.usnat != nil, spState.usnat == nil {
            spState.usnat = localStorage.userData.usnat?.consents ?? .empty()
            spState.usnat?.applies = localStorage.userData.usnat?.applies ?? false
            spState.usNatMetaData = .init()
        }
        if localCampaigns.ios14 != nil, spState.ios14 == nil {
            spState.ios14 = .init()
        }

        // Expire user consent if later than expirationDate
        if let gdprExpirationDate = spState.gdpr?.expirationDate.date,
           gdprExpirationDate < Date() {
            spState.gdpr = .empty()
        }
        if let ccpaExpirationDate = spState.ccpa?.expirationDate.date,
           ccpaExpirationDate < Date() {
            spState.ccpa = .empty()
        }
        if let usnatExpirationDate = spState.usnat?.expirationDate.date,
           usnatExpirationDate < Date() {
            spState.usnat = .empty()
        }

        return spState
    }

    func ccpaPvDataBody(
        from state: State,
        pubData: SPPublisherData?,
        messageMetaData: MessageMetaData?
    ) -> SPMobileCore.PvDataRequest {
        var request: SPMobileCore.PvDataRequest?
        if let stateCCPA = state.ccpa {
            let pubDataJson = pubData?.toCore()
            request = SPMobileCore.PvDataRequest.init(
                gdpr: nil,
                ccpa: SPMobileCore.PvDataRequest.CCPA.init(
                    applies: stateCCPA.applies,
                    uuid: stateCCPA.uuid,
                    accountId: Int32(accountId),
                    propertyId: Int32(propertyId),
                    consentStatus: stateCCPA.consentStatus.toCore(rejectedVendors: stateCCPA.rejectedVendors, rejectedCategories: stateCCPA.rejectedCategories),
                    pubData: JsonKt.encodeToJsonObject(pubDataJson),
                    messageId: KotlinInt(int: Int(messageMetaData?.messageId ?? "")),
                    sampleRate: KotlinFloat(float: state.ccpaMetaData?.sampleRate)
                ),
                usnat: nil
            )
        }
        return request ?? SPMobileCore.PvDataRequest(gdpr: nil, ccpa: nil, usnat: nil)
    }

    func gdprPvDataBody(
        from state: State,
        pubData: SPPublisherData?,
        messageMetaData: MessageMetaData?
    ) -> SPMobileCore.PvDataRequest {
        var request: SPMobileCore.PvDataRequest?
        if let stateGDPR = state.gdpr {
            let pubDataJson = pubData?.toCore()
            request = SPMobileCore.PvDataRequest.init(
                gdpr: SPMobileCore.PvDataRequest.GDPR.init(
                    applies: stateGDPR.applies,
                    uuid: stateGDPR.uuid,
                    accountId: Int32(accountId),
                    propertyId: Int32(propertyId),
                    consentStatus: stateGDPR.consentStatus.toCore(),
                    pubData: JsonKt.encodeToJsonObject(pubDataJson),
                    sampleRate: KotlinFloat(float: state.gdprMetaData?.sampleRate),
                    euconsent: stateGDPR.euconsent,
                    msgId: KotlinInt(int: Int(messageMetaData?.messageId ?? "")),
                    categoryId: KotlinInt(int: messageMetaData?.categoryId.rawValue),
                    subCategoryId: KotlinInt(int: messageMetaData?.subCategoryId.rawValue),
                    prtnUUID: messageMetaData?.messagePartitionUUID
                ),
                ccpa: nil,
                usnat: nil
            )
        }
        return request ?? SPMobileCore.PvDataRequest(gdpr: nil, ccpa: nil, usnat: nil)
    }

    func usnatPvDataBody(
        from state: State,
        pubData: SPPublisherData?,
        messageMetaData: MessageMetaData?
    ) -> SPMobileCore.PvDataRequest {
        var request: SPMobileCore.PvDataRequest?
        if let stateUsnat = state.usnat {
            let pubDataJson = pubData?.toCore()
            request = SPMobileCore.PvDataRequest.init(
                gdpr: nil,
                ccpa: nil,
                usnat: SPMobileCore.PvDataRequest.USNat.init(
                    applies: stateUsnat.applies,
                    uuid: stateUsnat.uuid,
                    accountId: Int32(accountId),
                    propertyId: Int32(propertyId),
                    consentStatus: stateUsnat.consentStatus.toCore(),
                    pubData: JsonKt.encodeToJsonObject(pubDataJson),
                    sampleRate: KotlinFloat(float: state.usNatMetaData?.sampleRate),
                    msgId: KotlinInt(int: Int(messageMetaData?.messageId ?? "")),
                    categoryId: KotlinInt(int: messageMetaData?.categoryId.rawValue),
                    subCategoryId: KotlinInt(int: messageMetaData?.subCategoryId.rawValue),
                    prtnUUID: messageMetaData?.messagePartitionUUID
                )
            )
        }
        return request ?? SPMobileCore.PvDataRequest(gdpr: nil, ccpa: nil, usnat: nil)
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

        let onError: ErrorHandler = {
            self.logErrorMetrics($0)
            handler(Result.failure($0))
        }

        metaData(onError) {
            self.consentStatus(onError) {
                self.state.udpateGDPRStatus()
                self.state.udpateUSNatStatus()
                self.messages { messagesResponse in
                    let (messages, _) = (try? messagesResponse.get()) ?? ([], SPUserData())
                    handler(messagesResponse)
                    self.pvData(pubData: pubData, messages: messages) { }
                }
            }
        }
    }

    func handleMetaDataResponse(_ response: SPMobileCore.MetaDataResponse) {
        if let gdprMetaData = response.gdpr {
            state.gdpr?.applies = gdprMetaData.applies
            state.gdprMetaData?.additionsChangeDate = SPDate(string: gdprMetaData.additionsChangeDate)
            state.gdprMetaData?.legalBasisChangeDate = SPDate(string: gdprMetaData.legalBasisChangeDate)
            state.gdprMetaData?.updateSampleFields(gdprMetaData.sampleRate)
            if campaigns.gdpr?.groupPmId != gdprMetaData.childPmId {
                storage.gdprChildPmId = gdprMetaData.childPmId
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
            state.usNatMetaData?.additionsChangeDate = SPDate(string: usnatMetaData.additionsChangeDate)
            state.usNatMetaData?.updateSampleFields(usnatMetaData.sampleRate)
            state.usNatMetaData?.applicableSections = usnatMetaData.applicableSections.map {
                Int(truncating: $0)
            }
            if previousApplicableSections.isNotEmpty() && previousApplicableSections != state.usNatMetaData?.applicableSections {
                needsNewUSNatData = true
            }
        }
        storage.spState = state
    }

    func metaData(_ errorHandler: @escaping ErrorHandler, next: @escaping () -> Void) {
        spClient.metaData(
            accountId: accountId,
            propertyId: propertyId,
            campaigns: metaDataParamsFromState
        ) { result in
            switch result {
                case .success(let response):
                    self.handleMetaDataResponse(response)
                    next()

                case .failure(let error): errorHandler(error)
            }
        }
    }

    func handleConsentStatusResponse(_ response: SPMobileCore.ConsentStatusResponse) {
        state.localState = try? SPJson(response.localState)
        if let gdpr = response.consentStatusData.gdpr {
            state.gdpr?.uuid = gdpr.uuid
            state.gdpr?.vendorGrants = gdpr.grants.mapValues { $0.toNative() }
            state.gdpr?.dateCreated = SPDate(string: gdpr.dateCreated ?? "")
            state.gdpr?.expirationDate = SPDate(string: gdpr.expirationDate ?? "")
            state.gdpr?.euconsent = gdpr.euconsent ?? ""
            state.gdpr?.tcfData = gdpr.tcData.toNative()
            state.gdpr?.consentStatus = gdpr.consentStatus.toNative()
            state.gdpr?.webConsentPayload = gdpr.webConsentPayload
            state.gdpr?.googleConsentMode = gdpr.gcmStatus?.toNative()
            state.gdpr?.acceptedLegIntCategories = gdpr.legIntCategories
            state.gdpr?.acceptedLegIntVendors = gdpr.legIntVendors
            state.gdpr?.acceptedVendors = gdpr.vendors
            state.gdpr?.acceptedCategories = gdpr.categories
            state.gdpr?.acceptedSpecialFeatures = gdpr.specialFeatures
        }
        if let ccpa = response.consentStatusData.ccpa {
            state.ccpa?.uuid = ccpa.uuid
            state.ccpa?.dateCreated = SPDate(string: ccpa.dateCreated ?? "")
            state.ccpa?.expirationDate = SPDate(string: ccpa.expirationDate ?? "")
            state.ccpa?.status = ccpa.status?.toNative() ?? .Unknown
            state.ccpa?.rejectedVendors = ccpa.rejectedVendors
            state.ccpa?.rejectedCategories = ccpa.rejectedCategories
            state.ccpa?.consentStatus = ConsentStatus(
                rejectedVendors: ccpa.rejectedVendors,
                rejectedCategories: ccpa.rejectedCategories
            )
            state.ccpa?.webConsentPayload = ccpa.webConsentPayload
            state.ccpa?.GPPData = ccpa.gppData.toNative() ?? SPJson()
        }
        if let usnat = response.consentStatusData.usnat {
            state.usnat = SPUSNatConsent(
                uuid: usnat.uuid,
                applies: state.usnat?.applies ?? false,
                dateCreated: SPDate(string: usnat.dateCreated ?? ""),
                expirationDate: SPDate(string: usnat.expirationDate ?? ""),
                consentStrings: usnat.consentStrings.map { $0.toNative() },
                webConsentPayload: usnat.webConsentPayload,
                categories: usnat.userConsents.categories.map { $0.toNative() },
                vendors: usnat.userConsents.vendors.map { $0.toNative() },
                consentStatus: usnat.consentStatus.toNative(),
                GPPData: usnat.gppData.toNative()
            )
        }

        storage.spState = state
    }

    func consentStatus(_ errorHandler: ErrorHandler, next: @escaping () -> Void) {
        if shouldCallConsentStatus {
            spClient.consentStatus(
                metadata: .init(
                    // swiftlint:disable force_unwrapping
                    gdpr: state.gdpr != nil ? .init(
                        applies: state.gdpr!.applies,
                        dateCreated: state.gdpr?.dateCreated.originalDateString,
                        uuid: state.gdpr?.uuid,
                        hasLocalData: state.hasGDPRLocalData,
                        idfaStatus: SPIDFAStatus.current().toCore()
                    ) : nil,
                    usnat: state.usnat != nil ? .init(
                        applies: state.usnat!.applies,
                        dateCreated: transitionCCPAOptedOut ?
                            state.ccpa?.dateCreated.originalDateString :
                            state.usnat?.dateCreated.originalDateString,
                        uuid: state.usnat?.uuid,
                        hasLocalData: state.hasUSNatLocalData,
                        idfaStatus: SPIDFAStatus.current().toCore(),
                        transitionCCPAAuth: KotlinBoolean(bool: authTransitionCCPAUSNat),
                        optedOut: KotlinBoolean(bool: transitionCCPAOptedOut)
                    ) : nil,
                    ccpa: state.ccpa != nil ? .init(
                        applies: state.ccpa!.applies,
                        dateCreated: state.ccpa?.dateCreated.originalDateString,
                        uuid: state.ccpa?.uuid,
                        hasLocalData: state.hasCCPALocalData,
                        idfaStatus: SPIDFAStatus.current().toCore()
                    ) : nil
                ),
                // swiftlint:enable force_unwrapping
                authId: authId
            ) { result in
                switch result {
                    case .success(let response):
                        self.state.localVersion = State.version
                        self.handleConsentStatusResponse(response)

                    case .failure(let error):
                        self.logErrorMetrics(error)
                }
                next()
            }
        } else {
            self.state.localVersion = State.version
            next()
        }
    }

    func handleMessagesResponse(_ response: MessagesResponse) -> LoadMessagesReturnType {
        state.localState = response.localState
        state.nonKeyedLocalState = response.nonKeyedLocalState

        response.campaigns.forEach {
            switch $0.type {
                case .gdpr: state.gdpr = $0.userConsent.toConsent(
                    defaults: state.gdpr
                )

                case .ccpa: state.ccpa = $0.userConsent.toConsent(
                    defaults: state.ccpa
                )

                case .usnat: state.usnat = $0.userConsent.toConsent(
                    defaults: state.usnat
                )

                case .ios14:
                    state.ios14?.messageId = $0.messageMetaData?.messageId
                    state.ios14?.partitionUUID = $0.messageMetaData?.messagePartitionUUID

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
                        self.logErrorMetrics(error)
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

    func handlePvDataResponse(_ response: Result<SPMobileCore.PvDataResponse, SPError>) {
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
    func sampleAndPvData(_ campaign: SPSampleable, request: SPMobileCore.PvDataRequest, handler: @escaping () -> Void) -> Bool {
        if campaign.wasSampled == nil {
            if sample(at: campaign.sampleRate) {
                spClient.pvData(request: request) {
                    self.handlePvDataResponse($0)
                    handler()
                }
                return true
            } else {
                handler()
                return false
            }
        } else if campaign.wasSampled == true {
            spClient.pvData(request: request) {
                self.handlePvDataResponse($0)
                handler()
            }
            return true
        } else {
            handler()
            return false
        }
    }

    func pvData(pubData: SPPublisherData?, messages: [MessageToDisplay], _ handler: @escaping () -> Void) {
        let pvDataGroup = DispatchGroup()
        if let gdprMetadata = state.gdprMetaData, campaigns.gdpr != nil {
            pvDataGroup.enter()
            let sampled = sampleAndPvData(
                gdprMetadata,
                request: gdprPvDataBody(
                    from: state,
                    pubData: pubData,
                    messageMetaData: messages.first { $0.type == .gdpr }?.metadata
                )
            ) {
                pvDataGroup.leave()
            }
            state.gdprMetaData?.wasSampled = sampled
        }
        if let ccpaMetadata = state.ccpaMetaData, campaigns.ccpa != nil {
            pvDataGroup.enter()
            let sampled = sampleAndPvData(
                ccpaMetadata,
                request: ccpaPvDataBody(
                    from: state,
                    pubData: pubData,
                    messageMetaData: messages.first { $0.type == .ccpa }?.metadata
                )
            ) {
                pvDataGroup.leave()
            }
            state.ccpaMetaData?.wasSampled = sampled
        }
        if let usNatMetadata = state.usNatMetaData, campaigns.usnat != nil {
            pvDataGroup.enter()
            let sampled = sampleAndPvData(
                usNatMetadata,
                request: usnatPvDataBody(
                    from: state,
                    pubData: pubData,
                    messageMetaData: messages.first { $0.type == .usnat }?.metadata
                )
            ) {
                pvDataGroup.leave()
            }
            state.usNatMetaData?.wasSampled = sampled
        }

        pvDataGroup.notify(queue: .main) {
            self.storage.spState = self.state
            handler()
        }
    }

    func handleGetChoices(_ response: SPMobileCore.ChoiceAllResponse, from campaign: SPCampaignType) {
        if let gdpr = response.gdpr, campaign == .gdpr {
            state.gdpr?.dateCreated = SPDate(string: gdpr.dateCreated ?? "")
            state.gdpr?.expirationDate = SPDate(string: gdpr.expirationDate ?? "")
            state.gdpr?.tcfData = gdpr.tcData?.toNative()
            state.gdpr?.vendorGrants = gdpr.grants.mapValues { $0.toNative() }
            state.gdpr?.euconsent = gdpr.euconsent
            state.gdpr?.consentStatus = gdpr.consentStatus.toNative()
            state.gdpr?.childPmId = gdpr.childPmId
            state.gdpr?.googleConsentMode = gdpr.gcmStatus?.toNative()
        }
        if let ccpa = response.ccpa, campaign == .ccpa {
            state.ccpa?.dateCreated = SPDate(string: ccpa.dateCreated ?? "")
            state.ccpa?.expirationDate = SPDate(string: ccpa.expirationDate ?? "")
            state.ccpa?.status = ccpa.status.toNative()
            state.ccpa?.GPPData = ccpa.gppData.toNative() ?? SPJson()
        }
        if let usnat = response.usnat, campaign == .usnat {
            state.usnat?.dateCreated = SPDate(string: usnat.dateCreated ?? "")
            state.usnat?.expirationDate = SPDate(string: usnat.expirationDate ?? "")
            state.usnat?.consentStatus = usnat.consentStatus.toNative()
            state.usnat?.GPPData = usnat.gppData.toNative()
            state.usnat?.consentStrings = usnat.consentStrings.map { $0.toNative() }
            state.usnat?.consentStatus.consentedToAll = usnat.consentedToAll
            state.usnat?.consentStatus.rejectedAny = usnat.rejectedAny
            state.usnat?.consentStatus.granularStatus?.gpcStatus = usnat.gpcEnabled?.boolValue
        }
        storage.spState = state
    }

    func getChoiceAll(_ action: SPAction, handler: @escaping (Result<SPMobileCore.ChoiceAllResponse?, SPError>) -> Void) {
        coreCoordinator.state = state.toCore()
        coreCoordinator.getChoiceAll(
            action: action.toCore(),
            campaigns: .init(
                gdpr: campaigns.gdpr != nil ? .init(applies: state.gdpr?.applies ?? false) : nil,
                ccpa: campaigns.ccpa != nil ? .init(applies: state.ccpa?.applies ?? false) : nil,
                usnat: campaigns.usnat != nil ? .init(applies: state.usnat?.applies ?? false) : nil
            )
        ) { response, error in
            if error != nil {
                handler(Result.failure(InvalidChoiceAllResponseError()))
            } else {
                if response != nil {
                    self.handleGetChoices(response!, from: action.campaignType) // swiftlint:disable:this force_unwrapping
                }
                handler(Result.success(response))
            }
        }
    }

    func postChoice(
        _ action: SPAction,
        postPayloadFromGetCall: SPMobileCore.ChoiceAllResponse.GDPRPostPayload?,
        handler: @escaping (Result<SPMobileCore.GDPRChoiceResponse, SPError>) -> Void
    ) {
        coreCoordinator.postChoiceGDPR(
            action: action.toCore(),
            postPayloadFromGetCall: postPayloadFromGetCall
        ) { response, error in
            if error != nil || response == nil {
                handler(Result.failure(InvalidResponseConsentError()))
            } else {
                handler(Result.success(response!)) // swiftlint:disable:this force_unwrapping
            }
        }
    }

    func postChoice(
        _ action: SPAction,
        handler: @escaping (Result<SPMobileCore.CCPAChoiceResponse, SPError>) -> Void
    ) {
        coreCoordinator.postChoiceCCPA(
            action: action.toCore()
        ) { response, error in
            if error != nil || response == nil {
                handler(Result.failure(InvalidResponseConsentError()))
            } else {
                handler(Result.success(response!)) // swiftlint:disable:this force_unwrapping
            }
        }
    }

    func postChoice(
        _ action: SPAction,
        handler: @escaping (Result<SPMobileCore.USNatChoiceResponse, SPError>) -> Void
    ) {
        coreCoordinator.postChoiceUSNat(
            action: action.toCore()
        ) { response, error in
            if error != nil || response == nil {
                handler(Result.failure(InvalidResponseConsentError()))
            } else {
                handler(Result.success(response!)) // swiftlint:disable:this force_unwrapping
            }
        }
    }

    func handleGPDRPostChoice(
        _ action: SPAction,
        _ getResponse: SPMobileCore.ChoiceAllResponse?,
        _ postResponse: SPMobileCore.GDPRChoiceResponse
    ) {
        if action.type == .SaveAndExit {
            state.gdpr?.tcfData = postResponse.tcData?.toNative()
        }
        state.gdpr?.uuid = postResponse.uuid
        state.gdpr?.dateCreated = SPDate(string: postResponse.dateCreated ?? "")
        state.gdpr?.expirationDate = SPDate(string: postResponse.expirationDate ?? "")
        state.gdpr?.consentStatus = postResponse.consentStatus?.toNative() ?? getResponse?.gdpr?.consentStatus.toNative() ?? ConsentStatus()
        state.gdpr?.euconsent = postResponse.euconsent ?? getResponse?.gdpr?.euconsent ?? ""
        state.gdpr?.vendorGrants = postResponse.grants?.mapValues { $0.toNative() } ?? getResponse?.gdpr?.grants.mapValues { $0.toNative() } ?? SPGDPRVendorGrants()
        state.gdpr?.webConsentPayload = postResponse.webConsentPayload ?? getResponse?.gdpr?.webConsentPayload
        state.gdpr?.googleConsentMode = postResponse.gcmStatus?.toNative() ?? getResponse?.gdpr?.gcmStatus?.toNative()
        state.gdpr?.acceptedLegIntCategories = postResponse.acceptedLegIntCategories ?? getResponse?.gdpr?.acceptedLegIntCategories ?? []
        state.gdpr?.acceptedLegIntVendors = postResponse.acceptedLegIntVendors ?? getResponse?.gdpr?.acceptedLegIntVendors ?? []
        state.gdpr?.acceptedVendors = postResponse.acceptedVendors ?? getResponse?.gdpr?.acceptedVendors ?? []
        state.gdpr?.acceptedCategories = postResponse.acceptedCategories ?? getResponse?.gdpr?.acceptedCategories ?? []
        state.gdpr?.acceptedSpecialFeatures = postResponse.acceptedSpecialFeatures ?? getResponse?.gdpr?.acceptedSpecialFeatures ?? []
        storage.spState = state
    }

    func reportGDPRAction(_ action: SPAction, _ getResponse: SPMobileCore.ChoiceAllResponse?, _ handler: @escaping ActionHandler) {
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
        _ getResponse: SPMobileCore.ChoiceAllResponse?,
        _ postResponse: SPMobileCore.CCPAChoiceResponse
    ) {
        if action.type == .SaveAndExit {
            state.ccpa?.GPPData = postResponse.gppData.toNative() ?? SPJson()
        }
        state.ccpa?.uuid = postResponse.uuid
        state.ccpa?.dateCreated = SPDate(string: postResponse.dateCreated ?? "")
        state.ccpa?.status = postResponse.status?.toNative() ?? getResponse?.ccpa?.status.toNative() ?? .RejectedAll
        state.ccpa?.rejectedVendors = postResponse.rejectedVendors ?? getResponse?.ccpa?.rejectedVendors ?? []
        state.ccpa?.rejectedCategories = postResponse.rejectedCategories ?? getResponse?.ccpa?.rejectedCategories ?? []
        state.ccpa?.webConsentPayload = postResponse.webConsentPayload ?? getResponse?.ccpa?.webConsentPayload
        storage.spState = state
    }

    func reportCCPAAction(_ action: SPAction, _ getResponse: SPMobileCore.ChoiceAllResponse?, _ handler: @escaping ActionHandler) {
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
        _ getResponse: SPMobileCore.ChoiceAllResponse?,
        _ postResponse: SPMobileCore.USNatChoiceResponse
    ) {
        state.usnat = SPUSNatConsent(
            uuid: postResponse.uuid,
            applies: state.usnat?.applies ?? false,
            dateCreated: SPDate(string: postResponse.dateCreated ?? ""),
            expirationDate: SPDate(string: postResponse.expirationDate ?? ""),
            consentStrings: postResponse.consentStrings.map { $0.toNative() },
            webConsentPayload: postResponse.webConsentPayload ?? getResponse?.usnat?.webConsentPayload,
            categories: postResponse.userConsents.categories.map { $0.toNative() },
            vendors: postResponse.userConsents.vendors.map { $0.toNative() },
            consentStatus: postResponse.consentStatus.toNative(),
            GPPData: postResponse.gppData.toNative() ?? getResponse?.usnat?.gppData.toNative()
        )

        storage.spState = state
    }

    func reportUSNatAction(_ action: SPAction, _ getResponse: SPMobileCore.ChoiceAllResponse?, _ handler: @escaping ActionHandler) {
        self.postChoice(action) { postResult in
            switch postResult {
                case .success(let response):
                    self.handleUSNatPostChoice(action, getResponse, response)
                    handler(Result.success(self.userData))

                case .failure(let error):
                    // flag to sync again later
                    handler(Result.failure(error))
            }
        }
    }

    func reportAction(_ action: SPAction, handler: @escaping ActionHandler) {
        coreCoordinator.authId = authId
        coreCoordinator.idfaStatus = idfaStatus.toCore()
        coreCoordinator.includeData = includeData.toCore()
        coreCoordinator.state = state.toCore()
        getChoiceAll(action) { getResult in
            switch getResult {
                case .success(let getResponse):
                    switch action.campaignType {
                        case .gdpr: self.reportGDPRAction(action, getResponse, handler)
                        case .ccpa: self.reportCCPAAction(action, getResponse, handler)
                        case .usnat: self.reportUSNatAction(action, getResponse, handler)
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
            messageId: Int(state.ios14?.messageId ?? ""),
            idfaStatus: status,
            iosVersion: osVersion,
            partitionUUID: state.ios14?.partitionUUID
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
        _ result: Result<SPMobileCore.GDPRConsent, SPError>,
        handler: @escaping GDPRCustomConsentHandler
    ) {
        switch result {
            case .success(let consents):
                state.gdpr?.vendorGrants = consents.toNativeAsAddOrDeleteCustomConsentResponse().grants
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

// swiftlint:enable type_body_length 
