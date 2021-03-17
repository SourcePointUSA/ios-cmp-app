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
    let campaign = CampaignRequest(
        campaignEnv: .Public,
        targetingParams: ["foo": "bar"]
    )
    override func spec() {
        let reqUUID = UUID()
        let message = MessageRequest(
            authId: nil,
            requestUUID: reqUUID,
            propertyHref: try! SPPropertyName("demo"),
            accountId: 1,
            idfaStatus: .unknown,
            localState: "",
            campaigns: CampaignsRequest(
                gdpr: campaign,
                ccpa: campaign,
                ios14: campaign
            )
        )
        let messageString = """
        {
            "accountId": 1,
            "idfaStatus": "unknown",
            "includeData":{
                "localState":{"type":"string"},
                "TCData": {"type":"RecordString"},
                "messageMetaData": {"type":"RecordString"}
            },
            "propertyHref": "https:\\/\\/demo",
            "localState": "",
            "requestUUID": "\(reqUUID.uuidString)",
            "campaigns": {
                "ccpa": {
                    "campaignEnv": "prod",
                    "targetingParams": {"foo":"bar"}
                },
                "gdpr": {
                    "campaignEnv": "prod",
                    "targetingParams": {"foo":"bar"}
                },
                "ios14": {
                    "campaignEnv": "prod",
                    "targetingParams": {"foo":"bar"}
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
