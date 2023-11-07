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

class SPConsentSpec: QuickSpec {
    let ccpaConsents = """
        {
            "applies": true,
            "consents": {
                "expirationDate": "2124-10-27T16:59:00.092Z",
                "status": "rejectedNone",
                "rejectedVendors": [],
                "rejectedCategories": [],
                "consentStatus": {},
                "signedLspa": false
            }
        }
    """

    let gdprConsents = """
        {
            "applies": true,
            "consents": {
                "expirationDate": "2124-10-27T16:59:00.092Z",
                "grants": {},
                "TCData": {},
                "euconsent": "",
                "consentStatus": {}
            }
        }
    """

    let usNatConsents = """
        {
            "applies": false,
            "consents": {
                "applies": false,
                "dateCreated": "2124-10-27T16:59:00.092Z",
                "consentString": "",
                "categories": []
            }
        }
    """

    override func spec() {
        // TODO: remove fdescribe
        fdescribe("SPConsent") {
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

            describe("USNat") {
                it("can be decode from JSON") {
                    expect(self.usNatConsents).to(decodeToValue(
                        SPConsent<SPUSNatConsent>(consents: .empty(), applies: false)
                    ))
                }
            }
        }
    }
}
