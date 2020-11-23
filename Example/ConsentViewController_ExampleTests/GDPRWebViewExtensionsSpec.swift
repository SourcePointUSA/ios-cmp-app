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

class WKWebViewSpy: WKWebView {
    var evaluatedJsString: String?
    override func evaluateJavaScript(_ javaScriptString: String, completionHandler: ((Any?, Error?) -> Void)? = nil) {
        super.evaluateJavaScript(javaScriptString, completionHandler: completionHandler)
        evaluatedJsString = javaScriptString
    }
}

func getScript(_ name: String) -> String? {
    return try? String(contentsOfFile: Bundle.framework.path(forResource: name, ofType: "js")!)
}

class GDPRWebViewExtensionsSpec: QuickSpec {
    override func spec() {
        describe("getAuthID") {
            it("should evaluate the content of getAuthId.js script") {
                let webview = WKWebViewSpy()
                webview.getAuthId { (_, _) in }
                expect(webview.evaluatedJsString).to(equal(getScript("getAuthId")))
            }
        }

        describe("setAuthId") {
            it("should add the content of setAuthId.js as userContentScript") {
                let webview = WKWebView()
                webview.setConsentFor(authId: "foo")
                expect(webview.configuration.userContentController.userScripts[0].source).to(equal(getScript("setAuthId")))
            }
        }
    }
}
