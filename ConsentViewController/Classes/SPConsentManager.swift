//
//  GDPRConsentViewController.swift
//  cmp-app-test-app
//
//  Created by Andre Herculano on 12/16/19.
//  Copyright © 2019 Sourcepoint. All rights reserved.
//

import UIKit

public typealias SPConsentUUID = String
typealias SPMeta = String

@objcMembers public class SPConsentManager: SPSDK {
    static public let VERSION = "6.0.0-beta1"

    static public var shouldCallErrorMetrics = true

    weak var delegate: SPDelegate?
    let accountId: Int
    let propertyName: SPPropertyName
    let campaigns: SPCampaigns
    let spClient: SourcePointProtocol
    var cleanUserDataOnError = true
    var storage: SPLocalStorage
    var consentsProfile: SPUserData { storage.userData }
    var messageControllersStack: [SPMessageViewController] = []

    public static func clearAllData() {
        SPUserDefaults(storage: UserDefaults.standard).clear()
    }

    public convenience init(accountId: Int, propertyName: SPPropertyName, campaigns: SPCampaigns, delegate: SPDelegate?) {
        self.init(
            accountId: accountId,
            propertyName: propertyName,
            campaigns: campaigns,
            delegate: delegate,
            spClient: SourcePointClient(accountId: accountId, propertyName: propertyName, timeout: 30),
            storage: SPUserDefaults(storage: UserDefaults.standard)
        )
    }

    init(
        accountId: Int,
        propertyName: SPPropertyName,
        campaigns: SPCampaigns,
        delegate: SPDelegate?,
        spClient: SourcePointProtocol,
        storage: SPLocalStorage) {
        self.accountId = accountId
        self.propertyName = propertyName
        self.campaigns = campaigns
        self.delegate = delegate
        self.spClient = spClient
        self.storage = storage
    }

    /// Instructs the privacy manager to be displayed with this tab.
    /// By default the SDK will use the defult tab of PM
    public var privacyManagerTab = SPPrivacyManagerTab.Default

    /// Instructs the message to be displayed in this language. If the translation is missing, the fallback will be English.
    /// By default the SDK will use the locale defined by the WebView
    public var messageLanguage = SPMessageLanguage.BrowserDefault

    func renderNextMessageIfAny () {
        DispatchQueue.main.async { [weak self] in
            if let ui = self?.messageControllersStack.popLast() {
                ui.loadMessage()
            } else {
                self?.delegate?.onConsentReady?(consents: SPUserData())
            }
        }
    }

    func messageToViewController (_ url: URL, _ message: Message?, _ type: SPCampaignType) -> SPMessageViewController? {
        switch message {
        case .native(let content):
            /// TODO: here we'd initialise the Native Message object
            /// Call a delegate Method to get the Message controller
            /// Pass the native message object to it
            return GenericWebMessageViewController(
                url: url,
                contents: content,
                campaignType: type,
                delegate: self
            )
        case .web(let content):
            return GenericWebMessageViewController(
                url: url,
                contents: content,
                campaignType: type,
                delegate: self
            )
        default:
            return nil
        }
    }

    public func loadMessage(forAuthId authId: String? = nil) {
        spClient.getMessages(
            campaigns: campaigns,
            authId: authId,
            localState: storage.localState,
            idfaStaus: SPIDFAStatus.current()
        ) { [weak self] result in
            switch result {
            case .success(let messagesResponse):
                self?.storage.localState = messagesResponse.localState
                self?.messageControllersStack = messagesResponse.campaigns
                    .filter { $0.message != nil }
                    .filter { $0.url != nil }
                    .compactMap { self?.messageToViewController($0.url!, $0.message, $0.type) }
                    .reversed()
                self?.renderNextMessageIfAny()
            case .failure(let error):
                self?.onError(error)
            }
        }
    }

    func report(action: SPAction) {
        switch action.campaignType {
        case .ccpa:
            spClient.postCCPAAction(action: action, consents: SPCCPAConsent.empty(), localState: storage.localState) { [weak self] result in
                switch result {
                case .success(let consentsResponse):
                    self?.storage.localState = consentsResponse.localState
                    self?.delegate?.onConsentReady?(consents: SPUserData())
                case .failure(let error):
                    self?.onError(error)
                }
            }
        case .gdpr:
            spClient.postGDPRAction(action: action, localState: storage.localState) { [weak self] result in
                switch result {
                case .success(let consentsResponse):
                    self?.storage.localState = consentsResponse.localState
                    self?.delegate?.onConsentReady?(consents: SPUserData())
                case .failure(let error):
                    self?.onError(error)
                }
            }
        default: break
        }
    }

    public func loadGDPRPrivacyManager() {
        loadPrivacyManager(.gdpr)
    }

    public func loadCCPAPrivacyManager() {
        loadPrivacyManager(.ccpa)
    }

    public func gdprApplies() -> Bool {
        /// TODO: implement
        consentsProfile.gdpr?.applies ?? false
    }

    public func ccpaApplies() -> Bool {
        /// TODO: implement
        consentsProfile.ccpa?.applies ?? false
    }

    func loadPrivacyManager(_ campaignType: SPCampaignType) {
        GenericWebMessageViewController(
            url: URL(string: "https://google.com")!, /// TODO: use real PM url
            contents: SPJson(),
            campaignType: campaignType,
            delegate: self
        ).loadPrivacyManager()
    }

    public func onError(_ error: SPError) {
        if cleanUserDataOnError {
            SPConsentManager.clearAllData()
        }
        delegate?.onError?(error: error)
    }
}

extension SPConsentManager: SPMessageUIDelegate {
    func loaded(_ controller: SPMessageViewController) {
        DispatchQueue.main.async {
            self.delegate?.onSPUIReady(controller)
        }
    }

    func finished() {
        DispatchQueue.main.async {
            self.delegate?.onSPUIFinished()
        }
    }

    func finishAndNextIfAny() {
        finished()
        renderNextMessageIfAny()
    }

    func action(_ action: SPAction, from controller: SPMessageViewController) {
        self.delegate?.onAction(action, from: controller)
        switch action.type {
        case .AcceptAll, .RejectAll, .SaveAndExit:
            report(action: action)
            finishAndNextIfAny()
        case .ShowPrivacyManager:
            if let url = action.pmURL {
                controller.loadPrivacyManager(url: url)
            } else {
                controller.loadPrivacyManager()
            }
        case .PMCancel:
            controller.closePrivacyManager()
        case .RequestATTAccess:
            SPIDFAStatus.requestAuthorisation { _ in
                self.finishAndNextIfAny()
            }
        default:
            print("[SDK] UNKNOWN Action")
        }
    }
}
