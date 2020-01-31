//
//  GDPRConsentViewController.swift
//  cmp-app-test-app
//
//  Created by Andre Herculano on 12/16/19.
//  Copyright © 2019 Sourcepoint. All rights reserved.
//

import UIKit

public typealias TargetingParams = [String:String]

@objcMembers open class GDPRConsentViewController: UIViewController {
    static let META_KEY: String = "sp_gdpr_meta"
    /// :nodoc:
    static let EU_CONSENT_KEY: String = "sp_gdpr_euconsent"
    /// :nodoc:
    static let GDPR_UUID_KEY: String = "sp_gdpr_consentUUID"

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

    /// The IAB consent string, set after the user has chosen after interacting with the ConsentViewController
    public var euconsent: ConsentString

    /// The UUID assigned to a user, available after calling `loadMessage`
    public var gdprUUID: GDPRUUID

    /// The timeout interval in seconds for the message being displayed
    public var messageTimeoutInSeconds = TimeInterval(300)

    private let accountId: Int
    private let propertyName: GDPRPropertyName
    private let propertyId: Int
    private let pmId: String
    
    private let targetingParams: TargetingParams

    private let sourcePoint: SourcePointClient
    private lazy var logger = { return Logger() }()

    /// will instruct the SDK to clean consent data if an error occurs
    public var shouldCleanConsentOnError = true

    private weak var consentDelegate: GDPRConsentDelegate?
    private var messageViewController: GDPRMessageViewController?
    
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
            - targetingParams: an arbitrary collection of key/value pairs made available to the Scenario built on SourcePoint's dashboard
            -  consentDelegate: responsible for dealing with the different consent lifecycle functions.
        - SeeAlso: ConsentDelegate
     */
    public init(
        accountId: Int,
        propertyId: Int,
        propertyName: GDPRPropertyName,
        PMId: String,
        campaignEnv: GDPRCampaignEnv,
        targetingParams: TargetingParams,
        consentDelegate: GDPRConsentDelegate
    ){
        self.accountId = accountId
        self.propertyName = propertyName
        self.propertyId = propertyId
        self.pmId = PMId
        self.targetingParams = targetingParams
        self.consentDelegate = consentDelegate

        self.gdprUUID = UserDefaults.standard.string(forKey: GDPRConsentViewController.GDPR_UUID_KEY) ??
            UUID().uuidString
        self.euconsent = (try? ConsentString(consentString: UserDefaults.standard.string(forKey: GDPRConsentViewController.EU_CONSENT_KEY) ?? "")) ?? ConsentString.empty
        
        self.sourcePoint = SourcePointClient(
            accountId: accountId,
            propertyId: propertyId,
            propertyName: propertyName,
            pmId: PMId,
            campaignEnv: campaignEnv,
            targetingParams: targetingParams
        )

        super.init(nibName: nil, bundle: nil)
        sourcePoint.onError = onError
        modalPresentationStyle = .overFullScreen
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
        self.init(accountId: accountId, propertyId: propertyId, propertyName: propertyName, PMId: PMId, campaignEnv: campaignEnv, targetingParams: [:], consentDelegate: consentDelegate)
    }

    /// :nodoc:
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadMessage(fromUrl url: URL) {
        messageViewController = MessageWebViewController(propertyId: propertyId, pmId: pmId, consentUUID: gdprUUID)
        messageViewController?.consentDelegate = self
        messageViewController?.loadMessage(fromUrl: url)
    }
    
    /// Will first check if there's a message to show according to the scenario
    /// If there is, we'll load the message in a WebView and call `ConsentDelegate.onConsentUIWillShow`
    /// Otherwise, we short circuit to `ConsentDelegate.onConsentReady`
    public func loadMessage() {
        loadMessage(forAuthId: nil)
    }
    
    /// Will first check if there's a message to show according to the scenario, for the `authId` provided.
    /// If there is, we'll load the message in a WebView and call `ConsentDelegate.onConsentUIWillShow`
    /// Otherwise, we short circuit to `ConsentDelegate.onConsentReady`
    ///
    /// - Parameter forAuthId: any arbitrary token that uniquely identifies an user in your system.
    public func loadMessage(forAuthId authId: String?) {
        if loading == .Ready {
            loading = .Loading
            sourcePoint.getMessage(consentUUID: gdprUUID, euconsent: euconsent, authId: authId) { [weak self] message in
                self?.gdprUUID = message.uuid
                if let url = message.url {
                    self?.loadMessage(fromUrl: url)
                } else {
                    self?.loading = .Ready
                    self?.onConsentReady(gdprUUID: message.uuid, userConsent: message.userConsent)
                }
            }
        }
    }

