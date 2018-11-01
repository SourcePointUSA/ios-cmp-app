//
//  ConsentWebView.swift
//  cmp-app-test-app
//
//  Created by Dmitri Rabinowitz on 8/13/18.
//  Copyright © 2018 Sourcepoint. All rights reserved.
//

public typealias Callback = (ConsentWebView) -> Void

import UIKit
import WebKit
import JavaScriptCore
import Consent_String_SDK_Swift

public class ConsentWebView: UIViewController, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {

    public enum DebugLevel: String {
        case DEBUG
        case INFO
        case TIME
        case WARN
        case ERROR
        case OFF
    }

    static public let EU_CONSENT_KEY: String = "euconsent"
    static public let CONSENT_UUID_KEY: String = "consentUUID"
    static public let IAB_CONSENT_CMP_PRESENT: String = "IABConsent_CMPPresent"
    static public let IAB_CONSENT_SUBJECT_TO_GDPR: String = "IABConsent_SubjectToGDPR"
    static public let IAB_CONSENT_CONSENT_STRING: String = "IABConsent_ConsentString"
    static public let IAB_CONSENT_PARSED_PURPOSE_CONSENTS: String = "IABConsent_ParsedPurposeConsents"
    static public let IAB_CONSENT_PARSED_VENDOR_CONSENTS: String = "IABConsent_ParsedVendorConsents"
    

    
    public let accountId: Int
    public let siteName: String

    static public let SP_PREFIX: String = "_sp_"
    static public let SP_SITE_ID: String = SP_PREFIX + "site_id"

    static private let MAX_VENDOR_ID: Int = 500
    static private let MAX_PURPOSE_ID: Int = 24

    public var page: String?
    public var isStage: Bool = false
    public var isInternalStage: Bool = false
    public var inAppMessagingPageUrl: String?
    public var mmsDomain: String?
    public var cmpDomain: String?
    private var targetingParams: [String: Any] = [:]
    public var debugLevel: DebugLevel = .OFF

    public var onReceiveMessageData: Callback?
    public var onMessageChoiceSelect: Callback?
    public var onInteractionComplete: Callback?

    var webView: WKWebView!
    public var msgJSON: String? = nil
    public var choiceType: Int? = nil
    public var euconsent: String? = nil
    public var consentUUID: String? = nil

    public var customConsent: [[String: Any]] = []

    private var mmsDomainToLoad: String?
    private var cmpDomainToLoad: String?
    private var cmpUrl: String?

    private static func load(_ urlString: String) -> Data? {
        let url = NSURL(string: urlString)
        if url == nil {
            print("invalid url string: " + urlString)
            return nil
        }
        let request = URLRequest(url: url! as URL)
        let response: AutoreleasingUnsafeMutablePointer<URLResponse?>? = nil
        return try! NSURLConnection.sendSynchronousRequest(request, returning: response)
    }

    public init(
        accountId: Int,
        siteName: String
        ) {
        
        // required parameters for construction
        self.accountId = accountId
        self.siteName = siteName

        // read consent from/write consent data to UserDefaults.standard storage
        // per gdpr framework: https://github.com/InteractiveAdvertisingBureau/GDPR-Transparency-and-Consent-Framework/blob/852cf086fdac6d89097fdec7c948e14a2121ca0e/In-App%20Reference/iOS/CMPConsentTool/Storage/CMPDataStorageUserDefaults.m
        self.euconsent = UserDefaults.standard.string(forKey: ConsentWebView.EU_CONSENT_KEY)
        self.consentUUID = UserDefaults.standard.string(forKey: ConsentWebView.CONSENT_UUID_KEY)
        super.init(nibName: nil, bundle: nil)
    }

    // may need to implement this eventually
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setTargetingParam(key: String, value: String) {
        targetingParams[key] = value
    }

    public func setTargetingParam(key: String, value: Int) {
        targetingParams[key] = value
    }

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

