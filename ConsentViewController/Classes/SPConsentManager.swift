//
//  SPConsentManager.swift
//  cmp-app-test-app
//
//  Created by Andre Herculano on 12/16/19.
//  Copyright © 2019 Sourcepoint. All rights reserved.
//

import Foundation

@objcMembers public class SPConsentManager: NSObject {
    static let ccpaBaseURL = URL(string: "https://cdn.privacy-mgmt.com/ccpa_pm/index.html")
    static let gdprBaseURL = URL(string: "https://cdn.privacy-mgmt.com/privacy-manager/index.html")
    static let DefaultTimeout = TimeInterval(30)
    static public var shouldCallErrorMetrics = true

    // MARK: - SPSDK
    /// By default, the SDK will remove all user consent data from UserDefaults, possibly triggering a message to be displayed again next time
    /// `.loadMessage` is called.
    /// Set this flag to `false` if you wish to opt-out from this behaviour.
    public var cleanUserDataOnError: Bool = true

    /// The timeout interval in seconds for the message being displayed
    public var messageTimeoutInSeconds = SPConsentManager.DefaultTimeout {
        didSet {
            spClient.setRequestTimeout(messageTimeoutInSeconds)
        }
    }

    /// Instructs the privacy manager to be displayed with this tab.
    /// By default the SDK will use the defult tab of PM
    public var privacyManagerTab = SPPrivacyManagerTab.Default

    /// Instructs the message to be displayed in this language. If the translation is missing, the fallback will be English.
    /// By default the SDK will use the locale defined by the WebView
    public var messageLanguage = SPMessageLanguage.BrowserDefault

    required public convenience init(accountId: Int, propertyName: SPPropertyName, campaignsEnv: SPCampaignEnv = .Public, campaigns: SPCampaigns, delegate: SPDelegate?) {
        self.init(
            accountId: accountId,
            propertyName: propertyName,
            campaignsEnv: campaignsEnv,
            campaigns: campaigns,
            delegate: delegate,
            spClient: SourcePointClient(accountId: accountId, propertyName: propertyName, campaignEnv: campaignsEnv, timeout: SPConsentManager.DefaultTimeout),
            storage: SPUserDefaults(storage: UserDefaults.standard)
        )
    }
    // MARK: - /SPSDK

    let accountId: Int
    let propertyName: SPPropertyName
    let campaigns: SPCampaigns
    let spClient: SourcePointProtocol
    let deviceManager: SPDeviceManager

    weak var delegate: SPDelegate?
    var authId: String?
    var storage: SPLocalStorage
    var messageControllersStack: [SPMessageViewController] = []
    var idfaStatus: SPIDFAStatus { SPIDFAStatus.current() }
    var ccpaUUID: String { storage.localState["ccpa"]?.dictionaryValue?["uuid"] as? String ?? "" }
    var gdprUUID: String { storage.localState["gdpr"]?.dictionaryValue?["uuid"] as? String ?? "" }
    var propertyId: Int? { storage.propertyId }
    var propertyIdString: String { propertyId != nil ? String(propertyId!) : "" }
    var iOSMessagePartitionUUID: String?

