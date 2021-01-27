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

/**


 {
 "requestUUID": "test",
 "campaigns": {
 "gdpr": {
 "accountId": 22,
 "propertyId": 7639,
 "propertyHref": "https://tcfv2.mobile.webview"
 },
 "ccpa": {
 "accountId": 22,
 "propertyId": 7639,
 "propertyHref": "https://tcfv2.mobile.webview"
 }
 }
 }
 */

class MessageRequestSpec: QuickSpec {
    override func spec() {
        let requestUUID = UUID()
        let message = MessageRequest(
            uuid: nil,
            euconsent: "euconsent",
            authId: nil,
            accountId: 1,
            propertyId: 1,
            propertyHref: try! SPPropertyName("propertyName"),
            campaignEnv: .Stage,
            targetingParams: nil,
            requestUUID: requestUUID,
            meta: "meta"
        )
        let messageString = """
        {
            "requestUUID": "uuid string",
            "campaigns": {
                "gdpr": {
                    "accountId": 1,
                    "propertyId": 1,
                    "propertyHref": "https://propertyName"
                },
                "ccpa": {
                    "accountId": 1,
                    "propertyId": 1,
                    "propertyHref": "https://propertyName"
                }
            }
        }
        """.filter { !" \n\t\r".contains($0) }

        it("can be encoded to JSON") {
            let messageEncoded = String(data: try! JSONEncoder().encode(message), encoding: .utf8)
            expect(messageString).to(equal(messageEncoded))
        }

        it("can be decoded from JSON") {
            let messageDecoded = try? JSONDecoder()
                .decode(MessageRequest.self, from: messageString.data(using: .utf8)!)
            expect(message).to(equal(messageDecoded))
        }
    }
}
