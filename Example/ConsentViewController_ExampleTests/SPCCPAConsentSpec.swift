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
                expect(consents.GPPData).to(equal(SPJson()))
                expect(consents.expirationDate.date).to(equal(.distantFuture))
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
                    "signedLspa": false,
                    "expirationDate": "2023-02-06T16:20:53.707Z",
                    "GPPData": {
                        "foo": "bar"
                    }
                }
                """.data(using: .utf8)
            }
            let consent = try ccpaConsents.decoded() as SPCCPAConsent
            expect(consent.applies).to(beTrue())
            expect(consent.status).to(equal(.RejectedNone))
            expect(consent.rejectedVendors).to(beEmpty())
            expect(consent.rejectedCategories).to(beEmpty())
            expect(consent.signedLspa).to(beFalse())
            expect(consent.GPPData.dictionaryValue?["foo"] as? String).to(equal("bar"))
            let date = Calendar.current.dateComponents([.day, .year, .month], from: consent.expirationDate.date)
            expect(date.year).to(equal(2023))
            expect(date.month).to(equal(02))
            expect(date.day).to(equal(06))
        }
    }
}
