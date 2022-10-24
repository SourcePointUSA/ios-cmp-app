//
//  SPGDPRConsents.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 27.05.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import ConsentViewController

class SPGDPRConsentsSpec: QuickSpec {
    override func spec() {
        describe("static empty()") {
            it("contain empty defaults for all its fields") {
                let consents = SPGDPRConsent.empty()
                expect(consents.euconsent).to(beEmpty())
                expect(consents.tcfData?.dictionaryValue).to(beEmpty())
                expect(consents.vendorGrants).to(beEmpty())
            }
        }

        it("is Codable") {
            let gdprCampaign = Result { """
                {
                    "euconsent": "ABCD",
                    "grants": {},
                    "childPmId": null,
                    "consentStatus": {}
                }
                """.data(using: .utf8) }
            let consent = try gdprCampaign.decoded() as SPGDPRConsent
            expect(consent.euconsent).to(equal("ABCD"))
            expect(consent.vendorGrants).to(equal(SPGDPRVendorGrants()))
            expect(consent.childPmId).to(beNil())
        }

        describe("acceptedCategories") {
            it("contains all purposes accepted in *all* vendors") {
                let consent = SPGDPRConsent(
                    vendorGrants: [
                        "vendor1": SPGDPRVendorGrant(granted: false, purposeGrants: [
                            "purpose1": true,
                            "purpose2": false
                        ]),
                        "vendor2": SPGDPRVendorGrant(granted: false, purposeGrants: [
                            "purpose1": true,
                            "purpose3": true
                        ])
                    ],
                    euconsent: "",
                    tcfData: SPJson(),
                    childPmId: "yes"
                )
                expect(consent.acceptedCategories).to(contain(["purpose1", "purpose3"]))
                expect(consent.acceptedCategories).notTo(contain(["purpose2"]))
                expect(consent.childPmId).to(equal("yes"))
            }
        }
    }
}
