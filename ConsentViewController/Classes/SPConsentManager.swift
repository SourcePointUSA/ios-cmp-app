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
    public static var shouldCallErrorMetrics = true

    // MARK: - SPSDK
    /// By default, the SDK preservs all user consent data from UserDefaults in case `OnError` event happens.
    /// Set this flag to `true` if you wish to opt-out from this behaviour.
    /// If set to `true` will remove all user consent data from UserDefaults, possibly triggering a message to be displayed again next time
    public var cleanUserDataOnError = false

    /// The timeout interval in seconds for the message being displayed
    public var messageTimeoutInSeconds = SPConsentManager.DefaultTimeout {
        didSet {
            spCoordinator.setRequestTimeout(messageTimeoutInSeconds)
        }
    }

    /// Instructs the privacy manager to be displayed with this tab.
    /// By default the SDK will use the defult tab of PM
    public var privacyManagerTab = SPPrivacyManagerTab.Default

    /// Instructs the message to be displayed in this language. If the translation is missing, the fallback will be English.
    /// By default the SDK will use the locale defined by the WebView
    public var messageLanguage: SPMessageLanguage {
        didSet {
            spCoordinator.language = messageLanguage
        }
    }

    let propertyId: Int
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
    var ccpaUUID: String? { spCoordinator.userData.ccpa?.consents?.uuid }
    var gdprUUID: String? { spCoordinator.userData.gdpr?.consents?.uuid }
    var messagesToShow = 0
    var responsesToReceive = 0

    public required convenience init(
        accountId: Int,
        propertyId: Int,
        propertyName: SPPropertyName,
        campaigns: SPCampaigns,
        language: SPMessageLanguage = .BrowserDefault,
        delegate: SPDelegate?
    ) {
        let client = SourcePointClient(
            accountId: accountId,
            propertyName: propertyName,
            campaignEnv: campaigns.environment,
            timeout: Self.DefaultTimeout
        )
        let localStorage = SPUserDefaults(storage: UserDefaults.standard)
        let coordinator = SourcepointClientCoordinator(
            accountId: accountId,
            propertyName: propertyName,
            propertyId: propertyId,
            language: language,
            campaigns: campaigns,
            storage: localStorage
        )
        self.init(
            propertyId: propertyId,
            campaigns: campaigns,
            language: language,
            delegate: delegate,
            spClient: client,
            storage: localStorage,
            spCoordinator: coordinator
        )
    }

    init(
        propertyId: Int,
        campaigns: SPCampaigns,
        language: SPMessageLanguage,
        delegate: SPDelegate?,
        spClient: SourcePointProtocol,
        storage: SPLocalStorage,
        spCoordinator: SPClientCoordinator,
        deviceManager: SPDeviceManager = SPDevice.standard
    ) {
        self.propertyId = propertyId
        self.campaigns = campaigns
        self.messageLanguage = language
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
                controller.categories = message.categories ?? []
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
                controller.ccpaConsents = userData.ccpa?.consents
                return controller
            }
            return nil
        #endif
        #if os(iOS)

        case .web:
            return GenericWebMessageViewController(
                url: url,
                messageId: messageId,
                contents: (try? JSONEncoder().encode(message)) ?? Data(),
                campaignType: type,
                timeout: messageTimeoutInSeconds,
                delegate: self,
                consentUUID: spCoordinator.userData.gdpr?.consents?.uuid
            )
        #endif

        default: return nil
        }
    }

    func storeLegislationConsent(userData: SPUserData) {
        if let tcData = userData.gdpr?.consents?.tcfData {
            storage.tcfData = tcData.dictionaryValue
        }
        if let uspString = userData.ccpa?.consents?.uspstring {
            storage.usPrivacyString = uspString
        }
        if let gppData = userData.ccpa?.consents?.GPPData {
            storage.gppData = gppData.dictionaryValue
        }
    }

    func report(action: SPAction) {
        responsesToReceive += 1
        switch action.campaignType {
            case .ccpa, .gdpr:
                spCoordinator.reportAction(action) { [weak self] result in
                    self?.responsesToReceive -= 1
                    switch result {
                        case .success(let response): self?.onConsentReceived(response)
                        case .failure(let error): self?.onError(error)
                    }
                }
            default: break
        }
    }

    #if os(iOS)
    func loadWebPrivacyManager(_ campaignType: SPCampaignType, _ pmURL: URL) {
        let pmId = URLComponents(url: pmURL, resolvingAgainstBaseURL: false)?
            .queryItems?
            .first { $0.name == "message_id" }?
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

    func onConsentReceived(_ userData: SPUserData) {
        storeLegislationConsent(userData: userData)
        delegate?.onConsentReady?(userData: userData)
        handleSDKDone()
    }

    public func gracefullyDegradeOnError(_ error: SPError) {
        spCoordinator.logErrorMetrics(error)
        if !userData.isEqual(SPUserData()) {
            delegate?.onConsentReady?(userData: userData)
            handleSDKDone()
        } else {
            if cleanUserDataOnError {
                Self.clearAllData()
            }
            delegate?.onError?(error: error)
        }
    }

    public func onError(_ error: SPError) {
        spCoordinator.logErrorMetrics(error)
        if cleanUserDataOnError {
            Self.clearAllData()
        }
        delegate?.onError?(error: error)
    }

    func selectPrivacyManagerId(fallbackId: String, groupPmId: String?, childPmId: String?) -> String {
        if let groupPmId = groupPmId, groupPmId.isNotEmpty(),
           let childPmId = childPmId, childPmId.isNotEmpty() {
            return childPmId
        }

        spCoordinator.logErrorMetrics(MissingChildPmIdError(usedId: fallbackId))
        return fallbackId
    }
}

