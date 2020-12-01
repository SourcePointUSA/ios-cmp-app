//
//  GDPRConsentViewController.swift
//  cmp-app-test-app
//
//  Created by Andre Herculano on 12/16/19.
//  Copyright © 2019 Sourcepoint. All rights reserved.
//

import UIKit

public typealias TargetingParams = [String: String]
public typealias GDPRUUID = String
typealias Meta = String

// swiftlint:disable type_body_length file_length

@objcMembers open class GDPRConsentViewController: UIViewController, GDPRMessageUIDelegate {
    static public let SP_GDPR_KEY_PREFIX = "sp_gdpr_"
    static let META_KEY = "\(SP_GDPR_KEY_PREFIX)meta"
    static let EU_CONSENT_KEY = "\(SP_GDPR_KEY_PREFIX)euconsent"
    static let GDPR_UUID_KEY = "\(SP_GDPR_KEY_PREFIX)consentUUID"
    static let GDPR_AUTH_ID_KEY = "\(SP_GDPR_KEY_PREFIX)authId"
    static public let IAB_KEY_PREFIX = "IABTCF_"
    static let IAB_CMP_SDK_ID_KEY = "\(IAB_KEY_PREFIX)CmpSdkID"
    static let IAB_CMP_SDK_ID = 6
    static let DefaultTimeout = TimeInterval(30)

    /// Resets the data stored by the SDK in the UserDefaults
    static public func clearAllData() {
        GDPRUserDefaults().clear()
    }

    /// The IAB consent string, set after the user has chosen after interacting with the ConsentViewController
    public var euconsent: String {
        return localStorage.userConsents.euconsent
    }

    /// The UUID assigned to a user, available after calling `loadMessage`
    public var gdprUUID: GDPRUUID {
        return localStorage.consentUUID
    }

    /// All data related to TCFv2
    public var tcfData: SPGDPRArbitraryJson {
        return localStorage.userConsents.tcfData
    }

    /// All consent data we have in memory and stored on UserDefaults
    public var userConsents: GDPRUserConsent {
        return localStorage.userConsents
    }

    /// The timeout interval in seconds for the message being displayed
    public var messageTimeoutInSeconds = GDPRConsentViewController.DefaultTimeout {
        didSet {
            sourcePoint.setRequestTimeout(self.messageTimeoutInSeconds)
        }
    }

    /// Set language to see the Message/PM in given langauge
    public var overwriteUserLanguageTo = MessageLanguage.BrowserDefault

    /// will instruct the SDK to clean consent data if an error occurs
    public var shouldCleanConsentOnError = true

    /// the instance of `GDPRConsentDelegate` which the `GDPRConsentViewController` will use to perform the lifecycle methods
    public weak var consentDelegate: GDPRConsentDelegate?

    var localStorage: GDPRLocalStorage

    let accountId: Int
    let propertyName: GDPRPropertyName
    let propertyId: Int
    let pmId: String
    let targetingParams: TargetingParams
    let sourcePoint: SourcePointProtocol
    lazy var logger = { return OSLogger() }()
    var messageViewController: GDPRMessageViewController?
    var loading: LoadingStatus = .Ready  // used in order not to load the message ui multiple times
    enum LoadingStatus: String {
        case Ready
        case Presenting
        case Loading
    }

    func remove(asChildViewController viewController: UIViewController?) {
        guard let viewController = viewController else { return }
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }

    func add(asChildViewController viewController: UIViewController) {
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }

    init(
        accountId: Int,
        propertyId: Int,
        propertyName: GDPRPropertyName,
        PMId: String,
        campaignEnv: GDPRCampaignEnv,
        targetingParams: TargetingParams,
        consentDelegate: GDPRConsentDelegate,
        sourcePointClient: SourcePointProtocol,
        localStorage: GDPRLocalStorage
    ) {
        self.accountId = accountId
        self.propertyName = propertyName
        self.propertyId = propertyId
        self.pmId = PMId
        self.targetingParams = targetingParams
        self.consentDelegate = consentDelegate
        self.sourcePoint = sourcePointClient
        self.localStorage = localStorage
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen

        /// - note: according to the IAB this value needs to be initialised as early as possible to signal to vendors, the app has a CMP
        localStorage.storage.set(GDPRConsentViewController.IAB_CMP_SDK_ID, forKey: GDPRConsentViewController.IAB_CMP_SDK_ID_KEY)
    }

