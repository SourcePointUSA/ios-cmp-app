//
//  WebViewExtensions.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 13.11.20.
//

import Foundation
import WebKit

@objc public extension WKWebView {
    /// Injects Sourcepoint's user data into the webview.
    /// This method is used in cases when your app has a web-based portion that also needs consent information. Make sure to check the discussion below.
    ///
    /// There are a few things to notice:
    /// * the web page should countain Sourcepoint's web script in it
    /// * you should append query param `_sp_pass_consent=true` to your page (so the our web script knows it should wait for consent data)
    /// * you need to call `preloadConsent` only _after_ the url been loaded into the webview (ie. after `.load(URLRequest)`)
    func preloadConsent(from consents: SPUserData) {
        let readyEventName = "sp.readyForConsent"
        let preloadEventName = "sp.loadConsent"
        if let consentsData = try? JSONEncoder().encode(consents.webConsents),
           let consents = String(data: consentsData, encoding: .utf8) {
            configuration.userContentController.addUserScript(WKUserScript(source: """
                window.postMessage({
                    name: "\(preloadEventName)",
                    consent: \(consents)
                }, "*")
                window.addEventListener('message', (event) => {
                    if(event && event.data && event.data.name === "\(readyEventName)") {
                        window.postMessage({
                            name: "\(preloadEventName)",
                            consent: \(consents)
                        }, "*")
                    }
                })
                """,
                injectionTime: .atDocumentStart,
                forMainFrameOnly: true
            ))
            evaluateJavaScript("""
                window.postMessage({
                    name: "\(preloadEventName)",
                    consent: \(consents)
                }, "*")
                window.addEventListener('message', (event) => {
                    if(event && event.data && event.data.name === "\(readyEventName)") {
                        window.postMessage({
                            name: "\(preloadEventName)",
                            consent: \(consents)
                        }, "*")
                    }
                })
            """)
        }
    }
}
