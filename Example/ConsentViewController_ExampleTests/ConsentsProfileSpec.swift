//
//  ConsentsProfileSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 11.02.21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation

import Quick
import Nimble
@testable import ConsentViewController

// swiftlint:disable force_try
class ConsentsProfileSpec: QuickSpec {
    let gdprProfile = ConsentProfile<SPGDPRConsent>(
        applies: true,
        consents: SPGDPRConsent.empty()
    )
    let ccpaProfile = ConsentProfile<SPCCPAConsent>(
        applies: true,
        consents: SPCCPAConsent.empty()
    )
    let jsonData = """
        {
            "ccpa": {
                "applies": true,
                "consents": {
                    "status": "rejectedNone",
                    "rejectedVendors": [],
                    "rejectedCategories": [],
                    "uspstring": "1---"
                }
            },
            "gdpr": {
                "applies": true,
                "consents": {
                    "grants": {},
                    "TCData": {},
                    "euconsent": ""
                }
            }
        }
    """.filter { !" \n\t\r".contains($0) }
    var consentsProfile: ConsentsProfile { ConsentsProfile(
        gdpr: gdprProfile,
        ccpa: ccpaProfile
    )}
    override func spec() {
        it("can be encoded to JSON") {
            let encoded = String(data: try! JSONEncoder()
                                    .encodeResult(self.consentsProfile).get(), encoding: .utf8)!
            expect(encoded).to(equal(self.jsonData))
        }

        it("can be decoded from JSON") {
            let decoded = try! JSONDecoder().decode(ConsentsProfile.self, from: self.jsonData.data(using: .utf8)!).get()
            expect(decoded).to(equal(self.consentsProfile))
        }
    }
}
