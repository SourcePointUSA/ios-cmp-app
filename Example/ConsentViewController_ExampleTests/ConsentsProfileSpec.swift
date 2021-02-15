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
        uuid: "gdpr-uuid",
        applies: true,
        meta: "{}",
        consents: SPGDPRConsent.empty()
    )
    let ccpaProfile = ConsentProfile<SPCCPAConsent>(
        uuid: "ccpa-uuid",
        applies: true,
        meta: "{}",
        consents: SPCCPAConsent.empty()
    )
    let jsonData = """
        {
            "ccpa": {
                "applies": true,
                "meta": "{}",
                "consents": {
                    "status": "rejectedNone",
                    "rejectedVendors": [],
                    "rejectedCategories": [],
                    "uspstring": "1---"
                },
                "uuid": "ccpa-uuid"
            },
            "gdpr": {
                "applies": true,
                "meta": "{}",
                "consents": {
                    "grants": {},
                    "TCData": {},
                    "acceptedVendors": [],
                    "legIntCategories": [],
                    "acceptedCategories": [],
                    "specialFeatures": [],
                    "euconsent": ""
                },
                "uuid": "gdpr-uuid"
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
                                    .encode(self.consentsProfile).get(), encoding: .utf8)!
            expect(encoded).to(equal(self.jsonData))
        }

        it("can be decoded from JSON") {
            let decoded = try! JSONDecoder().decode(ConsentsProfile.self, from: self.jsonData.data(using: .utf8)!).get()
            expect(decoded).to(equal(self.consentsProfile))
        }
    }
}
