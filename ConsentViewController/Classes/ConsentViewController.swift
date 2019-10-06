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
@objcMembers open class ConsentViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {

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
    static public let IN_APP_MESSAGING_PAGE_DOMAIN = "in-app-messaging.pm.sourcepoint.mgr.consensu.org/v3/index.html"

    private var targetingParams: [String: Any] = [:]
    /// :nodoc:
    public var debugLevel: DebugLevel = .OFF

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

    var webView: WKWebView!

    /// Holds the choice type the user has chosen after interacting with the ConsentViewController
    public var choiceId: Int? = nil

    /// The IAB consent string, set after the user has chosen after interacting with the ConsentViewController
    public var euconsent: String

    /// The UUID assigned to the user, set after the user has chosen after interacting with the ConsentViewController
    public var consentUUID: String

    /// The timeout interval in seconds for the message being displayed
    public var messageTimeoutInSeconds = TimeInterval(60)

    private let accountId: Int
    private let siteName: String
    private let siteId: Int
    private let showPM: Bool
    private var didMessageScriptLoad = false

    private let sourcePoint: SourcePointClient
    private let consentDelegate: ConsentDelegate
    private let logger: Logger

    private var newPM = false

    /**
     Initialises the library with `accountId`, `siteId`,`PMId`,`campaign`, `showPM` and siteName`.
     */
    public init(
        accountId: Int,
        siteId: Int,
        siteName: String,
        PMId: String,
        campaign: String,
        showPM: Bool,
        mmsDomain: String,
        cmpDomain: String,
        messageDomain: String,
        consentDelegate: ConsentDelegate
    ) throws {
        self.accountId = accountId
        self.siteName = siteName
        self.siteId = siteId
        self.showPM = showPM
        self.consentDelegate = consentDelegate
        
        let siteUrl = try Utils.validate(attributeName: "siteName", urlString: "https://"+siteName)
        let mmsUrl = try Utils.validate(attributeName: "mmsUrl", urlString: mmsDomain)
        let cmpUrl = try Utils.validate(attributeName: "cmpUrl", urlString: cmpDomain)
        let messageUrl = try Utils.validate(attributeName: "messageUrl", urlString: messageDomain)

        self.sourcePoint = try SourcePointClient(
            accountId: accountId,
            siteId: siteId,
            pmId: PMId,
            showPM: showPM,
            siteUrl: siteUrl,
            campaign: campaign,
            mmsUrl: mmsUrl,
            cmpUrl: cmpUrl,
            messageUrl: messageUrl
        )

        self.euconsent = UserDefaults.standard.string(forKey: ConsentViewController.EU_CONSENT_KEY) ?? ""
        self.consentUUID = UserDefaults.standard.string(forKey: ConsentViewController.CONSENT_UUID_KEY) ?? ""
        self.logger = Logger()

        super.init(nibName: nil, bundle: nil)
    }

    @objc(initWithAccountId:siteId:siteName:PMId:campaign:showPM:consentDelegate:andReturnError:)
    public convenience init(accountId: Int, siteId: Int, siteName: String, PMId: String, campaign: String, showPM: Bool, consentDelegate: ConsentDelegate) throws {
        try self.init(
            accountId: accountId,
            siteId: siteId,
            siteName: siteName,
            PMId: PMId,
            campaign: campaign,
            showPM: showPM,
            staging: false,
            consentDelegate: consentDelegate
        )
    }

