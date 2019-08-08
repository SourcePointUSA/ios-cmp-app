//
//  WebView.swift
//  ConsentViewController
//
//  Created by Vilas on 8/7/19.
//

import UIKit
import WebKit
import JavaScriptCore

public protocol ConsentWebViewHandler {
    func willShowMessage()
    func didGetConsentData(euconsent: String, consentUUID: String)
}

@objcMembers open class WebView: UIView, UIWebViewDelegate , WKNavigationDelegate, WKScriptMessageHandler {
    
    /**
     Reference to WKWebView
     */
    var webView: WKWebView?
    
    public var consentWebViewHandler: ConsentWebViewHandler?
    
    /**
     WKWebView Configuration
     */
    
    lazy var webConfig: WKWebViewConfiguration = {
        let webCfg: WKWebViewConfiguration = WKWebViewConfiguration()
        webCfg.allowsInlineMediaPlayback = true
        webCfg.requiresUserActionForMediaPlayback = false
        webCfg.preferences = WKPreferences()
        webCfg.preferences.javaScriptEnabled = true
        webCfg.userContentController.addUserScript(WebView.getJSReceiverScript())
        webCfg.userContentController.add(self, name: "JSReceiver")
        return webCfg
    }()
    
    static func getJSReceiverScript() -> WKUserScript {
        let scriptSource = try! String(contentsOfFile: Bundle(for: WebView.self).path(forResource: "JSReceiver", ofType: "js")!)
        //        print(scriptSource)
        return WKUserScript(source: scriptSource, injectionTime: .atDocumentStart, forMainFrameOnly: false)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    //MARK:- WKNavigationDelegate
    
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping ((WKNavigationActionPolicy) -> Void)) {
        print("decidePolicyFor is called")
        decisionHandler(WKNavigationActionPolicy.allow)
    }
    
    // MARK: - Instance Methods
    
    func webViewCleanup() {
        if let currentWebView = webView , let webContentURL = URL(string: "https://www.google.co.in/") {
            
            let requestObj = NSURLRequest(url: webContentURL)
            currentWebView.load(requestObj as URLRequest)
            
            currentWebView.removeFromSuperview()
            webView = nil
        }
    }
    
    public func loadWebContent(url: URL) {
        let webPageUrl = url
        self.webViewCleanup()
        webView = WKWebView(frame: self.frame, configuration: webConfig)
        webView?.isOpaque = false
        webView?.backgroundColor = UIColor.white
        webView?.translatesAutoresizingMaskIntoConstraints = false
        webView?.scrollView.backgroundColor = UIColor.white
        if #available(iOS 11.0, *) {
            webView?.scrollView.contentInsetAdjustmentBehavior = .never
        }
        webView?.scrollView.isScrollEnabled = false
        
        webView?.navigationDelegate = self
        webView?.evaluateJavaScript("JSReceiver", completionHandler: nil)
        
        if let wkWebView = webView {
            self.addSubview(wkWebView)
            self.sendSubviewToBack(wkWebView)
            let requestObj = NSURLRequest(url: webPageUrl)
            wkWebView.load(requestObj as URLRequest)
        }
    }
    
    private func handleMessage(withName name: String, andBody body: [String:Any?]) {
        switch name {
        case "onReceiveMessageData":
            guard
                let shouldShowMessage = body["shouldShowMessage"] as? Bool,
                let consentUUID = body["consentUUID"] as? String,
                let euconsent = body["euconsent"] as? String
                else { fallthrough }
            shouldShowMessage ?
                consentWebViewHandler?.willShowMessage() :
                consentWebViewHandler?.didGetConsentData(euconsent: euconsent, consentUUID: consentUUID)
        case "interactionComplete":
            guard
                let euconsent = body["euconsent"] as? String,
                let consentUUID = body["consentUUID"] as? String
                else { fallthrough }
            consentWebViewHandler?.didGetConsentData(euconsent: euconsent, consentUUID: consentUUID)
        default:
            print("ON ERROR STUB")
        }
    }
    
    /// :nodoc:
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        guard
            let messageBody = message.body as? [String: Any],
            let name = messageBody["name"] as? String,
            let body = messageBody["body"] as? [String: Any?]
            else { return }
        handleMessage(withName: name, andBody: body)
    }
}
