//
//  ConsentLib.swift
//  cmp-app-test-app
//
//  Created by Dmitri Rabinowitz on 8/20/18.
//  Copyright © 2018 Sourcepoint. All rights reserved.
//

import UIKit
import WebKit
class ConsentLib: WKUIDelegate, WKNavigationDelegate {
    
    var webView: WKWebView!
    override func loadView() {
        NSLog("Loading view")
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                print("\(cookie)")
            }
        }
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string: "https://pm.cmp.sp-stage.net/?privacy_manager_id=5b5b2cb90224020031755a12&site_id=674&consent_origin=https%3A%2F%2Fcmp.sp-stage.net&debug_level=DEBUG&in_app=true")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let host = navigationAction.request.url?.host {
            if host.contains("pm.cmp.sp-stage.net") {
                decisionHandler(.allow)
                return
            }
        }
        
        let maybeUrlAsString = navigationAction.request.url?.absoluteString;
        
        if maybeUrlAsString != nil {
            let urlAsString = maybeUrlAsString!;
            do {
                let regex = try NSRegularExpression(pattern: "consent://(.*)/consentUUID/(.*)")
                let results = regex.matches(in: urlAsString, range: NSRange(urlAsString.startIndex..., in: urlAsString))
                
                let euconsent = String(urlAsString[Range(results[0].range(at: 1), in: urlAsString)!])
                let consentUUID = String(urlAsString[Range(results[0].range(at: 2), in: urlAsString)!])
                let euconsentCookie = HTTPCookie(properties: [
                    HTTPCookiePropertyKey.domain: "cmp.sp-stage.net",
                    HTTPCookiePropertyKey.name: "euconsent",
                    HTTPCookiePropertyKey.value: euconsent,
                    HTTPCookiePropertyKey.path: "/",
                    HTTPCookiePropertyKey.secure: "TRUE",
                    HTTPCookiePropertyKey.expires: NSDate(timeIntervalSinceNow: TimeInterval(60 * 60 * 24 * 365)),
                    ])!
                let consentUUIDCookie = HTTPCookie(properties: [
                    HTTPCookiePropertyKey.domain: "cmp.sp-stage.net",
                    HTTPCookiePropertyKey.name: "consentUUID",
                    HTTPCookiePropertyKey.value: consentUUID,
                    HTTPCookiePropertyKey.path: "/",
                    HTTPCookiePropertyKey.secure: "TRUE",
                    HTTPCookiePropertyKey.expires: NSDate(timeIntervalSinceNow: TimeInterval(60 * 60 * 24 * 365)),
                    ])!
                HTTPCookieStorage.shared.setCookie(euconsentCookie)
                HTTPCookieStorage.shared.setCookie(consentUUIDCookie)
                if let cookies = HTTPCookieStorage.shared.cookies {
                    for cookie in cookies {
                        print("\(cookie)")
                    }
                }
            } catch let error {
                print(error)
            }
        }
        
        decisionHandler(.cancel)
    }
}