    @objc(initWithAccountId:siteId:siteName:PMId:campaign:showPM:staging:consentDelegate:andReturnError:)
    public convenience init(accountId: Int, siteId: Int, siteName: String, PMId: String, campaign: String, showPM: Bool, staging: Bool, consentDelegate: ConsentDelegate) throws {
        try self.init(
            accountId: accountId,
            siteId: siteId,
            siteName: siteName,
            PMId: PMId,
            campaign: campaign,
            showPM: showPM,
            mmsDomain: "https://" + (staging ? ConsentViewController.STAGING_MMS_DOMAIN : ConsentViewController.MMS_DOMAIN),
            cmpDomain: "https://" + (staging ? ConsentViewController.STAGING_CMP_DOMAIN : ConsentViewController.CMP_DOMAIN),
            messageDomain: "https://" + (staging ? ConsentViewController.STAGING_IN_APP_MESSAGING_PAGE_DOMAIN : ConsentViewController.IN_APP_MESSAGING_PAGE_DOMAIN),
            consentDelegate: consentDelegate
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

    /// :nodoc:
    override open func loadView() {
        let config = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        let scriptSource = try! String(contentsOfFile: Bundle(for: ConsentViewController.self).path(forResource: "JSReceiver", ofType: "js")!)
        let script = WKUserScript(source: scriptSource, injectionTime: .atDocumentStart, forMainFrameOnly: true)
        userContentController.addUserScript(script)
        userContentController.add(self, name: "JSReceiver")
        config.userContentController = userContentController
        webView = WKWebView(frame: .zero, configuration: config)
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never;
        }
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.translatesAutoresizingMaskIntoConstraints = true
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.isOpaque = false
        modalPresentationStyle = .overCurrentContext
        webView.backgroundColor = .clear
        webView.allowsBackForwardNavigationGestures = true
        view = webView
    }

    /// :nodoc:
    // handles links with "target=_blank", forcing them to open in Safari
    public func webView(_ webView: WKWebView,
                        createWebViewWith configuration: WKWebViewConfiguration,
                        for navigationAction: WKNavigationAction,
                        windowFeatures: WKWindowFeatures) -> WKWebView? {
        guard let url = navigationAction.request.url else { return nil }

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
        return nil
    }

    private func timeOut(inSeconds seconds: Double, callback: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: callback)
    }

