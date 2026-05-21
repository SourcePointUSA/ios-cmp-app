//
//  SPDidomiConsentManager.swift
//  Pods
//
//  Created by Andre Herculano on 14/1/26.
//

import Foundation
import UIKit
import Didomi

typealias DidomiEventListener = EventListener
typealias DidomiEventType = EventType
typealias DidomiUserStatus = CurrentUserStatus

@objcMembers open class SPDidomiConsentManager: NSObject, SPSDK {
    public static var VERSION: String = SPConsentManager.VERSION

    public var cleanUserDataOnError = false

    public var messageTimeoutInSeconds: TimeInterval = 0.0

    public var privacyManagerTab: SPPrivacyManagerTab = .Default

    public var messageLanguage: SPMessageLanguage = .BrowserDefault

    public var userData: SPUserData { Didomi.shared.getCurrentUserStatus().toSourcepoint() }

    public var gdprApplies: Bool { userData.gdpr?.applies ?? false }

    public var ccpaApplies: Bool { userData.ccpa?.applies ?? false }

    public var usnatApplies: Bool { userData.usnat?.applies ?? false }

    public var globalcmpApplies: Bool { userData.globalcmp?.applies ?? false }

    var didomiEventListener = SPDidomiEventListener()

    public weak var didomiUIController: UIViewController?

    weak var appDelegate: SPDelegate?

    required public init(
        accountId: Int,
        propertyId: Int,
        propertyName: SPPropertyName,
        campaigns: SPCampaigns,
        language: SPMessageLanguage,
        delegate: SPDelegate?,
    ) {
        super.init()
        appDelegate = delegate
        Didomi.shared.initialize(DidomiInitializeParameters(
            accountId: accountId,
            propertyId: propertyId,
            propertyName: propertyName.rawValue
        ))
        didomiEventListener.onAction = { [weak self] action in
            if let strongSelf = self, let didomiUIController = strongSelf.didomiUIController {
                strongSelf.appDelegate?.onAction(action, from: didomiUIController)
            }
        }
        didomiEventListener.onConsentUIReady = { [weak self] viewController in
            if let strongSelf = self {
                strongSelf.appDelegate?.onSPUIReady(viewController)
            }
        }
        didomiEventListener.onConsentUIFinished = { [weak self] viewController in
            if let strongSelf = self {
                strongSelf.appDelegate?.onSPUIFinished(viewController)
            }
        }
        Didomi.shared.addEventListener(listener: didomiEventListener.didomiEventListener)
    }

    public static func clearAllData() {
        Didomi.shared.reset()
    }

    public func loadMessage(forAuthId authId: String? = nil, publisherData: [String: String]? = [:]) {
        loadMessage(forAuthId: authId, publisherData: publisherData?.mapValues { AnyEncodable($0) })
    }

    public func loadMessage(forAuthId authId: String? = nil, publisherData: SPPublisherData? = [:]) {
        OSLogger.standard.begin("MessageFlow")
        // TODO: We'll need to think of a way to get the controller back from DDM SDK
        if let didomiUIController {
            Didomi.shared.setupUI(containerController: didomiUIController)
        }
    }

    public func loadGDPRPrivacyManager(withId id: String, tab: SPPrivacyManagerTab = .Default, useGroupPmIfAvailable: Bool = false) {
        OSLogger.standard.begin("MessageFlow")
        Didomi.shared.showPreferences()
    }

    public func loadCCPAPrivacyManager(withId id: String, tab: SPPrivacyManagerTab = .Default, useGroupPmIfAvailable: Bool = false) {
        OSLogger.standard.begin("MessageFlow")
        Didomi.shared.showPreferences()
    }

    public func loadUSNatPrivacyManager(withId id: String, tab: SPPrivacyManagerTab = .Default, useGroupPmIfAvailable: Bool = false) {
        OSLogger.standard.begin("MessageFlow")
        Didomi.shared.showPreferences()
    }

    public func loadGlobalCmpPrivacyManager(withId id: String, tab: SPPrivacyManagerTab = .Default, useGroupPmIfAvailable: Bool = false) {
        OSLogger.standard.begin("MessageFlow")
        Didomi.shared.showPreferences()
    }

    public func loadPreferenceCenter(withId id: String) {
        OSLogger.standard.begin("MessageFlow")
        Didomi.shared.showPreferences()
    }

    public func customConsentGDPR(vendors: [String], categories: [String], legIntCategories: [String], handler: @escaping (SPGDPRConsent) -> Void) {
        // TODO: we'll need a way to convert SP ids into DDM ids.
        Didomi.shared.setUserStatus(
            enabledConsentPurposeIds: Set<String>(),
            disabledConsentPurposeIds: Set<String>(),
            enabledLIPurposeIds: Set<String>(),
            disabledLIPurposeIds: Set<String>(),
            enabledConsentVendorIds: Set<String>(),
            disabledConsentVendorIds: Set<String>(),
            enabledLIVendorIds: Set<String>(),
            disabledLIVendorIds: Set<String>()
        )
    }

