//
//  ConsentWebView.swift
//  ConsentViewController
//
//  Created by Vilas on 11/5/19.
//

import UIKit
import WebKit
import JavaScriptCore

public protocol ConsentWebViewHandler {
    func willShowMessage()
    func done(euconsent: String, consentUUID: String)
    func onMessageChoiceSelect(choiceId: Int)
    func onErrorOccurred(error: ConsentViewControllerError)
}

@objcMembers open class ConsentWebView: UIView, UIWebViewDelegate , WKNavigationDelegate, WKScriptMessageHandler {

   /**
     Reference to WKWebView
     */
    var webView: WKWebView?
    var showPM = false
    var debugLevel : String?
    
    public var consentWebViewHandler: ConsentWebViewHandler?
    
    private let logger: Logger
        
    /**
     WKWebView Configuration
     */
    
    lazy var webConfig: WKWebViewConfiguration = {
        let webCfg: WKWebViewConfiguration = WKWebViewConfiguration()
        webCfg.allowsInlineMediaPlayback = true
        webCfg.requiresUserActionForMediaPlayback = false
        webCfg.preferences = WKPreferences()
        webCfg.preferences.javaScriptEnabled = true
        webCfg.userContentController.addUserScript(ConsentWebView.getJSReceiverScript())
        webCfg.userContentController.add(self, name: "JSReceiver")
        return webCfg
    }()
    
    static func getJSReceiverScript() -> WKUserScript {
        let scriptSource = try! String(contentsOfFile: Bundle(for: ConsentWebView.self).path(forResource: "JSReceiver", ofType: "js")!)
        return WKUserScript(source: scriptSource, injectionTime: .atDocumentStart, forMainFrameOnly: false)
    }
    
    override public init(frame: CGRect) {
        self.logger = Logger()
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
    
    public func loadWebContent(url: URL,showPM: Bool) {
        self.webViewCleanup()
        self.showPM = showPM
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
            let requestObj = NSURLRequest(url: url)
            wkWebView.load(requestObj as URLRequest)
        }
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
            consentWebViewHandler?.willShowMessage()
        case "onSPPMObjectReady":
            if self.showPM { consentWebViewHandler?.willShowMessage()}
        case "onPMCancel":
            logger.log("onPMCancel  event is triggered", [])
        case "onMessageChoiceSelect": // when a choice is selected
            guard let choiceId = body["choiceId"] as? Int else { fallthrough }
            consentWebViewHandler?.onMessageChoiceSelect(choiceId: choiceId)
        case "onConsentReady": // when interaction with message is complete
            let euconsent = body["euconsent"] as? String ?? ""
            let consentUUID = body["consentUUID"] as? String ?? ""
            consentWebViewHandler?.done(euconsent: euconsent, consentUUID: consentUUID)
        case "onPrivacyManagerAction":
            logger.log("onPrivacyManagerAction event is triggered", [])
            return
        case "onErrorOccurred":
//            consentDelegate?.onErrorOccurred(error: WebViewErrors[body["errorType"] as? String ?? ""] ?? PrivacyManagerUnknownError())
            consentWebViewHandler?.onErrorOccurred(error: WebViewErrors[body["errorType"] as? String ?? ""] ?? PrivacyManagerUnknownError())
        case "onMessageChoiceError":
            consentWebViewHandler?.onErrorOccurred(error: WebViewErrors[body["error"] as? String ?? ""] ?? PrivacyManagerUnknownError())
        case "xhrLog":
//            if debugLevel == .DEBUG {
//                handleXhrLog(body)
//            }
            logger.log("xhrLog event is triggered", [])
        default:
            consentWebViewHandler?.onErrorOccurred(error: PrivacyManagerUnknownMessageResponse(name: name, body: body))
        }
    }
    
     /// :nodoc:
       public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
           guard
               let messageBody = message.body as? [String: Any],
               let name = messageBody["name"] as? String
           else {
            consentWebViewHandler?.onErrorOccurred(error: PrivacyManagerUnknownMessageResponse(name: "", body: ["":""]))
               return
           }
           if let body = messageBody["body"] as? [String: Any?] {
               handleMessage(withName: name, andBody: body)
           } else {
               handleMessage(withName: name, andBody: ["":""])
           }
       }
}
