//
//  ConsentViewController.swift
//  cmp-app-test-app
//
//  Created by Andre Herculano on 12/16/19.
//  Copyright © 2019 Sourcepoint. All rights reserved.
//

import UIKit

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
    public var consentUUID: UUID?

    /// The timeout interval in seconds for the message being displayed
    public var messageTimeoutInSeconds = TimeInterval(300)

    private let accountId: Int
    private let property: String
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
            campaign: campaign,
            onError: consentDelegate.onError(error:)
        )

        self.euconsent = try? ConsentString(consentString: UserDefaults.standard.string(forKey: ConsentViewController.EU_CONSENT_KEY) ?? "")
        self.consentUUID = UUID(uuidString: UserDefaults.standard.string(forKey: ConsentViewController.CONSENT_UUID_KEY) ?? "")

        super.init(nibName: nil, bundle: nil)
    }

    /// :nodoc:
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func loadMessage() {
        sourcePoint.getMessage(accountId: accountId, propertyId: propertyId) { [weak self] message in
            if let url = message.url {
                self?.loadMessage(fromUrl: url)
            } else {
                self?.getConsents(forUUID: message.uuid, consentString: message.euconsent)
            }
        }
    }
    
    private func getConsents(forUUID uuid: UUID, consentString: ConsentString?) {
        sourcePoint.getCustomConsents(consentUUID: uuid) { [weak self] consents in
            self?.onConsentReady(
                consentUUID: uuid,
                consents: consents.consentedPurposes + consents.consentedVendors,
                consentString: consentString
            )
        }
    }
    
    private func loadMessage(fromUrl url: URL) {
        messageViewController = MessageWebViewController(propertyId: propertyId, pmId: pmId)
        messageViewController?.consentDelegate = self
        messageViewController?.loadMessage(fromUrl: url)
    }

    public func loadPrivacyManager() {
        messageViewController = MessageWebViewController(propertyId: propertyId, pmId: pmId)
        messageViewController?.consentDelegate = self
        messageViewController?.loadPrivacyManager()
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
            sourcePoint.postAction(action: action, consentUUID: consentUUID) { [weak self] response in
                self?.getConsents(forUUID: response.uuid, consentString: response.euconsent)
            }
        }
    }
    
    public func onConsentReady(consentUUID: UUID, consents: [Consent], consentString: ConsentString?) {
        guard let consentString = consentString else {
            return
        }
        self.consentUUID = consentUUID
        euconsent = consentString
        storeIABVars(consentString: consentString)
        UserDefaults.standard.setValue(consentString.consentString, forKey: ConsentViewController.EU_CONSENT_KEY)
        UserDefaults.standard.setValue(consentUUID.uuidString, forKey: ConsentViewController.CONSENT_UUID_KEY)
        UserDefaults.standard.synchronize()
        consentDelegate?.onConsentReady?(consentUUID: consentUUID, consents: consents, consentString: consentString)
    }

    public func messageWillShow() { consentDelegate?.messageWillShow?() }
    public func messageDidDisappear() { consentDelegate?.messageDidDisappear?() }
    public func pmWillShow() { consentDelegate?.pmWillShow?() }
    public func pmDidDisappear() { consentDelegate?.pmDidDisappear?() }
}
