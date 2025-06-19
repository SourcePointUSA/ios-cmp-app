//
//  SourcepointClientCoordinator.swift
//  Pods
//
//  Created by Andre Herculano on 14.09.22.
//
// swiftlint:disable type_body_length

import Foundation
import SPMobileCore

typealias CoreCoordinator = SPMobileCore.Coordinator

typealias ErrorHandler = (SPError) -> Void
typealias LoadMessagesReturnType = [MessageToDisplay]
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
    var gdprChildPmId: String? { get }
    var ccpaChildPmId: String? { get }
    var globalcmpChildPmId: String? { get }

    func loadMessages(forAuthId: String?, pubData: SPPublisherData?, _ handler: @escaping MessagesAndConsentsHandler)
    func reportAction(_ action: SPAction, handler: @escaping (Result<SPUserData, SPError>) -> Void)
    func reportIdfaStatus(osVersion: String)
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

        var accountId, propertyId: Int?

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
    let coreClient: CoreClient
    lazy var coreCoordinator: CoreCoordinator = CoreCoordinator.init(
        accountId: Int32(accountId),
        propertyId: Int32(propertyId),
        propertyName: propertyName.coreValue,
        campaigns: campaigns.toCore(),
        timeoutInSeconds: Int32(5)
    )
    let coreStorage: SPMobileCore.Repository
    var storage: SPLocalStorage

    var state: State

    var gdprChildPmId: String? { coreCoordinator.userData.gdpr?.childPmId }
    var ccpaChildPmId: String? { coreCoordinator.userData.ccpa?.childPmId }
    var globalcmpChildPmId: String? { coreCoordinator.userData.globalcmp?.childPmId }

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
        self.storage = storage
        self.spClient = spClient ?? SourcePointClient(
            accountId: accountId,
            propertyName: propertyName,
            propertyId: propertyId,
            campaignEnv: campaigns.environment,
            timeout: SPConsentManager.DefaultTimeout
        )
        self.state = State()
        self.deviceManager = deviceManager
        self.coreStorage = SPMobileCore.Repository.init()
        self.coreClient = CoreClient.init(
            accountId: Int32(accountId),
            propertyId: Int32(propertyId),
            requestTimeoutInSeconds: Int32(5)
        )
        self.coreCoordinator = CoreCoordinator.init(
            accountId: Int32(accountId),
            propertyId: Int32(propertyId),
            propertyName: propertyName.coreValue,
            campaigns: campaigns.toCore(),
            repository: coreStorage,
            timeoutInSeconds: Int32(5),
            spClient: coreClient,
            authId: nil,
            state: {
                if let localState = storage.spState {
                    storage.clear()
                    return localState.toCore(propertyId: propertyId, accountId: accountId)
                } else {
                    return coreStorage.state ?? State().toCore(propertyId: propertyId, accountId: accountId)
                }
            }()
        )
        self.coreCoordinator.getIDFAStatus = { return self.idfaStatus.toCore() }
        #if os(tvOS)
        coreCoordinator.setTranslateMessage(value: true)
        #endif
    }

    func loadMessages(forAuthId authId: String?, pubData: SPPublisherData?, _ handler: @escaping MessagesAndConsentsHandler) {
        coreCoordinator.loadMessages(authId: authId, pubData: JsonKt.encodeToJsonObject(pubData?.toCore()), language: language.toCore()) { response, error in
            if error != nil {
                var coreError = SPError()
                if let nsError = error as? NSError {
                    coreError = SPError.convertCoreError(error: nsError)
                }
                coreError.coreError = error as? CoreSPError
                handler(Result.failure(coreError))
            } else {
                self.updateStateFromCore(coreUserData: self.coreCoordinator.userData)
                var messageToDisplay: [MessageToDisplay]
                if let response = response.toNative() {
                    messageToDisplay = response
                } else {
                    messageToDisplay = []
                }
                let result = LoadMessagesReturnType(messageToDisplay)
                handler(Result.success(result))
            }
        }
    }

    func updateStateFromCore(coreUserData: SPMobileCore.SPUserData) {
        if let gdprData = coreUserData.gdpr?.consents {
            state.gdpr = SPGDPRConsent(
                uuid: gdprData.uuid,
                vendorGrants: gdprData.grants.mapValues { $0.toNative() },
                euconsent: gdprData.euconsent ?? "",
                tcfData: gdprData.tcData.toNative(),
                dateCreated: SPDate(string: gdprData.dateCreated.instantToString()),
                expirationDate: SPDate(string: gdprData.expirationDate.instantToString()),
                applies: gdprData.applies,
                consentStatus: gdprData.consentStatus.toNative(),
                webConsentPayload: gdprData.webConsentPayload,
                googleConsentMode: gdprData.gcmStatus?.toNative(),
                acceptedLegIntCategories: gdprData.legIntCategories,
                acceptedLegIntVendors: gdprData.legIntVendors,
                acceptedVendors: gdprData.vendors,
                acceptedCategories: gdprData.categories,
                acceptedSpecialFeatures: gdprData.specialFeatures
            )
        }
        if let ccpaData = coreUserData.ccpa?.consents {
            state.ccpa = SPCCPAConsent(
                uuid: ccpaData.uuid,
                status: ccpaData.status?.toNative() ?? .Unknown,
                rejectedVendors: ccpaData.rejectedVendors,
                rejectedCategories: ccpaData.rejectedCategories,
                signedLspa: ccpaData.signedLspa?.boolValue ?? state.ccpa?.signedLspa ?? false,
                applies: ccpaData.applies,
                dateCreated: SPDate(string: ccpaData.dateCreated.instantToString()),
                expirationDate: SPDate(string: ccpaData.expirationDate.instantToString()),
                consentStatus: ConsentStatus(consentedAll: ccpaData.consentedAll, rejectedAll: ccpaData.rejectedAll),
                webConsentPayload: ccpaData.webConsentPayload,
                GPPData: ccpaData.gppData.toNative() ?? SPJson()
            )
        }
        if let usnatData = coreUserData.usnat?.consents {
            state.usnat = SPUSNatConsent(
                uuid: usnatData.uuid,
                applies: usnatData.applies,
                dateCreated: SPDate(string: usnatData.dateCreated.instantToString()),
                expirationDate: SPDate(string: usnatData.expirationDate.instantToString()),
                consentStrings: usnatData.consentStrings.map { $0.toNative() },
                webConsentPayload: usnatData.webConsentPayload,
                categories: usnatData.userConsents.categories.map { $0.toNative() },
                vendors: usnatData.userConsents.vendors.map { $0.toNative() },
                consentStatus: usnatData.consentStatus.toNative(),
                GPPData: usnatData.gppData.toNative()
            )
        }
    }

    func reportAction(_ action: SPAction, handler: @escaping ActionHandler) {
        coreCoordinator.reportAction(
            action: action.toCore()
        ) { _, error in
            if error != nil {
                var coreError = SPError()
                if let nsError = error as? NSError {
                    coreError = SPError.convertCoreError(error: nsError)
                }
                coreError.coreError = error as? CoreSPError
                handler(Result.failure(coreError))
            } else {
                self.updateStateFromCore(coreUserData: self.coreCoordinator.userData)
                handler(Result.success(self.userData))
            }
        }
    }

    func reportIdfaStatus(osVersion: String) {
        coreCoordinator.reportIdfaStatus(osVersion: osVersion, requestUUID: UUID().uuidString) { _ in }
    }

    func logErrorMetrics(_ error: SPError) {
        if let logError = error.coreError {
            coreCoordinator.logError(error: logError) { _ in }
        } else {
            coreCoordinator.logError(error: error.toCore()) { _ in }
        }
    }

    func updateAfterCustomConsent(
        _ error: Error?,
        handler: @escaping GDPRCustomConsentHandler
    ) {
        if error == nil {
            updateStateFromCore(coreUserData: coreCoordinator.userData)
            handler(Result.success(state.gdpr ?? .empty()))
        } else {
            var coreError = SPError()
            if let nsError = error as? NSError {
                coreError = SPError.convertCoreError(error: nsError)
            }
            coreError.coreError = error as? CoreSPError
            handler(Result.failure(coreError))
        }
    }

    func deleteCustomConsentGDPR(
        vendors: [String],
        categories: [String],
        legIntCategories: [String],
        handler: @escaping GDPRCustomConsentHandler
    ) {
        coreCoordinator.deleteCustomConsentGDPR(
            vendors: vendors,
            categories: categories,
            legIntCategories: legIntCategories
        ) {
            self.updateAfterCustomConsent($0, handler: handler)
        }
    }

    func customConsentGDPR(
        vendors: [String],
        categories: [String],
        legIntCategories: [String],
        handler: @escaping GDPRCustomConsentHandler
    ) {
        coreCoordinator.customConsentGDPR(
            vendors: vendors,
            categories: categories,
            legIntCategories: legIntCategories
        ) {
            self.updateAfterCustomConsent($0, handler: handler)
        }
    }

    func setRequestTimeout(_ timeout: TimeInterval) {
        spClient.setRequestTimeout(timeout)
    }
}

// swiftlint:enable type_body_length 
