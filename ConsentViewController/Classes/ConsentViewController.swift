//
//  ConsentViewController.swift
//  cmp-app-test-app
//
//  Created by Andre Herculano on 12/16/19.
//  Copyright © 2019 Sourcepoint. All rights reserved.
//

import UIKit

@objcMembers open class ConsentViewController: UIViewController {
    static public let META_KEY: String = "sp_gdpr_meta"
    /// :nodoc:
    static public let EU_CONSENT_KEY: String = "sp_gdpr_euconsent"
    /// :nodoc:
    static public let CONSENT_UUID_KEY: String = "sp_gdpr_consentUUID"

    /// If the user has consent data stored, reading for this key in the `UserDefaults` will return "1"
    static public let IAB_CONSENT_CMP_PRESENT: String = "IABConsent_CMPPresent"

    /// If the user is subject to GDPR, reading for this key in the `UserDefaults` will return "1" otherwise "0"
    static public let IAB_CONSENT_SUBJECT_TO_GDPR: String = "IABConsent_SubjectToGDPR"

    /// They key used to store the IAB Consent string for the user in the `UserDefaults`
    static public let IAB_CONSENT_CONSENT_STRING: String = "IABConsent_ConsentString"

    /// They key used to read and write the parsed IAB Purposes consented by the user in the `UserDefaults`
    static public let IAB_CONSENT_PARSED_PURPOSE_CONSENTS: String = "IABConsent_ParsedPurposeConsents"

    /// The key used to read and write the parsed IAB Vendor consented by the user in the `UserDefaults`
    static public let IAB_CONSENT_PARSED_VENDOR_CONSENTS: String = "IABConsent_ParsedVendorConsents"

    static private let MAX_VENDOR_ID: Int = 500
    static private let MAX_PURPOSE_ID: Int = 24

    /// The IAB consent string, set after the user has chosen after interacting with the ConsentViewController
    public var euconsent: ConsentString?

    /// The UUID assigned to a user, available after calling `loadMessage`
    public var consentUUID: ConsentUUID?

    /// The timeout interval in seconds for the message being displayed
    public var messageTimeoutInSeconds = TimeInterval(300)

    private let accountId: Int
    private let propertyName: PropertyName
    private let propertyId: Int
    private let pmId: String

    typealias TargetingParams = [String:String]
    private let targetingParams: TargetingParams = [:]

    private let sourcePoint: SourcePointClient
    private lazy var logger = { return Logger() }()

    /// will instruct the SDK to clean consent data if an error occurs
    public var shouldCleanConsentOnError = true

    private weak var consentDelegate: ConsentDelegate?
    private var messageViewController: MessageViewController?
    
    enum LoadingStatus: String {
        case Ready = "Ready"
        case Presenting = "Presenting"
        case Loading = "Loading"
    }

    // used in order not to load the message ui multiple times
    private var loading: LoadingStatus = .Ready

    private func remove(asChildViewController viewController: UIViewController?) {
        guard let viewController = viewController else { return }
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }

