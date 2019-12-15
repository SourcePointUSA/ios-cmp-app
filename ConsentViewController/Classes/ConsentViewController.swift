//
//  ConsentViewController.swift
//  cmp-app-test-app
//
//  Created by Dmitri Rabinowitz on 8/13/18.
//  Copyright © 2018 Sourcepoint. All rights reserved.
//

/// :nodoc:
public typealias Callback = (ConsentViewController) -> Void

import UIKit
import WebKit
import JavaScriptCore

/**
 SourcePoint's Consent SDK is a WebView that loads SourcePoint's web consent managment tool
 and offers ways to inspect the consents and purposes the user has chosen.

 ```
 var consentViewController: ConsentViewController!
 override func viewDidLoad() {
     super.viewDidLoad()
     consentViewController = ConsentViewController(accountId: <ACCOUNT_ID>, siteName: "SITE_NAME", stagingCampaign: true|false)
     consentViewController.onMessageChoiceSelect = {
        (cbw: ConsentViewController) in print("Choice selected by user", cbw.choiceType as Any)
     }
     consentViewController.onInteractionComplete = { (cbw: ConsentViewController) in
         print(
             cbw.euconsent as Any,
             cbw.consentUUID as Any,
             cbw.getIABVendorConsents(["VENDOR_ID"]),
             cbw.getIABPurposeConsents(["PURPOSE_ID"]),
             cbw.getCustomVendorConsents(),
             cbw.getCustomPurposeConsents()
         )
     }
 view.addSubview(consentViewController.view)
 ```
*/
@objcMembers open class ConsentViewController: UIViewController {
    /// :nodoc:
    public enum DebugLevel: String {
        case DEBUG, INFO, TIME, WARN, ERROR, OFF
    }

    /// :nodoc:
    static public let EU_CONSENT_KEY: String = "euconsent"
    /// :nodoc:
    static public let CONSENT_UUID_KEY: String = "consentUUID"

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

    /// :nodoc:
    public var debugLevel: DebugLevel = .OFF

    /// The IAB consent string, set after the user has chosen after interacting with the ConsentViewController
    public var euconsent: ConsentString?

    /// The UUID assigned to the user, set after the user has chosen after interacting with the ConsentViewController
    public var consentUUID: String

    /// The timeout interval in seconds for the message being displayed
    public var messageTimeoutInSeconds = TimeInterval(300)

    private let accountId: Int
    private let property: String
    private let propertyId: Int
    private let pmId: String

    typealias TargetingParams = [String:String]
    private let targetingParams: TargetingParams = [:]

    private let sourcePoint: SourcePointClient
    private let logger: Logger

    /// will instruct the SDK to clean consent data if an error occurs
    public var shouldCleanConsentOnError = true

    private weak var consentDelegate: ConsentDelegate?
    private var messageViewController: MessageViewController?

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
     Initialises the library with `accountId`, `propertyId`, `property`, `PMId`,`campaign` and `messageDelegate`.
     */
    public init(
        accountId: Int,
        propertyId: Int,
        property: String,
        PMId: String,
        campaign: String,
        consentDelegate: ConsentDelegate
    ){
        self.accountId = accountId
        self.property = property
        self.propertyId = propertyId
        self.pmId = PMId
        self.consentDelegate = consentDelegate

        self.sourcePoint = SourcePointClient(
            accountId: accountId,
            propertyId: propertyId,
            pmId: PMId,
            campaign: campaign
        )

        self.consentUUID = UserDefaults.standard.string(forKey: ConsentViewController.CONSENT_UUID_KEY) ?? ""
        self.euconsent = try? ConsentString(consentString: UserDefaults.standard.string(forKey: ConsentViewController.EU_CONSENT_KEY) ?? "")
        self.logger = Logger()

        super.init(nibName: nil, bundle: nil)
    }

    /// :nodoc:
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func loadMessage() {
        messageViewController = MessageWebViewController(propertyId: propertyId, pmId: pmId)
        messageViewController?.consentDelegate = self
        messageViewController?.loadMessage(fromUrl: URL(string: "https://notice.sp-prod.net/?message_id=66281"))
    }

    public func loadPrivacyManager() {
        messageViewController = MessageWebViewController(propertyId: propertyId, pmId: pmId)
        messageViewController?.consentDelegate = self
        messageViewController?.loadPrivacyManager()
    }

    internal func setSubjectToGDPR() {
        sourcePoint.getGdprStatus { [weak self] (gdprStatus, error) in
            guard let gdprStatus = gdprStatus else {
                self?.logger.log("GDPR Status Error: %{public}@", [error ?? ""])
                return
            }
            UserDefaults.standard.setValue(gdprStatus, forKey: ConsentViewController.IAB_CONSENT_SUBJECT_TO_GDPR)
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
        let userDefaults = UserDefaults.standard

        userDefaults.setValue(consentString.consentString, forKey: ConsentViewController.IAB_CONSENT_CONSENT_STRING)

        // Generate parsed vendor consents string
        var parsedVendorConsents = [Character](repeating: "0", count: ConsentViewController.MAX_VENDOR_ID)
        for i in 1...ConsentViewController.MAX_VENDOR_ID {
            if consentString.isVendorAllowed(vendorId: i) {
                parsedVendorConsents[i - 1] = "1"
            }
        }
        userDefaults.setValue(String(parsedVendorConsents), forKey: ConsentViewController.IAB_CONSENT_PARSED_VENDOR_CONSENTS)

        // Generate parsed purpose consents string
        var parsedPurposeConsents = [Character](repeating: "0", count: ConsentViewController.MAX_PURPOSE_ID)
        for i in consentString.purposesAllowed {
            parsedPurposeConsents[Int(i) - 1] = "1"
        }
        userDefaults.setValue(String(parsedPurposeConsents), forKey: ConsentViewController.IAB_CONSENT_PARSED_PURPOSE_CONSENTS)
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
        remove(asChildViewController: messageViewController)
        messageViewController = nil
        consentDelegate?.consentUIDidDisappear()
    }

    public func onError(error: ConsentViewControllerError?) {
        if(shouldCleanConsentOnError) {
            clearAllConsentData()
        }
        consentDelegate?.onError?(error: error)
    }

    public func onAction(_ action: Action) {
        if(action == .AcceptAll || action == .RejectAll || action == .PMAction) {
            // report action to Wrapper api and on its response pass the consents to onConsentReady
            onConsentReady(consents: [VendorConsent(id: "abcd", name: "Example Vendor")])
        }
    }

    public func onConsentReady(consents: [Consent]) {
        /*  perform all IAB related on consent ready
            self.euconsent = euconsent
            self.consentUUID = consentUUID
            do {
                try storeIABVars(euconsent)
                let userDefaults = UserDefaults.standard
                userDefaults.setValue(euconsent, forKey: ConsentViewController.EU_CONSENT_KEY)
                userDefaults.setValue(consentUUID, forKey: ConsentViewController.CONSENT_UUID_KEY)
                userDefaults.synchronize()
            } catch let error as ConsentViewControllerError {
                onError(error: error)
            } catch {
                print(error)
            }
        */
        consentDelegate?.onConsentReady?(consents: consents)
    }

    public func messageWillShow() { consentDelegate?.messageWillShow?() }
    public func messageDidDisappear() { consentDelegate?.messageDidDisappear?() }
    public func pmWillShow() { consentDelegate?.pmWillShow?() }
    public func pmDidDisappear() { consentDelegate?.pmDidDisappear?() }
}
