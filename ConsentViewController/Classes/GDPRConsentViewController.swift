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
    
    static let GDPR_AUTH_ID_KEY: String = "sp_gdpr_authId"

    static public let GDPR_USER_CONSENTS: String = "sp_gdpr_user_consents"

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
    
    static let EmptyConsentUUID: GDPRUUID = ""

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

    /// will instruct the SDK to clean consent data if an error occurs
    public var shouldCleanConsentOnError = true

    public weak var consentDelegate: GDPRConsentDelegate?
    private var messageViewController: GDPRMessageViewController?

    /// Contains the `GDPRConsentStatus`, an array of accepted vendor ids and and array of accepted purposes
    public var userConsent: GDPRUserConsent
    
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

    private static func getStoredUserConsents() -> GDPRUserConsent {
        guard
            let jsonConsents = UserDefaults.standard.string(forKey: GDPR_USER_CONSENTS),
            let jsonData = jsonConsents.data(using: .utf8),
            let userConsent = try? JSONDecoder().decode(GDPRUserConsent.self, from: jsonData)
            else {
                return GDPRUserConsent.empty()
        }
        return userConsent
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

        self.gdprUUID = UserDefaults.standard.string(forKey: GDPRConsentViewController.GDPR_UUID_KEY) ?? ""
        self.euconsent = (try? ConsentString(consentString: UserDefaults.standard.string(forKey: GDPRConsentViewController.EU_CONSENT_KEY) ?? "")) ?? ConsentString.empty
        self.userConsent = GDPRConsentViewController.getStoredUserConsents()
        
        self.sourcePoint = SourcePointClient(
            accountId: accountId,
            propertyId: propertyId,
            propertyName: propertyName,
            pmId: PMId,
            campaignEnv: campaignEnv,
            targetingParams: targetingParams
        )

        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        UserDefaults.standard.setValue(true, forKey: GDPRConsentViewController.IAB_CONSENT_CMP_PRESENT)
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
    
    public func loadNativeMessage(forAuthId authId: String?) {
        if loading == .Ready {
            loading = .Loading
            sourcePoint.getMessageContents(consentUUID: gdprUUID, euconsent: euconsent, authId: authId) { [weak self] messageData, error in
                if let messageResponse = messageData {
                    self?.gdprUUID = messageResponse.uuid
                    self?.loading = .Ready
                    if let message = messageResponse.msgJSON {
                        self?.consentDelegate?.gdprConsentUIWillShow?(message: message)
                    } else {
                        self?.onConsentReady(gdprUUID: messageResponse.uuid, userConsent: messageResponse.userConsent)
                    }
                } else {
                    self?.onError(error: error)
                }
            }
        }
    }
    
    private func loadMessage(fromUrl url: URL) {
        messageViewController = MessageWebViewController(propertyId: propertyId, pmId: pmId, consentUUID: gdprUUID)
        messageViewController?.consentDelegate = self
        messageViewController?.loadMessage(fromUrl: url)
    }
    
    /// Will first check if there's a message to show according to the scenario
    /// If there is, we'll load the message in a WebView and call `ConsentDelegate.gdprConsentUIWillShow`
    /// Otherwise, we short circuit to `ConsentDelegate.onConsentReady`
    public func loadMessage() {
        loadMessage(forAuthId: nil)
    }
    
    /// Will first check if there's a message to show according to the scenario, for the `authId` provided.
    /// If there is, we'll load the message in a WebView and call `ConsentDelegate.gdprConsentUIWillShow`
    /// Otherwise, we short circuit to `ConsentDelegate.onConsentReady`
    ///
    /// - Parameter forAuthId: any arbitrary token that uniquely identifies an user in your system.
    public func loadMessage(forAuthId authId: String?) {
        if loading == .Ready {
            loading = .Loading
            if didAuthIdChange(newAuthId: (authId)){
                resetConsentData()
                UserDefaults.standard.setValue(authId, forKey: GDPRConsentViewController.GDPR_AUTH_ID_KEY)
            }
            sourcePoint.getMessageUrl(consentUUID: gdprUUID, euconsent: euconsent, authId: authId) { [weak self] messageData, error in
                if let message = messageData {
                    self?.gdprUUID = message.uuid
                    if let url = message.url {
                        self?.loadMessage(fromUrl: url)
                    } else {
                        self?.loading = .Ready
                        self?.onConsentReady(gdprUUID: message.uuid, userConsent: message.userConsent)
                    }
                } else {
                    self?.onError(error: error)
                }
            }
        }
    }
    
    private func didAuthIdChange(newAuthId: String?) -> Bool {
        let storedAuthId = UserDefaults.standard.string(forKey: GDPRConsentViewController.GDPR_AUTH_ID_KEY)
        return storedAuthId != nil && newAuthId != nil && storedAuthId != newAuthId
    }
    
    private func resetConsentData(){
        self.euconsent = ConsentString.empty
        self.gdprUUID = GDPRConsentViewController.EmptyConsentUUID
        clearAllData()
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
        sourcePoint.getGdprStatus { gdprAppliesStatus, error in
            if let gdprApplies = gdprAppliesStatus {
            UserDefaults.standard.setValue(gdprApplies ? "1" : "0", forKey: GDPRConsentViewController.IAB_CONSENT_SUBJECT_TO_GDPR)
            } else {
                self.onError(error: error)
            }
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
    }
    
    public func clearInternalData(){
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: GDPRConsentViewController.META_KEY)
        userDefaults.removeObject(forKey: GDPRConsentViewController.GDPR_UUID_KEY)
        userDefaults.removeObject(forKey: GDPRConsentViewController.GDPR_AUTH_ID_KEY)
        userDefaults.removeObject(forKey: GDPRConsentViewController.EU_CONSENT_KEY)
    }
    
    public func clearAllData(){
        clearInternalData()
        clearIABConsentData()
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
        if(shouldCleanConsentOnError) { clearIABConsentData() }
        consentDelegate?.onError?(error: error)
    }
    
    public func reportAction(_ action: GDPRAction, consents: GDPRPMConsents?) {
        if(action.type == .AcceptAll || action.type == .RejectAll || action.type == .SaveAndExit) {
            sourcePoint.postAction(action: action, consentUUID: gdprUUID, consents: consents) { [weak self] actionResponse, error in
                if let response = actionResponse {
                    self?.onConsentReady(gdprUUID: response.uuid, userConsent: response.userConsent)
                } else {
                    self?.onError(error: error)
                }
            }
        }
    }

    public func onAction(_ action: GDPRAction, gdprConsents: GDPRPMConsents?) {
        reportAction(action, consents: gdprConsents)
        consentDelegate?.onAction?(action, gdprConsents: gdprConsents)
    }

    public func onConsentReady(gdprUUID: GDPRUUID, userConsent: GDPRUserConsent) {
        self.gdprUUID = gdprUUID
        self.euconsent = userConsent.euconsent
        storeIABVars(consentString: euconsent)
        if let encodedConsents = try? JSONEncoder().encode(userConsent) {
            UserDefaults.standard.set(String(data: encodedConsents, encoding: .utf8), forKey: GDPRConsentViewController.GDPR_USER_CONSENTS)
        }
        UserDefaults.standard.setValue(euconsent.consentString, forKey: GDPRConsentViewController.EU_CONSENT_KEY)
        UserDefaults.standard.setValue(gdprUUID, forKey: GDPRConsentViewController.GDPR_UUID_KEY)
        UserDefaults.standard.synchronize()
        consentDelegate?.onConsentReady?(gdprUUID: gdprUUID, userConsent: userConsent)
    }

    public func messageWillShow() { consentDelegate?.messageWillShow?() }
    public func messageDidDisappear() { consentDelegate?.messageDidDisappear?() }
    public func gdprPMWillShow() { consentDelegate?.gdprPMWillShow?() }
    public func gdprPMDidDisappear() { consentDelegate?.gdprPMDidDisappear?() }
}
