//
//  SPDidomiConsentManager.swift
//  Pods
//
//  Created by Andre Herculano on 14/1/26.
//

import Foundation
import UIKit
import Didomi

@objcMembers open class SPDidomiConsentManager: NSObject, SPSDK {
    public static var VERSION: String = SPConsentManager.VERSION

    public var cleanUserDataOnError = false

    public var messageTimeoutInSeconds: TimeInterval = 0.0

    public var privacyManagerTab: SPPrivacyManagerTab = .Default

    public var messageLanguage: SPMessageLanguage = .BrowserDefault

    private let userDataAdapter = UserDataAdapter()

    public var userData: SPUserData { userDataAdapter.adapt(from: Didomi.shared.getCurrentUserStatus()) }

    public var gdprApplies: Bool { userData.gdpr?.applies ?? false }

    public var ccpaApplies: Bool { userData.ccpa?.applies ?? false }

    public var usnatApplies: Bool { userData.usnat?.applies ?? false }

    public var globalcmpApplies: Bool { userData.globalcmp?.applies ?? false }

    var didomiEventListener = SPDidomiEventListener()

    public weak var didomiUIController: UIViewController?

    weak var appDelegate: SPDelegate?

    private var isConsentUIReady = false
    private var isDidomiReady = false
    private var pendingLoadMessage = false

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
        Didomi.shared.onReady { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.isDidomiReady = true

            // If loadMessage was called before ready, process it now
            if strongSelf.pendingLoadMessage {
                strongSelf.pendingLoadMessage = false
                strongSelf.checkAndProceedWithConsent()
            }
        }
        didomiEventListener.onAction = { [weak self] action in
            if let strongSelf = self, let didomiUIController = strongSelf.didomiUIController {
                strongSelf.appDelegate?.onAction(action, from: didomiUIController)
            }
        }
        didomiEventListener.onConsentChanged = { [weak self] in
            if let strongSelf = self, strongSelf.isConsentUIReady {
                strongSelf.appDelegate?.onConsentReady?(userData: strongSelf.userData)
            }
        }
        didomiEventListener.onConsentUIReady = { [weak self] viewController in
            if let strongSelf = self {
                strongSelf.isConsentUIReady = true
                strongSelf.appDelegate?.onSPUIReady(viewController)
            }
        }
        didomiEventListener.onConsentUIFinished = { [weak self] viewController in
            if let strongSelf = self {
                strongSelf.appDelegate?.onSPUIFinished(viewController)
                strongSelf.appDelegate?.onSPFinished?(userData: strongSelf.userData)
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

        // Wait for Didomi to be ready before checking shouldUserStatusBeCollected
        if isDidomiReady {
            checkAndProceedWithConsent()
        } else {
            pendingLoadMessage = true
        }
    }

    private func checkAndProceedWithConsent() {
        // Check if user status should be collected (only call after ready event)
        if !Didomi.shared.shouldUserStatusBeCollected() {
            // If user status collection is not needed, call callbacks immediately
            appDelegate?.onConsentReady?(userData: userData)
            appDelegate?.onSPFinished?(userData: userData)
            return
        }

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