    public func deleteCustomConsentGDPR(vendors: [String], categories: [String], legIntCategories: [String], handler: @escaping (SPGDPRConsent) -> Void) {
        // TODO: we'll need a way to convert SP ids into DDM ids.
        Didomi.shared.setUserStatus(
            enabledConsentPurposeIds: Set<String>(),
            disabledConsentPurposeIds: Set<String>(),
            enabledLIPurposeIds: Set<String>(),
            disabledLIPurposeIds: Set<String>(),
            enabledConsentVendorIds: Set<String>(),
            disabledConsentVendorIds: Set<String>(),
            enabledLIVendorIds: Set<String>(),
            disabledLIVendorIds: Set<String>()
        )
    }

    public func rejectAll(campaignType: SPCampaignType) {
        Didomi.shared.setUserDisagreeToAll()
    }

    public func dismissMessage() {
        if Didomi.shared.isNoticeVisible() {
            Didomi.shared.hideNotice()
        } else if Didomi.shared.isPreferencesVisible() {
            Didomi.shared.hidePreferences()
        }
    }

    public func onMessageInactivityTimeout() {
        // TODO: implement this on DDM
    }

    public func onError(_ error: SPError) {
        OSLogger.standard.end("MessageFlow")
        appDelegate?.onError?(error: error)
    }

    public func finished(_ vcFinished: UIViewController) {}
    public func loaded(_ controller: UIViewController) {}
    public func action(_ action: SPAction, from controller: UIViewController) {}
}

// MARK: Didomi's stubbing

extension DidomiInitializeParameters {
    convenience init(accountId: Int, propertyId: Int, propertyName: String) {
        // TODO: The new implementation of the SDK will require apiKey and noticeID
        self.init(
            apiKey: "eea5ad63-29d4-4552-9dac-2edebe1fe518",
            noticeID: "BVP3EcHb",
            handleConsentUIAutomatically: false
        )
    }
}

class SPDidomiEventListener {
    var onConsentUIReady: (_ vc: UIViewController) -> Void = { _ in }
    var onConsentUIFinished: (_ vc: UIViewController) -> Void = { _ in }
    var onAction: (_ action: SPAction) -> Void = { _ in }
    var onError: (_ error: SPError) -> Void = { _ in }

    public var didomiEventListener = DidomiEventListener()

    lazy var defaultEventListenerLambda: (_ event: DidomiEventType) -> Void = { [weak self] eventType in
        print("DidomiEventType \(eventType)")
        switch eventType {
        case .noticeClickAgree, .preferencesClickAgreeToAll: // TODO: add .preferencesClickAgreeToAllVendors, .preferencesClickAgreeToAllPurposes ?
            self?.onAction(SPAction(type: .AcceptAll))
        case .noticeClickDisagree, .preferencesClickDisagreeToAll: // TODO: add .preferencesClickDisagreeToAllVendors, .preferencesClickDisagreeToAllPurposes ?
            self?.onAction(SPAction(type: .RejectAll))
        case .preferencesClickSaveChoices: // TODO: add .preferencesClickVendorSaveChoices ?
            self?.onAction(SPAction(type: .SaveAndExit))
        default: return
        }
    }

    init() {
        // TODO: remove listeners that are not used in the SP code
        didomiEventListener.onReady = defaultEventListenerLambda
        didomiEventListener.onShowNotice = defaultEventListenerLambda
        didomiEventListener.onHideNotice = defaultEventListenerLambda
        didomiEventListener.onShowPreferences = defaultEventListenerLambda
        didomiEventListener.onHidePreferences = defaultEventListenerLambda
        didomiEventListener.onConsentUIReady = { [weak self] event in
            if let vc = event?.viewController {
                self?.onConsentUIReady(vc)
            }
        }
        didomiEventListener.onConsentUIFinished = { [weak self] event in
            if let vc = event?.viewController {
                self?.onConsentUIFinished(vc)
            }
        }

        didomiEventListener.onNoticeClickAgree = defaultEventListenerLambda
        didomiEventListener.onPreferencesClickAgreeToAll = defaultEventListenerLambda
        didomiEventListener.onPreferencesClickAgreeToAllVendors = defaultEventListenerLambda
        didomiEventListener.onPreferencesClickAgreeToAllPurposes = defaultEventListenerLambda
        didomiEventListener.onNoticeClickDisagree = defaultEventListenerLambda
        didomiEventListener.onPreferencesClickDisagreeToAll = defaultEventListenerLambda
        didomiEventListener.onPreferencesClickDisagreeToAllVendors = defaultEventListenerLambda
        didomiEventListener.onPreferencesClickDisagreeToAllPurposes = defaultEventListenerLambda
        didomiEventListener.onPreferencesClickSaveChoices = defaultEventListenerLambda
        didomiEventListener.onPreferencesClickVendorSaveChoices = defaultEventListenerLambda
        didomiEventListener.onNoticeClickMoreInfo = defaultEventListenerLambda
        didomiEventListener.onNoticeClickViewVendors = defaultEventListenerLambda
        didomiEventListener.onError = { [weak self] errorEvent in
            self?.onError(SPError(error: SPDidomiError(errorEvent)))
        }
    }
}

