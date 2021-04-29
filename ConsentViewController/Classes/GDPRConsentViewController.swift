///
//  GDPRConsentViewController.swift
//  cmp-app-test-app
///
//  Created by Andre Herculano on 12/16/19.
//  Copyright © 2019 Sourcepoint. All rights reserved.
///
//
//import UIKit
//
//public typealias TargetingParams = [String: String]
//public typealias GDPRUUID = String
//typealias Meta = String
//
//@objcMembers open class GDPRConsentViewController: UIViewController, GDPRMessageUIDelegate {
//    /// The version of the SDK. It should mirror the version from podspec.
//    static public let VERSION = "5.3.6"
//
//    static public let SP_GDPR_KEY_PREFIX = "sp_gdpr_"
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
//        GDPRUserDefaults().clear()
//    }
//
//    /// The IAB consent string, set after the user has chosen after interacting with the ConsentViewController
//    public var euconsent: String {
//        return localStorage.userConsents.euconsent
//    }
//
//    /// The UUID assigned to a user, available after calling `loadMessage`
//    public var gdprUUID: GDPRUUID {
//        return localStorage.consentUUID
//    }
//
//    /// All data related to TCFv2
//    public var tcfData: SPGDPRArbitraryJson {
//        return localStorage.userConsents.tcfData
//    }
//
//    /// All consent data we have in memory and stored on UserDefaults
//    public var userConsents: GDPRUserConsent {
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
//    public var messageLanguage = SPMessageLanguage.BrowserDefault
//
//    /// Instructs the privacy manager to be displayed with this tab.
//    /// By default the SDK will use the defult tab of PM
//    public var privacyManagerTab = SPPrivacyManagerTab.Default
//
//    /// will instruct the SDK to clean consent data if an error occurs
//    public var shouldCleanConsentOnError = true
//
//    /// will instruct the SDK to call the error metrics if an error occurs
//    static public var shouldCallErrorMetrics = true
//
//    /// the instance of `GDPRConsentDelegate` which the `GDPRConsentViewController` will use to perform the lifecycle methods
//    public weak var consentDelegate: GDPRConsentDelegate?
//
//    var localStorage: GDPRLocalStorage
//
//    let accountId: Int
//    let propertyName: GDPRPropertyName
//    let propertyId: Int
//    let pmId: String
//    let targetingParams: TargetingParams
//    let sourcePoint: SourcePointProtocol
//    let deviceManager: SPDeviceManager
//    lazy var logger = { return OSLogger() }()
//    var messageViewController: GDPRMessageViewController?
//    var loading: LoadingStatus = .Ready  // used in order not to load the message ui multiple times
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
//        propertyName: GDPRPropertyName,
//        PMId: String,
//        campaignEnv: GDPRCampaignEnv,
//        targetingParams: TargetingParams = [:],
//        consentDelegate: GDPRConsentDelegate,
//        sourcePointClient: SourcePointProtocol,
//        localStorage: GDPRLocalStorage = GDPRUserDefaults(),
//        deviceManager: SPDeviceManager = SPDevice()
//    ) {
//        self.accountId = accountId
//        self.propertyName = propertyName
//        self.propertyId = propertyId
//        self.pmId = PMId
//        self.targetingParams = targetingParams
//        self.consentDelegate = consentDelegate
//        self.sourcePoint = sourcePointClient
//        self.localStorage = localStorage
//        self.deviceManager = deviceManager
//        super.init(nibName: nil, bundle: nil)
//        modalPresentationStyle = .overFullScreen
//
//        /// - note: according to the IAB this value needs to be initialised as early as possible to signal to vendors, the app has a CMP
//        localStorage.storage.set(GDPRConsentViewController.IAB_CMP_SDK_ID, forKey: GDPRConsentViewController.IAB_CMP_SDK_ID_KEY)
//    }
//    public convenience init(
//        accountId: Int,
//        propertyId: Int,
//        propertyName: GDPRPropertyName,
//        PMId: String,
//        campaignEnv: GDPRCampaignEnv = .Public,
//        targetingParams: TargetingParams = [:],
//        consentDelegate: GDPRConsentDelegate
//    ) {
//        let sourcePoint = SourcePointClient(
//            accountId: accountId,
//            propertyId: propertyId,
//            propertyName: propertyName,
//            pmId: PMId,
//            campaignEnv: campaignEnv,
//            targetingParams: targetingParams,
//            timeout: GDPRConsentViewController.DefaultTimeout
//        )
//        self.init(
//            accountId: accountId,
//            propertyId: propertyId,
//            propertyName: propertyName,
//            PMId: PMId,
//            campaignEnv: campaignEnv,
//            targetingParams: targetingParams,
//            consentDelegate: consentDelegate,
//            sourcePointClient: sourcePoint
//        )
//    }
//
//    /// :nodoc:
//    required public init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func handleNativeMessageResponse(_ response: MessageResponse) {
//        self.loading = .Ready
//        if let message = response.msgJSON {
//            self.consentDelegate?.consentUIWillShow?(message: message)
//        } else {
//            self.onConsentReady(gdprUUID: response.uuid, userConsent: response.userConsent)
//        }
//    }
//
//    func handleWebMessageResponse(_ response: MessageResponse) {
//       if let url = response.url {
//           self.loadMessage(fromUrl: url)
//       } else {
//           self.loading = .Ready
//           self.onConsentReady(gdprUUID: response.uuid, userConsent: response.userConsent)
//       }
//   }
//
//    func loadGDPRMessage(native: Bool, authId: String?) {
//        if loading == .Ready {
//            loading = .Loading
//            if didAuthIdChange(newAuthId: (authId)) {
//                clearAllData()
//            }
//            localStorage.authId = authId
//            sourcePoint.getMessage(native: native, consentUUID: gdprUUID, euconsent: euconsent, authId: authId, meta: localStorage.meta) { [weak self] messageResponse, error in
//                if let messageResponse = messageResponse {
//                    self?.localStorage.consentUUID = messageResponse.uuid
//                    self?.localStorage.meta = messageResponse.meta
//                    self?.localStorage.userConsents = messageResponse.userConsent
//                    native ?
//                        self?.handleNativeMessageResponse(messageResponse) :
//                        self?.handleWebMessageResponse(messageResponse)
//                } else {
//                    self?.onError(error: error ?? GDPRConsentViewControllerError())
//                }
//            }
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
//            consentUUID: gdprUUID,
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
//                consentUUID: gdprUUID,
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
//        tcfData: SPGDPRArbitraryJson,
//        completionHandler: @escaping (GDPRUserConsent) -> Void) {
//        sourcePoint.customConsent(toConsentUUID: uuid, vendors: vendors, categories: categories, legIntCategories: legIntCategories) { [weak self] (response, error) in
//            guard let response = response, error == nil else {
//                self?.onError(error: error ?? GDPRConsentViewControllerError())
//                return
//            }
//
//            let updatedUserConsents = GDPRUserConsent(
//                acceptedVendors: response.vendors,
//                acceptedCategories: response.categories,
//                legitimateInterestCategories: response.legIntCategories,
//                specialFeatures: response.specialFeatures,
//                vendorGrants: response.grants,
//                euconsent: euconsent,
//                tcfData: tcfData
//            )
//            self?.localStorage.userConsents = updatedUserConsents
//            completionHandler(updatedUserConsents)
//        }
//    }
//
//    /// Add the vendors/categories/legitimateInterestCategories ids to the consent profile of the current user.
//    /// In order words, programatically consent a user to the above
//    /// If an error occurs, the `GDPRConsentDelegate.onError` is called
//    public func customConsentTo(
//        vendors: [String],
//        categories: [String],
//        legIntCategories: [String],
//        completionHandler: @escaping (GDPRUserConsent) -> Void) {
//        if gdprUUID.isEmpty {
//            onError(error: PostingConsentWithoutConsentUUID())
//            return
//        }
//
//        customConsent(
//            uuid: gdprUUID,
//            vendors: vendors,
//            categories: categories,
//            legIntCategories: legIntCategories,
//            euconsent: self.euconsent,
//            tcfData: self.tcfData,
//            completionHandler: completionHandler
//        )
//    }
//
//    public func reportAction(_ action: GDPRAction) {
//        sourcePoint.postAction(action: action, consentUUID: gdprUUID, meta: localStorage.meta) { [weak self] response, error in
//            if let actionResponse = response {
//                self?.localStorage.meta = actionResponse.meta
//                self?.onConsentReady(gdprUUID: actionResponse.uuid, userConsent: actionResponse.userConsent)
//            } else {
//                self?.onError(error: error ?? GDPRConsentViewControllerError())
//            }
//        }
//    }
//}
//
//extension GDPRConsentViewController: GDPRConsentDelegate {
//    public func gdprConsentUIWillShow() {
//        loading = .Ready
//        guard let viewController = messageViewController else { return }
//        add(asChildViewController: viewController)
//        consentDelegate?.consentUIWillShow?()
//        consentDelegate?.gdprConsentUIWillShow?()
//    }
//
//    public func consentUIDidDisappear() {
//        loading = .Ready
//        remove(asChildViewController: messageViewController)
//        messageViewController = nil
//        consentDelegate?.consentUIDidDisappear?()
//    }
//
//    public func onError(error: GDPRConsentViewControllerError) {
//        loading = .Ready
//        if shouldCleanConsentOnError { clearIABConsentData() }
//        if GDPRConsentViewController.shouldCallErrorMetrics { sourcePoint.errorMetrics(
//            error,
//            sdkVersion: GDPRConsentViewController.VERSION,
//            OSVersion: deviceManager.osVersion(),
//            deviceFamily: deviceManager.deviceFamily(),
//            campaignType: .GDPR
//        )}
//        consentDelegate?.onError?(error: error)
//    }
//
//    public func onAction(_ action: GDPRAction) {
//        let type = action.type
//        consentDelegate?.onAction?(action)
//        if type == .Dismiss {
//            self.onConsentReady(gdprUUID: gdprUUID, userConsent: userConsents)
//        } else if type == .AcceptAll || type == .RejectAll || type == .SaveAndExit {
//            reportAction(action)
//        }
//    }
//
//    public func onConsentReady(gdprUUID: GDPRUUID, userConsent: GDPRUserConsent) {
//        localStorage.consentUUID = gdprUUID
//        localStorage.userConsents = userConsent
//        consentDelegate?.onConsentReady?(gdprUUID: gdprUUID, userConsent: userConsent)
//    }
//
//    public func messageWillShow() { consentDelegate?.messageWillShow?() }
//    public func messageDidDisappear() { consentDelegate?.messageDidDisappear?() }
//    public func gdprPMWillShow() { consentDelegate?.gdprPMWillShow?() }
//    public func gdprPMDidDisappear() { consentDelegate?.gdprPMDidDisappear?() }
//}
