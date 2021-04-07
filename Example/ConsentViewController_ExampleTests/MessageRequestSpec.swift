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
            },
            "idfaStatus": "unknown",
            "includeData": {
                "localState": {"type":"string"},
                "messageMetaData": {"type":"RecordString"},
                "TCData": {"type":"RecordString"}
            },
            "localState": "",
            "propertyHref": "https:\\/\\/demo",
            "requestUUID": "\(reqUUID.uuidString)"
        }
        """.filter { !" \n\t\r".contains($0) }

        it("can be encoded to JSON") {
            let encoder = JSONEncoder()
            if #available(iOS 11.0, *) { encoder.outputFormatting = .sortedKeys }
            let messageEncoded = String(data: try! encoder.encode(message), encoding: .utf8)
            expect(messageString).to(equal(messageEncoded))
        }
    }
}