    private func add(asChildViewController viewController: UIViewController) {
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
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
    public init(
        accountId: Int,
        propertyId: Int,
        propertyName: PropertyName,
        PMId: String,
        campaignEnv: CampaignEnv,
        consentDelegate: ConsentDelegate
    ){
        self.accountId = accountId
        self.propertyName = propertyName
        self.propertyId = propertyId
        self.pmId = PMId
        self.consentDelegate = consentDelegate

        self.consentUUID = UserDefaults.standard.string(forKey: ConsentViewController.CONSENT_UUID_KEY)
        
        self.sourcePoint = SourcePointClient(
            accountId: accountId,
            propertyId: propertyId,
            propertyName: propertyName,
            pmId: PMId,
            campaignEnv: campaignEnv
        )

        super.init(nibName: nil, bundle: nil)
        
        sourcePoint.onError = onError
        
        modalPresentationStyle = .overFullScreen
    }

    /// :nodoc:
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadMessage(fromUrl url: URL) {
        messageViewController = MessageWebViewController(propertyId: propertyId, pmId: pmId, consentUUID: consentUUID)
        messageViewController?.consentDelegate = self
        messageViewController?.loadMessage(fromUrl: url)
    }
    
    public func loadMessage() {
        if loading == .Ready {
            loading = .Loading
            sourcePoint.getMessage(consentUUID: consentUUID) { [weak self] message in
                if let url = message.url {
                    self?.loadMessage(fromUrl: url)
                } else {
                    self?.loading = .Ready
                    self?.onConsentReady(consentUUID: message.uuid, userConsent: message.userConsent)
                }
            }
        }
    }
    public func loadPrivacyManager() {
        if loading == .Ready {
            loading = .Loading
            messageViewController = MessageWebViewController(propertyId: propertyId, pmId: pmId, consentUUID: consentUUID)
            messageViewController?.consentDelegate = self
            messageViewController?.loadPrivacyManager()
        }
    }

    /**
     Get the IAB consents given to each vendor id in the array passed as parameter

     - Precondition: this function should be called either during the `Callback` `onConsentReady` or after it has returned.
     - Parameter _: an `Array` of vendor ids
     - Returns: an `Array` of `Bool` indicating if the user has given consent to the corresponding vendor.
     */
    public func getIABVendorConsents(_ forIds: [Int]) throws -> [Bool] {
        var results = Array(repeating: false, count: forIds.count)
        let storedConsentString = UserDefaults.standard.string(forKey: ConsentViewController.IAB_CONSENT_CONSENT_STRING) ?? ""
        let consentString = try ConsentString(consentString: storedConsentString)

        for i in 0..<forIds.count {
            results[i] = consentString.isVendorAllowed(vendorId: forIds[i])
        }
        return results
    }

    /**
     Checks if the IAB purposes passed as parameter were given consent or not.

     - Precondition: this function should be called either during the `Callback` `onConsentReady` or after it has returned.
     - Parameter _: an `Array` of purpose ids
     - Returns: an `Array` of `Bool` indicating if the user has given consent to the corresponding purpose.
     */
    public func getIABPurposeConsents(_ forIds: [Int8]) throws -> [Bool] {
        var results = Array(repeating: false, count: forIds.count)
        let storedConsentString = UserDefaults.standard.string(forKey: ConsentViewController.IAB_CONSENT_CONSENT_STRING) ?? ""
        let consentString = try ConsentString(consentString: storedConsentString)

        for i in 0..<forIds.count {
            results[i] = consentString.purposeAllowed(forPurposeId: forIds[i])
        }
        return results
    }

    internal func storeIABVars(consentString: ConsentString) {
        sourcePoint.getGdprStatus { gdprApplies in
            UserDefaults.standard.setValue(gdprApplies ? "1" : "0", forKey: ConsentViewController.IAB_CONSENT_SUBJECT_TO_GDPR)
        }

        UserDefaults.standard.setValue(consentString.consentString, forKey: ConsentViewController.IAB_CONSENT_CONSENT_STRING)

        // Generate parsed vendor consents string
        var parsedVendorConsents = [Character](repeating: "0", count: ConsentViewController.MAX_VENDOR_ID)
        for i in 1...ConsentViewController.MAX_VENDOR_ID {
            if consentString.isVendorAllowed(vendorId: i) {
                parsedVendorConsents[i - 1] = "1"
            }
        }
        UserDefaults.standard.setValue(String(parsedVendorConsents), forKey: ConsentViewController.IAB_CONSENT_PARSED_VENDOR_CONSENTS)

        // Generate parsed purpose consents string
        var parsedPurposeConsents = [Character](repeating: "0", count: ConsentViewController.MAX_PURPOSE_ID)
        for i in consentString.purposesAllowed {
            parsedPurposeConsents[Int(i) - 1] = "1"
        }
        UserDefaults.standard.setValue(String(parsedPurposeConsents), forKey: ConsentViewController.IAB_CONSENT_PARSED_PURPOSE_CONSENTS)
    }

    /// It will clear all the stored userDefaults Data
    public func clearAllConsentData() {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: ConsentViewController.EU_CONSENT_KEY)
        userDefaults.removeObject(forKey: ConsentViewController.CONSENT_UUID_KEY)
        userDefaults.removeObject(forKey: ConsentViewController.IAB_CONSENT_CMP_PRESENT)
        userDefaults.removeObject(forKey: ConsentViewController.IAB_CONSENT_SUBJECT_TO_GDPR)
        userDefaults.removeObject(forKey: ConsentViewController.IAB_CONSENT_CONSENT_STRING)
        userDefaults.removeObject(forKey: ConsentViewController.IAB_CONSENT_PARSED_PURPOSE_CONSENTS)
        userDefaults.removeObject(forKey: ConsentViewController.IAB_CONSENT_PARSED_VENDOR_CONSENTS)
        userDefaults.removeObject(forKey: ConsentViewController.META_KEY)
        userDefaults.synchronize()
    }
}

extension ConsentViewController: ConsentDelegate {
    public func consentUIWillShow() {
        guard let viewController = messageViewController else { return }
        add(asChildViewController: viewController)
        consentDelegate?.consentUIWillShow()
    }

    public func consentUIDidDisappear() {
        loading = .Ready
        remove(asChildViewController: messageViewController)
        messageViewController = nil
        consentDelegate?.consentUIDidDisappear()
    }

    public func onError(error: ConsentViewControllerError?) {
        loading = .Ready
        if(shouldCleanConsentOnError) {
            clearAllConsentData()
        }
        consentDelegate?.onError?(error: error)
    }

    public func onAction(_ action: Action, consents: PMConsents?) {
        if(action == .AcceptAll || action == .RejectAll || action == .SaveAndExit) {
            sourcePoint.postAction(action: action, consentUUID: consentUUID, consents: consents) { [weak self] response in
                self?.onConsentReady(consentUUID: response.uuid, userConsent: response.userConsent)
            }
        }
    }

    public func onConsentReady(consentUUID: ConsentUUID, userConsent: UserConsent) {
        self.consentUUID = consentUUID
        self.euconsent = userConsent.euconsent
        storeIABVars(consentString: userConsent.euconsent)
        UserDefaults.standard.setValue(userConsent.euconsent.consentString, forKey: ConsentViewController.EU_CONSENT_KEY)
        UserDefaults.standard.setValue(consentUUID, forKey: ConsentViewController.CONSENT_UUID_KEY)
        UserDefaults.standard.synchronize()
        consentDelegate?.onConsentReady?(consentUUID: consentUUID, userConsent: userConsent)
    }

    public func messageWillShow() { consentDelegate?.messageWillShow?() }
    public func messageDidDisappear() { consentDelegate?.messageDidDisappear?() }
    public func pmWillShow() { consentDelegate?.pmWillShow?() }
    public func pmDidDisappear() { consentDelegate?.pmDidDisappear?() }
}
