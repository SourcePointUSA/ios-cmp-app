//
//  GenericWebMessageViewControllerSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 10.05.23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

// swiftlint:disable force_unwrapping

import Foundation
import WebKit
import Nimble
import Quick
@testable import ConsentViewController

func renderingAppMock(messageReadyDelayInSeconds: Int) -> String {
    """
        <html>
            <header>
            <script>
                window.addEventListener("load", () => {
                    setTimeout(() => {
                        window.postMessage({ // calls message ready after X seconds
                            name: "sp.showMessage"
                        }, "*")
                    }, \(messageReadyDelayInSeconds * 1000));
                })
            </script>
            </header>
            <body></body>
        </html>
    """
}

class FaultyRenderingAppMock: WKWebView {
    override func load(_ request: URLRequest) -> WKNavigation? {
        loadHTMLString(
            renderingAppMock(messageReadyDelayInSeconds: 5),
            baseURL: URL(string: "https://example.com")!
        )
    }
}

class RenderingAppMock: WKWebView {
    override func load(_ request: URLRequest) -> WKNavigation? {
        loadHTMLString(
            renderingAppMock(messageReadyDelayInSeconds: 1),
            baseURL: URL(string: "https://example.com")!
        )
    }

    func triggerShowOptionsAction() {
        evaluateJavaScript("""
            window.postMessage({
                "name": "sp.hideMessage",
                "actions": [{
                    "type": "choice",
                    "data": {
                        "type": 12,
                        "iframe_url": "https://cdn.privacy-mgmt.com"
                    }
                }]
            }, "*")
        """)
    }
}

class DuplicatedShowMessageRenderingAppMock: WKWebView {
    override func load(_ request: URLRequest) -> WKNavigation? {
        loadHTMLString("""
            <html>
            <header>
            <script>
                window.addEventListener("load", () => {
                    setTimeout(() => {
                        window.postMessage({ name: "sp.showMessage" }, "*");
                        window.postMessage({ name: "sp.showMessage" }, "*");
                    }, 500);
                })
            </script>
            </header>
            <body></body>
            </html>
        """, baseURL: URL(string: "https://example.com")!)
    }
}

func loadMessage(
    with RenderingAppClass: WKWebView.Type,
    delegate: SPMessageUIDelegate,
    campaignType: SPCampaignType = .unknown,
    uuid: String? = nil,
    timeout: TimeInterval = 30.0
) {
    let controller = GenericWebMessageViewController(
        url: URL(string: "https://example.com")!,
        messageId: "",
        contents: Data(),
        campaignType: campaignType,
        timeout: timeout,
        delegate: delegate,
        consentUUID: uuid
    )
    controller.webview = RenderingAppClass.init(frame: .zero, configuration: controller.webviewConfig!)
    controller.loadMessage()
}

class GenericWebMessageViewControllerSpec: QuickSpec {
    override class func spec() {
        var delegate = MessageUIDelegateSpy() // swiftlint:disable:this weak_delegate

        beforeEach {
            delegate = MessageUIDelegateSpy()
        }

        it("calls loaded when the rendering app dispatches a sp.showMessage event") {
            loadMessage(with: RenderingAppMock.self, delegate: delegate)
            expect(delegate.loadedWasCalled).toEventually(beTrue(), timeout: .seconds(15))
            expect(delegate.onErrorWasCalled).to(beFalse())
        }

        it("calls onError if .loaded() is not called on the delegate before the timeout") {
            loadMessage(with: FaultyRenderingAppMock.self, delegate: delegate, timeout: 2.0)
            expect(delegate.onErrorWasCalled).toEventually(beTrue(), timeout: .seconds(10))
            expect(delegate.loadedWasCalled).to(beFalse())
        }

        describe("when a show options action is dispatched") {
            describe("and the campaign is gdpr") {
                it("pmURL contains consentUUID") {
                    delegate.onLoaded = { controller in
                        ((controller as? GenericWebMessageViewController)?.webview as? RenderingAppMock)?.triggerShowOptionsAction()
                    }
                    loadMessage(
                        with: RenderingAppMock.self,
                        delegate: delegate,
                        campaignType: .gdpr,
                        uuid: "abc"
                    )
                    expect(delegate.actionCalledWith?.pmURL)
                        .toEventually(containQueryParam("consentUUID", withValue: "abc"), timeout: .seconds(15))
                }
            }

            describe("and the campaign is ccpa") {
                it("pmURL contains ccpaUUID") {
                    delegate.onLoaded = { controller in
                        ((controller as? GenericWebMessageViewController)?.webview as? RenderingAppMock)?.triggerShowOptionsAction()
                    }
                    loadMessage(
                        with: RenderingAppMock.self,
                        delegate: delegate,
                        campaignType: .ccpa,
                        uuid: "abc"
                    )
                    expect(delegate.actionCalledWith?.pmURL)
                        .toEventually(containQueryParam("ccpaUUID", withValue: "abc"), timeout: .seconds(15))
                }
            }
        }

        describe("when rendering app dispatches sp.showMessage multiple times") {
            it("calls onMessageReady only once") {
                loadMessage(with: DuplicatedShowMessageRenderingAppMock.self, delegate: delegate)
                expect(delegate.loadedCallCount).toEventually(equal(1), timeout: .seconds(10))
            }
        }
    }
}
