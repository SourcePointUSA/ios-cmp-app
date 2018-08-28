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
public class ConsentWebView: UIViewController, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {
    
    static public let EU_CONSENT_KEY: String = "euconsent"
    static public let CONSENT_UUID_KEY: String = "consentUUID"
    
    let siteName: String
    let page: String?
    
    let onReceiveMessageData: Callback?
    let onMessageChoiceSelect: Callback?
    let onSendConsentData: Callback?
    
    var webView: WKWebView!
    var msgJSON: String? = nil
    var choiceType: Int? = nil
    var euconsent: String? = nil
    var consentUUID: String? = nil
    var isFirstLoad = true
    
    init(
        siteName: String,
        page: String? = nil,
        onReceiveMessageData: Callback? = nil,
        onMessageChoiceSelect: Callback? = nil,
        onSendConsentData: Callback? = nil
    ) {
        self.siteName = siteName
        self.page = page
        self.onReceiveMessageData = onReceiveMessageData
        self.onMessageChoiceSelect = onMessageChoiceSelect
        self.onSendConsentData = onSendConsentData
        
        self.euconsent = UserDefaults.standard.string(forKey: ConsentWebView.EU_CONSENT_KEY)
        self.consentUUID = UserDefaults.standard.string(forKey: ConsentWebView.CONSENT_UUID_KEY)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    // may need to implement this eventually
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            + "  sendConsentData: function (euconsent, consentUUID) { postToWebView('sendConsentData', { euconsent: euconsent, consentUUID: consentUUID }); }\n"
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
        print("consent web view did load")
        webView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        var characterSet = CharacterSet.alphanumerics
        characterSet.insert(charactersIn: "-_.!~*'()")
        let path = page == nil ? "" : page!
        let siteHref = ("http://" + siteName + "/" + path).addingPercentEncoding(withAllowedCharacters: characterSet)
        let myURL = URL(string: "http://in-app-messaging.pm.cmp.sp-stage.net/?_sp_cmp_inApp=true&_sp_writeFirstPartyCookies=true&_sp_siteHref=" + siteHref!)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let messageBody = message.body as? [String: Any], let name = messageBody["name"] as? String {
            if name == "onReceiveMessageData" {
                let body = messageBody["body"] as? [String: Any?]
                
                if let willShowMessage = body?["willShowMessage"] as? Bool, willShowMessage {
                    webView.frame = webView.superview!.frame
                } else {
                    webView.removeFromSuperview()
                }
                
                if let msgJSON = body?["msgJSON"] as? String {
                    self.msgJSON = msgJSON
                    self.onReceiveMessageData?(self)
                }
                
            } else if name == "onMessageChoiceSelect" {
                let body = messageBody["body"] as? [String: Int?]
                
                if let choiceType = body?["choiceType"] as? Int {
                    self.choiceType = choiceType
                    self.onMessageChoiceSelect?(self)
                }
                
            } else if name == "sendConsentData" {
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
                
                self.onSendConsentData?(self)
                
                webView.removeFromSuperview()
            }
        }
    }
}

