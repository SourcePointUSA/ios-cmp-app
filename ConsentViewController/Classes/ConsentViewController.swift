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
//import WebKit
//import JavaScriptCore
import Reachability

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
@objcMembers open class ConsentViewController: UIViewController, ConsentWebViewHandler  {

    /// :nodoc:
    public enum DebugLevel: String {
        case DEBUG
        case INFO
        case TIME
        case WARN
        case ERROR
        case OFF
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

    static private let SP_PREFIX: String = "_sp_"
    static private let SP_SITE_ID: String = SP_PREFIX + "site_id"

    static private let MAX_VENDOR_ID: Int = 500
    static private let MAX_PURPOSE_ID: Int = 24

    static public let STAGING_MMS_DOMAIN = "mms.sp-stage.net"
    static public let MMS_DOMAIN = "mms.sp-prod.net"

    static public let STAGING_CMP_DOMAIN = "cmp.sp-stage.net"
    static public let CMP_DOMAIN = "sourcepoint.mgr.consensu.org"

    static public let STAGING_IN_APP_MESSAGING_PAGE_DOMAIN = "in-app-messaging.pm.cmp.sp-stage.net/v2.0.html"
    static public let IN_APP_MESSAGING_PAGE_DOMAIN = "in-app-messaging.pm.sourcepoint.mgr.consensu.org/v2.0.html"

    private var targetingParams: [String: Any] = [:]
    /// :nodoc:
    public var debugLevel: DebugLevel = .OFF

    /**
     A `Callback` that will be called the message is about to be shown. Notice that,
     sometimes, depending on how the scenario was set up, the message might not show
     at all, thus this call back won't be called.
     */
    public var onMessageReady: Callback?

    /**
     A `Callback` that will be called when the user selects an option on the WebView.
     The selected choice will be available in the instance variable `choiceType`
     */
    public var onMessageChoiceSelect: Callback?

    /**
     A `Callback` to be called when the user finishes interacting with the WebView
     either by closing it, canceling or accepting the terms.
     At this point, the following keys will available populated in the `UserDefaults`:
     * `EU_CONSENT_KEY`
     * `CONSENT_UUID_KEY`
     * `IAB_CONSENT_SUBJECT_TO_GDPR`
     * `IAB_CONSENT_CONSENT_STRING`
     * `IAB_CONSENT_PARSED_PURPOSE_CONSENTS`
     * `IAB_CONSENT_PARSED_VENDOR_CONSENTS`

     Also at this point, the methods `getCustomVendorConsents()`,
     `getPurposeConsents(forIds:)` and `getPurposeConsent(forId:)`
     will also be able to be called from inside the callback
     */
    public var onInteractionComplete: Callback?

    public var onErrorOccurred: ((ConsentViewControllerError) -> Void)?

    /// Holds the choice type the user has chosen after interacting with the ConsentViewController
    public var choiceType: Int? = nil

    /// The IAB consent string, set after the user has chosen after interacting with the ConsentViewController
    public var euconsent: String

    /// The UUID assigned to the user, set after the user has chosen after interacting with the ConsentViewController
    public var consentUUID: String

    /// The timeout interval in seconds for the message being displayed
    public var messageTimeoutInSeconds = TimeInterval(30)

    private let accountId: Int
    private let siteName: String
    private var onMessageReadyCalled = false

    private let sourcePoint: SourcePointClient

    private var newPM = false
    
    public var sendURL: URL?
    public var webview: WebView?

    /**
     Initialises the library with `accountId` and `siteName`.
     */
    public init(
        accountId: Int,
        siteName: String,
        stagingCampaign: Bool,
        mmsDomain: String,
        cmpDomain: String,
        messageDomain: String
    ) throws {
        self.accountId = accountId
        self.siteName = siteName

        let siteUrl = try Utils.validate(attributeName: "siteName", urlString: "https://"+siteName)
        let mmsUrl = try Utils.validate(attributeName: "mmsUrl", urlString: mmsDomain)
        let cmpUrl = try Utils.validate(attributeName: "cmpUrl", urlString: cmpDomain)
        let messageUrl = try Utils.validate(attributeName: "messageUrl", urlString: messageDomain)

        self.sourcePoint = try SourcePointClient(
            accountId: String(accountId),
            siteUrl: siteUrl,
            stagingCampaign: stagingCampaign,
            mmsUrl: mmsUrl,
            cmpUrl: cmpUrl,
            messageUrl: messageUrl
        )

        self.euconsent = UserDefaults.standard.string(forKey: ConsentViewController.EU_CONSENT_KEY) ?? ""
        self.consentUUID = UserDefaults.standard.string(forKey: ConsentViewController.CONSENT_UUID_KEY) ?? ""

        super.init(nibName: nil, bundle: nil)
    }

