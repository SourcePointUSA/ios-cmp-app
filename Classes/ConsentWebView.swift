//
//  ConsentWebView.swift
//  cmp-app-test-app
//
//  Created by Dmitri Rabinowitz on 8/13/18.
//  Copyright © 2018 Sourcepoint. All rights reserved.
//

/// :nodoc:
public typealias Callback = (ConsentWebView) -> Void

import UIKit
import WebKit
import JavaScriptCore

/**
 SourcePoint's Consent SDK is a WebView that loads SourcePoint's web consent managment tool
 and offers ways to inspect the consents and purposes the user has chosen.
 
 ```
 var consentWebView: ConsentWebView!
 override func viewDidLoad() {
     super.viewDidLoad()
     consentWebView = ConsentWebView(accountId: <ACCOUNT_ID>, siteName: "SITE_NAME")
     consentWebView.onMessageChoiceSelect = {
        (cbw: ConsentWebView) in print("Choice selected by user", cbw.choiceType as Any)
     }
     consentWebView.onInteractionComplete = { (cbw: ConsentWebView) in
         print(
             cbw.euconsent as Any,
             cbw.consentUUID as Any,
             cbw.getIABVendorConsents(["VENDOR_ID"]),
             cbw.getIABPurposeConsents([PURPOSE_ID]),
             cbw.getCustomVendorConsents(forIds: ["VENDOR_ID"]),
             cbw.getPurposeConsents()
         )
     }
 view.addSubview(consentWebView.view)
 ```
*/
public class ConsentWebView: UIViewController, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {

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

    /// The id of your account can be found in the Publisher's portal -> Account menu
    public let accountId: Int
    
    /// The site name which the campaign and scenarios will be loaded from
    public let siteName: String

    static private let SP_PREFIX: String = "_sp_"
    static private let SP_SITE_ID: String = SP_PREFIX + "site_id"
    static private let CUSTOM_VENDOR_PREFIX = SP_PREFIX + "custom_vendor_consent_"
    static private let SP_CUSTOM_PURPOSE_CONSENT_PREFIX = SP_PREFIX + "custom_purpose_consent_"
    static private let SP_CUSTOM_PURPOSE_CONSENTS_JSON: String = SP_PREFIX + "custom_purpose_consents_json"

    static private let MAX_VENDOR_ID: Int = 500
    static private let MAX_PURPOSE_ID: Int = 24

    static private let PM_MESSAGING_HOST = "pm.sourcepoint.mgr.consensu.org"
    static private let IN_APP_MESSAGING_URL_STAGE = "https://in-app-messaging.pm.cmp.sp-stage.net/"
    static private let IN_APP_MESSAGING_URL_PRODUCTION = "https://in-app-messaging.pm.sourcepoint.mgr.consensu.org/"

    /// Page is merely for logging purposes, eg. https://mysitename.example/page
    public var page: String?
    
    /// Indicates if the campaign is a stage campaign
    public var isStage: Bool = false
    
    /// indicates if the data should come from SourcePoint's staging environment. Most of the times that's not what you want.
    public var isInternalStage: Bool = false
    
    /// :nodoc:
    private var inAppMessagingPageUrl: String?
    /// :nodoc:
    public var mmsDomain: String?
    /// :nodoc:
    public var cmpDomain: String?
    /// :nodoc:
    private var targetingParams: [String: Any] = [:]
    /// :nodoc:
    public var debugLevel: DebugLevel = .OFF

    // TODO: remove it, as in Android's SDK
    /// :nodoc:
    public var onReceiveMessageData: Callback?
    
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

    var webView: WKWebView!
    
    // TODO: remove it
    /// :nodoc:
    public var msgJSON: String? = nil
    
    /// Holds the choice type the user has chosen after interacting with the ConsentWebView
    public var choiceType: Int? = nil
    
    /// The IAB consent string, set after the user has chosen after interacting with the ConsentWebView
    public var euconsent: String? = nil
    
