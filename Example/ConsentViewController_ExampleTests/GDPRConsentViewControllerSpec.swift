//
//  GDPRConsentViewControllerSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Vilas on 3/16/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

// swiftlint:disable force_try function_body_length

import Quick
import Nimble
@testable import ConsentViewController

public class MockConsentDelegate: GDPRConsentDelegate {

    var isConsentUIWillShowCalled = false
    var isConsentUIDidDisappearCalled = false
    var isOnErrorCalled = false
    var isReportActionCalled = false
    var isOnActionCalled = false
    var isOnConsentReadyCalled = false
    var isMessageWillShowCalled = false
    var isMessageDidDisappearCalled = false
    var isPMWillShowCalled = false
    var isPMDidDisappearCalled = false

    public func consentUIWillShow() {
        isConsentUIWillShowCalled = true
    }

    public func consentUIDidDisappear() {
        isConsentUIDidDisappearCalled = true
    }

    public func onError(error: GDPRConsentViewControllerError?) {
        isOnErrorCalled = true
    }

    public func reportAction(_ action: GDPRAction) {
        isReportActionCalled = true
    }

    public func onAction(_ action: GDPRAction) {
        isOnActionCalled = true
    }

    public func onConsentReady(gdprUUID: GDPRUUID, userConsent: GDPRUserConsent) {
        isOnConsentReadyCalled = true
    }

    public func messageWillShow() {
        isMessageWillShowCalled = true
    }

    public func messageDidDisappear() {
        isMessageDidDisappearCalled = true
    }

    public func pmWillShow() {
        isPMWillShowCalled = true
    }

    public func pmDidDisappear() {
        isPMDidDisappearCalled = true
    }

}

class GDPRConsentViewControllerSpec: QuickSpec, GDPRConsentDelegate {

    func getGDPRConsentViewController() -> GDPRConsentViewController {
        return GDPRConsentViewController(accountId: 22,
                                         propertyId: 7094,
                                         propertyName: try! GDPRPropertyName("tcfv2.mobile.demo"),
                                         PMId: "100699",
                                         campaignEnv: .Public,
                                         consentDelegate: self)
    }

