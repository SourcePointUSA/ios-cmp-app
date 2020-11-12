//
//  HomeViewController.swift
//  AuthExample
//
//  Created by Andre Herculano on 19.06.19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import WebKit

class HomeViewController: UIViewController {
    static func prepareWebViewConsent(_ webview: WKWebView, authId: String) -> WKWebView {
        let script = WKUserScript(source: """
            document.cookie="authId=\(authId)"
        """, injectionTime: .atDocumentStart, forMainFrameOnly: true)
        webview.configuration.userContentController.addUserScript(script)
        return webview
    }

    static var webviewUrl = URL(string: "http://localhost:8080")!

    @IBOutlet weak var webview: WKWebView!

    var authId: String!

    override func viewDidLoad() {
        webview.navigationDelegate = self
        webview = HomeViewController.prepareWebViewConsent(webview, authId: authId)
        webview.load(URLRequest(url: HomeViewController.webviewUrl))
    }
}

extension HomeViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        webview.loadHTMLString("""
            <!DOCTYPE html>
            <html lang="en">
            <head>
              <meta name="viewport" content="width=device-width, initial-scale=1.0">
            </head>
            <body>
              <code>
                Could not load the web content.
                Is the server up?
              </code>
            </body>
            </html>
        """, baseURL: nil)
    }
}
