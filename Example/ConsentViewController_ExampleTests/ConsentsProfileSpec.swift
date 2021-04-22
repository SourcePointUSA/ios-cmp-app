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
    let gdprProfile = SPConsent<SPGDPRConsent>(
        consents: SPGDPRConsent.empty(),
        applies: true
    )
    let ccpaProfile = SPConsent<SPCCPAConsent>(
        consents: SPCCPAConsent.empty(),
        applies: true
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
    var consentsProfile: SPUserData { SPUserData(
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
            let decoded = try! JSONDecoder().decode(SPUserData.self, from: self.jsonData.data(using: .utf8)!).get()
            expect(decoded).to(equal(self.consentsProfile))
        }
    }
}
