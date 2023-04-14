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

    var userData: SPUserData!

    override func viewDidLoad() {
        webview.cleanCache()
        webview.navigationDelegate = self
        webview.load(URLRequest(url: HomeViewController.webviewUrl))
        webview.preloadConsent(from: userData)
    }
}

extension HomeViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        webview.loadHTMLString(try! String(contentsOfFile: HomeViewController.notFoundHtml), baseURL: nil)
    }
}

extension WKWebView {
    func cleanCache() {
        WKWebsiteDataStore.default().removeData(ofTypes: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache], modifiedSince: Date(timeIntervalSince1970: 0)) {}
    }
}
