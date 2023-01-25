//
//  SPUserConsent.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 25.01.23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import ConsentViewController

class SPConsentSpec: QuickSpec {
    let ccpaConsents = """
        {
            "applies": true,
            "consents": {
                "status": "rejectedNone",
                "rejectedVendors": [],
                "rejectedCategories": [],
                "uspstring": "1---"
            }
        }
    """

    let gdprConsents = """
        {
            "applies": true,
            "consents": {
                "grants": {},
                "TCData": {},
                "euconsent": ""
            }
        }
    """

    override func spec() {
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
