//
//  ConsentStatusSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 08.10.22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

@testable import ConsentViewController
import Foundation
import Nimble
import Quick

// swiftlint:disable force_try function_body_length force_unwrapping

class CampaignSpec: QuickSpec {
    override func spec() {
        let campaignWithKeydConsentStatus = try! JSONDecoder().decode(Campaign.self, from: """
        {
            "type": "test",
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
            },
            "dateCreated": "2022-10-08T09:10:41.926Z"
        }
        """.data(using: .utf8)!).get()

        let campaignWithNonKeyedConsentStatus = try! JSONDecoder().decode(Campaign.self, from: """
        {
            "type": "test",
            "consentedAll": false,
            "rejectedCategories": [],
            "rejectedVendors": [],
            "rejectedAll": false,
            "dateCreated": "2022-10-08T09:10:41.926Z"
        }
        """.data(using: .utf8)!).get()

        it("ccpa campaign can be decoded into SPCCPAConsent") {
            let ccpaCampaign = """
            {
                "type": "CCPA",
                "dateCreated": "2023-02-06T16:20:53.707Z",
                "expirationDate": "2123-02-06T16:20:53.707Z",
                "consentedAll": false,
                "rejectedCategories": [],
                "rejectedVendors": [],
                "rejectedAll": false,
                "status": "rejectedNone",
                "signedLspa": true
            }
            """
            expect(ccpaCampaign).to(decodeTo(SPCCPAConsent.self))
        }
    }
}
