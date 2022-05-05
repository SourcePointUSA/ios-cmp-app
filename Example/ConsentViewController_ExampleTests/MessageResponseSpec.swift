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

// swiftlint:disable function_body_length
// swiftlint:disable force_try
class MessageResponseSpec: QuickSpec {
    override func spec() {
        let response = Result { """
        {
            "propertyId": 1,
            "campaigns": [
                {
                    "type": "GDPR",
                    "applies": true,
                    "message": {
                        "site_id":1,
                        "message_json": {},
                        "message_choice": {}
                    },
                    "userConsent": {
                        "euconsent": "consent-string",
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
                    "messageMetaData": {
                        "messageId": 1,
                        "categoryId": 1,
                        "subCategoryId": 5,
                        "prtnUUID": "123"
                    }
                },
                {
                    "type": "CCPA",
                    "applies": true,
                    "message": {
                        "site_id":1,
                        "message_json": {},
                        "message_choice": {}
                    },
                    "userConsent": {
                        "status": "rejectedNone",
                        "uspstring": "us-pstring",
                        "rejectedVendors": ["rejected-vendor"],
                        "rejectedCategories": ["rejected-category"]
                    },
                    "meta": "ccpa-meta",
                    "messageMetaData": {
                        "messageId": 1,
                        "categoryId": 1,
                        "subCategoryId": 5,
                        "prtnUUID": "123"
                    }
                }
            ],
            "localState": {
                "local": "state"
            }
        }
        """.filter { !" \n\t\r".contains($0) }.data(using: .utf8) }

        it("can be decoded from JSON") {
            let metaData = MessageMetaData(
                categoryId: .gdpr,
                subCategoryId: .TCFv2,
                messageId: "1",
                messagePartitionUUID: "123"
            )
            let msg: Message = try Message(propertyId: 1, language: nil, category: .gdpr, subCategory: .TCFv2, messageChoices: SPJson(), webMessageJson: SPJson(), categories: nil)

            let msgResponse: MessagesResponse = MessagesResponse(
                propertyId: 1,
                localState: try! SPJson(["local": "state"]),
                campaigns: [
                        Campaign(
                            type: .gdpr,
                            message: msg,
                            userConsent: .gdpr(consents: SPGDPRConsent(
                                vendorGrants: [
                                    "foo-purpose": SPGDPRVendorGrant(
                                        granted: true,
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
                            message: msg,
                            userConsent: .ccpa(consents: SPCCPAConsent(
                                status: .RejectedNone,
                                rejectedVendors: ["rejected-vendor"],
                                rejectedCategories: ["rejected-category"],
                                uspstring: "us-pstring"
                            )),
                            applies: true,
                            messageMetaData: metaData
                        )
                    ]
            )
            let responseDecoded = try! response.decoded() as MessagesResponse
            expect(responseDecoded).to(equal(msgResponse))
        }
    }
}
