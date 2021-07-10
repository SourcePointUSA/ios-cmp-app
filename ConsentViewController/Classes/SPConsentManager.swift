//
//  SPConsentManager.swift
//  cmp-app-test-app
//
//  Created by Andre Herculano on 12/16/19.
//  Copyright © 2019 Sourcepoint. All rights reserved.
//

import Foundation

@objcMembers public class SPConsentManager: NSObject, SPSDK {
    static let ccpaBaseURL = URL(string: "https://cdn.privacy-mgmt.com/ccpa_pm/index.html")
    static let gdprBaseURL = URL(string: "https://cdn.privacy-mgmt.com/privacy-manager/index.html")

    static public let VERSION = "6.1.3"
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
    var propertyId: Int? { storage.propertyId }
    var propertyIdString: String { propertyId != nil ? String(propertyId!) : "" }
    var iOSMessagePartitionUUID: String?

    var pmSecondLayerData: PrivacyManagerViewResponse?

    public static func clearAllData() {
        SPUserDefaults(storage: UserDefaults.standard).clear()
    }

    /// The timeout interval in seconds for the message being displayed
    public var messageTimeoutInSeconds = SPConsentManager.DefaultTimeout {
        didSet {
            spClient.setRequestTimeout(messageTimeoutInSeconds)
        }
    }

    public convenience init(accountId: Int, propertyName: SPPropertyName, campaignsEnv: SPCampaignEnv = .Public, campaigns: SPCampaigns, delegate: SPDelegate?) {
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
        case .nativePM(let content):
            let controller = SPNativePrivacyManagerViewController(
                messageId: messageId,
                campaignType: type,
                viewData: content.homeView,
                pmData: content,
                delegate: self
            )
            controller.vendorGrants = userData.gdpr?.consents?.vendorGrants
            return controller
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
                let pmViewController = SPNativePrivacyManagerViewController(
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
            }
        default:
            print("[SDK] UNKNOWN Action")
        }
    }
}

extension SPConsentManager: SPNativePMDelegate {
//    func onAcceptAllTap() {
//        print("Accept All")
//    }
//
//    func onRejectAllTap() {
//        print("Reject All")
//    }
//
//    func onSaveAndExitTap() {
//        print("Save And Exit")
//    }
//
//    func onVendorOnTap() {
//        print("Vendor On")
//    }
//
//    func onVendorOffTap() {
//        print("Vendor Off")
//    }
//
//    func onCategoryOnTap() {
//        print("Category On")
//    }
//
//    func onCategoryOffTap() {
//        print("Category Off")
//    }

    func on2ndLayerNavigating(messageId: Int?, handler: @escaping SPSecondLayerHandler) {
//        if let messageId = messageId {
//            spClient.mmsMessage(messageId: messageId) { result in
//                let response = try! result.get()
//                handler(SPJson(response.messageJson) ?? SPJson())
//            }
//        }
        if let propertyId = propertyId, pmSecondLayerData == nil {
            spClient.privacyManagerView(
                propertyId: propertyId,
                consentLanguage: messageLanguage
            ) { [weak self] result in
                switch result {
                case .failure(let error): self?.onError(error)
                case .success(let pmData):
                    self?.pmSecondLayerData = pmData
                    handler(result)
                }
            }
        } else {
            handler(Result { pmSecondLayerData! }.mapError({ InvalidResponseNativeMessageError(error: $0)
            }))
        }
    }
}

typealias SPSecondLayerHandler = (Result<PrivacyManagerViewResponse, SPError>) -> Void

protocol SPNativePMDelegate: AnyObject {
    func on2ndLayerNavigating(messageId: Int?, handler: @escaping SPSecondLayerHandler)
//    func onAcceptAllTap()
//    func onRejectAllTap()
//    func onSaveAndExitTap()
//    func onVendorOnTap()
//    func onVendorOffTap()
//    func onCategoryOnTap()
//    func onCategoryOffTap()
}