    /// The UUID assigned to the user, set after the user has chosen after interacting with the ConsentWebView
    public var consentUUID: String? = nil

    /// Holds a collection of strings representing the non-IAB consents
    public var customConsent: [[String: Any]] = []

    private var mmsDomainToLoad: String?
    private var cmpDomainToLoad: String?
    private var cmpUrl: String?

    private func startLoad(_ urlString: String) -> Data? {
        let url = URL(string: urlString)!
        let semaphore = DispatchSemaphore( value: 0 )
        var responseData: Data?
        let task = URLSession.shared.dataTask(with: url) { data, reponse, error in
            responseData = data
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        return responseData
    }

    /**
     Initialises the library with `accountId` and `siteName`.
     */
    public init(accountId: Int, siteName: String) {
        self.accountId = accountId
        self.siteName = siteName

        // read consent from/write consent data to UserDefaults.standard storage
        // per gdpr framework: https://github.com/InteractiveAdvertisingBureau/GDPR-Transparency-and-Consent-Framework/blob/852cf086fdac6d89097fdec7c948e14a2121ca0e/In-App%20Reference/iOS/CMPConsentTool/Storage/CMPDataStorageUserDefaults.m
        self.euconsent = UserDefaults.standard.string(forKey: ConsentWebView.EU_CONSENT_KEY)
        self.consentUUID = UserDefaults.standard.string(forKey: ConsentWebView.CONSENT_UUID_KEY)
        super.init(nibName: nil, bundle: nil)
    }

    // TODO: may need to implement this eventually
    /// :nodoc:
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// :nodoc:
    public func setTargetingParam(key: String, value: String) {
        targetingParams[key] = value
    }

    /// :nodoc:
    public func setTargetingParam(key: String, value: Int) {
        targetingParams[key] = value
    }

    public func setInAppMessagingUrl(urlString: String) {
        inAppMessagingPageUrl = urlString
    }

    public func getInAppMessagingUrl() -> String {
        return inAppMessagingPageUrl ?? (isInternalStage ?
            ConsentWebView.IN_APP_MESSAGING_URL_STAGE :
            ConsentWebView.IN_APP_MESSAGING_URL_PRODUCTION
        )
    }

    /// :nodoc:
    override public func loadView() {
        euconsent = UserDefaults.standard.string(forKey: ConsentWebView.EU_CONSENT_KEY)
        consentUUID = UserDefaults.standard.string(forKey: ConsentWebView.CONSENT_UUID_KEY)

        let config = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        // inject js so we have a consistent interface to messaging page as in android
        let scriptSource = "(function () {\n"
            + "function postToWebView (name, body) {\n"
            + "  window.webkit.messageHandlers.JSReceiver.postMessage({ name: name, body: body });\n"
            + "}\n"
            + "window.JSReceiver = {\n"
            + "  onReceiveMessageData: function (willShowMessage, msgJSON) { postToWebView('onReceiveMessageData', { willShowMessage: willShowMessage, msgJSON: msgJSON }); },\n"
            + "  onMessageChoiceSelect: function (choiceType) { postToWebView('onMessageChoiceSelect', { choiceType: choiceType }); },\n"
            + "  sendConsentData: function (euconsent, consentUUID) { postToWebView('interactionComplete', { euconsent: euconsent, consentUUID: consentUUID }); }\n"
            + "};\n"
            + "})();"
        let script = WKUserScript(source: scriptSource, injectionTime: .atDocumentStart, forMainFrameOnly: true)
        userContentController.addUserScript(script)

        userContentController.add(self, name: "JSReceiver")

        config.userContentController = userContentController

        webView = WKWebView(frame: .zero, configuration: config)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.isOpaque = false
        webView.backgroundColor = UIColor.clear
        webView.allowsBackForwardNavigationGestures = true

        view = webView
    }

    private func openInBrowswerHelper(_ url:URL) -> Void {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }

    private func urlDoesNotBelongToDialog(_ url: URL) -> Bool {
        let allowedHosts : Set<String> = [
            URL(string: getInAppMessagingUrl())!.host!,
            siteName,
            mmsDomainToLoad!,
            cmpDomainToLoad!,
            ConsentWebView.PM_MESSAGING_HOST,
            "about:blank"
        ]
        return !allowedHosts.contains(url.host ?? "about:blank")
    }

    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url, urlDoesNotBelongToDialog(url) {
            openInBrowswerHelper(url)
            decisionHandler(WKNavigationActionPolicy.cancel)
        } else {
            decisionHandler(WKNavigationActionPolicy.allow)
        }
    }

