//
//  WebViewExtensions.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 13.11.20.
//

import Foundation
import WebKit

@objc public extension WKWebView {
    /// Reads the value of the cookie authId
    func getAuthId(handler: @escaping (_ authId: String?, _ error: Error?) -> Void) {
        getCookie("authId", handler)
    }

    /// Injects the cookie `authId` in the webview before loading its content.
    /// SourcePoint's web SDK reads the `authId` cookie and set everything up in the webview context.
    func setConsentFor(authId: String) {
        setCookie("authId", authId)
    }

    /// Injects the cookie `authId` in the webview before loading its content.
    /// SourcePoint's web SDK reads the `authId` cookie and set everything up in the webview context.
    func setCookie(_ name: String, _ value: String) {
        configuration.userContentController.addUserScript(WKUserScript(
            source: "document.cookie='\(name)=\(value)'",
            injectionTime: .atDocumentStart,
            forMainFrameOnly: true
        ))
    }

    private func getCookiesString(_ handler: @escaping (_ cookies: String?, _ error: Error?) -> Void) {
        evaluateJavaScript("document.cookie") { result, error in
            if error == nil, let cookies = result as? String {
                handler(cookies, nil)
            } else {
                handler(nil, error)
            }
        }
    }

    func getCookies(_ handler: @escaping (_ cookies: [String: String], _ error: Error?) -> Void) {
        getCookiesString { cookies, error in
            if let cookies = cookies, !cookies.isEmpty {
                handler(cookies
                    .components(separatedBy: "; ")
                    .compactMap { $0.components(separatedBy: "=") }
                    .reduce(into: [String: String]()) { (all, pair) in
                        all[pair[0]] = pair[1]
                    }, nil)
            } else {
                handler([:], error)
            }
        }
    }

    private func getCookie(_ name: String, _ handler: @escaping (_ authId: String?, _ error: Error?) -> Void) {
        getCookies { handler($0[name, default: ""], $1) }
    }
}
