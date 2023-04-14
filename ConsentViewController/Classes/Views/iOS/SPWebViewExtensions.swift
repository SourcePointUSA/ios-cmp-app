//
//  WebViewExtensions.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 13.11.20.
//

import Foundation
import WebKit

@objc public extension WKWebView {
    /// Injects the
    func preloadConsent(from consents: SPUserData) {
        let readyEventName = "sp.readyForConsent"
        let preloadEventName = "sp.loadConsent"
        if let consentsData = try? JSONEncoder().encode(consents.webConsents),
           let consents = String(data: consentsData, encoding: .utf8) {
            configuration.userContentController.addUserScript(WKUserScript(
                source: """
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