    /// :nodoc:
    // handles links with "target=_blank", forcing them to open in Safari
    public func webView(_ webView: WKWebView,
                        createWebViewWith configuration: WKWebViewConfiguration,
                        for navigationAction: WKNavigationAction,
                        windowFeatures: WKWindowFeatures) -> WKWebView? {
        openInBrowswerHelper(navigationAction.request.url!)
        return nil
    }

    /// :nodoc:
    override public func viewDidLoad() {
        super.viewDidLoad()
        // initially hide web view while loading
        webView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)

        let pageToLoad = getInAppMessagingUrl()

        let path = page == nil ? "" : page!
        let siteHref = "https://" + siteName + "/" + path + "?"

        mmsDomainToLoad = mmsDomain ?? (isInternalStage ?
            "mms.sp-stage.net" :
            "mms.sp-prod.net"
        )

        cmpDomainToLoad = cmpDomain ?? (isInternalStage ?
            "cmp.sp-stage.net" :
            "sourcepoint.mgr.consensu.org"
        )
        cmpUrl = "https://" + cmpDomainToLoad!

        var params = [
            "_sp_cmp_inApp=true",
            "_sp_writeFirstPartyCookies=true",
            "_sp_siteHref=" + encodeURIComponent(siteHref)!,
            "_sp_accountId=" + String(accountId),
            "_sp_msg_domain=" + encodeURIComponent(mmsDomainToLoad!)!,
            "_sp_cmp_origin=" + encodeURIComponent("//" + cmpDomainToLoad!)!,
            "_sp_debug_level=" + debugLevel.rawValue,
            "_sp_msg_stageCampaign=" + isStage.description
        ]

        var targetingParamStr: String?
        do {
            let targetingParamData = try JSONSerialization.data(withJSONObject: self.targetingParams, options: [])
            targetingParamStr = String(data: targetingParamData, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            print("error serializing targeting params: " + error.localizedDescription)
        }

        if targetingParamStr != nil {
            params.append("_sp_msg_targetingParams=" + encodeURIComponent(targetingParamStr!)!)
        }

        let myURL = URL(string: pageToLoad + "?" + params.joined(separator: "&"))
        let myRequest = URLRequest(url: myURL!)

        print ("url: \((myURL?.absoluteString)!)")

        UserDefaults.standard.setValue(true, forKey: "IABConsent_CMPPresent")
        let storedSubjectToGdpr = UserDefaults.standard.string(forKey: ConsentWebView.IAB_CONSENT_SUBJECT_TO_GDPR)
        if storedSubjectToGdpr == nil {
            UserDefaults.standard.setValue(getGdprApplies(), forKey: ConsentWebView.IAB_CONSENT_SUBJECT_TO_GDPR)
        }

        webView.load(myRequest)
    }

