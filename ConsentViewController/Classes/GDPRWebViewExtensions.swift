//
//  WebViewExtensions.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 13.11.20.
//

import Foundation
import WebKit

@objc public extension WKWebView {
    /// Injects the cookie `authId` in the webview before loading its content.
    /// SourcePoint's web SDK reads the `authId` cookie and set everything up in the webview context.
    func setConsentFor(authId: String) {
        configuration.userContentController.addUserScript(WKUserScript(
            source: "document.cookie='authId=\(authId);'",
            injectionTime: .atDocumentStart,
            forMainFrameOnly: true
        ))
    }

    /// Reads the value of the cookie authId
    func getAuthId(completionHandler: @escaping (_ authId: String?, _ error: Error?) -> Void) {
        let getAuthIdScript = """
            document.cookie
                .split("; ")
                .filter(c => c.startsWith('authId='))
                .map(c => c.replace('authId=', ''))[0]
        """
        evaluateJavaScript(getAuthIdScript) { result, error in
            if error == nil, let authId = result as? String {
                completionHandler(authId, nil)
            } else {
                completionHandler(nil, error)
            }
        }
    }
}
