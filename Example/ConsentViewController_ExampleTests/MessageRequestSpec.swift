//
//  MessageRequestSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 01.07.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import ConsentViewController

// swiftlint:disable force_try

class MessageRequestSpec: QuickSpec {
    func campaign(_ name: String) -> CampaignRequest { CampaignRequest(
            uuid: nil,
            accountId: 1,
            propertyId: 1,
            propertyHref: try! SPPropertyName(name),
            campaignEnv: .Public,
            meta: "",
            targetingParams: ["foo": "bar"]
        )
    }
    override func spec() {
        let reqUUID = UUID()
        let message = MessageRequest(
            authId: nil,
            requestUUID: reqUUID,
            campaigns: CampaignsRequest(gdpr: campaign("gdpr"), ccpa: campaign("ccpa"))
        )
        let messageString = """
        {
            "requestUUID": "\(reqUUID.uuidString)",
            "campaigns": {
                "ccpa": {
                    "campaignEnv": "prod",
                    "propertyId": 1,
                    "accountId": 1,
                    "meta": "",
                    "targetingParams": {"foo":"bar"},
                    "propertyHref": "https:\\/\\/ccpa"
                },
                "gdpr": {
                    "campaignEnv": "prod",
                    "propertyId": 1,
                    "accountId": 1,
                    "meta": "",
                    "targetingParams": {"foo":"bar"},
                    "propertyHref": "https:\\/\\/gdpr"
                }
            }
        }
        """.filter { !" \n\t\r".contains($0) }

        it("can be encoded to JSON") {
            let messageEncoded = String(data: try! JSONEncoder().encode(message), encoding: .utf8)
            expect(messageString).to(equal(messageEncoded))
        }
    }
}
