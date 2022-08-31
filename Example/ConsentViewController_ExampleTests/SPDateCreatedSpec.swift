//
//  SPDateCreatedSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 31.08.22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation

import Quick
import Nimble
@testable import ConsentViewController

// swiftlint:disable force_try

class SPDateCreatedSpec: QuickSpec {
    override func spec() {
        func dateFromString(_ date: String) -> Date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            return formatter.date(from: date)!
        }

        describe("SPDateCreated") {
            it("should encode to string") {
                let dateString = "\"2022-08-25T20:56:38.551Z\""
                let decoded: SPDateCreated = try! JSONDecoder().decode(SPDateCreated.self, from: dateString.data(using: .utf8)!)
                let encoded = try! JSONEncoder().encode(decoded)
                let encodedString = String(data: encoded, encoding: .utf8)!
                expect(encodedString).to(equal(dateString))
            }

            it("should decode from string") {
                let dateString = "\"2022-08-25T20:56:38.551Z\""
                let decoded: SPDateCreated = try! JSONDecoder().decode(SPDateCreated.self, from: dateString.data(using: .utf8)!)
                let date = dateFromString(dateString.replacingOccurrences(of: "\"", with: ""))
                expect(decoded.date).to(equal(date))
            }
        }
    }
}
