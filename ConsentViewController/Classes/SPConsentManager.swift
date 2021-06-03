//
//  SPConsentManager.swift
//  cmp-app-test-app
//
//  Created by Andre Herculano on 12/16/19.
//  Copyright © 2019 Sourcepoint. All rights reserved.
//

import Foundation

@objcMembers public class SPConsentManager: NSObject, SPSDK {
    static public let VERSION = "6.0.3"

    static public var shouldCallErrorMetrics = true

    weak var delegate: SPDelegate?
    let accountId: Int
    let propertyName: SPPropertyName
    let campaigns: SPCampaigns

    var authId: String?
    let spClient: SourcePointProtocol
    let deviceManager: SPDeviceManager
    var cleanUserDataOnError = true
    var storage: SPLocalStorage
    public var userData: SPUserData { storage.userData }
    var messageControllersStack: [SPMessageViewController] = []
    var idfaStatus: SPIDFAStatus { SPIDFAStatus.current() }
    static let DefaultTimeout = TimeInterval(30)

    var ccpaUUID: String { storage.localState["ccpa"]?.dictionaryValue?["uuid"] as? String ?? "" }
    var gdprUUID: String { storage.localState["gdpr"]?.dictionaryValue?["uuid"] as? String ?? "" }
    var propertyId: Int?
    var iOSMessagePartitionUUID: String?

    public static func clearAllData() {
        SPUserDefaults(storage: UserDefaults.standard).clear()
    }

    /// The timeout interval in seconds for the message being displayed
    public var messageTimeoutInSeconds = SPConsentManager.DefaultTimeout {
        didSet {
            spClient.setRequestTimeout(self.messageTimeoutInSeconds)
        }
    }

    public convenience init(accountId: Int, propertyName: SPPropertyName, campaigns: SPCampaigns, delegate: SPDelegate?) {
        self.init(
            accountId: accountId,
            propertyName: propertyName,
            campaigns: campaigns,
            delegate: delegate,
            spClient: SourcePointClient(accountId: accountId, propertyName: propertyName, timeout: SPConsentManager.DefaultTimeout),
            storage: SPUserDefaults(storage: UserDefaults.standard)
        )
    }

