//
//  SPGDPRConsents.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 27.05.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

@testable import ConsentViewController
import Foundation
import Nimble
import Quick

class SPGDPRConsentsSpec: QuickSpec {
    override func spec() {
        describe("static empty()") {
            it("contain empty defaults for all its fields") {
                let consents = SPGDPRConsent.empty()
                expect(consents.euconsent).to(beEmpty())
                expect(consents.tcfData?.dictionaryValue).to(beEmpty())
                expect(consents.vendorGrants).to(beEmpty())
                expect(consents.googleConsentMode).to(beNil())
            }
        }

        it("is Codable") {
            let gdprCampaign = Result { """
                {
                    "applies": true,
                    "euconsent": "ABCD",
                    "grants": {},
                    "childPmId": null,
                    "consentStatus": {},
                    "expirationDate": "2124-10-27T16:59:00.092Z",
                    "gcmStatus": {
                        "ad_user_data": "granted"
                    }
                }
                """.data(using: .utf8)
            }
            do {
                let consent = try gdprCampaign.decoded() as SPGDPRConsent
                expect(consent.euconsent) == "ABCD"
                expect(consent.vendorGrants) == SPGDPRVendorGrants()
                expect(consent.childPmId).to(beNil())
                expect(consent.applies).to(beTrue())
                expect(consent.googleConsentMode?.adUserData).to(equal(.granted))
            } catch {
                fail(String(describing: error))
            }
        }
    }
}
