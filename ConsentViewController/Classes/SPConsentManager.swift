//
//  SPConsentManager.swift
//  cmp-app-test-app
//
//  Created by Andre Herculano on 12/16/19.
//  Copyright © 2019 Sourcepoint. All rights reserved.
//

import Foundation
import UIKit
// swiftlint:disable file_length
@objcMembers public class SPConsentManager: NSObject {
    static let DefaultTimeout = TimeInterval(30)
    static public var shouldCallErrorMetrics = true

    // MARK: - SPSDK
    /// By default, the SDK preservs all user consent data from UserDefaults in case `OnError` event happens.
    /// Set this flag to `true` if you wish to opt-out from this behaviour.
    /// If set to `true` will remove all user consent data from UserDefaults, possibly triggering a message to be displayed again next time
    public var cleanUserDataOnError: Bool = false

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

    required public convenience init(
        accountId: Int,
        propertyId: Int,
        propertyName: SPPropertyName,
        campaignsEnv: SPCampaignEnv = .Public,
        campaigns: SPCampaigns,
        delegate: SPDelegate?
    ) {
        let client = SourcePointClient(
            accountId: accountId,
            propertyName: propertyName,
            campaignEnv: campaignsEnv,
            timeout: SPConsentManager.DefaultTimeout
        )
        let localStorage = SPUserDefaults(storage: UserDefaults.standard)
        let coordinator = SourcepointClientCoordinator(
            accountId: accountId,
            propertyName: propertyName,
            propertyId: propertyId,
            campaigns: campaigns,
            storage: localStorage
        )
        self.init(
            accountId: accountId,
            propertyId: propertyId,
            propertyName: propertyName,
            campaignsEnv: campaignsEnv,
            campaigns: campaigns,
            delegate: delegate,
            spClient: client,
            storage: localStorage,
            spCoordinator: coordinator
        )
    }
    // MARK: - /SPSDK

    let accountId, propertyId: Int
    let propertyName: SPPropertyName
    let campaigns: SPCampaigns
    let spClient: SourcePointProtocol
    var spCoordinator: SPClientCoordinator
    let deviceManager: SPDeviceManager

    weak var delegate: SPDelegate?
    var authId: String? {
        didSet {
            spCoordinator.authId = authId
        }
    }
    var storage: SPLocalStorage
    var messageControllersStack: [SPMessageView] = []
    var idfaStatus: SPIDFAStatus { SPIDFAStatus.current() }
    var ccpaUUID: String { storage.localState?["ccpa"]?.dictionaryValue?["uuid"] as? String ?? "" }
    var gdprUUID: String { storage.localState?["gdpr"]?.dictionaryValue?["uuid"] as? String ?? "" }
    var iOSMessagePartitionUUID: String?
    var messagesToShow = 0
    var responsesToReceive = 0

    init(
        accountId: Int,
        propertyId: Int,
        propertyName: SPPropertyName,
        campaignsEnv: SPCampaignEnv,
        campaigns: SPCampaigns,
        delegate: SPDelegate?,
        spClient: SourcePointProtocol,
        storage: SPLocalStorage,
        spCoordinator: SPClientCoordinator,
        deviceManager: SPDeviceManager = SPDevice()
    ) {
        self.accountId = accountId
        self.propertyId = propertyId
        self.propertyName = propertyName
        self.campaigns = campaigns
        self.delegate = delegate
        self.spClient = spClient
        self.storage = storage
        self.deviceManager = deviceManager
        self.spCoordinator = spCoordinator
    }