        view = webView
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        // initially hide web view while loading
        webView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)

        let pageToLoad = inAppMessagingPageUrl ?? (isInternalStage ?
            "http://in-app-messaging.pm.cmp.sp-stage.net/" :
            "http://in-app-messaging.pm.sourcepoint.mgr.consensu.org/"
        )

        let path = page == nil ? "" : page!
        let siteHref = "http://" + siteName + "/" + path + "?"

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

    private func getSiteId() -> String? {
        let siteIdKey = ConsentWebView.SP_SITE_ID + "_" + String(accountId) + "_" + siteName
        let storedSiteId = UserDefaults.standard.string(forKey: siteIdKey)
        if storedSiteId != nil {
            return storedSiteId
        }

        let path = page == nil ? "" : page!
        let siteHref = "http://" + siteName + "/" + path + "?"
        
        let result = ConsentWebView.load(
            "http://" + mmsDomainToLoad! + "/get_site_data?account_id=" + String(accountId) + "&href=" + siteHref
        )
        let parsedResult = try! JSONSerialization.jsonObject(with: result!, options: []) as? [String:Int]

        let siteId = parsedResult!["site_id"]

        UserDefaults.standard.setValue(siteId, forKey: siteIdKey)
        UserDefaults.standard.synchronize()
        
        return String(siteId!)
    }

    public func getGdprApplies() -> Bool {
        let path = "/consent/v2/gdpr-status"
        let result = ConsentWebView.load(cmpUrl! + path)
        let parsedResult = try! JSONSerialization.jsonObject(with: result!, options: []) as? [String: Int]
        return parsedResult!["gdprApplies"] == 1;
    }

    public func getVendorConsent(_ customVendorId: String) -> Bool {
        return getVendorConsents([customVendorId])[0]
    }

    public func getVendorConsents(_ customVendorIds: [String]) -> [Bool] {
        let CUSTOM_VENDOR_PREFIX = ConsentWebView.SP_PREFIX + "_custom_vendor_consent_"
        var result = Array(repeating: false, count: customVendorIds.count)

        let siteId = getSiteId()
        if siteId == nil {
            return result
        }

        var customVendorIdsToRequest: [String] = []
        for index in 0..<customVendorIds.count {
            let customVendorId = customVendorIds[index]
            let storedConsentData = UserDefaults.standard.string(forKey: CUSTOM_VENDOR_PREFIX + customVendorId)
            if storedConsentData == nil {
                customVendorIdsToRequest.append(customVendorId)
            } else {
                result[index] = storedConsentData == "true"
            }
        }

        if customVendorIdsToRequest.count == 0 {
            return result
        }

        let consentParam = consentUUID == nil ? "[CONSENT_UUID]" : consentUUID!
        let euconsentParam = euconsent == nil ? "[EUCONSENT]" : euconsent!
        let customVendorIdString = encodeURIComponent(customVendorIdsToRequest.joined(separator: ","))

        let path = "/consent/v2/" + siteId! + "/custom-vendors"
        let search = "?customVendorIds=" + customVendorIdString! + "&consentUUID=" + consentParam + "&euconsent=" + euconsentParam
        let url = cmpUrl! + path + search
        let data = ConsentWebView.load(url)
        
        let consents = try! JSONSerialization.jsonObject(with: data!, options: []) as? [String:[[String: String]]]
        let consentedCustomVendors = consents!["consentedVendors"]
        for consentedCustomVendor in consentedCustomVendors! {
            UserDefaults.standard.setValue("true", forKey: CUSTOM_VENDOR_PREFIX + consentedCustomVendor["_id"]!)
        }
        UserDefaults.standard.synchronize()

        for index in 0..<customVendorIds.count {
            let customVendorId = customVendorIds[index]
            let storedConsentData = UserDefaults.standard.string(forKey: CUSTOM_VENDOR_PREFIX + customVendorId)
            
            if storedConsentData != nil {
                result[index] = storedConsentData == "true"
            }
        }

        return result
    }

    private func encodeURIComponent(_ val: String) -> String? {
        var characterSet = CharacterSet.alphanumerics
        characterSet.insert(charactersIn: "-_.!~*'()")
        return val.addingPercentEncoding(withAllowedCharacters: characterSet)
    }

    let maxPurposes:Int64 = 24

    private func storeIABVars(_ euconsentBase64Url: String) {
        let userDefaults = UserDefaults.standard
        // Set the standard IABConsent_ConsentString var in userDefaults
        userDefaults.setValue(euconsentBase64Url, forKey: ConsentWebView.IAB_CONSENT_CONSENT_STRING)

        //Convert base46URL to regular base64 encoding for Consent String SDK Swift
        var euconsent = euconsentBase64Url
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        let cstring = try! ConsentString(
            consentString: euconsent
        )

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