@objc extension SPConsentManager: SPSDK {
    public static let VERSION = "7.4.3"

    public var gdprApplies: Bool { spCoordinator.userData.gdpr?.applies ?? false }

    public var ccpaApplies: Bool { spCoordinator.userData.ccpa?.applies ?? false }

    /// Returns the user data **stored in the `UserDefaults`**.
    public var userData: SPUserData { spCoordinator.userData }

    public static func clearAllData() {
        SPUserDefaults(storage: UserDefaults.standard).clear()
    }

    @nonobjc
    private func messagesToViewController(_ messages: [MessageToDisplay]) -> [SPMessageView] {
        messages
            .compactMap {
                messageToViewController(
                    $0.url,
                    $0.metadata.messageId,
                    $0.message,
                    $0.type
                )
            }
            .reversed()
    }

    public func loadMessage(forAuthId authId: String? = nil, publisherData: [String: String]? = [:]) {
        loadMessage(forAuthId: authId, publisherData: publisherData?.mapValues { AnyEncodable($0) })
    }

    public func loadMessage(forAuthId authId: String? = nil, publisherData: SPPublisherData? = [:]) {
        self.authId = authId
        responsesToReceive += 1

        spCoordinator.loadMessages(forAuthId: authId, pubData: publisherData) { [weak self] result in
            if let strongSelf = self {
                strongSelf.responsesToReceive -= 1
                switch result {
                    case .success(let (messages, consents)):
                        strongSelf.storeLegislationConsent(userData: consents)
                        strongSelf.messageControllersStack = strongSelf.messagesToViewController(messages)
                        strongSelf.messagesToShow = strongSelf.messageControllersStack.count
                        if strongSelf.messageControllersStack.isEmpty {
                            strongSelf.onConsentReceived(strongSelf.userData)
                        } else {
                            strongSelf.renderNextMessageIfAny()
                        }

                    case .failure(let error):
                        strongSelf.gracefullyDegradeOnError(error)
                }
            }
        }
    }

    func buildGDPRPmUrl(usedId: String, pmTab: SPPrivacyManagerTab = .Default) -> URL? {
        let pmUrl = Constants.Urls.GDPR_PM_URL.appendQueryItems([
            "message_id": usedId,
            "pmTab": pmTab.rawValue,
            "consentUUID": gdprUUID,
            "idfaStatus": idfaStatus.description,
            "site_id": String(propertyId),
            "consentLanguage": messageLanguage.rawValue
        ])
        return pmUrl
    }

