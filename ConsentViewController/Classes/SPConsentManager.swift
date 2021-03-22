//
//  GDPRConsentViewController.swift
//  cmp-app-test-app
//
//  Created by Andre Herculano on 12/16/19.
//  Copyright © 2019 Sourcepoint. All rights reserved.
//

import UIKit

// swiftlint:disable file_length

public typealias SPConsentUUID = String
typealias SPMeta = String

@objcMembers public class SPConsentManager: SPSDK {
    static public let VERSION = "6.0.0-beta"

    static public var shouldCallErrorMetrics = true

    weak var delegate: SPDelegate?
    let accountId: Int
    let propertyName: SPPropertyName
    let campaigns: SPCampaigns
    let spClient: SourcePointProtocol
    var cleanUserDataOnError = true
    var storage: SPLocalStorage
    var presentingLegislation: SPLegislation?
    var consentsProfile: ConsentsProfile { storage.consentsProfile }
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
        if let ui = messageControllersStack.popLast() {
            DispatchQueue.main.async {
                ui.loadMessage()
            }
        } else {
            delegate?.onConsentReady?(consents: SPConsents())
        }
    }

    func messageToViewController (_ message: Message?, _ type: CampaignType) -> SPMessageViewController? {
        switch message {
        case .native(let content):
            /// TODO: here we'd initialise the Native Message object
            /// Call a delegate Method to get the Message controller
            /// Pass the native message object to it
            return GenericWebMessageViewController(contents: content, campaignType: type, delegate: self)
        case .web(let content):
            return GenericWebMessageViewController(contents: content, campaignType: type, delegate: self)
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
                self?.messageControllersStack = messagesResponse.campaigns
                    .filter { $0.message != nil }
                    .compactMap { self?.messageToViewController($0.message, $0.type) }
                    .reversed()
                self?.renderNextMessageIfAny()
            case .failure(let error): self?.onError(error)
            }
        }
    }

    func report(action: SPAction, legislation: SPLegislation) {

    }

    public func loadGDPRPrivacyManager() {
        loadPrivacyManager(.gdpr)
    }

    public func loadCCPAPrivacyManager() {
        loadPrivacyManager(.ccpa)
    }

    public func gdprApplies() -> Bool {
        consentsProfile.gdpr?.applies ?? false
    }

    public func ccpaApplies() -> Bool {
        consentsProfile.ccpa?.applies ?? false
    }

    func loadPrivacyManager(_ campaignType: CampaignType) {
        GenericWebMessageViewController(
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
        self.finished()
        self.renderNextMessageIfAny()
    }

    func action(_ action: SPAction) {
        self.delegate?.onAction(action)
        switch action.type {
        case .AcceptAll, .RejectAll, .SaveAndExit:
            if let legislation = presentingLegislation {
                report(action: action, legislation: legislation)
            }
            finishAndNextIfAny()
        case .IDFAOk:
            SPIDFAStatus.requestAuthorisation { status in
                print("[SDK] IDFA status:", status)
                /// pass the status here
                // self.report(action: action, legislation: legislation)
                self.finishAndNextIfAny()
            }
        default:
            print("[SDK] UNKNOWN Action")
        }
    }
}

