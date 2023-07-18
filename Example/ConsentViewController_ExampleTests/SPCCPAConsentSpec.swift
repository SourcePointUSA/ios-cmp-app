//
//  SPCCPAConsentSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 21.06.23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

@testable import ConsentViewController
import Foundation
import Nimble
import Quick

class SPCCPAConsentsSpec: QuickSpec {
    override func spec() {
        describe("static empty()") {
            it("contain empty defaults for all its fields") {
                let consents = SPCCPAConsent.empty()
                expect(consents.uspstring).to(equal("1---"))
                expect(consents.rejectedVendors).to(equal([]))
                expect(consents.rejectedCategories).to(equal([]))
                expect(consents.uuid).to(beNil())
                expect(consents.applies).to(beFalse())
                expect(consents.status).to(equal(.RejectedNone))
            }
        }

        it("is Codable") {
            let ccpaConsents = Result { """
                {
                    "applies": true,
                    "status": "rejectedNone",
                    "rejectedVendors": [],
                    "rejectedCategories": [],
                    "consentStatus": {},
                    "signedLspa": false
                }
                """.data(using: .utf8)
            }
            let consent = try ccpaConsents.decoded() as SPCCPAConsent
            expect(consent.applies).to(beTrue())
            expect(consent.applies).to(beTrue())
        }
    }
}