    public func loadGDPRPrivacyManager(withId id: String, tab: SPPrivacyManagerTab = .Default, useGroupPmIfAvailable: Bool = false) {
        messagesToShow += 1
        var usedId: String = id
        if useGroupPmIfAvailable {
            usedId = selectPrivacyManagerId(fallbackId: id, groupPmId: campaigns.gdpr?.groupPmId, childPmId: storage.gdprChildPmId)
        }
        #if os(iOS)
        guard let pmUrl = buildGDPRPmUrl(usedId: usedId, pmTab: tab) else {
            onError(InvalidURLError(urlString: "Invalid PM URL"))
            return
        }
        loadWebPrivacyManager(.gdpr, pmUrl)
        #elseif os(tvOS)
        spClient.getGDPRMessage(propertyId: String(propertyId), consentLanguage: messageLanguage, messageId: usedId) { [weak self] result in
            switch result {
            case .success(let message):
                guard case let .nativePM(nativePMMessage) = message.messageJson else {
                    self?.onError(InvalidJSONEncodeResult())
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

    func buildCCPAPmUrl(usedId: String, pmTab: SPPrivacyManagerTab = .Default) -> URL? {
        let pmUrl = Constants.Urls.CCPA_PM_URL.appendQueryItems([
            "message_id": usedId,
            "pmTab": pmTab.rawValue,
            "ccpaUUID": ccpaUUID,
            "idfaStatus": idfaStatus.description,
            "site_id": String(propertyId),
            "consentLanguage": messageLanguage.rawValue
        ])
        return pmUrl
    }

    public func loadCCPAPrivacyManager(withId id: String, tab: SPPrivacyManagerTab = .Default, useGroupPmIfAvailable: Bool = false) {
        messagesToShow += 1
        var usedId: String = id
        if useGroupPmIfAvailable {
            usedId = selectPrivacyManagerId(fallbackId: id, groupPmId: campaigns.ccpa?.groupPmId, childPmId: storage.ccpaChildPmId)
        }
        #if os(iOS)
        guard let pmUrl = buildCCPAPmUrl(usedId: usedId, pmTab: tab) else {
            onError(InvalidURLError(urlString: "Invalid PM URL"))
            return
        }
        loadWebPrivacyManager(.ccpa, pmUrl)
        #elseif os(tvOS)
        spClient.getCCPAMessage(propertyId: String(propertyId), consentLanguage: messageLanguage, messageId: usedId) { [weak self] result in
            switch result {
            case .success(let message):
                guard case let .nativePM(nativePMMessage) = message.messageJson else {
                    self?.onError(InvalidJSONEncodeResult())
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
                pmViewController.ccpaConsents = self?.userData.ccpa?.consents
                self?.loaded(pmViewController)

            case .failure(let error):
                self?.onError(error)
            }
        }
        #endif
    }

    @nonobjc func handleCustomConsentResult(
        _ result: Result<SPGDPRConsent, SPError>,
        handler: @escaping (SPGDPRConsent) -> Void
    ) {
        switch result {
            case .success(let result): handler(result)
            case .failure(let error): onError(error)
        }
    }

    public func customConsentGDPR(
        vendors: [String],
        categories: [String],
        legIntCategories: [String],
        handler: @escaping (SPGDPRConsent) -> Void
    ) {
        spCoordinator.customConsentGDPR(
            vendors: vendors,
            categories: categories,
            legIntCategories: legIntCategories
        ) { [weak self] result in
            self?.handleCustomConsentResult(result, handler: handler)
        }
    }

    public func deleteCustomConsentGDPR(
        vendors: [String],
        categories: [String],
        legIntCategories: [String],
        handler: @escaping (SPGDPRConsent) -> Void
    ) {
        spCoordinator.deleteCustomConsentGDPR(
            vendors: vendors,
            categories: categories,
            legIntCategories: legIntCategories
        ) { [weak self] result in
            self?.handleCustomConsentResult(result, handler: handler)
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
                self?.spCoordinator.reportIdfaStatus(
                    status: status,
                    osVersion: self?.deviceManager.osVersion ?? ""
                )
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
                pmData.legIntCategories = self?.userData.gdpr?.consents?.legIntCategories ?? []
                pmData.legIntVendors = self?.userData.gdpr?.consents?.legIntVendors ?? []
                pmData.acceptedVendors = self?.userData.gdpr?.consents?.vendors ?? []
                pmData.acceptedCategories = self?.userData.gdpr?.consents?.categories ?? []
                pmData.hasConsentData = self?.userData.gdpr?.consents?.consentStatus.hasConsentData
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