//
//
//
//@objcMembers open class GDPRConsentViewController: UIViewController, GDPRMessageUIDelegate {
//    /// The version of the SDK. It should mirror the version from podspec.
//    static public let VERSION = "5.3.3"
//
//    static public let SP_KEY_PREFIX = "sp_gdpr_"
//    static let META_KEY = "\(SP_GDPR_KEY_PREFIX)meta"
//    static let EU_CONSENT_KEY = "\(SP_GDPR_KEY_PREFIX)euconsent"
//    static let GDPR_UUID_KEY = "\(SP_GDPR_KEY_PREFIX)consentUUID"
//    static let GDPR_AUTH_ID_KEY = "\(SP_GDPR_KEY_PREFIX)authId"
//    static public let IAB_KEY_PREFIX = "IABTCF_"
//    static let IAB_CMP_SDK_ID_KEY = "\(IAB_KEY_PREFIX)CmpSdkID"
//    static let IAB_CMP_SDK_ID = 6
//    static let DefaultTimeout = TimeInterval(30)
//
//    /// Resets the data stored by the SDK in the UserDefaults
//    static public func clearAllData() {
//        SPUserDefaults().clear()
//    }
//
//    /// The IAB consent string, set after the user has chosen after interacting with the ConsentViewController
//    public var euconsent: String {
//        return localStorage.userConsents.euconsent
//    }
//
//    /// The UUID assigned to a user, available after calling `loadMessage`
//    public var consentUUID: SPConsentUUID {
//        return localStorage.consentUUID
//    }
//
//    /// All data related to TCFv2
//    public var tcfData: SPJson {
//        return localStorage.userConsents.tcfData
//    }
//
//    /// All consent data we have in memory and stored on UserDefaults
//    public var userConsents: SPGDPRConsent {
//        return localStorage.userConsents
//    }
//
//    /// The timeout interval in seconds for the message being displayed
//    public var messageTimeoutInSeconds = GDPRConsentViewController.DefaultTimeout {
//        didSet {
//            sourcePoint.setRequestTimeout(self.messageTimeoutInSeconds)
//        }
//    }
//
//    /// Instructs the message to be displayed in this language. If the translation is missing, the fallback will be English.
//    /// By default the SDK will use the locale defined by the WebView
//    public var messageLanguage = MessageLanguage.BrowserDefault
//
//    /// Instructs the privacy manager to be displayed with this tab.
//    /// By default the SDK will use the defult tab of PM
//    public var privacyManagerTab = PrivacyManagerTab.Default
//
//    /// will instruct the SDK to clean consent data if an error occurs
//    public var shouldCleanConsentOnError = true
//
//    /// the instance of `GDPRConsentDelegate` which the `GDPRConsentViewController` will use to perform the lifecycle methods
//    public weak var spDelegate: SPDelegate?
//
//    var localStorage: SPLocalStorage
//
//    let accountId: Int
//    let propertyName: SPPropertyName
//    let propertyId: Int
//    let pmId: String
//    let targetingParams: SPTargetingParams
//    let sourcePoint: SourcePointProtocol
//    let deviceManager: SPDeviceManager
//    lazy var logger = { return OSLogger() }()
//    var messageViewController: GDPRMessageViewController?
//    var loading: LoadingStatus = .Ready  // used in order not to load the message ui multiple times
//
//    let campaigns: SPCampaigns
//    let profile: ConsentsProfile
//
//    enum LoadingStatus: String {
//        case Ready
//        case Presenting
//        case Loading
//    }
//
//    func remove(asChildViewController viewController: UIViewController?) {
//        guard let viewController = viewController else { return }
//        viewController.willMove(toParent: nil)
//        viewController.view.removeFromSuperview()
//        viewController.removeFromParent()
//    }
//
//    func add(asChildViewController viewController: UIViewController) {
//        addChild(viewController)
//        view.addSubview(viewController.view)
//        viewController.view.frame = view.bounds
//        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        viewController.didMove(toParent: self)
//    }
//
//    init(
//        accountId: Int,
//        propertyId: Int,
//        propertyName: SPPropertyName,
//        PMId: String,
//        campaignEnv: SPCampaignEnv,
//        targetingParams: SPTargetingParams = [:],
//        spDelegate: SPDelegate,
//        sourcePointClient: SourcePointProtocol,
//        localStorage: GDPRLocalStorage = GDPRUserDefaults(),
//        deviceManager: SPDeviceManager = SPDevice()
//    ) {
//        campaigns = SPCampaigns(
//            gdpr: SPCampaign(
//                accountId: accountId,
//                propertyId: propertyId,
//                pmId: PMId,
//                propertyName: propertyName,
//                environment: campaignEnv,
//                targetingParams: targetingParams
//            )
//        )
//        profile = ConsentsProfile(
//            gdpr: ConsentProfile<SPGDPRConsent>(
//                uuid: localStorage.consentUUID,
//                authId: localStorage.authId,
//                meta: localStorage.meta,
//                consents: localStorage.userConsents
//            )
//        )
//        self.accountId = accountId
//        self.propertyName = propertyName
//        self.propertyId = propertyId
//        self.pmId = PMId
//        self.targetingParams = targetingParams
//        self.spDelegate = spDelegate
//        self.sourcePoint = sourcePointClient
//        self.localStorage = localStorage
//        self.deviceManager = deviceManager
//        super.init(nibName: nil, bundle: nil)
//        modalPresentationStyle = .overFullScreen
//
//        /// - note: according to the IAB this value needs to be initialised as early as possible to signal to vendors, the app has a CMP
//        localStorage.storage.set(GDPRConsentViewController.IAB_CMP_SDK_ID, forKey: GDPRConsentViewController.IAB_CMP_SDK_ID_KEY)
//    }
//
//    /**
//        - Parameters:
//            - accountId: the id of your account, can be found in the Account section of SourcePoint's dashboard
//            - propertyId: the id of your property, can be found in the property page of SourcePoint's dashboard
//            - propertyName: the exact name of your property,
//            -  PMId: the id of the PrivacyManager, can be found in the PrivacyManager page of SourcePoint's dashboard
//            -  campaignEnv: Indicates if the SDK should load the message from the Public or Stage campaign
//            - targetingParams: an arbitrary collection of key/value pairs made available to the Scenario built on SourcePoint's dashboard
//            -  spDelegate: responsible for dealing with the different consent lifecycle functions.
//        - SeeAlso: ConsentDelegate
//     */
//    public convenience init(
//        accountId: Int,
//        propertyId: Int,
//        propertyName: SPPropertyName,
//        PMId: String,
//        campaignEnv: SPCampaignEnv = .Public,
//        targetingParams: SPTargetingParams = [:],
//        spDelegate: SPDelegate
//    ) {
//        let sourcePoint = SourcePointClient(
//            timeout: GDPRConsentViewController.DefaultTimeout
//        )
//        self.init(
//            accountId: accountId,
//            propertyId: propertyId,
//            propertyName: propertyName,
//            PMId: PMId,
//            campaignEnv: campaignEnv,
//            targetingParams: targetingParams,
//            spDelegate: spDelegate,
//            sourcePointClient: sourcePoint
//        )
//    }
//
//    /// :nodoc:
//    required public init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    /// TODO: model native message
//    func handleNativeMessageResponse(_ response: MessagesResponse<SPJson>) {
//        self.loading = .Ready
////        if let message = response.msgJSON {
////            self.spDelegate?.consentUIWillShow?(message: message)
////        } else {
////            self.onConsentReady(consentUUID: response.uuid, userConsent: response.userConsent)
////        }
//    }
//
//    typealias WebMessage = SPJson
//    func handleWebMessageResponse(_ response: MessagesResponse<WebMessage>) {
////       if let url = response.url {
////           self.loadMessage(fromUrl: url)
////       } else {
////           self.loading = .Ready
////           self.onConsentReady(consentUUID: response.uuid, userConsent: response.userConsent)
////       }
//   }
//
//    func loadGDPRMessage(native: Bool, authId: String?) {
//        if loading == .Ready {
//            loading = .Loading
//            if didAuthIdChange(newAuthId: (authId)) {
//                clearAllData()
//            }
//            localStorage.authId = authId
////            sourcePoint.getMessage(native: native, campaigns: campaigns, profile: profile) { [weak self] result in
////                switch result {
////                case .success(let messageResponse):
////                    self?.localStorage.consentUUID = messageResponse.uuid
////                    self?.localStorage.meta = messageResponse.meta
////                    self?.localStorage.userConsents = messageResponse.userConsent
////                    native ?
////                        self?.handleNativeMessageResponse(messageResponse) :
////                        self?.handleWebMessageResponse(messageResponse)
////                case .failure(let error):
////                    self?.onError(error: error)
////                }
////            }
//        }
//    }
//
//    public func loadNativeMessage(forAuthId authId: String?) {
//       loadGDPRMessage(native: true, authId: authId)
//    }
//
//    public func loadMessage(fromUrl url: URL) {
//        messageViewController = MessageWebViewController(
//            propertyId: propertyId,
//            pmId: pmId,
//            consentUUID: consentUUID,
//            messageLanguage: messageLanguage,
//            pmTab: privacyManagerTab,
//            timeout: messageTimeoutInSeconds
//        )
//        messageViewController?.consentDelegate = self
//        messageViewController?.loadMessage(fromUrl: url)
//    }
//
//    /// Will first check if there's a message to show according to the scenario
//    /// If there is, we'll load the message in a WebView and call `ConsentDelegate.onConsentUIWillShow`
//    /// Otherwise, we short circuit to `ConsentDelegate.onConsentReady`
//    public func loadMessage() {
//        loadGDPRMessage(native: false, authId: nil)
//    }
//
//    /// Will first check if there's a message to show according to the scenario, for the `authId` provided.
//    /// If there is, we'll load the message in a WebView and call `ConsentDelegate.onConsentUIWillShow`
//    /// Otherwise, we short circuit to `ConsentDelegate.onConsentReady`
//    /// - Parameter authId: any arbitrary token that uniquely identifies an user in your system.
//    public func loadMessage(forAuthId authId: String?) {
//        loadGDPRMessage(native: false, authId: authId)
//    }
//
//    func didAuthIdChange(newAuthId: String?) -> Bool {
//        return newAuthId != nil &&
//            localStorage.authId != nil &&
//            localStorage.authId != newAuthId
//    }
//
//    /// Loads the PrivacyManager (that popup with the toggles) in a WebView
//    /// If the user changes her consents we call `ConsentDelegate.onConsentReady`
//    public func loadPrivacyManager() {
//        if loading == .Ready {
//            loading = .Loading
//            messageViewController = MessageWebViewController(
//                propertyId: propertyId,
//                pmId: pmId,
//                consentUUID: consentUUID,
//                messageLanguage: messageLanguage,
//                pmTab: privacyManagerTab,
//                timeout: messageTimeoutInSeconds
//            )
//            messageViewController?.consentDelegate = self
//            messageViewController?.loadPrivacyManager()
//        }
//    }
//
//    /// Clears all IAB related data from the UserDefaults
//    public func clearIABConsentData() {
//        localStorage.tcfData = [:]
//    }
//
//    /// Clears all consent data from the UserDefaults. Use this method if you want to **completely** wipe the user's consent data from the device.
//    public func clearAllData() {
//        localStorage.clear()
//    }
//
//    func customConsent(
//        uuid: String,
//        vendors: [String],
//        categories: [String],
//        legIntCategories: [String],
//        euconsent: String,
//        tcfData: SPJson,
//        completionHandler: @escaping (SPGDPRConsent) -> Void) {
//        /// TODO: implement custom consent
////        sourcePoint.customConsent(toConsentUUID: uuid, vendors: vendors, categories: categories, legIntCategories: legIntCategories) { [weak self] (response, error) in
////            guard let response = response, error == nil else {
////                self?.onError(error: error ?? SPError())
////                return
////            }
////
////            let updatedUserConsents = SPGDPRConsent(
////                acceptedVendors: response.vendors,
////                acceptedCategories: response.categories,
////                legitimateInterestCategories: response.legIntCategories,
////                specialFeatures: response.specialFeatures,
////                vendorGrants: response.grants,
////                euconsent: euconsent,
////                tcfData: tcfData
////            )
////            self?.localStorage.userConsents = updatedUserConsents
////            completionHandler(updatedUserConsents)
////        }
//    }
//
//    /// Add the vendors/categories/legitimateInterestCategories ids to the consent profile of the current user.
//    /// In order words, programatically consent a user to the above
//    /// If an error occurs, the `GDPRConsentDelegate.onError` is called
//    public func customConsentTo(
//        vendors: [String],
//        categories: [String],
//        legIntCategories: [String],
//        completionHandler: @escaping (SPGDPRConsent) -> Void) {
//        if consentUUID.isEmpty {
//            onError(error: PostingConsentWithoutConsentUUID())
//            return
//        }
//
//        customConsent(
//            uuid: consentUUID,
//            vendors: vendors,
//            categories: categories,
//            legIntCategories: legIntCategories,
//            euconsent: self.euconsent,
//            tcfData: self.tcfData,
//            completionHandler: completionHandler
//        )
//    }
//
//    public func reportAction(_ action: SPAction) {
//        /// TODO: add support to CCPA
//        sourcePoint.postAction(action: action, campaign: campaigns.gdpr!, profile: profile.gdpr!)
//        { [weak self] result in
//            switch result {
//            case .success(let actionResponse):
//                self?.localStorage.meta = actionResponse.meta
////                self?.onConsentReady(consentUUID: actionResponse.uuid, userConsent: actionResponse.userConsent)
//            case .failure(let error):
//                self?.onError(error: error)
//            }
//        }
//    }
//}
//
//extension GDPRConsentViewController: SPDelegate {
//    public func onSPUIReady(_ viewController: UIViewController) {
//        loading = .Ready
//        guard let viewController = messageViewController else { return }
//        add(asChildViewController: viewController)
//        spDelegate?.onSPUIReady(self)
//    }
//
//    public func onSPUIFinished() {
//        loading = .Ready
//        remove(asChildViewController: messageViewController)
//        messageViewController = nil
//        spDelegate?.onSPUIFinished()
//    }
//
//    public func onError(error: SPError) {
//        loading = .Ready
//        if shouldCleanConsentOnError { clearIABConsentData() }
////        sourcePoint.errorMetrics(
////            error,
////            campaign: campaigns.gdpr!, /// TODO: remove this optional unwrapping
////            sdkVersion: GDPRConsentViewController.VERSION,
////            OSVersion: deviceManager.osVersion(),
////            deviceFamily: deviceManager.deviceFamily(),
////            legislation: .GDPR
////        )
//        spDelegate?.onError?(error: error)
//    }
//
//    public func onAction(_ action: SPAction) {
//        let type = action.type
//        spDelegate?.onAction(action)
//        /// TODO: evaluate if we can call on consent ready
//        if type == .Dismiss {
////            self.onConsentReady(consentUUID: consentUUID, userConsent: userConsents)
//        } else if type == .AcceptAll || type == .RejectAll || type == .SaveAndExit {
//            reportAction(action)
//        }
//    }
//
//    @objc(onGDPRConsentReady:) public func onConsentReady(consents: SPGDPRConsent) {
//        /// TODO: implement
//        spDelegate?.onConsentReady?(consents: consents)
//    }
//
//    @objc(onCCPAConsentReady:) public func onConsentReady(consents: SPCCPAConsent) {
//        /// TODO: implement
//        spDelegate?.onConsentReady?(consents: consents)
//    }
//}
