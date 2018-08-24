//
//  ViewController.swift
//  cmp-app-test-app
//
//  Created by Dmitri Rabinowitz on 8/13/18.
//  Copyright © 2018 Sourcepoint. All rights reserved.
//

import UIKit
import WebKit
import JavaScriptCore
class ConsentUIWebView: UIViewController, UIWebViewDelegate, WKScriptMessageHandler {
    
    var webView: UIWebView!
    
    override func loadView() {
        print("in load consent web view")
        
        let config = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        
        let scriptSource = "(function () {\n"
            + "function postToWebView (name, body) {\n"
            + "  window.webkit.messageHandlers.JSReceiver.postMessage({ name: name, body: body });\n"
            + "}\n"
            + "window.JSReceiver = {\n"
            + "  onLoadMessage: function (willShowMessage) { postToWebView('onLoadMessage', willShowMessage); },\n"
            + "  sendConsentData: function (euconsent, consentUUID) { postToWebView('sendConsentData', { euconsent: euconsent, consentUUID: consentUUID }); }\n"
            + "};\n"
            + "})();"
        
        let script = WKUserScript(source: scriptSource, injectionTime: .atDocumentStart, forMainFrameOnly: true)
        userContentController.addUserScript(script)
        
        userContentController.add(self, name: "JSReceiver")
        
        config.userContentController = userContentController
        
        webView = UIWebView(frame: .zero)
        webView.delegate = self
        
        view = webView
    }
    func webView(webView: )
    override func viewDidLoad() {
        super.viewDidLoad()
        print("consent web view did load")
        webView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        let myURL = URL(string: "http://in-app-messaging.pm.cmp.sp-stage.net/?_sp_cmp_inApp=true")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("view will appear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("view did appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("view will disappear")
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("receiving", message)
        if let messageBody = message.body as? [String: Any], let name = messageBody["name"] as? String {
            print("valid message body")
            if name == "onLoadMessage" {
                print("name is onLoadMessage")
                if let willShowMessage = messageBody["body"] as? Bool, willShowMessage {
                    print("will show message")
                    webView.frame = webView.superview!.frame
                } else {
                    webView.removeFromSuperview()
                }
            } else if name == "sendConsentData" {
                print("name is sendConsentData")
                if let body = messageBody["body"] as? [String: String], let euconsent = body["euconsent"] as? String, let consentUUID = body["consentUUID"] as? String {
                    print("euconsent: " + euconsent)
                    print("consentUUID: " + consentUUID)
                    let userDefaults = UserDefaults.standard
                    userDefaults.setValue(euconsent, forKey: "euconsent")
                    userDefaults.setValue(consentUUID, forKey: "consentUUID")
                    userDefaults.synchronize()
                }
                webView.removeFromSuperview()
            }
        }
    }
}
