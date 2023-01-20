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

class ConsentsProfileSpec: QuickSpec {
    let ccpaConsents = """
        {
            "applies": true,
            "consents": {
                "status": "rejectedNone",
                "rejectedVendors": [],
                "rejectedCategories": [],
                "uspstring": "1---",
                "consentStatus": {}
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
                    expect(self.gdprConsents).to(decodeTo(SPConsent<SPGDPRConsent>.self))
                }
            }

            describe("CCPA") {
                it("can be decode from JSON") {
                    expect(self.ccpaConsents).to(decodeTo(SPConsent<SPCCPAConsent>.self))
                }
            }
        }
    }
}