    @objc(initWithAccountId:siteName:stagingCampaign:andReturnError:)
    public convenience init(accountId: Int, siteName: String, stagingCampaign: Bool) throws {
        try self.init(
            accountId: accountId,
            siteName: siteName,
            stagingCampaign: stagingCampaign,
            staging: false
        )
    }

    @objc(initWithAccountId:siteName:stagingCampaign:staging:andReturnError:)
    public convenience init(accountId: Int, siteName: String, stagingCampaign: Bool, staging: Bool) throws {
        try self.init(
            accountId: accountId,
            siteName: siteName,
            stagingCampaign: stagingCampaign,
            mmsDomain: "https://" + (staging ? ConsentViewController.STAGING_MMS_DOMAIN : ConsentViewController.MMS_DOMAIN),
            cmpDomain: "https://" + (staging ? ConsentViewController.STAGING_CMP_DOMAIN : ConsentViewController.CMP_DOMAIN),
            messageDomain: "https://" + (staging ? ConsentViewController.STAGING_IN_APP_MESSAGING_PAGE_DOMAIN : ConsentViewController.IN_APP_MESSAGING_PAGE_DOMAIN)
        )
    }

    /// :nodoc:
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// :nodoc:
    @objc(setTargetingParamString:value:)
    public func setTargetingParam(key: String, value: String) {
        targetingParams[key] = value
    }

    /// :nodoc:
    @objc(setTargetingParamInt:value:)
    public func setTargetingParam(key: String, value: Int) {
        targetingParams[key] = value
    }

    public func enableNewPM(_ newPM: Bool) {
        self.newPM = newPM
    }
    
    public func willShowMessage() {
        onMessageReadyCalled = true
        onMessageReady?(self)
    }
    
    public func didGetConsentData(euconsent: String, consentUUID: String) {
        onMessageReadyCalled = true // TODO: change this variable to onConsentLoaded
        self.euconsent = euconsent
        self.consentUUID = consentUUID
        do {
            try storeIABVars(euconsent)
            let userDefaults = UserDefaults.standard
            userDefaults.setValue(euconsent, forKey: ConsentViewController.EU_CONSENT_KEY)
            userDefaults.setValue(consentUUID, forKey: ConsentViewController.CONSENT_UUID_KEY)
            userDefaults.synchronize()
        } catch let error as ConsentViewControllerError {
            onErrorOccurred?(error)
        } catch {}
        done()
    }

    private func timeOut(inSeconds seconds: Double, callback: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: callback)
    }

    private enum MessageStatus { case notStarted, loading, loaded }
    private var messageStatus = MessageStatus.notStarted
    private func loadMessage(withMessageUrl messageUrl: URL) {
        if(messageStatus == .loading || messageStatus == .loaded) { return }

        messageStatus = .loading
//        loadView()
        print ("url: \((messageUrl.absoluteString))")
        UserDefaults.standard.setValue(true, forKey: "IABConsent_CMPPresent")
        self.sendURL = messageUrl
        self.webview?.consentWebViewHandler = self
        return

//        setSubjectToGDPR { (optionalErrorObject) in
//            if let error = optionalErrorObject {
//                self.messageStatus = .notStarted
//                self.onErrorOccurred?(error)
//            } else {
//                guard Reachability()!.connection != .none else {
//                    self.onErrorOccurred?(NoInternetConnection())
//                    self.messageStatus = .notStarted
//                    return
//                }
////                self.webView.load(URLRequest(url: messageUrl))
//                self.timeOut(inSeconds: self.messageTimeoutInSeconds) { if(!self.onMessageReadyCalled) {
//                    self.onMessageReady = nil
//                    self.onErrorOccurred?(MessageTimeout())
//                    self.messageStatus = .notStarted
//                    }};
//                self.messageStatus = .loaded
//            }
//        }
    }

    private func getMessageUrl(authId: String?) -> URL? {
        do {
           return try sourcePoint.getMessageUrl(
                forTargetingParams:  targetingParams,
                debugLevel: debugLevel.rawValue,
                newPM: newPM,
                authId: authId
            )
        } catch let error as ConsentViewControllerError {
            onErrorOccurred?(error)
        } catch {}
        return nil
    }

