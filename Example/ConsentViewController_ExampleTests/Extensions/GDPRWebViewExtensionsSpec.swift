//
//  GDPRWebViewExtensions.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 13.11.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
import WebKit
@testable import ConsentViewController

class TestWebView: WKWebView, WKNavigationDelegate {
    var onLoaded = {}

    init() {
        super.init(frame: CGRect(), configuration: WKWebViewConfiguration())
        navigationDelegate = self
    }

    required init?(coder: NSCoder) { super.init(coder: coder) }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        onLoaded()
    }
}

class GDPRWebViewExtensionsSpec: QuickSpec {
    override func spec() {
        beforeSuite {
            // changing AsyncDefaults make the test suite pass in CI due to slow CI environment
            AsyncDefaults.timeout = .seconds(5)
            AsyncDefaults.pollInterval = .seconds(1)
        }

        describe("getAuthID") {
            it("should evaluate the content of getAuthId.js script") {
                let webview = TestWebView()
                var authId: String?
                webview.configuration.userContentController.addUserScript(
                    WKUserScript(
                        source: "document.cookie='authId=foo;'",
                        injectionTime: .atDocumentStart,
                        forMainFrameOnly: true
                ))
                webview.onLoaded = {
                    webview.getAuthId { result, _ in authId = result }
                }
                webview.loadHTMLString("", baseURL: URL(string: "https://sourcepoint.com")!)
                expect(authId).toEventually(equal("foo"))
            }
        }

        describe("setAuthId") {
            beforeSuite {
                AsyncDefaults.timeout = .seconds(5)
            }

            it("should add the content of setAuthId.js as userContentScript") {
                let webview = TestWebView()
                var cookies: String?
                webview.setConsentFor(authId: "foo")
                webview.onLoaded = {
                    webview.evaluateJavaScript("document.cookie") { result, _ in
                        cookies = result as? String
                    }
                }
                webview.loadHTMLString("", baseURL: URL(string: "https://sourcepoint.com")!)
                expect(cookies).toEventually(equal("authId=foo"))
            }
        }
    }
}
