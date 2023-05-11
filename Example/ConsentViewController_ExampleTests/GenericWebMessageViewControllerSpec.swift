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

class UIDelegateMock: SPMessageUIDelegate {
    var loadedWasCalled = false
    var onErrorWasCalled = false

    func loaded(_ controller: UIViewController) {
        loadedWasCalled = true
    }

    func action(_ action: ConsentViewController.SPAction, from controller: UIViewController) {}

    func onError(_ error: ConsentViewController.SPError) {
        onErrorWasCalled = true
    }

    func finished(_ vcFinished: UIViewController) {}
}

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
            renderingAppMock(messageReadyDelayInSeconds: 3),
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
}

func loadMessage(withRenderingApp RenderingAppClass: WKWebView.Type) -> UIDelegateMock {
    let delegate = UIDelegateMock()
    let controller = GenericWebMessageViewController(
        url: URL(string: "https://example.com")!,
        messageId: "",
        contents: Data(),
        campaignType: .unknown,
        timeout: 2.0,
        delegate: delegate
    )
    controller.webview = RenderingAppClass.init(frame: .zero, configuration: controller.webviewConfig!)
    controller.loadMessage()
    return delegate
}

class GenericWebMessageViewControllerSpec: QuickSpec {
    override func spec() {
        it("calls loaded when the rendering app dispatches a sp.showMessage event") {
            let delegate = loadMessage(withRenderingApp: RenderingAppMock.self)
            waitUntil { done in
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
                    expect(delegate.loadedWasCalled).to(beTrue())
                    expect(delegate.onErrorWasCalled).to(beFalse())
                    done()
                }
            }
        }

        it("calls onError if .loaded() is not called on the delegate before the timeout") {
            let delegate = loadMessage(withRenderingApp: FaultyRenderingAppMock.self)
            waitUntil { done in
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
                    expect(delegate.loadedWasCalled).to(beFalse())
                    expect(delegate.onErrorWasCalled).to(beTrue())
                    done()
                }
            }
        }
    }
}
