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
        groupPmId: nil, targetingParams: ["foo": "bar"]
    )

    // swiftlint:disable function_body_length
    override func spec() {
        let reqUUID = UUID()
        let message = MessageRequest(
            authId: nil,
            requestUUID: reqUUID,
            propertyHref: try! SPPropertyName("demo"),
            accountId: 1,
            campaignEnv: .Public,
            idfaStatus: .unknown,
            localState: SPJson(),
            consentLanguage: .Bulgarian,
            campaigns: CampaignsRequest(
                gdpr: campaign,
                ccpa: campaign,
                ios14: campaign
            ),
            pubData: [:]
        )
        let messageString = """
        {
            "accountId": 1,
            "campaignEnv":"prod",
            "campaigns": {
                "ccpa": {
                    "targetingParams": {"foo":"bar"}
                },
                "gdpr": {
                    "targetingParams": {"foo":"bar"}
                },
                "ios14": {
                    "targetingParams": {"foo":"bar"}
                }
            },
            "consentLanguage":"BG",
            "idfaStatus": "unknown",
            "includeData": {
                "localState": {"type":"RecordString"},
                "messageMetaData": {"type":"RecordString"},
                "TCData": {"type":"RecordString"}
            },
            "localState": {},
            "propertyHref": "https:\\/\\/demo",
            "pubData":{},
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
