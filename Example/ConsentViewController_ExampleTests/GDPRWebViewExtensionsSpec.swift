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

class LoadedNotifier: NSObject, WKNavigationDelegate {
    let onLoaded: () -> Void

    init(_ handler: @escaping () -> Void) {
        onLoaded = handler
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        onLoaded()
    }
}

class GDPRWebViewExtensionsSpec: QuickSpec {
    override func spec() {
        describe("getAuthID") {
            it("should evaluate the content of getAuthId.js script") {
                let webview = WKWebView()
                var authId: String?
                let loadedNotifier = LoadedNotifier {
                    webview.getAuthId { result, _ in authId = result }
                }

                webview.navigationDelegate = loadedNotifier
                webview.configuration.userContentController.addUserScript(
                    WKUserScript(source: "document.cookie='authId=foo;'", injectionTime: .atDocumentStart, forMainFrameOnly: true))
                webview.loadHTMLString("", baseURL: URL(string: "https://sourcepoint.com")!)

                expect(authId).toEventually(equal("foo"))
            }
        }

        describe("setAuthId") {
            it("should add the content of setAuthId.js as userContentScript") {
                let webview = WKWebView()
                webview.setConsentFor(authId: "foo")
                expect(webview.configuration.userContentController.userScripts[0].source).to(equal("document.cookie='authId=foo;'"))
            }
        }
    }
}
