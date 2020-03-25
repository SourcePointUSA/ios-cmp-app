//
//  MessageWebViewControllerSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Vilas on 3/16/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import WebKit
@testable import ConsentViewController

class MessageWebViewControllerSpec: QuickSpec, GDPRConsentDelegate,WKNavigationDelegate  {
    
    func getMessageWebViewController() -> MessageWebViewController {
        return MessageWebViewController(propertyId: 22, pmId: "100699", consentUUID: UUID().uuidString)
    }
    
    override func spec() {
        var messageWebViewController : MessageWebViewController!
        let mockConsentDelegate = MockConsentDelegate()
        let showPMAction = GDPRAction(type: .ShowPrivacyManager, id: "1234")
        let cancelPMAction = GDPRAction(type: .PMCancel, id: "1234")
        let acceptedVendors = ["123", "456", "789"]
        let acceptedPurposes = ["123", "456", "789"]
        let vendors = ["vendors": acceptedVendors]
        let purposes = ["categories": acceptedPurposes]
        let consents = [vendors, purposes]
        let payload: NSDictionary = ["id": "455262", "consents": consents]
        let vendorconsents = PMConsent(accepted: [])
        let purposeconsents = PMConsent(accepted: [])
        let mockConsents = PMConsents(vendors: vendorconsents, categories: purposeconsents)

        /// this method is used to test whether webview is loaded or not successfully
        describe("Test loadView method") {
            beforeEach {
                messageWebViewController = self.getMessageWebViewController()
            }
            it("Test MessageWebViewController calls loadView method") {
                messageWebViewController.loadView()
                expect(messageWebViewController.webview).notTo(beNil(), description: "Webview initialized successfully")
            }
        }
        
        describe("Test GDPRConsentDelegate methods") {
            beforeEach {
                messageWebViewController = self.getMessageWebViewController()
                messageWebViewController.consentDelegate = mockConsentDelegate
            }
            context("Test consentUIWillShow delegate method") {
                it("Test MessageWebViewController calls consentUIWillShow delegate method") {
                    messageWebViewController.gdprConsentUIWillShow()
                    expect(mockConsentDelegate.isConsentUIWillShowCalled).to(equal(false), description: "consentUIWillShow delegate method calls successfully")
                }
            }
            
            context("Test onMessageReady method") {
                it("Test MessageWebViewController calls messageWillShow delegate method") {
                    messageWebViewController.onMessageReady()
                    expect(mockConsentDelegate.isMessageWillShowCalled).to(equal(true), description: "messageWillShow delegate method calls successfully")
                }
            }
            
            context("Test pmWillShow delegate method") {
                it("Test MessageWebViewController calls pmWillShow delegate method") {
                    messageWebViewController.onPMReady()
                    expect(mockConsentDelegate.isPMWillShowCalled).to(equal(true), description: "pmWillShow delegate method calls successfully")
                }
            }
            
            context("Test consentUIDidDisappear delegate method") {
                it("Test MessageWebViewController calls consentUIDidDisappear delegate method") {
                    messageWebViewController.consentUIDidDisappear()
                    expect(mockConsentDelegate.isConsentUIDidDisappearCalled).to(equal(true), description: "consentUIDidDisappear delegate method calls successfully")
                }
            }
            
            context("Test onError delegate method") {
                it("Test MessageWebViewController calls onError delegate method") {
                    let error = GDPRConsentViewControllerError()
                    messageWebViewController.onError(error: error)
                    expect(mockConsentDelegate.isOnErrorCalled).to(equal(true), description: "onError delegate method calls successfully")
                }
            }
            
            context("Test messageDidDisappear delegate method") {
                it("Test MessageWebViewController calls messageDidDisappear delegate method") {
                    messageWebViewController.showPrivacyManagerFromMessageAction()
                    expect(mockConsentDelegate.isMessageDidDisappearCalled).to(equal(true), description: "messageDidDisappear delegate method calls successfully")
                }
            }
            
            context("Test pmDidDisappear delegate method") {
                it("Test MessageWebViewController calls pmDidDisappear delegate method") {
                    messageWebViewController.navigateBackToMessage()
                    expect(mockConsentDelegate.isPMDidDisappearCalled).to(equal(true), description: "pmDidDisappear delegate method calls successfully")
                }
            }
            
            context("Test onAction delegate method") {
                it("Test MessageWebViewController calls onAction delegate method for show PM action") {
                    messageWebViewController.onAction(showPMAction, consents: mockConsents)
                    expect(mockConsentDelegate.isOnActionCalled).to(equal(true), description: "onAction delegate method calls successfully")
                }
            }
            
            context("Test onAction delegate method") {
                it("Test MessageWebViewController calls onAction delegate method for PM cancel action") {
                    messageWebViewController.onAction(cancelPMAction, consents: mockConsents)
                    expect(mockConsentDelegate.isOnActionCalled).to(equal(true), description: "onAction delegate method calls successfully")
                }
            }
            
            context("Test loadMessage  method") {
                it("Test MessageWebViewController calls loadMessage delegate method") {
                    let WRAPPER_API = URL(string: "https://wrapper-api.sp-prod.net/tcfv2/v1/gdpr/")!
                    messageWebViewController.loadMessage(fromUrl: WRAPPER_API)
                    expect(messageWebViewController).notTo(beNil(), description: "loadMessage delegate method calls successfully")
                }
            }
            context("Test loadPrivacyManager method") {
                it("Test MessageWebViewController calls loadPrivacyManager delegate method") {
                    messageWebViewController.loadPrivacyManager()
                    expect(messageWebViewController).notTo(beNil(), description: "loadPrivacyManager delegate method calls successfully")
                }
                
                it("Test pmUrl is called and returns url"){
                    let pmURL = messageWebViewController.pmUrl()
                    expect(pmURL).notTo(beNil(), description: "Able to get pmUrl")
                }
            }
        }
        
        /// this method is used to test whether viewWillDisappear is called or not successfully
        describe("Test viewWillDisappear methods") {
            beforeEach {
                messageWebViewController = self.getMessageWebViewController()
            }
            it("Test MessageWebViewController calls viewWillDisappear method") {
                messageWebViewController.viewWillDisappear(false)
                expect(messageWebViewController.consentDelegate).to(beNil(), description: "ConsentDelegate gets cleared")
            }
        }
        
        describe("Test getChoiceId methods") {
            var chioceID: String?
            var pmConsents: PMConsents?
            beforeEach {
                messageWebViewController = self.getMessageWebViewController()
            }
            it("Test MessageWebViewController calls getChoiceId method") {
                chioceID = messageWebViewController.getChoiceId(payload as! [String : Any])
                if chioceID != nil {
                    expect(chioceID!).to(equal("455262"), description: "Able to get chioceID")
                }else {
                    expect(chioceID).to(beNil(), description: "Unable to get chioceID")
                }
            }
            
            it("Test MessageWebViewController calls getPMConsentsIfAny method") {
              pmConsents =  messageWebViewController.getPMConsentsIfAny(payload as! [String : Any])
                if pmConsents != nil {
                    expect(pmConsents).notTo(beNil(), description: "Able get PM consents from wraper API")
                }else {
                    expect(pmConsents).to(beNil(), description: "Didn't get any PM consents from wraper API")
                }
            }
        }
    }
}