    /**
        - Parameters:
            - accountId: the id of your account, can be found in the Account section of SourcePoint's dashboard
            - propertyId: the id of your property, can be found in the property page of SourcePoint's dashboard
            - propertyName: the exact name of your property,
            -  PMId: the id of the PrivacyManager, can be found in the PrivacyManager page of SourcePoint's dashboard
            -  campaignEnv: Indicates if the SDK should load the message from the Public or Stage campaign
            - targetingParams: an arbitrary collection of key/value pairs made available to the Scenario built on SourcePoint's dashboard
            -  consentDelegate: responsible for dealing with the different consent lifecycle functions.
        - SeeAlso: ConsentDelegate
     */
    public convenience init(
        accountId: Int,
        propertyId: Int,
        propertyName: GDPRPropertyName,
        PMId: String,
        campaignEnv: GDPRCampaignEnv,
        targetingParams: TargetingParams,
        consentDelegate: GDPRConsentDelegate
    ) {
        let sourcePoint = SourcePointClient(
            accountId: accountId,
            propertyId: propertyId,
            propertyName: propertyName,
            pmId: PMId,
            campaignEnv: campaignEnv,
            targetingParams: targetingParams,
            timeout: GDPRConsentViewController.DefaultTimeout
        )
        self.init(
            accountId: accountId,
            propertyId: propertyId,
            propertyName: propertyName,
            PMId: PMId,
            campaignEnv: campaignEnv,
            targetingParams: targetingParams,
            consentDelegate: consentDelegate,
            sourcePointClient: sourcePoint,
            localStorage: GDPRUserDefaults()
        )
    }

    /**
       - Parameters:
           - accountId: the id of your account, can be found in the Account section of SourcePoint's dashboard
           - propertyId: the id of your property, can be found in the property page of SourcePoint's dashboard
           - propertyName: the exact name of your property,
           -  PMId: the id of the PrivacyManager, can be found in the PrivacyManager page of SourcePoint's dashboard
           -  campaignEnv: Indicates if the SDK should load the message from the Public or Stage campaign
           -  consentDelegate: responsible for dealing with the different consent lifecycle functions.
       - SeeAlso: ConsentDelegate
    */
    public convenience init(
        accountId: Int,
        propertyId: Int,
        propertyName: GDPRPropertyName,
        PMId: String,
        campaignEnv: GDPRCampaignEnv,
        consentDelegate: GDPRConsentDelegate) {
        self.init(
            accountId: accountId,
            propertyId: propertyId,
            propertyName: propertyName,
            PMId: PMId,
            campaignEnv: campaignEnv,
            targetingParams: [:],
            consentDelegate: consentDelegate
        )
    }

    /// :nodoc:
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func handleNativeMessageResponse(_ response: MessageResponse) {
        self.loading = .Ready
        if let message = response.msgJSON {
            self.consentDelegate?.consentUIWillShow?(message: message)
        } else {
            self.onConsentReady(gdprUUID: response.uuid, userConsent: response.userConsent)
        }
    }

    func handleWebMessageResponse(_ response: MessageResponse) {
       if let url = response.url {
           self.loadMessage(fromUrl: url)
       } else {
           self.loading = .Ready
           self.onConsentReady(gdprUUID: response.uuid, userConsent: response.userConsent)
       }
   }

    func loadGDPRMessage(native: Bool, authId: String?) {
        if loading == .Ready {
            loading = .Loading
            if didAuthIdChange(newAuthId: (authId)) {
                clearAllData()
            }
            localStorage.authId = authId
            sourcePoint.getMessage(native: native, consentUUID: gdprUUID, euconsent: euconsent, authId: authId, meta: localStorage.meta) { [weak self] messageResponse, error in
                if let messageResponse = messageResponse {
                    self?.localStorage.consentUUID = messageResponse.uuid
                    self?.localStorage.meta = messageResponse.meta
                    self?.localStorage.userConsents = messageResponse.userConsent
                    native ?
                        self?.handleNativeMessageResponse(messageResponse) :
                        self?.handleWebMessageResponse(messageResponse)
                } else {
                    self?.onError(error: error)
                }
            }
        }
    }

    public func loadNativeMessage(forAuthId authId: String?) {
       loadGDPRMessage(native: true, authId: authId)
    }

    public func loadMessage(fromUrl url: URL) {
        messageViewController = MessageWebViewController(
            propertyId: propertyId,
            pmId: pmId,
            consentUUID: gdprUUID,
            messageLanguage: overwriteUserLanguageTo,
            timeout: messageTimeoutInSeconds
        )
        messageViewController?.consentDelegate = self
        messageViewController?.loadMessage(fromUrl: url)
    }

    /// Will first check if there's a message to show according to the scenario
    /// If there is, we'll load the message in a WebView and call `ConsentDelegate.onConsentUIWillShow`
    /// Otherwise, we short circuit to `ConsentDelegate.onConsentReady`
    public func loadMessage() {
        loadGDPRMessage(native: false, authId: nil)
    }

    /// Will first check if there's a message to show according to the scenario, for the `authId` provided.
    /// If there is, we'll load the message in a WebView and call `ConsentDelegate.onConsentUIWillShow`
    /// Otherwise, we short circuit to `ConsentDelegate.onConsentReady`
    /// - Parameter authId: any arbitrary token that uniquely identifies an user in your system.
    public func loadMessage(forAuthId authId: String?) {
        loadGDPRMessage(native: false, authId: authId)
    }

    func didAuthIdChange(newAuthId: String?) -> Bool {
        return newAuthId != nil &&
            localStorage.authId != nil &&
            localStorage.authId != newAuthId
    }

