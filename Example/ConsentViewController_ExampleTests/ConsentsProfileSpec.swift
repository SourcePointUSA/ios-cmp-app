//
//  ConsentsProfileSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 11.02.21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation

@testable import ConsentViewController
import Nimble
import Quick

class ConsentsProfileSpec: QuickSpec {
    let ccpaConsents = """
        {
            "applies": true,
            "consents": {
                "status": "rejectedNone",
                "rejectedVendors": [],
                "rejectedCategories": [],
                "uspstring": "1---",
                "consentStatus": {},
                "signedLspa": false
            }
        }
    """

    let gdprConsents = """
        {
            "applies": true,
            "consents": {
                "grants": {},
                "TCData": {},
                "euconsent": "",
                "consentStatus": {}
            }
        }
    """

    override func spec() {
        describe("SPConsents") {
            describe("GDPR") {
                it("can be decode from JSON") {
                    expect(self.gdprConsents).to(decodeToValue(
                        SPConsent<SPGDPRConsent>(consents: .empty(), applies: true)
                    ))
                }
            }

            describe("CCPA") {
                it("can be decode from JSON") {
                    expect(self.ccpaConsents).to(decodeToValue(
                        SPConsent<SPCCPAConsent>(consents: .empty(), applies: true)
                    ))
                }
            }
        }
    }
}
