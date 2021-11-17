//
//  SPConsentManager.swift
//  cmp-app-test-app
//
//  Created by Andre Herculano on 12/16/19.
//  Copyright © 2019 Sourcepoint. All rights reserved.
//

import Foundation
import UIKit

@objcMembers public class SPConsentManager: NSObject {
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
    var messageControllersStack: [SPMessageView] = []
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

    func renderNextMessageIfAny() {
        DispatchQueue.main.async { [weak self] in
            if let ui = self?.messageControllersStack.popLast() {
                ui.loadMessage()
            }
        }
    }

    func nextMessageIfAny(_ vcFinished: UIViewController) {
        finished(vcFinished)
        renderNextMessageIfAny()
    }

    func messageToViewController(_ url: URL, _ messageId: String, _ message: Message?, _ type: SPCampaignType) -> SPMessageView? {
        switch message?.messageJson {
        case .native(let nativeMessage):
            nativeMessage.messageUIDelegate = self
            return nativeMessage
        #if os(tvOS)
        case .nativePM(let content):
            if type == .gdpr {
                let controller = SPGDPRNativePrivacyManagerViewController(
                    messageId: messageId,
                    campaignType: type,
                    viewData: content.homeView,
                    pmData: content,
                    delegate: self
                )
                controller.categories = message?.categories ?? []
                controller.delegate = self
                return controller
            }
            if type == .ccpa {
                let controller = SPCCPANativePrivacyManagerViewController(
                    messageId: messageId,
                    campaignType: type,
                    viewData: content.homeView,
                    pmData: content,
                    delegate: self
                )
                controller.delegate = self
                controller.snapshot = CCPAPMConsentSnaptshot()
                return controller
            }
            return nil
        #endif
        #if os(iOS)
        case .web:
            return GenericWebMessageViewController(
            url: url,
            messageId: messageId,
            contents: try! JSONEncoder().encode(message), // swiftlint:disable:this force_try
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
        let pmId = URLComponents(url: pmURL, resolvingAgainstBaseURL: false)?
            .queryItems?
            .first { $0.name == "message_id"}?
            .value ?? ""
        GenericWebMessageViewController(
            url: pmURL,
            messageId: pmId,
            contents: Data(),
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

@objc extension SPConsentManager: SPSDK {
    public static let VERSION = "6.3.1"

    public static func clearAllData() {
        SPUserDefaults(storage: UserDefaults.standard).clear()
    }

    public var gdprApplies: Bool { storage.userData.gdpr?.applies ?? false }

    public var ccpaApplies: Bool { storage.userData.ccpa?.applies ?? false }

    /// Returns the user data **stored in the `UserDefaults`**.
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
        guard let pmUrl = Constants.GDPR_PM_URL.appendQueryItems([
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
        spClient.getGDPRMessage(propertyId: propertyIdString, consentLanguage: messageLanguage, messageId: id) { [weak self] result in
            switch result {
            case .success(let message):
                guard case let .nativePM(nativePMMessage) = message.messageJson else {
                    self?.onError(SPError())
                    return
                }

                let pmViewController = SPGDPRNativePrivacyManagerViewController(
                    messageId: id,
                    campaignType: .gdpr,
                    viewData: nativePMMessage.homeView,
                    pmData: nativePMMessage,
                    delegate: self
                )
                pmViewController.categories = message.categories ?? []
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
        guard let pmUrl = Constants.CCPA_PM_URL.appendQueryItems([
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
        spClient.getCCPAMessage(propertyId: propertyIdString, consentLanguage: messageLanguage, messageId: id) { [weak self] result in
            switch result {
            case .success(let message):
                guard case let .nativePM(nativePMMessage) = message.messageJson else {
                    self?.onError(SPError())
                    return
                }
                let pmViewController = SPCCPANativePrivacyManagerViewController(
                    messageId: id,
                    campaignType: .ccpa,
                    viewData: nativePMMessage.homeView,
                    pmData: nativePMMessage,
                    delegate: self
                )
                pmViewController.delegate = self
                pmViewController.snapshot = CCPAPMConsentSnaptshot(withStatus: self?.userData.ccpa?.consents?.status)
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
    public func loaded(_ message: SPNativeMessage) {
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.onSPNativeMessageReady?(message)
        }
    }

    public func loaded(_ controller: UIViewController) {
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.onSPUIReady(controller)
        }
    }

    public func finished(_ vcFinished: UIViewController) {
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.onSPUIFinished(vcFinished)
        }
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

    public func action(_ action: SPAction, from controller: UIViewController) {
        delegate?.onAction(action, from: controller)
        switch action.type {
        case .AcceptAll, .RejectAll, .SaveAndExit:
            report(action: action)
            nextMessageIfAny(controller)
        case .ShowPrivacyManager:
            guard let url = action.pmURL?.appendQueryItems(["site_id": propertyIdString]) else {
                onError(InvalidURLError(urlString: "Empty or invalid PM URL"))
                return
            }
            if let spController = controller as? SPMessageViewController {
                spController.loadPrivacyManager(url: url)
            }
        case .PMCancel:
            if let spController = controller as? SPMessageViewController {
                spController.closePrivacyManager()
            }
        case .RequestATTAccess:
            SPIDFAStatus.requestAuthorisation { [weak self] status in
                let spController = controller as? SPMessageViewController
                self?.reportIdfaStatus(status: status, messageId: Int(spController?.messageId ?? ""))
                self?.nextMessageIfAny(controller)
                if status == .accepted {
                    action.type = .IDFAAccepted
                    self?.delegate?.onAction(action, from: controller)
                } else if status == .denied {
                    action.type = .IDFADenied
                    self?.delegate?.onAction(action, from: controller)
                }
            }
        default:
            nextMessageIfAny(controller)
        }
    }
}

typealias SPGDPRSecondLayerHandler = (Result<GDPRPrivacyManagerViewResponse, SPError>) -> Void
typealias SPCCPASecondLayerHandler = (Result<CCPAPrivacyManagerViewResponse, SPError>) -> Void

protocol SPNativePMDelegate: AnyObject {
    func onGDPR2ndLayerNavigate(messageId: String, handler: @escaping SPGDPRSecondLayerHandler)
    func onCCPA2ndLayerNavigate(messageId: String, handler: @escaping SPCCPASecondLayerHandler)
}

extension SPConsentManager: SPNativePMDelegate {
    func onGDPR2ndLayerNavigate(messageId: String, handler: @escaping SPGDPRSecondLayerHandler) {
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

    func onCCPA2ndLayerNavigate(messageId: String, handler: @escaping SPCCPASecondLayerHandler) {
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
                    pmData.consentStatus = self?.userData.ccpa?.consents?.status
                    handler(result.map { _ in pmData })
                }
            }
        }
    }
}