    init(
        accountId: Int,
        propertyName: SPPropertyName,
        campaignsEnv: SPCampaignEnv,
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
        case .nativePM(let content):
            var controller = (type == .gdpr ?
                SPGDPRNativePrivacyManagerViewController(
                    messageId: messageId,
                    campaignType: type,
                    viewData: content.homeView,
                    pmData: content,
                    delegate: self
                ) :
                SPCCPANativePrivacyManagerViewController(
                    messageId: messageId,
                    campaignType: type,
                    viewData: content.homeView,
                    pmData: content,
                    delegate: self
                )) as? SPNativePrivacyManagerHome
            controller?.delegate = self
            return controller as? SPNativeScreenViewController
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

    func storeData(localState: SPJson, userData: SPUserData, propertyId: Int?) {
        storage.propertyId = propertyId
        storage.localState = localState
        storage.userData = userData
        if let tcData = userData.gdpr?.consents?.tcfData {
            storage.tcfData = tcData.dictionaryValue
        }
        if let uspString = userData.ccpa?.consents?.uspstring {
            storage.usPrivacyString = uspString
        }
    }

    func report(action: SPAction) {
        switch action.campaignType {
        case .ccpa:
            spClient.postCCPAAction(authId: authId, action: action, localState: storage.localState, idfaStatus: idfaStatus) { [weak self] result in
                switch result {
                case .success((let localState, let consents)):
                    let userData = SPUserData(
                        gdpr: self?.storage.userData.gdpr,
                        ccpa: SPConsent(consents: consents, applies: true)
                    )
                    self?.storeData(
                        localState: localState,
                        userData: userData,
                        propertyId: self?.propertyId
                    )
                    self?.delegate?.onConsentReady?(userData: userData)
                case .failure(let error):
                    self?.onError(error)
                }
            }
        case .gdpr:
            spClient.postGDPRAction(authId: authId, action: action, localState: storage.localState, idfaStatus: idfaStatus) { [weak self] result in
                switch result {
                case .success((let localState, let consents)):
                    let userData = SPUserData(
                        gdpr: SPConsent(consents: consents, applies: true),
                        ccpa: self?.storage.userData.ccpa
                    )
                    self?.storeData(
                        localState: localState,
                        userData: userData,
                        propertyId: self?.propertyId
                    )
                    self?.delegate?.onConsentReady?(userData: userData)
                case .failure(let error):
                    self?.onError(error)
                }
            }
        default: break
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

    func onError(_ error: SPError) {
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

@objc extension SPConsentManager: SPSDK {
    public static let VERSION = "6.1.6"

    public static func clearAllData() {
        SPUserDefaults(storage: UserDefaults.standard).clear()
    }

    public var gdprApplies: Bool { storage.userData.gdpr?.applies ?? false }

    public var ccpaApplies: Bool { storage.userData.ccpa?.applies ?? false }

    public var userData: SPUserData { storage.userData }

    public func loadMessage(forAuthId authId: String? = nil) {
        self.authId = authId
        spClient.getMessages(
            campaigns: campaigns,
            authId: authId,
            localState: storage.localState,
            idfaStaus: idfaStatus,
            consentLanguage: messageLanguage
        ) { [weak self] result in
            switch result {
            case .success(let messagesResponse):
                self?.storeData(
                    localState: messagesResponse.localState,
                    userData: SPUserData(from: messagesResponse),
                    propertyId: messagesResponse.propertyId
                )
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

    public func loadGDPRPrivacyManager(withId id: String, tab: SPPrivacyManagerTab = .Default) {
        #if os(iOS)
        guard let pmUrl = SPConsentManager.gdprBaseURL?.appendQueryItems([
            "message_id": id,
            "pmTab": tab.rawValue,
            "consentUUID": gdprUUID,
            "idfaStatus": idfaStatus.description,
            "site_id": propertyIdString
        ]) else {
            onError(InvalidURLError(urlString: "Invalid PM URL"))
            return
        }
        loadWebPrivacyManager(.gdpr, pmUrl)
        #elseif os(tvOS)
        spClient.getNativePrivacyManager(withId: id) { [weak self] result in
            switch result {
            case .success(let content):
                let pmViewController = SPGDPRNativePrivacyManagerViewController(
                    messageId: Int(id),
                    campaignType: .gdpr,
                    viewData: content.homeView,
                    pmData: content,
                    delegate: self
                )
                pmViewController.delegate = self
                self?.loaded(pmViewController)
            case .failure(let error):
                self?.onError(error)
            }
        }
        #endif
    }

    public func loadCCPAPrivacyManager(withId id: String, tab: SPPrivacyManagerTab = .Default) {
        #if os(iOS)
        guard let pmUrl = SPConsentManager.ccpaBaseURL?.appendQueryItems([
            "message_id": id,
            "pmTab": tab.rawValue,
            "ccpaUUID": ccpaUUID,
            "idfaStatus": idfaStatus.description,
            "site_id": propertyIdString
        ]) else {
            onError(InvalidURLError(urlString: "Invalid PM URL"))
            return
        }
        loadWebPrivacyManager(.ccpa, pmUrl)
        #elseif os(tvOS)
        spClient.getNativePrivacyManager(withId: id) { [weak self] result in
            switch result {
            case .success(let content):
                let pmViewController = SPCCPANativePrivacyManagerViewController(
                    messageId: Int(id),
                    campaignType: .ccpa,
                    viewData: content.homeView,
                    pmData: content,
                    delegate: self
                )
                pmViewController.delegate = self
                self?.loaded(pmViewController)
            case .failure(let error):
                self?.onError(error)
            }
        }
        #endif
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
                    uuid: self?.gdprUUID,
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
}

extension SPConsentManager: SPMessageUIDelegate {
    func loaded(_ controller: SPMessageViewController) {
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.onSPUIReady(controller)
        }
    }

    func finished(_ vcFinished: SPMessageViewController) {
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.onSPUIFinished(vcFinished)
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
        delegate?.onAction(action, from: controller)
        switch action.type {
        case .AcceptAll, .RejectAll, .SaveAndExit:
            report(action: action)
            finishAndNextIfAny(controller)
        case .ShowPrivacyManager:
            guard let url = action.pmURL?.appendQueryItems(["site_id": propertyIdString]) else {
                onError(InvalidURLError(urlString: "Empty or invalid PM URL"))
                return
            }
            controller.loadPrivacyManager(url: url)
        case .PMCancel:
            controller.closePrivacyManager()
        case .Dismiss:
            finishAndNextIfAny(controller)
        case .RequestATTAccess:
            SPIDFAStatus.requestAuthorisation { [weak self] status in
                self?.reportIdfaStatus(status: status, messageId: controller.messageId)
                self?.finishAndNextIfAny(controller)
                if status == .accepted {
                    action.type = .IDFAAccepted
                    self?.delegate?.onAction(action, from: controller)
                } else if status == .denied {
                    action.type = .IDFADenied
                    self?.delegate?.onAction(action, from: controller)
                }
            }
        default:
            print("[SDK] UNKNOWN Action")
        }
    }
}

typealias SPGDPRSecondLayerHandler = (Result<GDPRPrivacyManagerViewResponse, SPError>) -> Void
typealias SPCCPASecondLayerHandler = (Result<CCPAPrivacyManagerViewResponse, SPError>) -> Void

protocol SPNativePMDelegate: AnyObject {
    func onGDPR2ndLayerNavigate(messageId: Int?, handler: @escaping SPGDPRSecondLayerHandler)
    func onCCPA2ndLayerNavigate(messageId: Int?, handler: @escaping SPCCPASecondLayerHandler)
}

extension SPConsentManager: SPNativePMDelegate {
    func onGDPR2ndLayerNavigate(messageId: Int?, handler: @escaping SPGDPRSecondLayerHandler) {
        if let propertyId = propertyId {
            spClient.gdprPrivacyManagerView(
                propertyId: propertyId,
                consentLanguage: messageLanguage
            ) { [weak self] result in
                switch result {
                case .failure(let error): self?.onError(error)
                case .success(var pmData):
                    pmData.grants = self?.userData.gdpr?.consents?.vendorGrants
                    handler(result.map { _ in pmData })
                }
            }
        }
    }

    func onCCPA2ndLayerNavigate(messageId: Int?, handler: @escaping SPCCPASecondLayerHandler) {
        if let propertyId = propertyId {
            spClient.ccpaPrivacyManagerView(
                propertyId: propertyId,
                consentLanguage: messageLanguage
            ) { [weak self] result in
                switch result {
                case .failure(let error): self?.onError(error)
                case .success(var pmData):
                    pmData.rejectedCategories = self?.userData.ccpa?.consents?.rejectedCategories
                    pmData.rejectedVendors = self?.userData.ccpa?.consents?.rejectedVendors
                    handler(result.map { _ in pmData })
                }
            }
        }
    }
}
