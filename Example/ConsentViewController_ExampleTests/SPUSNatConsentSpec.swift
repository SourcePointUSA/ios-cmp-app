//
//  SPUSNatConsentSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 02.11.23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

@testable import ConsentViewController
import Foundation
import Nimble
import Quick

class SPUSNatConsentsSpec: QuickSpec {
    override func spec() {
        describe("static empty()") {
            it("contain empty defaults for all its fields") {
                let consents = SPUSNatConsent.empty()
                expect(consents.uuid).to(beNil())
                expect(consents.applies).to(beFalse())
                expect(consents.dateCreated.date.doubleValue).to(beCloseTo(SPDate(date: Date()).date.doubleValue, within: 0.01))
            }
        }

        it("is Codable") {
            let usnatConsents = Result { """
                {
                    "applies": true,
                    "dateCreated": "2023-02-06T16:20:53.707Z",
                    "expirationDate": "2024-02-06T16:20:53.707Z",
                    "consentStrings": [{
                        "sectionId": 99,
                        "sectionName": "abc",
                        "consentString": "xyz"
                    }],
                    "userConsents": {
                        "categories": [{
                            "_id": "categoryId",
                            "consented": false
                        }],
                        "vendors": [{
                            "_id": "vendorId",
                            "consented": false
                        }]
                    },
                    "consentStatus": {
                        "rejectedAny": true,
                        "consentedToAll": true,
                        "consentedToAny": true,
                        "hasConsentData": true,
                        "granularStatus": {
                            "sellStatus": true,
                            "shareStatus": true,
                            "sensitiveDataStatus": true,
                            "gpcStatus": true
                        }
                    },
                    "GPPData": {
                        "foo": "bar"
                    }
                }
                """.data(using: .utf8)
            }
            do {
                let consent = try usnatConsents.decoded() as SPUSNatConsent
                expect(consent.applies).to(beTrue())
                expect(consent.categories)
                    .to(equal([SPConsentable(id: "categoryId", consented: false)]))
                expect(consent.vendors)
                    .to(equal([SPConsentable(id: "vendorId", consented: false)]))
                expect(consent.GPPData).to(equal(try? SPJson(["foo": "bar"])))
                expect(consent.consentStrings).to(equal([
                    .init(sectionId: 99, sectionName: "abc", consentString: "xyz")
                ]))
                expect(consent.dateCreated).to(equal(year: 2023, month: 2, day: 6))
                expect(consent.expirationDate).to(equal(year: 2024, month: 2, day: 6))
                expect(consent.statuses).to(equal(
                    SPUSNatConsent.Statuses(
                        rejectedAny: true,
                        consentedToAll: true,
                        consentedToAny: true,
                        hasConsentData: true,
                        sellStatus: true,
                        shareStatus: true,
                        sensitiveDataStatus: true,
                        gpcStatus: true
                    )
                ))
            } catch {
                fail(String(describing: error))
            }
        }
    }
}
