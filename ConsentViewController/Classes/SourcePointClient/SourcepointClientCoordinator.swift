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
}

class SourcepointClientCoordinator: SPClientCoordinator {
    struct State: Codable {
        static let version = 4

        struct GDPRMetaData: Codable, SPSampleable, Equatable {
            var vendorListId: String?
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
            var vendorListId: String?
            var applicableSections: [Int] = []
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

    var userData: SPUserData { coreCoordinator.userData.toNative() }

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
        self.state = State()
        self.updateCoreStorage()
    }

    func updateCoreStorage() {
        if let localState = storage.localState {
            coreCoordinator.repository.cachedLocalState = localState.toCore()
        }
        if let tcfData = storage.tcfData, tcfData.isNotEmpty() {
            coreCoordinator.repository.cachedTcData = tcfData.mapValues { JsonKt.toJsonPrimitive($0) }
        }
        if let gppData = storage.gppData, gppData.isNotEmpty() {
            coreCoordinator.repository.cachedGppData = gppData.mapValues { JsonKt.toJsonPrimitive($0) }
        }
        if let usPrivacyString = storage.usPrivacyString, usPrivacyString.isNotEmpty() {
            coreCoordinator.repository.cachedUspString = usPrivacyString
        }
        if storage.userData.gdpr != nil || storage.userData.ccpa != nil || storage.userData.usnat != nil {
            coreCoordinator.repository.cachedUserData = SPMobileCore.SPUserData(
                gdpr: SPUserDataSPConsent(consents: storage.userData.gdpr?.consents?.toCore()),
                ccpa: SPUserDataSPConsent(consents: storage.userData.ccpa?.consents?.toCore()),
                usnat: SPUserDataSPConsent(consents: storage.userData.usnat?.consents?.toCore())
            )
        }
        if let gdprChildPmId = storage.gdprChildPmId {
            coreCoordinator.repository.cachedGdprChildPmId = gdprChildPmId
        }
        if let ccpaChildPmId = storage.ccpaChildPmId {
            coreCoordinator.repository.cachedCcpaChildPmId = ccpaChildPmId
        }
        if let spState = storage.spState {
            coreCoordinator.repository.cachedSPState = spState.toCore()
        }
        storage.clear()
        print(coreCoordinator.repository.cachedSPState)
        //coreCoordinator.repository.clear()
    }

    func loadMessages(forAuthId authId: String?, pubData: SPPublisherData?, _ handler: @escaping MessagesAndConsentsHandler) {
        coreCoordinator.authId = authId
        coreCoordinator.idfaStatus = idfaStatus.toCore()
        coreCoordinator.includeData = includeData.toCore()
        coreCoordinator.campaigns = campaigns.toCore()
        coreCoordinator.loadMessages(authId: authId, pubData: JsonKt.encodeToJsonObject(pubData?.toCore())) { response, error in
            if error != nil {
                let coreError = SPError()
                self.logErrorMetrics(coreError)
                handler(Result.failure(coreError))
            } else {
                self.updateStateFromCore(coreState: self.coreCoordinator.state)
                var messageToDisplay: [MessageToDisplay]
                if let response = response.toNative() {
                    messageToDisplay = response
                } else {
                    messageToDisplay = []
                }
                let result = LoadMessagesReturnType(messageToDisplay, self.userData)
                handler(Result.success(result))
            }
        }
    }

