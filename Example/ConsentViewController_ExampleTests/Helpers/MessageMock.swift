//
//  WebViewMock.swift
//  ConsentViewController_ExampleTests
//
//  Created by Vilas on 26/06/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

@testable import ConsentViewController
import Foundation
import WebKit

class WebViewMock: WKWebView {
    var loadCalledWith: URLRequest!

    override func load(_ request: URLRequest) -> WKNavigation? {
        loadCalledWith = request
        return nil
    }
}

class MessageMock: WKScriptMessage {
    var _body: Any
    override var body: Any {
        get {
            _body
        }
        set {
            _body = newValue
        }
    }

    init(_ body: Any) {
        self._body = body
    }
}
