//
//  ActionRequest.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 18.08.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import ConsentViewController

// swiftlint:disable force_try
class ActionRequestSpec: QuickSpec {
    override func spec() {
        let requestUUID = UUID()
        let action = ActionRequest(
            propertyHref: try! SPPropertyName("property-name"),
            accountId: 1,
            actionType: 1,
            choiceId: "choiceId",
            privacyManagerId: "pmId",
            requestFromPM: false,
            requestUUID: requestUUID,
            pmSaveAndExitVariables: try! SPJson(["foo": "bar"]),
            localState: "local state",
            publisherData: try! ["pubFoo": SPJson("pubBar")],
            consentLanguage: "EN"
        )
        let actionString = """
        {
            "pmSaveAndExitVariables": {
                "foo": "bar"
            },
            "uuid": "consentUUID",
            "consentLanguage":"EN",
            "privacyManagerId": "pmId",
            "choiceId": "choiceId",
            "requestFromPM": false,
            "accountId": 1,
            "actionType": 1,
            "requestUUID": "\(requestUUID.uuidString)",
            "meta": "meta",
            "propertyId": 1,
            "propertyHref": "https:\\/\\/property-name",
            "pubData": {
                "pubFoo": "pubBar"
            }
        }
        """.filter { !" \n\t\r".contains($0) }

        it("can be encoded to JSON") {
            let actionEncoded = String(data: try! JSONEncoder().encode(action), encoding: .utf8)
            expect(actionString).to(equal(actionEncoded))
        }

        it("can be decoded from JSON") {
            _ = JSONDecoder().decode(ActionRequest.self, from: actionString.data(using: .utf8)!).map {
                expect(action).to(equal($0))
            }
        }
    }
}
