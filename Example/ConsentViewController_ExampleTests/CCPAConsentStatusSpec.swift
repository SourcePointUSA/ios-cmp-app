//
//  CCPAConsentStatusSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 24.01.23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import ConsentViewController

// swiftlint:disable colon

class CCPAConsentStatusSpec: QuickSpec {
    override func spec() {
        let statusMapping: [String: CCPAConsentStatus] = [
            "consentedAll"  : .ConsentedAll,
            "rejectedAll"   : .RejectedAll,
            "rejectedSome"  : .RejectedSome,
            "rejectedNone"  : .RejectedNone,
            "linkedNoAction": .LinkedNoAction,
            "unknown"       : .Unknown
        ]

        statusMapping.keys.forEach { rawConsentStatus in
            let statusEnum = statusMapping[rawConsentStatus]

            it("\(rawConsentStatus) should decode to \(String(describing: statusEnum))") {
                let decoded = try? JSONDecoder().decode(CCPAConsentStatus.self, from: "\"\(rawConsentStatus)\"".data(using: .utf8)!).get()
                expect(decoded).to(equal(statusEnum))
            }
        }

        statusMapping.values.forEach { enumStatus in
            let rawValueExpected = "\"\(statusMapping.first { $0.value == enumStatus }?.key ?? "")\""

            it("\(enumStatus) should decode to \(String(describing: rawValueExpected))") {
                let encoded = try? JSONEncoder().encode(enumStatus)
                expect(encoded).to(equal(rawValueExpected.data(using: .utf8)))
            }
        }

        it("unknown values should decode to .Unknown") {
            let decoded = try? JSONDecoder().decode(CCPAConsentStatus.self,
                from: "\"foo\"".data(using: .utf8)!).get()
            expect(decoded).to(equal(.Unknown))
        }
    }
}