    override func spec() {
        var consentViewController: GDPRConsentViewController!
        let mockConsentDelegate = MockConsentDelegate()
        let acceptAllAction = GDPRAction(type: .AcceptAll, id: "1234")
        let dismissAction = GDPRAction(type: .Dismiss, id: "1234")
        let gdprUUID = UUID().uuidString
        let messageViewController = GDPRMessageViewController()
        let userConsents = GDPRUserConsent(
            acceptedVendors: [],
            acceptedCategories: [],
            legitimateInterestCategories: [],
            specialFeatures: [],
            euconsent: "",
            tcfData: SPGDPRArbitraryJson())

        describe("load Native Message") {
            beforeEach {
                consentViewController = self.getGDPRConsentViewController()
            }

            it("Load native message with auth ID") {
                consentViewController.loadNativeMessage(forAuthId: "SPTest")
                expect(consentViewController.loading).to(equal(.Loading), description: "")
            }
        }

        describe("load Message in webview") {
            beforeEach {
                consentViewController = self.getGDPRConsentViewController()
            }

            it("Load message in webview without authId") {
                consentViewController.loadMessage()
                expect(consentViewController.loading).to(equal(.Loading), description: "loadMessage method works as expected")
            }

            it("Load message in webview with authId") {
                consentViewController.loadMessage(forAuthId: "SPTestMessage")
                expect(consentViewController.loading).to(equal(.Loading), description: "loadMessage method with authID works as expected")
            }
        }

        describe("load Privacy Manager") {
            beforeEach {
                consentViewController = self.getGDPRConsentViewController()
            }

            it("Load privacy manager in webview") {
                consentViewController.loadPrivacyManager()
                expect(consentViewController.loading).to(equal(.Loading), description: "loadPrivacyManager method works as expected")
            }
        }

        describe("Clears UserDefaults ") {
            beforeEach {
                consentViewController = self.getGDPRConsentViewController()
            }

            it("Clears all IAB related data from the UserDefaults") {
                consentViewController.clearIABConsentData()
                let gdprUUIDKey = UserDefaults.standard.string(forKey: GDPRConsentViewController.GDPR_UUID_KEY)
                expect(gdprUUIDKey).to(beNil(), description: "Upon successful call to clearIABConsentData GDPR_UUID_KEY gets cleared")
            }

            it("Clears meta data used by the SDK") {
                consentViewController.clearInternalData()
                let iABKeyPrefix = UserDefaults.standard.string(forKey: GDPRConsentViewController.IAB_KEY_PREFIX)
                expect(iABKeyPrefix).to(beNil(), description: "Upon successful call to clearInternalData IAB_KEY_PREFIX gets cleared")
            }

            it("Clears all consent data from the UserDefaults") {
                consentViewController.clearAllData()
                let metaKey = UserDefaults.standard.string(forKey: GDPRConsentViewController.META_KEY)
                expect(metaKey).to(beNil(), description: "Upon successful call to clearAllData META_KEY gets cleared")
            }
        }

        describe("Test GDPRConsentDelegate methods") {
            beforeEach {
                consentViewController = self.getGDPRConsentViewController()
                consentViewController.consentDelegate = mockConsentDelegate
            }
            context("Test consentUIWillShow delegate method") {
                it("Test GDPRConsentViewController calls consentUIWillShow delegate method") {
                    consentViewController.gdprConsentUIWillShow()
                    if consentViewController.messageViewController == nil {
                        expect(consentViewController.messageViewController).to(beNil())
                    } else {
                        expect(mockConsentDelegate.isConsentUIWillShowCalled).to(equal(true), description: "consentUIWillShow delegate method calls successfully")
                    }
                }
            }

            context("Test consentUIDidDisappear delegate method") {
                it("Test GDPRMessageViewController calls consentUIDidDisappear delegate method") {
                    consentViewController.consentUIDidDisappear()
                    expect(mockConsentDelegate.isConsentUIDidDisappearCalled).to(equal(true), description: "consentUIDidDisappear delegate method calls successfully")
                }
            }

            context("Test onError delegate method") {
                it("Test GDPRMessageViewController calls onError delegate method") {
                    let error = GDPRConsentViewControllerError()
                    consentViewController.onError(error: error)
                    expect(mockConsentDelegate.isOnErrorCalled).to(equal(true), description: "onError delegate method calls successfully")
                }
            }

            context("Test reportAction delegate method") {
                it("Test GDPRMessageViewController calls reportAction delegate method for accept all action") {
                    consentViewController.reportAction(acceptAllAction)
                    expect(mockConsentDelegate.isOnConsentReadyCalled).to(equal(false), description: "reportAction delegate method calls successfully")
                }
            }

            context("Test reportAction delegate method") {
                it("Test GDPRMessageViewController calls reportAction delegate method for dismiss action") {
                    consentViewController.reportAction(dismissAction)
                    expect(mockConsentDelegate.isOnConsentReadyCalled).to(equal(true), description: "reportAction delegate method calls successfully")
                }
            }

            context("Test onAction delegate method") {
                it("Test GDPRMessageViewController calls onAction delegate method") {
                    consentViewController.onAction(acceptAllAction)
                    expect(mockConsentDelegate.isOnActionCalled).to(equal(true), description: "onAction delegate method calls successfully")
                }
            }

            context("Test onConsentReady delegate method") {
                it("Test GDPRMessageViewController calls onConsentReady delegate method") {
                    consentViewController.onConsentReady(gdprUUID: gdprUUID, userConsent: userConsents)
                    expect(mockConsentDelegate.isOnConsentReadyCalled).to(equal(true), description: "onConsentReady delegate method calls successfully")
                }
            }

            context("Test messageWillShow delegate method") {
                it("Test GDPRMessageViewController calls messageWillShow delegate method") {
                    consentViewController.messageWillShow()
                    expect(mockConsentDelegate.isMessageWillShowCalled).to(equal(true), description: "messageWillShow delegate method calls successfully")
                }
            }

            context("Test messageDidDisappear delegate method") {
                it("Test GDPRMessageViewController calls messageDidDisappear delegate method") {
                    consentViewController.messageDidDisappear()
                    expect(mockConsentDelegate.isMessageDidDisappearCalled).to(equal(true), description: "messageDidDisappear delegate method calls successfully")
                }
            }

            context("Test consentUIDidDisappear delegate method") {
                it("Test GDPRMessageViewController calls consentUIDidDisappear delegate method") {
                    consentViewController.consentUIDidDisappear()
                    expect(mockConsentDelegate.isConsentUIDidDisappearCalled).to(equal(true), description: "consentUIDidDisappear delegate method calls successfully")
                }
            }

            context("Test pmWillShow delegate method") {
                it("Test GDPRMessageViewController calls pmWillShow delegate method") {
                    consentViewController.pmWillShow()
                    expect(mockConsentDelegate.isPMWillShowCalled).to(equal(true), description: "pmWillShow delegate method calls successfully")
                }
            }

            context("Test pmDidDisappear delegate method") {
                it("Test GDPRMessageViewController calls pmDidDisappear delegate method") {
                    consentViewController.pmDidDisappear()
                    expect(mockConsentDelegate.isPMDidDisappearCalled).to(equal(true), description: "pmDidDisappear delegate method calls successfully")
                }
            }
        }

        describe("Test Add/Remove MessageViewController") {
            beforeEach {
                consentViewController = self.getGDPRConsentViewController()
            }

            it("Test add MessageViewController into viewcontroller stack") {
                let viewController = UIViewController()
                consentViewController.add(asChildViewController: viewController)
                let navigationController = UINavigationController(rootViewController: consentViewController)
                let controllersInStack = navigationController.viewControllers
                if let messageViewController = controllersInStack.first(where: { $0 is GDPRMessageViewController }) {
                    expect(messageViewController).to(equal(GDPRMessageViewController.self()), description: "GDPRMessageViewController is added into naviagtion stack")
                } else {
                    expect(consentViewController.messageViewController).to(beNil(), description: "GDPRMessageViewController is not added into naviagtion stack")
                }
            }

            it("Test remove MessageViewController from viewcontroller stack") {
                consentViewController.add(asChildViewController: messageViewController)
                consentViewController.remove(asChildViewController: messageViewController)
                expect(consentViewController.messageViewController).to(beNil(), description: "GDPRMessageViewController is removed from naviagtion stack")
            }
        }
    }
}
