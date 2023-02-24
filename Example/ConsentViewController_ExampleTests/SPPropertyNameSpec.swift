//
//  SPPropertyNameSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Wombat MBP 17 on 26.01.2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation

@testable import ConsentViewController
import Nimble
import Quick

// swiftlint:disable force_try
class SPPropertyNameSpec: QuickSpec {
    override func spec() {
        it("http:// in property are not affected") {
            let property = "http://any"
            let spProperty = try! SPPropertyName(property)
            expect(spProperty.rawValue) == property
        }

        it("https:// in property are not affected") {
            let property = "https://any"
            let spProperty = try! SPPropertyName(property)
            expect(spProperty.rawValue) == property
        }

        it("https:// prefix is added to property name if not present") {
            let property = "any"
            let spProperty = try! SPPropertyName(property)
            expect(spProperty.rawValue) == "https://any"
        }
    }
}
