//
//  GDPRMessageSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Vilas on 21/03/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

@testable import ConsentViewController
import Nimble
import Quick

class GDPRMessageSpec: QuickSpec {
    override func spec() {
        describe("Test GDPRMessage") {
            var attributeStyle: SPNativeMessage.AttributeStyle!
            var messageAttribute: SPNativeMessage.Attribute!
            var messageAction: SPNativeMessage.Action!
            var gdprMessage: SPNativeMessage!
            let customFileds = ["Custom": "Fileds"]

            beforeEach {
                attributeStyle = SPNativeMessage.AttributeStyle(fontFamily: "System-Font", fontSize: 14, color: "#00FA9A", backgroundColor: "#944488")
                messageAttribute = SPNativeMessage.Attribute(text: "Test GDPR Message", style: attributeStyle, customFields: customFileds)
                messageAction = SPNativeMessage.Action(text: "Test GDPR Message", style: attributeStyle, customFields: customFileds, choiceType: SPActionType.AcceptAll, url: nil)
                gdprMessage = SPNativeMessage(title: messageAttribute, body: messageAttribute, actions: [messageAction], customFields: customFileds)
            }

            it("Test AttributeStyle method") {
                expect(attributeStyle.backgroundColor) == "#944488"
            }

            it("Test MessageAction method") {
                expect(messageAttribute.style.backgroundColor) == "#944488"
            }

            it("Test MessageAction method") {
                expect(messageAction.choiceType) == SPActionType.AcceptAll
            }

            it("Test GDPRMessage method") {
                expect(gdprMessage.title.style.color) == "#00FA9A"
            }
        }
    }
}