struct SPDidomiError: Error {
    var debugDescription: String?

    init(_ didomiErrorEvent: DidomiErrorEvent) {
        debugDescription = """
            DidomiErrorEvent(
                -type: \(didomiErrorEvent.type),
                -descriptionText: \(didomiErrorEvent.descriptionText)
            )
        """
    }
}

extension DidomiEventType: @retroactive CustomStringConvertible {
    public var description: String {
        switch self {
        case .ready: return ".ready"
        case .showNotice: return ".showNotice"
        case .hideNotice: return ".hideNotice"
        case .showPreferences: return ".showPreferences"
        case .hidePreferences: return ".hidePreferences"
        case .noticeClickAgree: return ".noticeClickAgree"
        case .preferencesClickAgreeToAll: return ".preferencesClickAgreeToAll"
        case .preferencesClickAgreeToAllVendors: return ".preferencesClickAgreeToAllVendors"
        case .preferencesClickAgreeToAllPurposes: return ".preferencesClickAgreeToAllPurposes"
        case .noticeClickDisagree: return ".noticeClickDisagree"
        case .preferencesClickDisagreeToAll: return ".preferencesClickDisagreeToAll"
        case .preferencesClickDisagreeToAllVendors: return ".preferencesClickDisagreeToAllVendors"
        case .preferencesClickDisagreeToAllPurposes: return ".preferencesClickDisagreeToAllPurposes"
        case .preferencesClickSaveChoices: return ".preferencesClickSaveChoices"
        case .preferencesClickVendorSaveChoices: return ".preferencesClickVendorSaveChoices"
        case .noticeClickMoreInfo: return ".noticeClickMoreInfo"
        case .noticeClickViewVendors: return ".noticeClickViewVendors"
        case .consentChanged: return ".consentChanged"
        case .integrationError: return ".error"
        case .noticeClickPrivacyPolicy: return ".noticeClickPrivacyPolicy"
        case .preferencesClickResetAllPurposes: return ".preferencesClickResetAllPurposes"
        case .preferencesClickPurposeAgree: return ".preferencesClickPurposeAgree"
        case .preferencesClickPurposeDisagree: return ".preferencesClickPurposeDisagree"
        case .preferencesClickCategoryAgree: return ".preferencesClickCategoryAgree"
        case .preferencesClickCategoryDisagree: return ".preferencesClickCategoryDisagree"
        case .preferencesClickViewVendors: return ".preferencesClickViewVendors"
        case .preferencesClickViewPurposes: return ".preferencesClickViewPurposes"
        case .preferencesClickVendorAgree: return ".preferencesClickVendorAgree"
        case .preferencesClickVendorDisagree: return ".preferencesClickVendorDisagree"
        case .syncUserChanged: return ".syncUserChanged"
        case .syncDone: return ".syncDone"
        case .syncReady: return ".syncReady"
        case .syncError: return ".syncError"
        case .languageUpdated: return ".languageUpdated"
        case .languageUpdateFailed: return ".languageUpdateFailed"
        case .noticeClickViewSPIPurposes: return ".noticeClickViewSPIPurposes"
        case .preferencesClickViewSPIPurposes: return ".preferencesClickViewSPIPurposes"
        case .preferencesClickSPIPurposeAgree: return ".preferencesClickSPIPurposeAgree"
        case .preferencesClickSPIPurposeDisagree: return ".preferencesClickSPIPurposeDisagree"
        case .preferencesClickSPICategoryAgree: return ".preferencesClickSPICategoryAgree"
        case .preferencesClickSPICategoryDisagree: return ".preferencesClickSPICategoryDisagree"
        case .preferencesClickSPIPurposeSaveChoices: return ".preferencesClickSPIPurposeSaveChoices"
        case .dcsSignatureReady: return ".dcsSignatureReady"
        case .dcsSignatureError: return ".dcsSignatureError"
        @unknown default:
            fatalError()
        }
    }
}

extension DidomiUserStatus {
    // TODO: provide all legislation consents from DDM
    /// With SP, developers get an object `SPUserData` with all legislation consents, regardless if they apply to the current geolocation or not.
    /// We might have to implement a way on DDM to get that for all legislations, not only the "current".
    func toSourcepoint() -> SPUserData {
        var gdpr: SPConsent<SPGDPRConsent>? = nil
        var ccpa: SPConsent<SPCCPAConsent>? = nil // TODO: can we remove support to ccpa?
        var usnat: SPConsent<SPUSNatConsent>? = nil
        var preferences: SPConsent<SPPreferencesConsent>? = nil // TODO: does DDM support something like Preferences?
        var globalcmp: SPConsent<SPGlobalCmpConsent>? = nil

        switch regulation {
            case .gdpr:
                gdpr = SPConsent(consents: .empty(), applies: true)
            case .cpra:
                ccpa = SPConsent(consents: .empty(), applies: true)
            default: break
        }

        return SPUserData(gdpr: gdpr, ccpa: ccpa, usnat: usnat, globalcmp: globalcmp, preferences: preferences)
    }
}
