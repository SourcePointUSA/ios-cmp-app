//
//  GDPRNativeMessageViewControllerSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Vilas on 23/03/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import ConsentViewController

class GDPRNativeMessageViewControllerSpec: QuickSpec, GDPRConsentDelegate {

    func getGDPRConsentViewController() -> GDPRConsentViewController {
        return GDPRConsentViewController(accountId: 22, propertyId: 7094, propertyName: try! GDPRPropertyName("tcfv2.mobile.demo"), PMId: "100699", campaignEnv: .Public, consentDelegate: self)
    }

    override func spec() {

        describe("Test GDPRNativeMessageViewController methods") {
            let customFileds = ["Custom": "Fileds"]
            let attributeStyle = AttributeStyle(fontFamily: "System-Font", fontSize: 14, color: "#00FA9A", backgroundColor: "#944488")
            let messageAttribute = MessageAttribute(text: "Test GDPR Message", style: attributeStyle, customFields: customFileds)
            let messageAction = MessageAction(text: "Test GDPR Message", style: attributeStyle, customFields: customFileds, choiceId: 12, choiceType: GDPRActionType.AcceptAll)
            let gdprMessage = GDPRMessage(title: messageAttribute, body: messageAttribute, actions: [messageAction], customFields: customFileds)
            var gdprNativeMessageViewController: GDPRNativeMessageViewController?
            var gdprConsentViewController: GDPRConsentViewController!
            let mockConsentDelegate = MockConsentDelegate()

            let titleLabel = UILabel()
            let descriptionTextView = UITextView()
            let acceptButton = UIButton()

            beforeEach {
                gdprConsentViewController = self.getGDPRConsentViewController()
                gdprConsentViewController.consentDelegate = mockConsentDelegate
                gdprNativeMessageViewController = GDPRNativeMessageViewController(messageContents: gdprMessage, consentViewController: gdprConsentViewController)
            }

            it("Test onShowOptionsTap method") {
                gdprNativeMessageViewController?.onShowOptionsTap(AnyClass.self)
                expect(mockConsentDelegate.isOnActionCalled).to(equal(false), description: "onAction delegate method calls successfully")
            }

            it("Test onShowOptionsTap method") {
                gdprNativeMessageViewController?.onRejectTap(AnyClass.self)
                expect(mockConsentDelegate.isOnActionCalled).to(equal(false), description: "onAction delegate method calls successfully")
            }

            it("Test onShowOptionsTap method") {
                gdprNativeMessageViewController?.onAcceptTap(AnyClass.self)
                expect(mockConsentDelegate.isOnActionCalled).to(equal(true), description: "onAction delegate method calls successfully")
            }

            it("Test loadOrHideActionButton method") {
                gdprNativeMessageViewController?.loadOrHideActionButton(actionType: GDPRActionType.AcceptAll, button: acceptButton)
                expect(acceptButton.titleLabel?.text).to(equal("Test GDPR Message"), description: "Expected data is added in label")
            }

            it("Test loadTitle method") {
                gdprNativeMessageViewController?.loadTitle(forAttribute: messageAttribute, label: titleLabel)
                expect(titleLabel.text).to(equal("Test GDPR Message"), description: "Expected data is added in label")
            }

            it("Test loadBody method") {
                gdprNativeMessageViewController?.loadBody(forAttribute: messageAttribute, textView: descriptionTextView)
                expect(descriptionTextView.text).to(equal("Test GDPR Message"), description: "Expected data is added in textview")
            }

            context("Test onAction delegate method") {
                it("Test GDPRMessageViewController calls onAction delegate method") {
                    gdprNativeMessageViewController?.action(GDPRActionType.AcceptAll)
                    expect(mockConsentDelegate.isOnActionCalled).to(equal(true), description: "onAction delegate method calls successfully")
                }
            }

            it("Load privacy manager in webview") {
                gdprNativeMessageViewController?.showPrivacyManager()
                expect(gdprConsentViewController.loading).to(equal(.Loading), description: "loadPrivacyManager method works as expected")
            }

            it("Test hexStringToUIColor method") {
                let rgbColor = gdprNativeMessageViewController?.hexStringToUIColor(hex: "#757575")
                expect(rgbColor?.cgColor.components).to(equal([0.4588235294117647, 0.4588235294117647, 0.4588235294117647, 1.0]), description: "Hex string converted to UIColor")
            }
        }
    }
}