    /// Loads the PrivacyManager (that popup with the toggles) in a WebView
    /// If the user changes her consents we call `ConsentDelegate.onConsentReady`
    public func loadPrivacyManager() {
        if loading == .Ready {
            loading = .Loading
            messageViewController = MessageWebViewController(propertyId: propertyId, pmId: pmId, consentUUID: gdprUUID)
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
        let storedConsentString = UserDefaults.standard.string(forKey: GDPRConsentViewController.IAB_CONSENT_CONSENT_STRING) ?? ""
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
        let storedConsentString = UserDefaults.standard.string(forKey: GDPRConsentViewController.IAB_CONSENT_CONSENT_STRING) ?? ""
        let consentString = try ConsentString(consentString: storedConsentString)

        for i in 0..<forIds.count {
            results[i] = consentString.purposeAllowed(forPurposeId: forIds[i])
        }
        return results
    }

    internal func storeIABVars(consentString: ConsentString) {
        sourcePoint.getGdprStatus { gdprApplies in
            UserDefaults.standard.setValue(gdprApplies ? "1" : "0", forKey: GDPRConsentViewController.IAB_CONSENT_SUBJECT_TO_GDPR)
        }

        UserDefaults.standard.setValue(consentString.consentString, forKey: GDPRConsentViewController.IAB_CONSENT_CONSENT_STRING)

        // Generate parsed vendor consents string
        var parsedVendorConsents = [Character](repeating: "0", count: consentString.maxVendorId)
        if(parsedVendorConsents.count > 0) {
            for i in 1...consentString.maxVendorId {
                if consentString.isVendorAllowed(vendorId: i) {
                    parsedVendorConsents[i - 1] = "1"
                }
            }
        }
        UserDefaults.standard.setValue(String(parsedVendorConsents), forKey: GDPRConsentViewController.IAB_CONSENT_PARSED_VENDOR_CONSENTS)

        // Generate parsed purpose consents string
        var parsedPurposeConsents = [Character](repeating: "0", count: Int(consentString.maxPurposes))
        for i in consentString.purposesAllowed {
            parsedPurposeConsents[Int(i) - 1] = "1"
        }
        UserDefaults.standard.setValue(String(parsedPurposeConsents), forKey: GDPRConsentViewController.IAB_CONSENT_PARSED_PURPOSE_CONSENTS)
    }

    /// Clears all IAB related data from the UserDefaults
    public func clearIABConsentData() {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: GDPRConsentViewController.IAB_CONSENT_CMP_PRESENT)
        userDefaults.removeObject(forKey: GDPRConsentViewController.IAB_CONSENT_SUBJECT_TO_GDPR)
        userDefaults.removeObject(forKey: GDPRConsentViewController.IAB_CONSENT_CONSENT_STRING)
        userDefaults.removeObject(forKey: GDPRConsentViewController.IAB_CONSENT_PARSED_PURPOSE_CONSENTS)
        userDefaults.removeObject(forKey: GDPRConsentViewController.IAB_CONSENT_PARSED_VENDOR_CONSENTS)
        userDefaults.synchronize()
    }
}

extension GDPRConsentViewController: GDPRConsentDelegate {
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

    public func onError(error: GDPRConsentViewControllerError?) {
        loading = .Ready
        if(shouldCleanConsentOnError) { clearIABConsentData() }
        consentDelegate?.onError?(error: error)
    }

    public func onAction(_ action: GDPRAction, consents: PMConsents?) {
        if(action.type == .AcceptAll || action.type == .RejectAll || action.type == .SaveAndExit) {
            sourcePoint.postAction(action: action, consentUUID: gdprUUID, consents: consents) { [weak self] response in
                self?.onConsentReady(gdprUUID: response.uuid, userConsent: response.userConsent)
            }
        } else if (action.type == .Dismiss) {
            self.onConsentReady(
                gdprUUID: gdprUUID,
                userConsent: GDPRUserConsent(
                    acceptedVendors: consents?.vendors.accepted ?? [],
                    acceptedCategories: consents?.categories.accepted ?? [],
                    euconsent: euconsent
                )
            )
        }
    }

    public func onConsentReady(gdprUUID: GDPRUUID, userConsent: GDPRUserConsent) {
        self.gdprUUID = gdprUUID
        self.euconsent = userConsent.euconsent
        storeIABVars(consentString: euconsent)
        UserDefaults.standard.setValue(euconsent.consentString, forKey: GDPRConsentViewController.EU_CONSENT_KEY)
        UserDefaults.standard.setValue(gdprUUID, forKey: GDPRConsentViewController.GDPR_UUID_KEY)
        UserDefaults.standard.synchronize()
        consentDelegate?.onConsentReady?(gdprUUID: gdprUUID, userConsent: userConsent)
    }

    public func messageWillShow() { consentDelegate?.messageWillShow?() }
    public func messageDidDisappear() { consentDelegate?.messageDidDisappear?() }
    public func pmWillShow() { consentDelegate?.pmWillShow?() }
    public func pmDidDisappear() { consentDelegate?.pmDidDisappear?() }
}
