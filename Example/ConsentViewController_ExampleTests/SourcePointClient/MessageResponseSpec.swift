//
//  MessageResponseSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 08.02.21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import ConsentViewController

class MessageResponseSpec: QuickSpec {
    override func spec() {
        let messageResponse = """
        {
            "message": {
                "site_id": 1,
                "message_json": {},
                "message_choice": {}
            },
            "messageMetaData": {
                "messageId": 1,
                "categoryId": 1,
                "subCategoryId": 5,
                "prtnUUID": "123"
            }
        }
        """

        it("can be decoded from JSON") {
            expect(messageResponse).to(decodeTo(MessageResponse.self))
        }
    }
}