    /**
     Get the IAB consents given to each vendor id in the array passed as parameter
     
     - Precondition: this function should be called either during the `Callback` `onInteractionComplete` or after it has returned.
     - Parameter _: an `Array` of vendor ids
     - Returns: an `Array` of `Bool` indicating if the user has given consent to the corresponding vendor.
    */
    public func getIABVendorConsents(_ forIds: [Int]) -> [Bool]{
        var results = Array(repeating: false, count: forIds.count)
        let storedConsentString = UserDefaults.standard.string(forKey: ConsentWebView.IAB_CONSENT_CONSENT_STRING) ?? ""
        let consentString:ConsentString = buildConsentString(storedConsentString)
        
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
    public func getIABPurposeConsents(_ forIds: [Int8]) -> [Bool]{
        var results = Array(repeating: false, count: forIds.count)
        let storedConsentString = UserDefaults.standard.string(forKey: ConsentWebView.IAB_CONSENT_CONSENT_STRING) ?? ""
        let consentString:ConsentString = buildConsentString(storedConsentString)
        
        for i in 0..<forIds.count {
            results[i] = consentString.purposeAllowed(forPurposeId: forIds[i])
        }
        return results
    }
    
    private func getSiteId() -> String? {
        let siteIdKey = ConsentWebView.SP_SITE_ID + "_" + String(accountId) + "_" + siteName
        let storedSiteId = UserDefaults.standard.string(forKey: siteIdKey)
        if storedSiteId != nil {
            return storedSiteId
        }

        let path = page == nil ? "" : page!
        let siteHref = "https://" + siteName + "/" + path + "?"

        let result = self.startLoad(
            "https://" + mmsDomainToLoad! + "/get_site_data?account_id=" + String(accountId) + "&href=" + siteHref
        )
        let parsedResult = try! JSONSerialization.jsonObject(with: result!, options: []) as? [String:Int]

        let siteId = parsedResult!["site_id"]

        UserDefaults.standard.setValue(siteId, forKey: siteIdKey)
        UserDefaults.standard.synchronize()

        return String(siteId!)
    }

    /**
     Checks if GDPR applies the user
     
     - Returns: a `Bool` indicating if GDPR applies that user.
     */
    public func getGdprApplies() -> Bool {
        let path = "/consent/v2/gdpr-status"
        let result = self.startLoad(cmpUrl! + path)
        let parsedResult = try! JSONSerialization.jsonObject(with: result!, options: []) as? [String: Int]
        return parsedResult!["gdprApplies"] == 1;
    }

    /**
     Get the non-IAB consents given to a single vendor id
     
     - Precondition: this function should be called either during the `Callback` `onInteractionComplete` or after it has returned.
     - Parameter forId: the vendor id
     - Returns: a `Bool` indicating if the user has given consent to that vendor.
     */
    public func getCustomVendorConsent(forId customVendorId: String) -> Bool {
        return getCustomVendorConsents(forIds: [customVendorId])[0]
    }

    /**
     Checks if the non-IAB purposes passed as parameter were given consent or not.
     Same as `getIabVendorConsents(forIds: )` but for non-IAB vendors.
     
     - Precondition: this function should be called either during the `Callback` `onInteractionComplete` or after it has returned.
     - Parameter forIds: an `Array` of vendor ids
     - Returns: an `Array` of `Bool` indicating if the user has given consent to the corresponding vendor.
     */
    public func getCustomVendorConsents(forIds customVendorIds: [String]) -> [Bool] {
        var result = Array(repeating: false, count: customVendorIds.count)

        loadAndStoreConsents(customVendorIds)

        for index in 0..<customVendorIds.count {
            let customVendorId = customVendorIds[index]
            let storedConsentData = UserDefaults.standard.string(
                forKey: ConsentWebView.CUSTOM_VENDOR_PREFIX + customVendorId
            )

            if storedConsentData != nil {
                result[index] = storedConsentData == "true"
            }
        }

        return result
    }

    /**
     Checks if a non-IAB purpose was given consent.
     Same as `getIabPurposeConsents(_) but for a single non-IAB purpose.
     
     - Precondition: this function should be called either during the `Callback` `onInteractionComplete` or after it has returned.
     - Parameter forId: the purpose id
     - Returns: a `Bool` indicating if the user has given consent to that purpose.
     */
    public func getPurposeConsent(forId purposeId: String) -> Bool {
        var consented = false
        for purpose in getPurposeConsents(forIds: [purposeId]) {
            if purposeId == purpose?["_id"] { consented = true }
        }
        return consented
    }

    /**
     Checks if a non-IAB purpose was given consent.
     Same as `getIabPurposeConsents(_) but for non-IAB purposes.
     
     - Precondition: this function should be called either during the `Callback` `onInteractionComplete` or after it has returned.
     - Parameter forIds: the purpose id
     - Returns: a `Bool` indicating if the user has given consent to that purpose.
     */
    public func getPurposeConsents(forIds purposeIds: [String] = []) -> [[String:String]?] {
        var storedPurposeConsentsJson = UserDefaults.standard.string(
            forKey: ConsentWebView.SP_CUSTOM_PURPOSE_CONSENTS_JSON
        )
        if (storedPurposeConsentsJson == nil) {
            loadAndStoreConsents([])
            storedPurposeConsentsJson = UserDefaults.standard.string(
                forKey: ConsentWebView.SP_CUSTOM_PURPOSE_CONSENTS_JSON
            )
        }

        let purposeConsents = try! JSONSerialization.jsonObject(
            with: storedPurposeConsentsJson!.data(using: String.Encoding.utf8)!, options: []
            ) as? [[String: String]]

        if purposeIds.count == 0 {
            return purposeConsents!
        }

        var results = [[String: String]?](repeating: nil, count: purposeIds.count)
        for consentedPurpose in purposeConsents! {
            if let i = purposeIds.index(of: consentedPurpose["_id"]!) {
                results[i] = consentedPurpose
            }
        }
        return results
    }
    
    
    /**
     * When we receive data from the server, if a given custom vendor is no longer given consent
     * to, its information won't be present in the payload. Therefore we have to first clear the
     * preferences then set each vendor to true based on the response.
     */
    private func clearStoredVendorConsents(forIds vendorIds: [String]) {
        for id in vendorIds {
            UserDefaults.standard.removeObject(forKey: ConsentWebView.CUSTOM_VENDOR_PREFIX + id)
        }
    }

    private func loadAndStoreConsents(_ customVendorIdsToRequest: [String]) {
        let consentParam = consentUUID == nil ? "[CONSENT_UUID]" : consentUUID!
        let euconsentParam = euconsent == nil ? "[EUCONSENT]" : euconsent!
        let customVendorIdString = encodeURIComponent(customVendorIdsToRequest.joined(separator: ","))

        let siteId = getSiteId()
        if siteId == nil {
            return
        }

        let path = "/consent/v2/" + siteId! + "/custom-vendors"
        let search = "?customVendorIds=" + customVendorIdString! +
            "&consentUUID=" + consentParam +
            "&euconsent=" + euconsentParam
        let url = cmpUrl! + path + search
        let data = self.startLoad(url)

        let consents = try! JSONSerialization.jsonObject(with: data!, options: []) as? [String:[[String: String]]]

        // Store consented vendors in UserDefaults one by one
        let consentedCustomVendors = consents!["consentedVendors"]
        clearStoredVendorConsents(forIds: customVendorIdsToRequest)
        for consentedCustomVendor in consentedCustomVendors! {
            UserDefaults.standard.setValue(
                "true",
                forKey: ConsentWebView.CUSTOM_VENDOR_PREFIX + consentedCustomVendor["_id"]!
            )
        }

        // Store consented purposes in UserDefaults as a JSON
        let consentedPurposes = consents!["consentedPurposes"]
        // Serialize consented purposes again
        guard let consentedPurposesJson = try? JSONSerialization.data(withJSONObject: consentedPurposes as Any, options: []) else {
            return
        }
        UserDefaults.standard.setValue(
            String(data: consentedPurposesJson, encoding: String.Encoding.utf8),
            forKey: ConsentWebView.SP_CUSTOM_PURPOSE_CONSENTS_JSON
        )
        for consentedPurpose in consentedPurposes! {
            UserDefaults.standard.setValue(
                "true",
                forKey: ConsentWebView.SP_CUSTOM_PURPOSE_CONSENT_PREFIX + consentedPurpose["_id"]!
            )
        }
        UserDefaults.standard.synchronize()
    }

    private func encodeURIComponent(_ val: String) -> String? {
        var characterSet = CharacterSet.alphanumerics
        characterSet.insert(charactersIn: "-_.!~*'()")
        return val.addingPercentEncoding(withAllowedCharacters: characterSet)
    }

    let maxPurposes:Int64 = 24

    private func buildConsentString(_ euconsentBase64Url: String) -> ConsentString {
        //Convert base46URL to regular base64 encoding for Consent String SDK Swift

        let euconsent = euconsentBase64Url
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        return try! ConsentString(
            consentString: euconsent
        )
    }
    
    private func storeIABVars(_ euconsentBase64Url: String) {
        let userDefaults = UserDefaults.standard
        // Set the standard IABConsent_ConsentString var in userDefaults
        userDefaults.setValue(euconsentBase64Url, forKey: ConsentWebView.IAB_CONSENT_CONSENT_STRING)

        let cstring = buildConsentString(euconsentBase64Url)

        // Generate parsed vendor consents string
        var parsedVendorConsents = [Character](repeating: "0", count: ConsentWebView.MAX_VENDOR_ID)
        for i in 1...ConsentWebView.MAX_VENDOR_ID {
            if cstring.isVendorAllowed(vendorId: i) {
                parsedVendorConsents[i - 1] = "1"
            }
        }
        userDefaults.setValue(String(parsedVendorConsents), forKey: ConsentWebView.IAB_CONSENT_PARSED_VENDOR_CONSENTS)

        // Generate parsed purpose consents string
        var parsedPurposeConsents = [Character](repeating: "0", count: ConsentWebView.MAX_PURPOSE_ID)
        for pId in cstring.purposesAllowed {
            parsedPurposeConsents[Int(pId) - 1] = "1"
        }
        userDefaults.setValue(String(parsedPurposeConsents), forKey: ConsentWebView.IAB_CONSENT_PARSED_PURPOSE_CONSENTS)
    }

    /// :nodoc:
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let messageBody = message.body as? [String: Any], let name = messageBody["name"] as? String {
            // called when message loads
            if name == "onReceiveMessageData" {
                let body = messageBody["body"] as? [String: Any?]

                if let msgJSON = body?["msgJSON"] as? String {
                    self.msgJSON = msgJSON
                    self.onReceiveMessageData?(self)
                }

                if let willShowMessage = body?["willShowMessage"] as? Bool, willShowMessage {
                    // display web view once the message is ready to display
                    webView.frame = webView.superview!.frame
                } else {
                    self.onInteractionComplete?(self)

                    webView.removeFromSuperview()
                }

                // called when choice is selected
            } else if name == "onMessageChoiceSelect" {
                let body = messageBody["body"] as? [String: Int?]

                if let choiceType = body?["choiceType"] as? Int {
                    self.choiceType = choiceType
                    self.onMessageChoiceSelect?(self)
                }

                // called when interaction with message is complete
            } else if name == "interactionComplete" {
                if let body = messageBody["body"] as? [String: String?], let euconsent = body["euconsent"], let consentUUID = body["consentUUID"] {
                    let userDefaults = UserDefaults.standard
                    if (euconsent != nil) {
                        self.euconsent = euconsent
                        userDefaults.setValue(euconsent, forKey: ConsentWebView.EU_CONSENT_KEY)
                        storeIABVars(euconsent!)
                    }

                    if (consentUUID != nil) {
                        self.consentUUID = consentUUID
                        userDefaults.setValue(consentUUID, forKey: ConsentWebView.CONSENT_UUID_KEY)
                    }

                    if (euconsent != nil || consentUUID != nil) {
                        userDefaults.synchronize()
                    }
                }
                self.onInteractionComplete?(self)

                webView.removeFromSuperview()
            }
        }
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