    private enum MessageStatus { case notStarted, loading, loaded, timedout }
    private var messageStatus = MessageStatus.notStarted
    private func loadMessage(withMessageUrl messageUrl: URL) {
        if(messageStatus == .loading || messageStatus == .loaded) { return }

        messageStatus = .loading
        loadView()
        logger.log("url: %{public}@", [messageUrl.absoluteString])
        UserDefaults.standard.setValue(true, forKey: ConsentViewController.IAB_CONSENT_CMP_PRESENT)
        UserDefaults.standard.setValue(1, forKey: ConsentViewController.IAB_CONSENT_SUBJECT_TO_GDPR)
        setSubjectToGDPR()

        guard Reachability()!.connection != .none else {
            consentDelegate.onErrorOccurred(error: NoInternetConnection())
            self.messageStatus = .notStarted
            return
        }
        self.webView.load(URLRequest(url: messageUrl))
        self.timeOut(inSeconds: self.messageTimeoutInSeconds) {
            if(!self.didMessageScriptLoad) {
                self.consentDelegate.onErrorOccurred(error: MessageTimeout())
                self.messageStatus = .timedout
            }
        };
        self.messageStatus = .loaded
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
            consentDelegate.onErrorOccurred(error: error)
        } catch {}
        return nil
    }

    public func loadMessage(forAuthId authId: String) {
        guard let url = getMessageUrl(authId: authId) else { return }
        loadMessage(withMessageUrl: url)
    }

    public func loadMessage() {
        guard let url = getMessageUrl(authId: nil) else { return }
        loadMessage(withMessageUrl: url)
    }

    private func setSubjectToGDPR() {
        sourcePoint.getGdprStatus { (gdprStatus, error) in
            guard let _gdprStatus = gdprStatus else {
                if let gdprError = error {
                    self.logger.log("GDPR Status Error: %{public}@", [gdprError])
                }
                return
            }
            UserDefaults.standard.setValue(_gdprStatus, forKey: ConsentViewController.IAB_CONSENT_SUBJECT_TO_GDPR)
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

    private func loadAndStoreConsents(completionHandler cHandler:@escaping (ConsentsResponse?,ConsentViewControllerError?) -> Void) {
        self.sourcePoint.getCustomConsents(forSiteId: String(self.siteId), consentUUID: self.consentUUID, euConsent: self.euconsent, completionHandler: { (consents, error) in
            if let _consents = consents {
                cHandler(_consents, nil)
            } else {
                cHandler(nil, error)
            }
        })
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

    private func onMessageChoiceSelect(choiceId: Int) {
        guard Reachability()!.connection != .none else {
            consentDelegate.onErrorOccurred(error: NoInternetConnection())
            return
        }
        self.choiceId = choiceId
        onMessageChoiceSelect?(self)
    }

    private func done(euconsent: String, consentUUID: String) {
        didMessageScriptLoad = true
        self.euconsent = euconsent
        self.consentUUID = consentUUID
        do {
            try storeIABVars(euconsent)
            let userDefaults = UserDefaults.standard
            userDefaults.setValue(euconsent, forKey: ConsentViewController.EU_CONSENT_KEY)
            userDefaults.setValue(consentUUID, forKey: ConsentViewController.CONSENT_UUID_KEY)
            userDefaults.synchronize()
        } catch let error as ConsentViewControllerError {
            consentDelegate.onErrorOccurred(error: error)
        } catch {}
        consentDelegate.onConsentReady(controller: self)
    }

    private func showMessage() {
        if(messageStatus == .timedout) { return }

        didMessageScriptLoad = true
        consentDelegate.onMessageReady(controller: self)
    }

    private func handleXhrLog(_ body: [String:Any?]) {
        let type = body["type"] as! String
        let url = body["url"] as! String
        if(type == "request"){
            if let cookies = body["cookies"] as? String {
                logger.log("{ \"type\": \"%{public}@\", \"url\": \"%{public}@\", \"cookies\": \"%{public}@\" }", [type, url, cookies])
            } else {
                logger.log("{ \"type\": \"%{public}@\", \"url\": \"%{public}@\"}", [type, url])
            }
        } else {
            let status = body["status"] as? String
            let response = body["response"] as! String
            if let cookies = body["cookies"] as? String {
                logger.log("{ \"type\": \"%{public}@\", \"url\": \"%{public}@\", \"cookies\": \"%{public}@\", \"status\": \"%{public}@\", \"response\": \"%{public}@\" }", [type, url, cookies, status ?? "", response])
            } else {
                logger.log("{ \"type\": \"%{public}@\", \"url\": \"%{public}@\", \"status\": \"%{public}@\", \"response\": \"%{public}@\" }", [type, url, status ?? "", response])
            }
        }
    }

    private func handleMessage(withName name: String, andBody body: [String:Any?]) {
        switch name {
        case "onMessageReady": // when the message is first loaded
            showMessage()
        case "onSPPMObjectReady":
            if self.showPM { showMessage()}
        case "onPMCancel":
            logger.log("onPMCancel  event is triggered", [])
        case "onMessageChoiceSelect": // when a choice is selected
            guard let choiceId = body["choiceId"] as? Int else { fallthrough }
            onMessageChoiceSelect(choiceId: choiceId)
        case "onConsentReady": // when interaction with message is complete
            let euconsent = body["euconsent"] as? String ?? ""
            let consentUUID = body["consentUUID"] as? String ?? ""
            done(euconsent: euconsent, consentUUID: consentUUID)
        case "onPrivacyManagerAction":
            logger.log("onPrivacyManagerAction event is triggered", [])
            return
        case "onErrorOccurred":
            consentDelegate.onErrorOccurred(error: WebViewErrors[body["errorType"] as? String ?? ""] ?? PrivacyManagerUnknownError())
        case "onMessageChoiceError":
            consentDelegate.onErrorOccurred(error: WebViewErrors[body["error"] as? String ?? ""] ?? PrivacyManagerUnknownError())
        case "xhrLog":
            if debugLevel == .DEBUG {
                handleXhrLog(body)
            }
        default:
            consentDelegate.onErrorOccurred(error: PrivacyManagerUnknownMessageResponse(name: name, body: body))
        }
    }

    /// :nodoc:
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard
            let messageBody = message.body as? [String: Any],
            let name = messageBody["name"] as? String
        else {
            consentDelegate.onErrorOccurred(error: PrivacyManagerUnknownMessageResponse(name: "", body: ["":""]))
            return
        }
        if let body = messageBody["body"] as? [String: Any?] {
            handleMessage(withName: name, andBody: body)
        } else {
            handleMessage(withName: name, andBody: ["":""])
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
