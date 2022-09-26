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
    let authIdToInject: String?
    let onLoad: (_ webView: WKWebView) -> Void

    init(authIdToInject: String? = nil, onLoad: @escaping (_ webView: WKWebView) -> Void = { _ in }) {
        self.authIdToInject = authIdToInject
        self.onLoad = onLoad
        super.init(frame: CGRect(), configuration: WKWebViewConfiguration())
        self.navigationDelegate = self
        if let authIdToInject = authIdToInject {
            configuration.userContentController.addUserScript(WKUserScript(
                source: "document.cookie='authId=\(authIdToInject)'",
                injectionTime: .atDocumentStart,
                forMainFrameOnly: true
            ))
        }
        loadHTMLString("", baseURL: URL(string: "https://sourcepoint.com")!)
    }

    required init?(coder: NSCoder) { fatalError("not implemented") }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        onLoad(webView)
    }
}

class GDPRWebViewExtensionsSpec: QuickSpec {
    var webView = TestWebView()

    func resetAuthIdCookie() {
        self.webView.evaluateJavaScript("document.cookie='authId='")
    }

    override func spec() {
        beforeSuite {
            // changing AsyncDefaults make the test suite pass in CI due to slow CI environment
            AsyncDefaults.timeout = .seconds(10)
            AsyncDefaults.pollInterval = .seconds(10)
        }

        afterSuite {
            // changing AsyncDefaults back to defaults after suite is done
            AsyncDefaults.timeout = .seconds(1)
            AsyncDefaults.pollInterval = .milliseconds(10)
        }

        beforeEach {
            self.resetAuthIdCookie()
        }

        describe("getAuthID") {
            it("should get the authId cookie from the webview") {
                waitUntil { done in
                    self.webView = TestWebView(authIdToInject: "foo") { $0.getAuthId { authId, error in
                        expect(authId).to(equal("foo"), description: error.debugDescription)
                        done()
                    }}
                }
            }

            context("when there are no cookies") {
                it("returns empty string") {
                    waitUntil { done in
                        self.webView = TestWebView {
                            $0.getAuthId { authId, error in
                                expect(authId).to(beEmpty(), description: error.debugDescription)
                                done()
                            }}
                    }
                }
            }

            context("when authId cookie is empty") {
                it("returns empty string") {
                    waitUntil { done in
                        self.webView = TestWebView(authIdToInject: "") {
                            $0.getAuthId { authId, error in
                                expect(authId).to(beEmpty(), description: error.debugDescription)
                                done()
                            }}
                    }
                }
            }
        }

        describe("setAuthId") {
            it("should add the content of setAuthId.js as userContentScript") {
                waitUntil { done in
                    self.webView = TestWebView { $0.getAuthId { authId, error in
                        expect(authId).to(equal("another foo"), description: error.debugDescription)
                        done()
                    }}
                    self.webView.setConsentFor(authId: "another foo")
                }
            }
        }
    }
}
