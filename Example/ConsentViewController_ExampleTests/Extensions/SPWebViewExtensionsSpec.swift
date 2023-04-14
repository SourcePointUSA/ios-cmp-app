//
//  GDPRWebViewExtensions.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 13.11.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

@testable import ConsentViewController
import Foundation
import Nimble
import Quick
import WebKit

class TestWebView: WKWebView, WKNavigationDelegate {
    let onLoad: (_ webView: WKWebView) -> Void

    init(onLoad: @escaping (_ webView: WKWebView) -> Void = { _ in }) {
        self.onLoad = onLoad
        super.init(frame: CGRect(), configuration: WKWebViewConfiguration())
        self.navigationDelegate = self
        // swiftlint:disable:next force_unwrapping
        loadHTMLString("", baseURL: URL(string: "https://sourcepoint.com")!)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("not implemented") }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        onLoad(webView)
    }
}

class SPWebViewExtensionsSpec: QuickSpec {
    var webView = TestWebView()

    override func spec() {
        beforeSuite {
            // changing AsyncDefaults make the test suite pass in CI due to slow CI environment
            AsyncDefaults.timeout = .seconds(10)
            AsyncDefaults.pollInterval = .milliseconds(100)
        }

        afterSuite {
            // changing AsyncDefaults back to defaults after suite is done
            AsyncDefaults.timeout = .seconds(1)
            AsyncDefaults.pollInterval = .milliseconds(10)
        }

        describe("setAuthId") {
            it("should add the content of setAuthId.js as userContentScript") {
                fail("not implemented")
                self.webView.preloadConsent(from: SPUserData())
            }
        }
    }
}
