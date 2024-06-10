//
//  SPConsentManager.swift
//  cmp-app-test-app
//
//  Created by Andre Herculano on 12/16/19.
//  Copyright © 2019 Sourcepoint. All rights reserved.
//

import Foundation
import UIKit

// swiftlint:disable file_length function_parameter_count
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
    var usnatUUID: String? { spCoordinator.userData.usnat?.consents?.uuid }
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
            onSPFinished(userData: userData)
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

    // swiftlint:disable:next function_body_length
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
            var uuid: String?
            switch type {
                case .gdpr: uuid = spCoordinator.userData.gdpr?.consents?.uuid
                case .ccpa: uuid = spCoordinator.userData.ccpa?.consents?.uuid
                default: break
            }
            return GenericWebMessageViewController(
                url: url,
                messageId: messageId,
                contents: (try? JSONEncoder().encode(message)) ?? Data(),
                campaignType: type,
                timeout: messageTimeoutInSeconds,
                delegate: self,
                consentUUID: uuid
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
        if let ccpaGPPData = userData.ccpa?.consents?.GPPData {
            storage.gppData = ccpaGPPData.dictionaryValue
        }
        if let usnatGPPData = userData.usnat?.consents?.GPPData {
            storage.gppData = usnatGPPData.dictionaryValue
        }
    }

    func report(action: SPAction) {
        responsesToReceive += 1
        switch action.campaignType {
            case .ccpa, .gdpr, .usnat:
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
    func loadWebPrivacyManager(_ campaignType: SPCampaignType, _ pmURL: URL, messageId: String) {
        GenericWebMessageViewController(
            url: pmURL,
            messageId: messageId,
            contents: Data(),
            campaignType: campaignType,
            timeout: messageTimeoutInSeconds,
            delegate: self
        ).loadPrivacyManager(url: pmURL)
    }
    #endif

    func onConsentReceived(_ userData: SPUserData) {
        storeLegislationConsent(userData: userData)
        onConsentReady(userData: userData)
        handleSDKDone()
    }

    public func gracefullyDegradeOnError(_ error: SPError) {
        if userData.isNotEmpty {
            spCoordinator.logErrorMetrics(error)
            onConsentReady(userData: userData)
            handleSDKDone()
        } else {
            onError(error)
        }
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
    public static let VERSION = "7.6.8"

    public var gdprApplies: Bool { spCoordinator.userData.gdpr?.applies ?? false }

    public var ccpaApplies: Bool { spCoordinator.userData.ccpa?.applies ?? false }

    public var usnatApplies: Bool { spCoordinator.userData.usnat?.applies ?? false }

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
        OSLogger.standard.begin("MessageFlow")
        self.authId = authId
        responsesToReceive += 1

        spCoordinator.loadMessages(forAuthId: authId, pubData: publisherData) { [weak self] result in
            if let strongSelf = self {
                strongSelf.responsesToReceive -= 1
                switch result {
                    case .success(let (messages, consents)):
                        strongSelf.storeLegislationConsent(userData: consents)
                        mainSync { [weak self] in
                            self?.messageControllersStack = strongSelf.messagesToViewController(messages)
                        }
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

    func genericPMUrl(
        _ specificUrl: URL?,
        pmId: String,
        uuidName: String,
        uuidValue: String?,
        propertyId: Int,
        tab: SPPrivacyManagerTab = .Default,
        idfaStatus: SPIDFAStatus = SPIDFAStatus.current(),
        consentLanguage: SPMessageLanguage
    ) -> URL? {
        specificUrl?.appendQueryItems([
            "message_id": pmId,
            "pmTab": tab.rawValue,
            uuidName: uuidValue,
            "idfaStatus": idfaStatus.description,
            "site_id": String(propertyId),
            "consentLanguage": messageLanguage.rawValue
        ])
    }

    func buildGDPRPmUrl(
        usedId: String,
        pmTab: SPPrivacyManagerTab = .Default,
        uuid: String?
    ) -> URL? {
        genericPMUrl(
            Constants.Urls.GDPR_PM_URL,
            pmId: usedId,
            uuidName: "consentUUID",
            uuidValue: uuid,
            propertyId: propertyId,
            consentLanguage: messageLanguage
        )
    }

    public func loadGDPRPrivacyManager(withId id: String, tab: SPPrivacyManagerTab = .Default, useGroupPmIfAvailable: Bool = false) {
        OSLogger.standard.begin("MessageFlow")
        messagesToShow += 1
        var usedId: String = id
        if useGroupPmIfAvailable {
            usedId = selectPrivacyManagerId(fallbackId: id, groupPmId: campaigns.gdpr?.groupPmId, childPmId: storage.gdprChildPmId)
        }
        #if os(iOS)
        guard let pmUrl = buildGDPRPmUrl(usedId: usedId, pmTab: tab, uuid: gdprUUID) else {
            onError(InvalidURLError(urlString: "Invalid PM URL"))
            return
        }
        mainSync {
            loadWebPrivacyManager(.gdpr, pmUrl, messageId: usedId)
        }
        #elseif os(tvOS)
        spClient.getGDPRMessage(propertyId: String(propertyId), consentLanguage: messageLanguage, messageId: usedId) { [weak self] result in
            switch result {
            case .success(let message):
                guard case let .nativePM(nativePMMessage) = message.messageJson else {
                    self?.onError(InvalidJSONEncodeResult())
                    return
                }
                mainSync {
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
                }

            case .failure(let error):
                self?.onError(error)
            }
        }
        #endif
    }

    func buildCCPAPmUrl(usedId: String, pmTab: SPPrivacyManagerTab = .Default, uuid: String?) -> URL? {
        genericPMUrl(
            Constants.Urls.CCPA_PM_URL,
            pmId: usedId,
            uuidName: "ccpaUUID",
            uuidValue: uuid,
            propertyId: propertyId,
            consentLanguage: messageLanguage
        )
    }

    public func loadCCPAPrivacyManager(withId id: String, tab: SPPrivacyManagerTab = .Default, useGroupPmIfAvailable: Bool = false) {
        OSLogger.standard.begin("MessageFlow")
        messagesToShow += 1
        var usedId: String = id
        if useGroupPmIfAvailable {
            usedId = selectPrivacyManagerId(fallbackId: id, groupPmId: campaigns.ccpa?.groupPmId, childPmId: storage.ccpaChildPmId)
        }
        #if os(iOS)
        guard let pmUrl = buildCCPAPmUrl(usedId: usedId, pmTab: tab, uuid: ccpaUUID) else {
            onError(InvalidURLError(urlString: "Invalid PM URL"))
            return
        }
        mainSync {
            loadWebPrivacyManager(.ccpa, pmUrl, messageId: usedId)
        }
        #elseif os(tvOS)
        spClient.getCCPAMessage(propertyId: String(propertyId), consentLanguage: messageLanguage, messageId: usedId) { [weak self] result in
            switch result {
            case .success(let message):
                guard case let .nativePM(nativePMMessage) = message.messageJson else {
                    self?.onError(InvalidJSONEncodeResult())
                    return
                }
                mainSync {
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
                }

            case .failure(let error):
                self?.onError(error)
            }
        }
        #endif
    }

    func buildUSNatPmUrl(usedId: String, pmTab: SPPrivacyManagerTab = .Default, uuid: String?) -> URL? {
        genericPMUrl(
            Constants.Urls.USNAT_PM_URL,
            pmId: usedId,
            uuidName: "uuid",
            uuidValue: uuid,
            propertyId: propertyId,
            consentLanguage: messageLanguage
        )
    }

    public func loadUSNatPrivacyManager(withId id: String, tab: SPPrivacyManagerTab = .Default, useGroupPmIfAvailable: Bool = false) {
        #if os(iOS)
        messagesToShow += 1
        var usedId: String = id
        if useGroupPmIfAvailable {
            usedId = selectPrivacyManagerId(fallbackId: id, groupPmId: campaigns.ccpa?.groupPmId, childPmId: storage.ccpaChildPmId)
        }

        guard let pmUrl = buildUSNatPmUrl(usedId: usedId, pmTab: tab, uuid: usnatUUID) else {
            onError(InvalidURLError(urlString: "Invalid PM URL"))
            return
        }
        loadWebPrivacyManager(.usnat, pmUrl, messageId: usedId)
        #endif
    }

    @nonobjc func handleCustomConsentResult(
        _ result: Result<SPGDPRConsent, SPError>,
        handler: @escaping (SPGDPRConsent) -> Void
    ) {
        switch result {
            case .success(let result): DispatchQueue.main.async { handler(result) }

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
        onSPNativeMessageReady(message)
    }

    public func loaded(_ controller: UIViewController) {
        onSPUIReady(controller)
    }

    public func finished(_ vcFinished: UIViewController) {
        onSPUIFinished(vcFinished)
        messagesToShow -= 1
        handleSDKDone()
    }

    public func action(_ action: SPAction, from controller: UIViewController) {
        onAction(action, from: controller)
        switch action.type {
        case .AcceptAll, .RejectAll, .SaveAndExit:
            report(action: action)
            nextMessageIfAny(controller)

        case .ShowPrivacyManager:
            guard let url = action.pmURL?.appendQueryItems(["site_id": String(propertyId), "consentLanguage": String(messageLanguage.rawValue)]) else {
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
                pmData.legIntCategories = self?.userData.gdpr?.consents?.acceptedLegIntCategories
                pmData.legIntVendors = self?.userData.gdpr?.consents?.acceptedLegIntVendors
                pmData.acceptedVendors = self?.userData.gdpr?.consents?.acceptedVendors
                pmData.acceptedCategories = self?.userData.gdpr?.consents?.acceptedCategories
                pmData.acceptedSpecialFeatures = self?.userData.gdpr?.consents?.acceptedSpecialFeatures
                pmData.hasConsentData = self?.userData.gdpr?.consents?.consentStatus.hasConsentData
                mainSync {
                    handler(result.map { _ in pmData })
                }
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
                mainSync {
                    handler(result.map { _ in pmData })
                }
            }
        }
    }
}

extension SPConsentManager: SPDelegate {
    public func onSPUIReady(_ controller: UIViewController) {
        OSLogger.standard.end("MessageFlow")
        OSLogger.standard.event("onSPUIReady")
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.onSPUIReady(controller)
        }
    }

    public func onSPNativeMessageReady(_ message: SPNativeMessage) {
        OSLogger.standard.end("MessageFlow")
        OSLogger.standard.event("onSPNativeMessageReady")
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.onSPNativeMessageReady?(message)
        }
    }

    public func onAction(_ action: SPAction, from controller: UIViewController) {
        OSLogger.standard.event("onAction", action.type.description)
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.onAction(action, from: controller)
        }
    }

    public func onSPUIFinished(_ controller: UIViewController) {
        OSLogger.standard.event("onSPUIFinished")
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.onSPUIFinished(controller)
        }
    }

    public func onConsentReady(userData: SPUserData) {
        OSLogger.standard.end("MessageFlow")
        OSLogger.standard.event("onConsentReady")
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.onConsentReady?(userData: userData)
        }
    }

    public func onSPFinished(userData: SPUserData) {
        OSLogger.standard.event("onSPFinished")
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.onSPFinished?(userData: userData)
        }
    }

    public func onError(_ error: SPError) {
        OSLogger.standard.end("MessageFlow")
        OSLogger.standard.event("onError")
        OSLogger.standard.error("onError")
        spCoordinator.logErrorMetrics(error)
        if cleanUserDataOnError {
            Self.clearAllData()
        }
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.onError?(error: error)
        }
    }
}

func mainSync<T>(execute work: () throws -> T) rethrows -> T {
    if Thread.isMainThread {
        return try work()
    }

    return try DispatchQueue.main.sync { try work() }
}

// swiftlint:enable function_parameter_count
