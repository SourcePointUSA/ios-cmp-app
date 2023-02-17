//
//  CCPAConsentStatusSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 24.01.23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

@testable import ConsentViewController
import Foundation
import Nimble
import Quick

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

        statusMapping.keys.forEach { statusString in
            let statusEnum = statusMapping[statusString]
            it("\(statusString) should decode to \(statusEnum!))") {
                expect("\"\(statusString)\"").to(decodeToValue(statusEnum))
            }
        }

        statusMapping.values.forEach { enumStatus in
            let enumString = statusMapping.first { $0.value == enumStatus }?.key ?? ""

            it("\(enumStatus) should decode to \(enumString))") {
                expect(enumStatus).to(encodeToValue("\"\(enumString)\""))
            }
        }

        it("unknown values should decode to .Unknown") {
            expect("\"foo\"").to(decodeToValue(CCPAConsentStatus.Unknown))
        }
    }
}
