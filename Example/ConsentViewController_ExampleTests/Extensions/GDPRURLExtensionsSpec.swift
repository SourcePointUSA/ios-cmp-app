//
//  GDPRURLExtensions.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 09.12.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import ConsentViewController

class GDPRURLExtensionsSpec: QuickSpec {
    override func spec() {
        describe("appendQueryItem") {
            it("should append a query param at the end of the URL while keeping the URL intact") {
                var url = URL(string: "https://example.com?foo=bar")
                url = url?.appendQueryItem(["a": "b", "c": "d"])
                expect(url).to(equal(URL(string: "https://example.com?foo=bar&a=b&c=d")))
            }
        }
    }
}
