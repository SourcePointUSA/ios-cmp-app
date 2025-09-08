//
//  WebViewExtensions.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 13.11.20.
//
// swiftlint:disable line_length

import Foundation
import WebKit

@objc public extension WKWebView {
    struct PreloadConsentsPayload: Encodable {
        let name = "sp.loadConsent"
        let consent: SPWebConsents
    }

    private func preloadScript(
        with payload: String,
        readyEventName: String = "sp.readyForConsent"
    ) -> String {
        """
        window.postMessage(\(payload), "*")
        window.addEventListener('message', (event) => {
            if(event && event.data && event.data.name === "\(readyEventName)") {
                window.postMessage(\(payload), "*")
            }
        })
        """
    }

    func setFontScale(_ scale: Float) {
        evaluateJavaScript("document.documentElement.style.setProperty('--font-scale', \(scale))")
    }

    /// Injects Sourcepoint's user data into the webview.
    /// This method is used in cases when your app has a web-based portion that also needs consent information. Make sure to check the discussion below.
    ///
    /// There are a few things to notice:
    /// * the web page should countain Sourcepoint's web script in it
    /// * you should append query param `_sp_pass_consent=true` to your page (so the our web script knows it should wait for consent data)
    /// * you need to call `preloadConsent` only _after_ the url been loaded into the webview (ie. after `.load(URLRequest)`)
    func preloadConsent(from consents: SPUserData) {
        guard
            let consentsData = try? JSONEncoder().encode(
                PreloadConsentsPayload(consent: consents.webConsents)
            ),
            let payload = String(data: consentsData, encoding: .utf8) else {
            return
        }

        configuration.userContentController.addUserScript(WKUserScript(
            source: preloadScript(with: payload),
            injectionTime: .atDocumentStart,
            forMainFrameOnly: true
        ))
        evaluateJavaScript(preloadScript(with: payload))
    }

    // MARK: Deprecated
    /// Reads the value of the cookie authId
    @available(*, deprecated, message: "This method relies on a legacy way of sharing consent with the webview and will not work on newer versions. You should use preloadConsent(from: SPUserData) instead.")
    func getAuthId(handler: @escaping (_ authId: String?, _ error: Error?) -> Void) {
        getCookie("authId", handler)
    }

    /// Injects the cookie `authId` in the webview before loading its content.
    /// SourcePoint's web SDK reads the `authId` cookie and set everything up in the webview context.
    @available(*, deprecated, message: "This method relies on a legacy way of sharing consent with the webview and will not work on newer versions. You should use preloadConsent(from: SPUserData) instead.")
    func setConsentFor(authId: String) {
        setCookie("authId", authId)
    }

    /// Injects the cookie `authId` in the webview before loading its content.
    /// SourcePoint's web SDK reads the `authId` cookie and set everything up in the webview context.
    private func setCookie(_ name: String, _ value: String) {
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

    private func getCookies(_ handler: @escaping (_ cookies: [String: String], _ error: Error?) -> Void) {
        getCookiesString { cookies, error in
            if let cookies = cookies, !cookies.isEmpty {
                handler(cookies
                    .components(separatedBy: "; ")
                    .compactMap { $0.components(separatedBy: "=") }
                    .reduce(into: [String: String]()) { all, pair in
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

// swiftlint:enable line_length