    init(
        accountId: Int,
        propertyName: SPPropertyName,
        campaigns: SPCampaigns,
        delegate: SPDelegate?,
        spClient: SourcePointProtocol,
        storage: SPLocalStorage,
        deviceManager: SPDeviceManager = SPDevice()
    ) {
        self.accountId = accountId
        self.propertyName = propertyName
        self.campaigns = campaigns
        self.delegate = delegate
        self.spClient = spClient
        self.storage = storage
        self.deviceManager = deviceManager
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
            }
        }
    }

    func messageToViewController (_ url: URL, _ messageId: Int, _ message: Message?, _ type: SPCampaignType) -> SPMessageViewController? {
        switch message {
        case .native:
            /// TODO: Initialise the Native Message object
            /// Call a delegate Method to get the Message controller
            /// Pass the native message object to it
            return nil
        #if os(tvOS)
        case .nativePM(let content): return SPNativePrivacyManagerViewController(
            messageId: messageId,
            contents: content,
            campaignType: type,
            delegate: self
        )
        #endif
        #if os(iOS)
        case .web(let content): return GenericWebMessageViewController(
            url: url,
            messageId: messageId,
            contents: content,
            campaignType: type,
            timeout: messageTimeoutInSeconds,
            delegate: self
        )
        #endif
        default:
            return nil
        }
    }

    func storeData(localState: SPJson, userData: SPUserData) {
        storage.localState = localState
        storage.userData = userData
        if let tcData = userData.gdpr?.consents?.tcfData {
            storage.tcfData = tcData.dictionaryValue
        }
        if let uspString = userData.ccpa?.consents?.uspstring {
            storage.usPrivacyString = uspString
        }
    }

    public func loadMessage(forAuthId authId: String? = nil) {
        self.authId = authId
        spClient.getMessages(
            campaigns: campaigns,
            authId: authId,
            localState: storage.localState,
            idfaStaus: idfaStatus
        ) { [weak self] result in
            switch result {
            case .success(let messagesResponse):
                self?.storeData(
                    localState: messagesResponse.localState,
                    userData: SPUserData(from: messagesResponse)
                )
                self?.propertyId = messagesResponse.propertyId
                self?.messageControllersStack = messagesResponse.campaigns
                    .filter { $0.message != nil }
                    .filter {
                        if $0.type == .ios14 {
                            self?.iOSMessagePartitionUUID = $0.messageMetaData?.messagePartitionUUID
                        }
                        return $0.messageMetaData != nil
                    }
                    .filter { $0.url != nil }
                    .compactMap { self?.messageToViewController(
                        $0.url!,
                        $0.messageMetaData!.messageId,
                        $0.message,
                        $0.type
                    )}
                    .reversed()
                if self?.messageControllersStack.isEmpty ?? true {
                    self?.delegate?.onConsentReady?(userData: self?.storage.userData ?? SPUserData())
                } else {
                    self?.renderNextMessageIfAny()
                }
            case .failure(let error):
                self?.onError(error)
            }
        }
    }

    func report(action: SPAction) {
        switch action.campaignType {
        case .ccpa:
            spClient.postCCPAAction(authId: authId, action: action, localState: storage.localState, idfaStatus: idfaStatus) { [weak self] result in
                switch result {
                case .success(let consentsResponse):
                    let userData = SPUserData(
                        gdpr: self?.storage.userData.gdpr,
                        ccpa: SPConsent(consents: consentsResponse.userConsent, applies: true)
                    )
                    self?.storeData(
                        localState: consentsResponse.localState,
                        userData: userData
                    )
                    self?.delegate?.onConsentReady?(userData: userData)
                case .failure(let error):
                    self?.onError(error)
                }
            }
        case .gdpr:
            spClient.postGDPRAction(authId: authId, action: action, localState: storage.localState, idfaStatus: idfaStatus) { [weak self] result in
                switch result {
                case .success(let consentsResponse):
                    let userData = SPUserData(
                        gdpr: SPConsent(consents: consentsResponse.userConsent, applies: true),
                        ccpa: self?.storage.userData.ccpa
                    )
                    self?.storeData(
                        localState: consentsResponse.localState,
                        userData: userData
                    )
                    self?.delegate?.onConsentReady?(userData: userData)
                case .failure(let error):
                    self?.onError(error)
                }
            }
        default: break
        }
    }

    public func loadGDPRPrivacyManager(withId id: String, tab: SPPrivacyManagerTab = .Default) {
        #if os(iOS)
        let pmUrl = URL(string: "https://cdn.privacy-mgmt.com/privacy-manager/index.html?&message_id=\(id)&pmTab=\(tab.rawValue)&consentUUID=\(gdprUUID)&idfaStatus=\(idfaStatus)")!
        loadWebPrivacyManager(.gdpr, pmUrl)
        #elseif os(tvOS)
        spClient.getNativePrivacyManager(withId: id) { result in
            switch result {
            case .success(let pmContent):
                self.loaded(SPNativePrivacyManagerViewController(
                    messageId: nil, // TODO: make sure PM comes with message id
                    contents: pmContent,
                    campaignType: .gdpr,
                    delegate: self
                ))
            case .failure(let error):
                self.onError(error)
            }
        }
        #endif
    }

    public func loadCCPAPrivacyManager(withId id: String, tab: SPPrivacyManagerTab = .Default) {
        #if os(iOS)
        let pmUrl = URL(string: "https://ccpa-inapp-pm.sp-prod.net/ccpa_pm/index.html?&message_id=\(id)&pmTab=\(tab.rawValue)&ccpaUUID=\(ccpaUUID)&idfaStatus=\(idfaStatus)")!
        loadWebPrivacyManager(.ccpa, pmUrl)
        #elseif os(tvOS)
        /// TODO: load NativePM
        #endif
    }

    public func gdprApplies() -> Bool {
        storage.userData.gdpr?.applies ?? false
    }

    public func ccpaApplies() -> Bool {
        storage.userData.ccpa?.applies ?? false
    }

    public func customConsentGDPR(vendors: [String], categories: [String], legIntCategories: [String], handler: @escaping (SPGDPRConsent) -> Void) {
        guard let propertyId = propertyId, !gdprUUID.isEmpty else {
            onError(PostingConsentWithoutConsentUUID())
            return
        }
        spClient.customConsentGDPR(
            toConsentUUID: gdprUUID,
            vendors: vendors,
            categories: categories,
            legIntCategories: legIntCategories,
            propertyId: propertyId
        ) { [weak self] result in
            switch result {
            case .success(let consents):
                let newGDPRConsents = SPGDPRConsent(
                    vendorGrants: consents.grants,
                    euconsent: self?.storage.userData.gdpr?.consents?.euconsent ?? "",
                    tcfData: self?.storage.userData.gdpr?.consents?.tcfData ?? SPJson()
                )
                self?.storage.userData = SPUserData(
                    gdpr: SPConsent<SPGDPRConsent>(consents: newGDPRConsents, applies: self?.storage.userData.gdpr?.applies ?? false),
                    ccpa: self?.storage.userData.ccpa
                )
                handler(newGDPRConsents)
            case .failure(let error):
                self?.onError(error)
            }
        }
    }

    #if os(iOS)
    func loadWebPrivacyManager(_ campaignType: SPCampaignType, _ pmURL: URL) {
        let messageId = Int(
            URLComponents(url: pmURL, resolvingAgainstBaseURL: false)?
                .queryItems?
                .first { $0.name == "message_id"}?
                .value ?? ""
        )
        GenericWebMessageViewController(
            url: pmURL,
            messageId: messageId,
            contents: SPJson(),
            campaignType: campaignType,
            timeout: messageTimeoutInSeconds,
            delegate: self
        ).loadPrivacyManager(url: pmURL)
    }
    #endif

    public func onError(_ error: SPError) {
        spClient.errorMetrics(
            error,
            propertyId: propertyId,
            sdkVersion: SPConsentManager.VERSION,
            OSVersion: deviceManager.osVersion(),
            deviceFamily: deviceManager.osVersion(),
            campaignType: error.campaignType
        )
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

    func finished(_ vcFinished: SPMessageViewController) {
        DispatchQueue.main.async {
            self.delegate?.onSPUIFinished(vcFinished)
        }
    }

    func finishAndNextIfAny(_ vcFinished: SPMessageViewController) {
        finished(vcFinished)
        renderNextMessageIfAny()
    }

    func reportIdfaStatus(status: SPIDFAStatus, messageId: Int?) {
        var uuid = ""
        var uuidType: SPCampaignType?
        if !gdprUUID.isEmpty {
            uuid = gdprUUID
            uuidType = .gdpr
        } else if !ccpaUUID.isEmpty {
            uuid = ccpaUUID
            uuidType = .ccpa
        }
        spClient.reportIdfaStatus(
            propertyId: propertyId,
            uuid: uuid,
            uuidType: uuidType,
            messageId: messageId,
            idfaStatus: status,
            iosVersion: deviceManager.osVersion(),
            partitionUUID: iOSMessagePartitionUUID
        )
    }

    func action(_ action: SPAction, from controller: SPMessageViewController) {
        self.delegate?.onAction(action, from: controller)
        switch action.type {
        case .AcceptAll, .RejectAll, .SaveAndExit:
            report(action: action)
            finishAndNextIfAny(controller)
        case .ShowPrivacyManager:
            if let url = action.pmURL {
                controller.loadPrivacyManager(url: url)
            }
        case .PMCancel:
            controller.closePrivacyManager()
        case .Dismiss:
            finishAndNextIfAny(controller)
        case .RequestATTAccess:
            SPIDFAStatus.requestAuthorisation { status in
                self.reportIdfaStatus(status: status, messageId: controller.messageId)
                self.finishAndNextIfAny(controller)
            }
        default:
            print("[SDK] UNKNOWN Action")
        }
    }
}
