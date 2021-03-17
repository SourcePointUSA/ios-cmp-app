//
//  MessageResponseSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 08.02.21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import ConsentViewController

// swiftlint:disable force_try function_body_length
class MessageResponseSpec: QuickSpec {
    override func spec() {
        let response = Result { """
        {
            "gdpr": {
                "uuid": "gdpr-uuid",
                "applies": true,
                "userConsent": {
                    "euconsent": "consent-string",
                    "acceptedCategories": ["accepted-category"],
                    "acceptedVendors": ["accepted-vendor"],
                    "specialFeatures": ["special-feature"],
                    "legIntCategories": ["leg-int-category"],
                    "grants": {
                        "foo-purpose": {
                            "vendorGrant": true,
                            "purposeGrants": {}
                        }
                    },
                    "TCData": {
                        "foo": "tc-data"
                    }
                },
                "meta": "gdpr-meta",
                "message": {
                    "foo": "message"
                }
            },
            "ccpa": {
                "uuid": "ccpa-uuid",
                "applies": true,
                "userConsent": {
                    "status": "rejectedNone",
                    "uspstring": "us-pstring",
                    "rejectedVendors": ["rejected-vendor"],
                    "rejectedCategories": ["rejected-category"]
                },
                "meta": "ccpa-meta",
                "message": {
                    "foo": "message"
                }
            }
        }
        """.filter { !" \n\t\r".contains($0) }.data(using: .utf8) }

        it("can be decoded from JSON") {
            let metaData = MessageMetaData(
                categoryId: .unknown,
                subCategoryId: .TCFv2,
                messageId: 1
            )
            expect(try! response.decoded() as MessagesResponse).to(equal(MessagesResponse(
                campaigns: [
                    Campaign(
                        type: .gdpr,
                        message: .web(try! SPJson(["foo": "message"])),
                        userConsent: .gdpr(consents: SPGDPRConsent(
                            vendorGrants: [
                                "foo-purpose": SPGDPRVendorGrant(
                                    vendorGrant: true,
                                    purposeGrants: SPGDPRPurposeGrants()
                                )
                            ],
                            euconsent: "consent-string",
                            tcfData: try! SPJson(["foo": "tc-data"])
                        )),
                        applies: true,
                        messageMetaData: metaData
                    ),
                    Campaign(
                        type: .ccpa,
                        message: .web(try! SPJson(["foo": "message"])),
                        userConsent: .ccpa(consents: SPCCPAConsent(
                            status: .RejectedNone,
                            rejectedVendors: ["rejected-vendor"],
                            rejectedCategories: ["rejected-category"],
                            uspstring: "us-pstring"
                        )),
                        applies: true,
                        messageMetaData: metaData
                    )
                ],
                localState: ""
            )))
        }
    }
}
