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
        let request = GDPRConsentRequest(
            authId: "authId",
            idfaStatus: .accepted,
            localState: try! SPJson(["local": "state"]),
            pmSaveAndExitVariables: try! SPJson(["foo": "bar"]),
            publisherData: ["pubFoo": try? SPJson("pubBar")],
            requestUUID: requestUUID
        )
        let actionString = """
        {
            "pmSaveAndExitVariables": {
                "foo": "bar"
            },
            "localState": {
                "local": "state"
            },
            "requestUUID": "\(requestUUID.uuidString)",
            "pubData": {
                "pubFoo": "pubBar"
            }
        }
        """.filter { !" \n\t\r".contains($0) }

        it("can be encoded to JSON") {
            let actionEncoded = String(data: try! JSONEncoder().encode(request), encoding: .utf8)
            expect(actionString).to(equal(actionEncoded))
        }
    }
}