    public func loadMessage(forAuthId authId: String) -> URL? {
        guard let url = getMessageUrl(authId: authId) else { return nil }
        loadMessage(withMessageUrl: url)
        return sendURL
    }

    public func loadMessage() -> URL? {
        guard let url = getMessageUrl(authId: nil) else { return nil}
        loadMessage(withMessageUrl: url)
        return sendURL
    }

    private func setSubjectToGDPR(completionHandler cHandler:@escaping (ConsentViewControllerError?) -> Void) {
        sourcePoint.getGdprStatus { (gdprStatus, error) in
            guard let _gdprStatus = gdprStatus else {
                cHandler(error)
                return
            }
            cHandler(nil)
            UserDefaults.standard.setValue(String(_gdprStatus), forKey: ConsentViewController.IAB_CONSENT_SUBJECT_TO_GDPR)
        }
    }

    /**
     Get the IAB consents given to each vendor id in the array passed as parameter

     - Precondition: this function should be called either during the `Callback` `onInteractionComplete` or after it has returned.
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

     - Precondition: this function should be called either during the `Callback` `onInteractionComplete` or after it has returned.
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

    private func getSiteId (completionHandler cHandler:@escaping (String?, ConsentViewControllerError?) -> Void) {
        let siteIdKey = ConsentViewController.SP_SITE_ID + "_" + String(accountId) + "_" + siteName
        sourcePoint.getSiteId { (siteId, error) in
            guard let siteId = siteId else {
                cHandler(nil, error)
                return
            }

            UserDefaults.standard.setValue(siteId, forKey: siteIdKey)
            UserDefaults.standard.synchronize()
            cHandler(siteId, nil)
        }
    }

    /**
     Checks if the non-IAB purposes passed as parameter were given consent or not.
     Same as `getIabVendorConsents(forIds: )` but for non-IAB vendors.

     - Precondition: this function should be called either during the `Callback` `onInteractionComplete` or after it has returned.
     - Parameter forIds: an `Array` of vendor ids
     - Returns: an `Array` of `Bool` indicating if the user has given consent to the corresponding vendor.
     */
    public func getCustomVendorConsents(completionHandler cHandler : @escaping ([VendorConsent]) -> Void) {
        loadAndStoreConsents { (consentsResponse) in cHandler(consentsResponse.consentedVendors) }
    }

    /**
     Checks if a non-IAB purpose was given consent.
     Same as `getIabPurposeConsents(_) but for non-IAB purposes.

     - Precondition: this function should be called either during the `Callback` `onInteractionComplete` or after it has returned.
     - Parameter forIds: the purpose id
     - Returns: a `Bool` indicating if the user has given consent to that purpose.
     */
    public func getCustomPurposeConsents(completionHandler cHandler : @escaping ([PurposeConsent]) -> Void) {
        loadAndStoreConsents { (consentsResponse) in cHandler(consentsResponse.consentedPurposes) }
    }

    private func loadAndStoreConsents(completionHandler cHandler:@escaping (ConsentsResponse) -> Void) {
        getSiteId { (optionalSiteID, error) in
            if let _siteID = optionalSiteID {
                self.sourcePoint.getCustomConsents(forSiteId: _siteID, consentUUID: self.consentUUID, euConsent: self.euconsent, completionHandler: { (consents, errror) in
                    if let _consents = consents {
                        cHandler(_consents)
                    }else {
                        cHandler(ConsentsResponse(consentedVendors: [], consentedPurposes: []))
                    }
                })
            } else {
                cHandler(ConsentsResponse(consentedVendors: [], consentedPurposes: []))
            }
        }
    }

    private func buildConsentString(_ euconsentBase64Url: String) throws -> ConsentString {
        //Convert base46URL to regular base64 encoding for Consent String SDK Swift
        let euconsent = euconsentBase64Url
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")

        guard let consentString = try? ConsentString(consentString: euconsent) else {
            throw UnableToParseConsentStringError(euConsent: euconsentBase64Url)
        }
        return consentString
    }

    private func storeIABVars(_ euconsentBase64Url: String) throws {
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

    private func onMessageChoiceSelect(choiceType: Int) {
        guard Reachability()!.connection != .none else {
            onErrorOccurred?(NoInternetConnection())
            done()
            return
        }
        self.choiceType = choiceType
        onMessageChoiceSelect?(self)
    }

    private func onErrorOccurred(_ error: ConsentViewControllerError) {
        onErrorOccurred?(error)
        done()
    }

    private func done() {
        onInteractionComplete?(self)
    }
}