    func handleSDKDone() {
        if messagesToShow == 0, responsesToReceive == 0 {
            delegate?.onSPFinished?(userData: userData)
        }
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

    func messageToViewController(_ url: URL, _ messageId: String, _ message: Message, _ type: SPCampaignType) -> SPMessageView? {
        switch message.messageJson {
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

    func storeConsent(userData: SPUserData) {
        storage.userData = userData
        if let tcData = userData.gdpr?.consents?.tcfData {
            storage.tcfData = tcData.dictionaryValue
        }
        if let uspString = userData.ccpa?.consents?.uspstring {
            storage.usPrivacyString = uspString
        }
    }

    func saveChildPmId(_ messages: [MessageToDisplay]) {
        for message in messages {
            switch message.type {
                case .ccpa: storage.ccpaChildPmId = message.childPmId
                case .gdpr: storage.ccpaChildPmId = message.childPmId
                default: break
            }
        }
    }

    func report(action: SPAction) {
        responsesToReceive += 1
        switch action.campaignType {
        case .ccpa:
            spClient.postCCPAAction(
                authId: authId,
                action: action,
                localState: storage.localState ?? SPJson(),
                idfaStatus: idfaStatus
            ) { [weak self] result in
                self?.responsesToReceive -= 1
                switch result {
                case .success((_, let consents)):
                    let userData = SPUserData(
                        gdpr: self?.storage.userData.gdpr,
                        ccpa: SPConsent(consents: consents, applies: true)
                    )
                    self?.storeConsent(userData: userData)
                    self?.onConsentReceived()
                case .failure(let error):
                    self?.onError(error)
                }
            }
        case .gdpr:
            spClient.postGDPRAction(
                authId: authId,
                action: action,
                localState: storage.localState ?? SPJson(),
                idfaStatus: idfaStatus
            ) { [weak self] result in
                self?.responsesToReceive -= 1
                switch result {
                case .success((_, let consents)):
                    let userData = SPUserData(
                        gdpr: SPConsent(consents: consents, applies: true),
                        ccpa: self?.storage.userData.ccpa
                    )
                    self?.storeConsent(userData: userData)
                    self?.onConsentReceived()
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

    func onConsentReceived() {
        delegate?.onConsentReady?(userData: storage.userData)
        handleSDKDone()
    }

    public func gracefullyDegradeOnError(_ error: SPError) {
        logErrorMetrics(error)
        let userData = storage.userData
        if !userData.isEqual(SPUserData()) {
            delegate?.onConsentReady?(userData: userData)
        } else {
            if cleanUserDataOnError {
                SPConsentManager.clearAllData()
            }
            delegate?.onError?(error: error)
        }
    }

    public func onError(_ error: SPError) {
        logErrorMetrics(error)
        if cleanUserDataOnError {
            SPConsentManager.clearAllData()
        }
        delegate?.onError?(error: error)
    }

    private func logErrorMetrics(_ error: SPError) {
        spClient.errorMetrics(
            error,
            propertyId: propertyId,
            sdkVersion: SPConsentManager.VERSION,
            OSVersion: deviceManager.osVersion(),
            deviceFamily: deviceManager.osVersion(),
            campaignType: error.campaignType
        )
    }

    private func selectPrivacyManagerId(fallbackId: String, groupPmId: String?, childPmId: String?) -> String {
        let hasGroupPmId = groupPmId != nil && groupPmId != ""
        let hasChildPmId = childPmId != nil && childPmId != ""
        if hasChildPmId, let childPmId = childPmId {
            return childPmId
        }
        if hasGroupPmId, !hasChildPmId {
            logErrorMetrics(MissingChildPmIdError(usedId: fallbackId))
        }
        return fallbackId
    }
}

@objc extension SPConsentManager: SPSDK {
    public static let VERSION = "6.7.1"

    public static func clearAllData() {
        SPUserDefaults(storage: UserDefaults.standard).clear()
    }

    public var gdprApplies: Bool { storage.userData.gdpr?.applies ?? false }

    public var ccpaApplies: Bool { storage.userData.ccpa?.applies ?? false }

    /// Returns the user data **stored in the `UserDefaults`**.
    public var userData: SPUserData { storage.userData }

    @nonobjc
    private func messagesToViewController(_ messages: [MessageToDisplay]) -> [SPMessageView] {
        messages
            .compactMap {
                if $0.type == .ios14 {
                    iOSMessagePartitionUUID = $0.metadata.messagePartitionUUID
                }
                return messageToViewController(
                    $0.url,
                    $0.metadata.messageId,
                    $0.message,
                    $0.type
                )
            }
            .reversed()
    }

    public func loadMessage(forAuthId authId: String? = nil, publisherData: SPPublisherData? = [:]) {
        self.authId = authId
        responsesToReceive += 1

        // TODO: - add message language to loadMessages
        spCoordinator.loadMessages { [weak self] result in
            if let strongSelf = self {
                strongSelf.responsesToReceive -= 1
                switch result {
                    case .success(let (messages, consents)):
                        strongSelf.storeConsent(userData: consents)
                        strongSelf.saveChildPmId(messages)
                        strongSelf.messageControllersStack = strongSelf.messagesToViewController(messages)
                        strongSelf.messagesToShow = strongSelf.messageControllersStack.count
                        if strongSelf.messageControllersStack.isEmpty {
                            strongSelf.onConsentReceived()
                        } else {
                            strongSelf.renderNextMessageIfAny()
                        }
                    case .failure(let error):
                        strongSelf.gracefullyDegradeOnError(error)
                }
            }
        }
    }

    public func loadGDPRPrivacyManager(withId id: String, tab: SPPrivacyManagerTab = .Default, useGroupPmIfAvailable: Bool = false) {
        messagesToShow += 1
        var usedId: String = id
        if useGroupPmIfAvailable {
            usedId = selectPrivacyManagerId(fallbackId: id, groupPmId: campaigns.gdpr?.groupPmId, childPmId: storage.gdprChildPmId)
        }
        #if os(iOS)
        guard let pmUrl = Constants.Urls.GDPR_PM_URL.appendQueryItems([
            "message_id": usedId,
            "pmTab": tab.rawValue,
            "consentUUID": gdprUUID,
            "idfaStatus": idfaStatus.description,
            "site_id": String(propertyId)
        ]) else {
            onError(InvalidURLError(urlString: "Invalid PM URL"))
            return
        }
        loadWebPrivacyManager(.gdpr, pmUrl)
        #elseif os(tvOS)
        spClient.getGDPRMessage(propertyId: propertyIdString, consentLanguage: messageLanguage, messageId: usedId) { [weak self] result in
            switch result {
            case .success(let message):
                guard case let .nativePM(nativePMMessage) = message.messageJson else {
                    self?.onError(SPError())
                    return
                }
                let pmViewController = SPGDPRNativePrivacyManagerViewController(
                    messageId: usedId,
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

    public func loadCCPAPrivacyManager(withId id: String, tab: SPPrivacyManagerTab = .Default, useGroupPmIfAvailable: Bool = false) {
        messagesToShow += 1
        var usedId: String = id
        if useGroupPmIfAvailable {
            usedId = selectPrivacyManagerId(fallbackId: id, groupPmId: campaigns.ccpa?.groupPmId, childPmId: storage.ccpaChildPmId)
        }
        #if os(iOS)
        guard let pmUrl = Constants.Urls.CCPA_PM_URL.appendQueryItems([
            "message_id": usedId,
            "pmTab": tab.rawValue,
            "ccpaUUID": ccpaUUID,
            "idfaStatus": idfaStatus.description,
            "site_id": String(propertyId)
        ]) else {
            onError(InvalidURLError(urlString: "Invalid PM URL"))
            return
        }
        loadWebPrivacyManager(.ccpa, pmUrl)
        #elseif os(tvOS)
        spClient.getCCPAMessage(propertyId: String(propertyId), consentLanguage: messageLanguage, messageId: usedId) { [weak self] result in
            switch result {
            case .success(let message):
                guard case let .nativePM(nativePMMessage) = message.messageJson else {
                    self?.onError(SPError())
                    return
                }
                let pmViewController = SPCCPANativePrivacyManagerViewController(
                    messageId: usedId,
                    campaignType: .ccpa,
                    viewData: nativePMMessage.homeView,
                    pmData: nativePMMessage,
                    delegate: self
                )
                pmViewController.delegate = self
//                pmViewController.snapshot = CCPAPMConsentSnaptshot(withStatus: self?.userData.ccpa?.consents?.status)
                self?.loaded(pmViewController)
            case .failure(let error):
                self?.onError(error)
            }
        }
        #endif
    }

    public func customConsentGDPR(vendors: [String], categories: [String], legIntCategories: [String], handler: @escaping (SPGDPRConsent) -> Void) {
        guard !gdprUUID.isEmpty else {
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

    public func deleteCustomConsentGDPR(vendors: [String], categories: [String], legIntCategories: [String], handler: @escaping (SPGDPRConsent) -> Void) {
        guard !gdprUUID.isEmpty else {
            onError(PostingConsentWithoutConsentUUID())
            return
        }
        spClient.deleteCustomConsentGDPR(
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
            self?.messagesToShow -= 1
            self?.handleSDKDone()
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
        onAction(action, from: controller)
        switch action.type {
        case .AcceptAll, .RejectAll, .SaveAndExit:
            report(action: action)
            nextMessageIfAny(controller)
        case .ShowPrivacyManager:
            guard let url = action.pmURL?.appendQueryItems(["site_id": String(propertyId)]) else {
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
                if status == .accepted {
                    action.type = .IDFAAccepted
                    self?.onAction(action, from: controller)
                } else if status == .denied {
                    action.type = .IDFADenied
                    self?.onAction(action, from: controller)
                }
                self?.nextMessageIfAny(controller)
            }
        default:
            nextMessageIfAny(controller)
        }
    }

    func onAction(_ action: SPAction, from controller: UIViewController) {
        delegate?.onAction(action, from: controller)
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

    func onCCPA2ndLayerNavigate(messageId: String, handler: @escaping SPCCPASecondLayerHandler) {
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
