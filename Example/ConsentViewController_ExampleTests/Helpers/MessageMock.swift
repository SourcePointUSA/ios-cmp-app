//
//  WebViewMock.swift
//  ConsentViewController_ExampleTests
//
//  Created by Vilas on 26/06/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import WebKit
@testable import ConsentViewController

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
            return _body
        }
        set {
            _body = newValue
        }
    }

    init(_ body: Any) {
        self._body = body
    }
}
