//
//  HomeViewController.swift
//  AuthExample
//
//  Created by Andre Herculano on 19.06.19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import WebKit
import ConsentViewController

class HomeViewController: UIViewController {
    static let webviewUrl = URL(string: "http://localhost:8080/")!
    static let notFoundHtml = Bundle.main.path(forResource: "webserver/404", ofType: "html")!

    @IBOutlet weak var webview: WKWebView!

    var authId: String!

    override func viewDidLoad() {
        webview.setConsentFor(authId: authId)
        webview.navigationDelegate = self
        webview.load(URLRequest(url: HomeViewController.webviewUrl))
    }
}

extension HomeViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        webview.loadHTMLString(try! String(contentsOfFile: HomeViewController.notFoundHtml), baseURL: nil)
    }

    /// Get the value of authId cookie from the document
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.getAuthId { authId, error in
            error != nil ?
                print(error.debugDescription) :
                print("AuthId:", authId ?? "No AuthId")
        }
    }
}
