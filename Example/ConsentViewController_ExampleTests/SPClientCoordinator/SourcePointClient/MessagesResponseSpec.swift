//
//  MessagesResponseSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 05.09.22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

@testable import ConsentViewController
import Foundation
import Nimble
import Quick

// swiftlint:disable function_body_length
class MessagesResponseSpec: QuickSpec {
    override func spec() {
        let gdprCampaign = """
        {
            "type": "GDPR",
            "message": {
                "message_json": {},
                "message_choice": [],
                "site_id": 123
            },
            "url": "https://rendering-app-url.com",
            "messageMetaData": {
                "messageId": 123,
                "categoryId": 1,
                "subCategoryId": 5
            },
            "euconsent": "consent string",
            "grants": {},
            "childPmId": null,
            "dateCreated": "2022-09-05T14:56:57.880Z",
            "consentStatus": {
                "rejectedAny": true,
                "rejectedLI": false,
                "consentedAll": false,
                "granularStatus": {
                    "vendorConsent": "NONE",
                    "vendorLegInt": "ALL",
                    "purposeConsent": "NONE",
                    "purposeLegInt": "ALL",
                    "previousOptInAll": false,
                    "defaultConsent": true
                },
                "hasConsentData": false,
                "consentedToAny": false
            }
        }
        """

        let ccpaCampaign = """
        {
            "type": "CCPA",
            "applies": true,
            "url": "https://rendering-app-url.com",
            "dateCreated": "2022-09-05T14:56:58.195Z",
            "consentedAll": false,
            "rejectedCategories": [],
            "rejectedVendors": [],
            "rejectedAll": false,
            "status": "rejectedNone",
            "uspstring": "1YNN",
            "message": {
                "message_json": {},
                "message_choice": [],
                "site_id": 123
            },
            "messageMetaData": {
                "messageId": 123,
                "categoryId": 2,
                "subCategoryId": 1
            }
        }
        """

        let messagesResponse = """
        {
            "propertyId": 123,
            "campaigns": [
                \(gdprCampaign),
                \(ccpaCampaign)
            ],
            "localState": {},
            "nonKeyedLocalState": {}
        }
        """

        describe("GDPRCampaignResponse") {
            it("can be decoded from json") {
                expect(gdprCampaign).to(decodeTo(Campaign.self))
            }
        }

        describe("CCPACampaignResponse") {
            it("can be decoded from json") {
                expect(ccpaCampaign).to(decodeTo(Campaign.self))
            }
        }

        describe("MessagesResponse") {
            it("can be decoded from json") {
                expect(messagesResponse).to(decodeTo(MessagesResponse.self))
            }
        }
    }
}
