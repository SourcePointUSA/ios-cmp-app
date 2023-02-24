//
//  GDPRURLExtensions.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 09.12.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

@testable import ConsentViewController
import Foundation
import Nimble
import Quick

class SPURLExtensions: QuickSpec {
    override func spec() {
        describe("appendQueryItem") {
            it("should append a query param at the end of the URL while keeping the URL intact") {
                var url = URL(string: "https://example.com?foo=bar")
                url = url?.appendQueryItems(["a": "b", "c": "d"])
                expect(url) == URL(string: "https://example.com?foo=bar&a=b&c=d")
            }
        }
    }
}