    func updateStateFromCore(coreState: SPMobileCore.State) {
        state.gdpr?.applies = coreState.gdpr?.applies ?? false
        state.gdpr?.uuid = coreState.gdpr?.uuid
        state.gdpr?.dateCreated = SPDate(string: coreState.gdpr?.dateCreated ?? "")
        state.gdpr?.expirationDate = SPDate(string: coreState.gdpr?.expirationDate ?? "")
        state.gdpr?.tcfData = coreState.gdpr?.tcData.toNative()
        state.gdpr?.vendorGrants = coreState.gdpr?.grants.mapValues { $0.toNative() } ?? state.gdpr?.vendorGrants ?? [:]
        state.gdpr?.webConsentPayload = coreState.gdpr?.webConsentPayload
        state.gdpr?.euconsent = coreState.gdpr?.euconsent ?? state.gdpr?.euconsent ?? ""
        state.gdpr?.consentStatus = coreState.gdpr?.consentStatus.toNative() ?? state.gdpr?.consentStatus ?? ConsentStatus()
        state.gdpr?.childPmId = coreState.gdpr?.childPmId
        state.gdpr?.googleConsentMode = coreState.gdpr?.gcmStatus?.toNative()
        state.gdpr?.acceptedVendors = coreState.gdpr?.vendors ?? state.gdpr?.acceptedVendors ?? []
        state.gdpr?.acceptedCategories = coreState.gdpr?.categories ?? state.gdpr?.acceptedCategories ?? []
        state.gdpr?.acceptedLegIntVendors = coreState.gdpr?.legIntVendors ?? state.gdpr?.acceptedLegIntVendors ?? []
        state.gdpr?.acceptedLegIntCategories = coreState.gdpr?.legIntCategories ?? state.gdpr?.acceptedLegIntCategories ?? []
        state.gdpr?.acceptedSpecialFeatures = coreState.gdpr?.specialFeatures ?? state.gdpr?.acceptedSpecialFeatures ?? []
        
        state.ccpa?.applies = coreState.ccpa?.applies ?? false
        state.ccpa?.uuid = coreState.ccpa?.uuid
        state.ccpa?.dateCreated = SPDate(string: coreState.ccpa?.dateCreated ?? "")
        state.ccpa?.expirationDate = SPDate(string: coreState.ccpa?.expirationDate ?? "")
        state.ccpa?.status = coreState.ccpa?.status?.toNative() ?? state.ccpa?.status ?? .Unknown
        state.ccpa?.GPPData = coreState.ccpa?.gppData.toNative() ?? SPJson()
        state.ccpa?.rejectedVendors = coreState.ccpa?.rejectedVendors  ?? state.ccpa?.rejectedVendors ?? []
        state.ccpa?.rejectedCategories = coreState.ccpa?.rejectedCategories ?? state.ccpa?.rejectedCategories ?? []
        state.ccpa?.webConsentPayload = coreState.ccpa?.webConsentPayload
        state.ccpa?.signedLspa = coreState.ccpa?.signedLspa?.boolValue ?? state.ccpa?.signedLspa ?? false
        state.ccpa?.consentStatus.rejectedAll = coreState.ccpa?.rejectedAll?.boolValue
        state.ccpa?.consentStatus.consentedAll = coreState.ccpa?.consentedAll?.boolValue
        
        state.usnat?.applies = coreState.usNat?.applies ?? false
        state.usnat?.uuid = coreState.usNat?.uuid
        state.usnat?.dateCreated = SPDate(string: coreState.usNat?.dateCreated ?? "")
        state.usnat?.expirationDate = SPDate(string: coreState.usNat?.expirationDate ?? "")
        state.usnat?.consentStatus = coreState.usNat?.consentStatus.toNative() ?? state.usnat?.consentStatus ?? ConsentStatus()
        state.usnat?.GPPData = coreState.usNat?.gppData.toNative()
        state.usnat?.consentStrings = coreState.usNat?.consentStrings.map { $0.toNative() } ?? state.usnat?.consentStrings ?? []
        state.usnat?.consentStatus.granularStatus?.gpcStatus = coreState.usNat?.consentStatus.granularStatus?.gpcStatus?.boolValue
        state.usnat?.webConsentPayload = coreState.usNat?.webConsentPayload
        state.usnat?.userConsents.vendors = coreState.usNat?.userConsents.vendors.map { $0.toNative() } ?? state.usnat?.userConsents.vendors ?? []
        state.usnat?.userConsents.categories = coreState.usNat?.userConsents.categories.map { $0.toNative() } ?? state.usnat?.userConsents.categories ?? []

        storage.spState = state
    }

    func buildChoiceAllCampaigns(action: SPAction) -> ChoiceAllRequest.ChoiceAllCampaigns {
        var gdprApplies: Bool?
        var ccpaApplies: Bool?
        var usnatApplies: Bool?
        switch action.campaignType {
        case .gdpr:
            gdprApplies = state.gdpr?.applies

        case .ccpa:
            ccpaApplies = state.ccpa?.applies

        case .usnat:
            usnatApplies = state.usnat?.applies

        case .ios14, .unknown:
            break
        }
        return .init(
            gdpr: .init(applies: gdprApplies ?? false),
            ccpa: .init(applies: ccpaApplies ?? false),
            usnat: .init(applies: usnatApplies ?? false)
        )
    }

    func reportAction(_ action: SPAction, handler: @escaping ActionHandler) {
        coreCoordinator.authId = authId
        coreCoordinator.idfaStatus = idfaStatus.toCore()
        coreCoordinator.includeData = includeData.toCore()
        coreCoordinator.reportAction(
            action: action.toCore(),
            campaigns: buildChoiceAllCampaigns(action: action)
        ) { _, error in
            if error != nil {
                handler(Result.failure(InvalidChoiceAllResponseError()))
            } else {
                self.updateStateFromCore(coreState: self.coreCoordinator.state)
                handler(Result.success(self.userData))
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
