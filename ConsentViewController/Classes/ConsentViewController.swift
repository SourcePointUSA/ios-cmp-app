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
@objcMembers open class ConsentViewController: UIViewController, ConsentDelegate {
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
    public var euconsent: String

    /// The UUID assigned to the user, set after the user has chosen after interacting with the ConsentViewController
    public var consentUUID: String

    /// The timeout interval in seconds for the message being displayed
    public var messageTimeoutInSeconds = TimeInterval(300)

    private let accountId: Int
    private let property: String
    private let propertyId: Int

    typealias TargetingParams = [String:String]
    private let targetingParams: TargetingParams = [:]

    private let sourcePoint: SourcePointClient
    private let logger: Logger

    /// will instruct the SDK to clean consent data if an error occurs
    public var shouldCleanConsentOnError = true

    private weak var messageDelegate: ConsentDelegate?
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
        messageDelegate: ConsentDelegate
    ){
        self.accountId = accountId
        self.property = property
        self.propertyId = propertyId
        self.messageDelegate = messageDelegate

        self.sourcePoint = SourcePointClient(
            accountId: accountId,
            propertyId: propertyId,
            pmId: PMId,
            campaign: campaign
        )

        self.euconsent = UserDefaults.standard.string(forKey: ConsentViewController.EU_CONSENT_KEY) ?? ""
        self.consentUUID = UserDefaults.standard.string(forKey: ConsentViewController.CONSENT_UUID_KEY) ?? ""
        self.logger = Logger()

        super.init(nibName: nil, bundle: nil)
    }

    /// :nodoc:
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func loadMessage() {
        messageViewController = MessageWebViewController()
        messageViewController?.consentDelegate = self
        messageViewController?.loadMessage(fromUrl: URL(string: "https://notice.sp-prod.net/?message_id=66281"))
    }

    public func loadPrivacyManager() {
        messageViewController = MessageWebViewController()
        messageViewController?.consentDelegate = self
        messageViewController?.loadPrivacyManager(withId: "5c0e81b7d74b3c30c6852301", andPropertyId: 2372)
    }

    public func onMessageReady() {
        guard let viewController = messageViewController else { return }
        add(asChildViewController: viewController)
        messageDelegate?.onMessageReady()
    }

    public func onConsentReady() {
        remove(asChildViewController: messageViewController)
        messageViewController = nil
        messageDelegate?.onConsentReady()

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
    }

    public func onError(error: ConsentViewControllerError?) {
        remove(asChildViewController: messageViewController)
        messageViewController = nil
        if(shouldCleanConsentOnError) {
            clearAllConsentData()
        }
        messageDelegate?.onError(error: error)
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
        let consentString = try buildConsentString(storedConsentString)

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
        let consentString = try buildConsentString(storedConsentString)

        for i in 0..<forIds.count {
            results[i] = consentString.purposeAllowed(forPurposeId: forIds[i])
        }
        return results
    }

    /**
     Checks if the non-IAB purposes passed as parameter were given consent or not.
     Same as `getIabVendorConsents(forIds: )` but for non-IAB vendors.

     - Precondition: this function should be called either during the `Callback` `onConsentReady` or after it has returned.
     - Parameter forIds: an `Array` of vendor ids
     - Returns: an `Array` of `Bool` indicating if the user has given consent to the corresponding vendor.
     */
    public func getCustomVendorConsents(completionHandler cHandler : @escaping ([VendorConsent]?, ConsentViewControllerError?) -> Void) {
        loadAndStoreConsents { (consentsResponse, error) in
            if let vendorConsents = consentsResponse?.consentedVendors {
                cHandler(vendorConsents, nil)
            }else {
                cHandler(nil, error)
            }
        }
    }

    /**
     Checks if a non-IAB purpose was given consent.
     Same as `getIabPurposeConsents(_) but for non-IAB purposes.

     - Precondition: this function should be called either during the `Callback` `onConsentReady` or after it has returned.
     - Parameter forIds: the purpose id
     - Returns: a `Bool` indicating if the user has given consent to that purpose.
     */
    public func getCustomPurposeConsents(completionHandler cHandler : @escaping ([PurposeConsent]?,ConsentViewControllerError?) -> Void) {
        loadAndStoreConsents { (consentsResponse, error) in
            if let purposeConsents = consentsResponse?.consentedPurposes {
                cHandler(purposeConsents, nil)
            } else {
                cHandler(nil, error)
            }
        }
    }

    internal func loadAndStoreConsents(completionHandler cHandler:@escaping (ConsentsResponse?,ConsentViewControllerError?) -> Void) {
        self.sourcePoint.getCustomConsents(forPropertyId: String(self.propertyId), consentUUID: self.consentUUID, euConsent: self.euconsent, completionHandler: { (consents, error) in
            if let _consents = consents {
                cHandler(_consents, nil)
            } else {
                cHandler(nil, error)
            }
        })
    }

    internal func buildConsentString(_ euconsentBase64Url: String) throws -> ConsentString {
        //Convert base46URL to regular base64 encoding for Consent String SDK Swift
        let euconsent = euconsentBase64Url
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")

        guard let consentString = try? ConsentString(consentString: euconsent) else {
            throw UnableToParseConsentStringError(euConsent: euconsentBase64Url)
        }
        return consentString
    }

    internal func storeIABVars(_ euconsentBase64Url: String) throws {
        let userDefaults = UserDefaults.standard
        // Set the standard IABConsent_ConsentString var in userDefaults
        userDefaults.setValue(euconsentBase64Url, forKey: ConsentViewController.IAB_CONSENT_CONSENT_STRING)

        let cstring = try buildConsentString(euconsentBase64Url)

        // Generate parsed vendor consents string
        var parsedVendorConsents = [Character](repeating: "0", count: ConsentViewController.MAX_VENDOR_ID)
        for i in 1...ConsentViewController.MAX_VENDOR_ID {
            if cstring.isVendorAllowed(vendorId: i) {
                parsedVendorConsents[i - 1] = "1"
            }
        }
        userDefaults.setValue(String(parsedVendorConsents), forKey: ConsentViewController.IAB_CONSENT_PARSED_VENDOR_CONSENTS)

        // Generate parsed purpose consents string
        var parsedPurposeConsents = [Character](repeating: "0", count: ConsentViewController.MAX_PURPOSE_ID)
        for pId in cstring.purposesAllowed {
            parsedPurposeConsents[Int(pId) - 1] = "1"
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
