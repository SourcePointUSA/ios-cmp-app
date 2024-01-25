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
                        window.postMessage({ // calls message ready after 5 seconds
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
            renderingAppMock(messageReadyDelayInSeconds: 7),
            baseURL: URL(string: "https://example.com")!
        )
    }
}

class RenderingAppMock: WKWebView {
    override func load(_ request: URLRequest) -> WKNavigation? {
        loadHTMLString(
            renderingAppMock(messageReadyDelayInSeconds: 2),
            baseURL: URL(string: "https://example.com")!
        )
    }

    func triggerShowOptionsAction() {
        self.evaluateJavaScript("""
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

func loadMessage(
    with RenderingAppClass: WKWebView.Type,
    delegate: SPMessageUIDelegate,
    campaignType: SPCampaignType = .unknown,
    uuid: String? = nil
) {
    let controller = GenericWebMessageViewController(
        url: URL(string: "https://example.com")!,
        messageId: "",
        contents: Data(),
        campaignType: campaignType,
        timeout: 5.0,
        delegate: delegate,
        consentUUID: uuid
    )
    controller.webview = RenderingAppClass.init(frame: .zero, configuration: controller.webviewConfig!)
    controller.loadMessage()
}

class GenericWebMessageViewControllerSpec: QuickSpec {
    var delegate = MessageUIDelegateSpy() // swiftlint:disable:this weak_delegate

    override func spec() {
        beforeEach {
            self.delegate = MessageUIDelegateSpy()
        }

        it("calls loaded when the rendering app dispatches a sp.showMessage event") {
            loadMessage(with: RenderingAppMock.self, delegate: self.delegate)
            after(.seconds(6)) {
                expect(self.delegate.loadedWasCalled).to(beTrue())
                expect(self.delegate.onErrorWasCalled).to(beFalse())
            }
        }

        it("calls onError if .loaded() is not called on the delegate before the timeout") {
            loadMessage(with: FaultyRenderingAppMock.self, delegate: self.delegate)
            after(.seconds(6)) {
                expect(self.delegate.loadedWasCalled).to(beFalse())
                expect(self.delegate.onErrorWasCalled).to(beTrue())
            }
        }

        describe("when a show options action is dispatched") {
            describe("and the campaign is gdpr") {
                it("pmURL contains consentUUID") {
                    self.delegate.onLoaded = { controller in
                        ((controller as? GenericWebMessageViewController)?.webview as? RenderingAppMock)?.triggerShowOptionsAction()
                    }
                    loadMessage(
                        with: RenderingAppMock.self,
                        delegate: self.delegate,
                        campaignType: .gdpr,
                        uuid: "abc"
                    )
                    expect(self.delegate.actionCalledWith?.pmURL)
                        .toEventually(containQueryParam("consentUUID", withValue: "abc"))
                }
            }

            describe("and the campaign is ccpa") {
                it("pmURL contains ccpaUUID") {
                    self.delegate.onLoaded = { controller in
                        ((controller as? GenericWebMessageViewController)?.webview as? RenderingAppMock)?.triggerShowOptionsAction()
                    }
                    loadMessage(
                        with: RenderingAppMock.self,
                        delegate: self.delegate,
                        campaignType: .ccpa,
                        uuid: "abc"
                    )
                    expect(self.delegate.actionCalledWith?.pmURL)
                        .toEventually(containQueryParam("ccpaUUID", withValue: "abc"))
                }
            }
        }
    }
}
