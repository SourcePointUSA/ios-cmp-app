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
            renderingAppMock(messageReadyDelayInSeconds: 4),
            baseURL: URL(string: "https://example.com")!
        )
    }
}

class RenderingAppMock: WKWebView {
    override func load(_ request: URLRequest) -> WKNavigation? {
        loadHTMLString(
            renderingAppMock(messageReadyDelayInSeconds: 0),
            baseURL: URL(string: "https://example.com")!
        )
    }
}

func loadMessage(with RenderingAppClass: WKWebView.Type) -> MessageUIDelegate {
    let delegate = MessageUIDelegate()
    let controller = GenericWebMessageViewController(
        url: URL(string: "https://example.com")!,
        messageId: "",
        contents: Data(),
        campaignType: .unknown,
        timeout: 3.0,
        delegate: delegate
    )
    controller.webview = RenderingAppClass.init(frame: .zero, configuration: controller.webviewConfig!)
    controller.loadMessage()
    return delegate
}

class GenericWebMessageViewControllerSpec: QuickSpec {
    override func spec() {
        it("calls loaded when the rendering app dispatches a sp.showMessage event") {
            let delegate = loadMessage(with: RenderingAppMock.self)
            after(.seconds(120)) {
                expect(delegate.loadedWasCalled).to(beTrue())
                expect(delegate.onErrorWasCalled).to(beFalse())
            }
        }

        it("calls onError if .loaded() is not called on the delegate before the timeout") {
            let delegate = loadMessage(with: FaultyRenderingAppMock.self)
            after(.seconds(120)) {
                expect(delegate.loadedWasCalled).to(beFalse())
                expect(delegate.onErrorWasCalled).to(beTrue())
            }
        }
    }
}
