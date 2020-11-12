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
    /// Injects the cookie `authId` in the webview before loading its content.
    /// SourcePoint's web SDK reads the `authId` cookie and set everything up in the webview context.
    static func prepareWebViewConsent(_ webview: WKWebView, authId: String) {
        webview.configuration.userContentController.addUserScript(WKUserScript(
            source: "document.cookie=\"authId=\(authId);\"",
            injectionTime: .atDocumentStart,
            forMainFrameOnly: true
        ))
    }

    static let webviewUrl = URL(string: "http://localhost:8080/")!
    static let notFoundHtml = Bundle.main.path(forResource: "webserver/404", ofType: "html")!

    @IBOutlet weak var webview: WKWebView!

    var authId: String!

    override func viewDidLoad() {
        HomeViewController.prepareWebViewConsent(webview, authId: authId)
        webview.navigationDelegate = self
        webview.load(URLRequest(url: HomeViewController.webviewUrl))
    }
}

extension HomeViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        webview.loadHTMLString(try! String(contentsOfFile: HomeViewController.notFoundHtml), baseURL: nil)
    }
}
