//
//  GDPRMessageSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Vilas on 21/03/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import ConsentViewController

class GDPRMessageSpec: QuickSpec {

    override func spec() {

        describe("Test GDPRMessage") {

            var attributeStyle: AttributeStyle?
            var messageAttribute: MessageAttribute?
            var messageAction: MessageAction?
            var gdprMessage: GDPRMessage?
            let customFileds = ["Custom": "Fileds"]

            beforeEach {
                attributeStyle = AttributeStyle(fontFamily: "System-Font", fontSize: 14, color: "#00FA9A", backgroundColor: "#944488")
                messageAttribute = MessageAttribute(text: "Test GDPR Message", style: attributeStyle!, customFields: customFileds)
                messageAction = MessageAction(text: "Test GDPR Message", style: attributeStyle!, customFields: customFileds, choiceId: 12, choiceType: GDPRActionType.AcceptAll)
                gdprMessage = GDPRMessage(title: messageAttribute!, body: messageAttribute!, actions: [messageAction!], customFields: customFileds)
            }

            it("Test AttributeStyle method") {
                expect(attributeStyle?.backgroundColor).to(equal("#944488"))
            }

            it("Test MessageAction method") {
                expect(messageAttribute?.style.backgroundColor).to(equal("#944488"))
            }

            it("Test MessageAction method") {
                expect(messageAction?.choiceType).to(equal(GDPRActionType.AcceptAll))
            }

            it("Test GDPRMessage method") {
                expect(gdprMessage?.title.style.color).to(equal("#00FA9A"))
            }
        }
    }
}
