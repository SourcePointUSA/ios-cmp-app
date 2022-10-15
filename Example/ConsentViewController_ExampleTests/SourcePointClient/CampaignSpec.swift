//
//  ConsentStatusSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 08.10.22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import ConsentViewController

// swiftlint:disable force_try function_body_length

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

        it("can be decoded with keyed consentStatus") {
            expect(campaignWithKeydConsentStatus.consentStatus?.rejectedAny).to(beTrue())
            expect(campaignWithKeydConsentStatus.consentStatus?.rejectedLI).to(beFalse())
            expect(campaignWithKeydConsentStatus.consentStatus?.consentedAll).to(beFalse())
            expect(campaignWithKeydConsentStatus.consentStatus?.hasConsentData).to(beFalse())
            expect(campaignWithKeydConsentStatus.consentStatus?.consentedToAny).to(beFalse())
        }

        it("can be decoded with non keyed consentStatus") {
            expect(campaignWithNonKeyedConsentStatus.consentStatus?.consentedAll).to(beFalse())
            expect(campaignWithNonKeyedConsentStatus.consentStatus?.rejectedAll).to(beFalse())
            expect(campaignWithNonKeyedConsentStatus.consentStatus?.rejectedVendors).to(equal([]))
            expect(campaignWithNonKeyedConsentStatus.consentStatus?.rejectedCategories).to(equal([]))
        }
    }
}
