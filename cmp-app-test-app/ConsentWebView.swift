//
//  ViewController.swift
//  cmp-app-test-app
//
//  Created by Dmitri Rabinowitz on 8/13/18.
//  Copyright © 2018 Sourcepoint. All rights reserved.
//

public typealias Callback = (ConsentWebView) -> Void

import UIKit
import WebKit
import JavaScriptCore

@objc public class ConsentWebView: UIViewController, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {
    
    enum DebugLevel: String {
        case DEBUG
        case INFO
        case TIME
        case WARN
        case ERROR
        case OFF
    }
    
    static public let EU_CONSENT_KEY: String = "euconsent"
    static public let CONSENT_UUID_KEY: String = "consentUUID"
    
    let accountId: Int
    let siteName: String
    
    var page: String?
    var isStage: Bool = false
    var isInternalStage: Bool = false
    var inAppMessagingPageUrl: String?
    var mmsDomain: String?
    var cmpDomain: String?
    private var targetingParams: [String: Any] = [:]
    var debugLevel: DebugLevel = .OFF
    
    var onReceiveMessageData: Callback?
    var onMessageChoiceSelect: Callback?
    var onInteractionComplete: Callback?
    
    var webView: WKWebView!
    var msgJSON: String? = nil
    var choiceType: Int? = nil
    var euconsent: String? = nil
    var consentUUID: String? = nil
    var isFirstLoad = true
    
    init(
        accountId: Int,
        siteName: String
    ) {
        self.accountId = accountId
        self.siteName = siteName
        
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
        
        view = webView
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        webView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        let pageToLoad = inAppMessagingPageUrl ?? (isInternalStage ?
            "http://in-app-messaging.pm.cmp.sp-stage.net/" :
            "http://in-app-messaging.pm.sourcepoint.mgr.consensu.org/"
        )
        
        let path = page == nil ? "" : page!
        let siteHref = "http://" + siteName + "/" + path + "?"
        
        let mmsDomainToLoad = mmsDomain ?? (isInternalStage ?
            "mms.sp-stage.net" :
            "mms.sp-prod.net"
        )
        
        let cmpDomainToLoad = cmpDomain ?? (isInternalStage ?
            "cmp.sp-stage.net" :
            "sourcepoint.mgr.consensu.org"
        )
        
        var params = [
            "_sp_cmp_inApp=true",
            "_sp_writeFirstPartyCookies=true",
            "_sp_siteHref=" + encodeURIComponent(siteHref)!,
            "_sp_accountId=" + String(accountId),
            "_sp_msg_domain=" + encodeURIComponent(mmsDomainToLoad)!,
            "_sp_cmp_origin=" + encodeURIComponent("//" + cmpDomainToLoad)!,
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
        
        webView.load(myRequest)
    }
    
    private func encodeURIComponent(_ val: String) -> String? {
        var characterSet = CharacterSet.alphanumerics
        characterSet.insert(charactersIn: "-_.!~*'()")
        return val.addingPercentEncoding(withAllowedCharacters: characterSet)
    }
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let messageBody = message.body as? [String: Any], let name = messageBody["name"] as? String {
            if name == "onReceiveMessageData" {
                let body = messageBody["body"] as? [String: Any?]
                
                if let msgJSON = body?["msgJSON"] as? String {
                    self.msgJSON = msgJSON
                    self.onReceiveMessageData?(self)
                }
                
                if let willShowMessage = body?["willShowMessage"] as? Bool, willShowMessage {
                    webView.frame = webView.superview!.frame
                } else {
                    self.onInteractionComplete?(self)
                    
                    webView.removeFromSuperview()
                }
                
            } else if name == "onMessageChoiceSelect" {
                let body = messageBody["body"] as? [String: Int?]
                
                if let choiceType = body?["choiceType"] as? Int {
                    self.choiceType = choiceType
                    self.onMessageChoiceSelect?(self)
                }
                
            } else if name == "interactionComplete" {
                if let body = messageBody["body"] as? [String: String?], let euconsent = body["euconsent"], let consentUUID = body["consentUUID"] {
                    let userDefaults = UserDefaults.standard
                    if (euconsent != nil) {
                        self.euconsent = euconsent
                        userDefaults.setValue(euconsent, forKey: ConsentWebView.EU_CONSENT_KEY)
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

