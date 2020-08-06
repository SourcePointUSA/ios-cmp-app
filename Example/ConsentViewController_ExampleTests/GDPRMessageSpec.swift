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

            context("Test JSON Encoding") {
                var actual: GDPRMessage?
                beforeEach {
                    guard let data = try? JSONEncoder().encode(gdprMessage) else {
                                      fail("Failed to encode \(String(describing: GDPRMessage.self))")
                                      return
                                  }

                    actual = try? JSONDecoder().decode(GDPRMessage.self, from: data)
                }

                it("has matching title text") {
                    expect(actual?.title.text).to(equal(gdprMessage?.title.text))
                }

                it("has matching body text") {
                    expect(actual?.body.text).to(equal(gdprMessage?.body.text))
                }

                it("has matching action choice type") {
                    expect(actual?.actions.first?.choiceType).to(equal(gdprMessage?.actions.first?.choiceType))
                }

                it("has matching action choice id") {
                    expect(actual?.actions.first?.choiceId).to(equal(gdprMessage?.actions.first?.choiceId))
                }

                it("has matching action custom fields") {
                    expect(actual?.customFields).to(equal(gdprMessage?.customFields))
                }
            }
        }
    }
}