    /// Loads the PrivacyManager (that popup with the toggles) in a WebView
    /// If the user changes her consents we call `ConsentDelegate.onConsentReady`
    public func loadPrivacyManager() {
        if loading == .Ready {
            loading = .Loading
            messageViewController = MessageWebViewController(
                propertyId: propertyId,
                pmId: pmId,
                consentUUID: gdprUUID,
                messageLanguage: overwriteUserLanguageTo,
                timeout: messageTimeoutInSeconds
            )
            messageViewController?.consentDelegate = self
            messageViewController?.loadPrivacyManager()
        }
    }

    /// Clears all IAB related data from the UserDefaults
    public func clearIABConsentData() {
        localStorage.tcfData = [:]
    }

    /// Clears all consent data from the UserDefaults. Use this method if you want to **completely** wipe the user's consent data from the device.
    public func clearAllData() {
        localStorage.clear()
    }

    // swiftlint:disable:next function_parameter_count
    func customConsent(
        uuid: String,
        vendors: [String],
        categories: [String],
        legIntCategories: [String],
        euconsent: String,
        tcfData: SPGDPRArbitraryJson,
        completionHandler: @escaping (GDPRUserConsent) -> Void) {
        sourcePoint.customConsent(toConsentUUID: uuid, vendors: vendors, categories: categories, legIntCategories: legIntCategories) { [weak self] (response, error) in
            guard let response = response, error == nil else {
                self?.consentDelegate?.onError?(error: error)
                return
            }

            let updatedUserConsents = GDPRUserConsent(
                acceptedVendors: response.vendors,
                acceptedCategories: response.categories,
                legitimateInterestCategories: response.legIntCategories,
                specialFeatures: response.specialFeatures,
                vendorGrants: response.grants,
                euconsent: euconsent,
                tcfData: tcfData
            )
            self?.localStorage.userConsents = updatedUserConsents
            completionHandler(updatedUserConsents)
        }
    }

    /// Add the vendors/categories/legitimateInterestCategories ids to the consent profile of the current user.
    /// In order words, programatically consent a user to the above
    /// If an error occurs, the `GDPRConsentDelegate.onError` is called
    public func customConsentTo(
        vendors: [String],
        categories: [String],
        legIntCategories: [String],
        completionHandler: @escaping (GDPRUserConsent) -> Void) {
        if gdprUUID.isEmpty {
            consentDelegate?.onError?(error: PostingConsentWithoutConsentUUID())
            return
        }

        customConsent(
            uuid: gdprUUID,
            vendors: vendors,
            categories: categories,
            legIntCategories: legIntCategories,
            euconsent: self.euconsent,
            tcfData: self.tcfData,
            completionHandler: completionHandler
        )
    }

    public func reportAction(_ action: GDPRAction) {
        sourcePoint.postAction(action: action, consentUUID: gdprUUID, meta: localStorage.meta) { [weak self] response, error in
            if let actionResponse = response {
                self?.localStorage.meta = actionResponse.meta
                self?.onConsentReady(gdprUUID: actionResponse.uuid, userConsent: actionResponse.userConsent)
            } else {
                self?.onError(error: error)
            }
        }
    }
}

extension GDPRConsentViewController: GDPRConsentDelegate {
    public func gdprConsentUIWillShow() {
        loading = .Ready
        guard let viewController = messageViewController else { return }
        add(asChildViewController: viewController)
        consentDelegate?.consentUIWillShow?()
        consentDelegate?.gdprConsentUIWillShow?()
    }

    public func consentUIDidDisappear() {
        loading = .Ready
        remove(asChildViewController: messageViewController)
        messageViewController = nil
        consentDelegate?.consentUIDidDisappear?()
    }

    public func onError(error: GDPRConsentViewControllerError?) {
        loading = .Ready
        if shouldCleanConsentOnError { clearIABConsentData() }
        consentDelegate?.onError?(error: error)
    }

    public func onAction(_ action: GDPRAction) {
        let type = action.type
        consentDelegate?.onAction?(action)
        if type == .Dismiss {
            self.onConsentReady(gdprUUID: gdprUUID, userConsent: userConsents)
        } else if type == .AcceptAll || type == .RejectAll || type == .SaveAndExit {
            reportAction(action)
        }
    }

    public func onConsentReady(gdprUUID: GDPRUUID, userConsent: GDPRUserConsent) {
        localStorage.consentUUID = gdprUUID
        localStorage.userConsents = userConsent
        consentDelegate?.onConsentReady?(gdprUUID: gdprUUID, userConsent: userConsent)
    }

    public func messageWillShow() { consentDelegate?.messageWillShow?() }
    public func messageDidDisappear() { consentDelegate?.messageDidDisappear?() }
    public func gdprPMWillShow() { consentDelegate?.gdprPMWillShow?() }
    public func gdprPMDidDisappear() { consentDelegate?.gdprPMDidDisappear?() }
}
