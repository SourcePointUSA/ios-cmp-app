//
//  GDPRConsentViewControllerSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Vilas on 3/16/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

// swiftlint:disable force_try function_body_length force_cast type_body_length

import Quick
import Nimble
@testable import ConsentViewController

struct DeviceMock: SPDeviceManager {
    func osVersion() -> String { "1.2.3" }
    func deviceFamily() -> String { "1.2.3" }
}

class GDPRConsentViewControllerSpec: QuickSpec {
    func getController(
        _ delegate: GDPRConsentDelegate = MockConsentDelegate(),
        _ spClient: SourcePointProtocol = SourcePointClientMock(timeout: 1),
        _ storage: GDPRLocalStorage = GDPRLocalStorageMock(),
        _ deviceManager: SPDeviceManager = DeviceMock()
    ) -> GDPRConsentViewController {
        return GDPRConsentViewController(accountId: 22,
                                         propertyId: 7094,
                                         propertyName: try! SPPropertyName("tcfv2.mobile.demo"),
                                         PMId: "100699",
                                         campaignEnv: .Public,
                                         consentDelegate: delegate,
                                         sourcePointClient: spClient,
                                         localStorage: storage,
                                         deviceManager: deviceManager
        )
    }

    override func spec() {
        var sourcePointClient = SourcePointClientMock(timeout: 1)
        var localStorage = GDPRLocalStorageMock()
        var mockConsentDelegate = MockConsentDelegate()
        var mockDeviceManager = DeviceMock()
        var consentViewController = self.getController(mockConsentDelegate, sourcePointClient, localStorage)
        var messageViewController = GDPRMessageViewController()
        var userConsents = SPGDPRConsent.empty()

        beforeEach {
            sourcePointClient = SourcePointClientMock(timeout: 1)
            localStorage = GDPRLocalStorageMock()
            mockDeviceManager = DeviceMock()
            mockConsentDelegate = MockConsentDelegate()
            consentViewController = self.getController(mockConsentDelegate, sourcePointClient, localStorage)
            messageViewController = GDPRMessageViewController()
            userConsents = SPGDPRConsent.empty()
        }

        describe("loadNativeMessage") {
            it("calls getMessage on SourcePointClient") {
                consentViewController.loadNativeMessage(forAuthId: nil)
                expect(sourcePointClient.getMessageCalled).to(beTruthy())
            }
        }

        describe("loadMessage") {
            it("calls getMessage on SourcePointClient") {
                consentViewController.loadMessage()
                expect(sourcePointClient.getMessageCalled).to(beTruthy())
            }
        }

        xdescribe("customConsentTo") {
            context("when the consentUUID is not empty") {
                beforeEach { consentViewController.localStorage.consentUUID = "uuid" }

                it("calls customConsentTo on SourcePointClient with the correct parameters") {
                    consentViewController.customConsentTo(vendors: ["aVendor"], categories: ["aCategory"], legIntCategories: ["aLegInt"]) { _ in }
                    expect((sourcePointClient.customConsentWasCalledWith["consentUUID"] as! String)).to(equal("uuid"))
                    expect((sourcePointClient.customConsentWasCalledWith["vendors"] as! [String])).to(equal(["aVendor"]))
                    expect((sourcePointClient.customConsentWasCalledWith["categories"] as? [String])).to(equal(["aCategory"]))
                    expect((sourcePointClient.customConsentWasCalledWith["legIntCategories"] as? [String])).to(equal(["aLegInt"]))
                }

                context("and the response is successfull") {
                    let grants = ["vendorId": GDPRVendorGrant(vendorGrant: true, purposeGrants: ["purposeId": true])]

                    beforeEach {
                        sourcePointClient.customConsentResponse = CustomConsentResponse(
                            vendors: ["vendor"],
                            categories: ["category"],
                            legIntCategories: ["legInt"],
                            specialFeatures: ["specialFeature"],
                            grants: grants
                        )
                    }

                    it("updates its own userConsents property with the result") {
                        consentViewController.customConsentTo(vendors: [], categories: [], legIntCategories: []) { consents in
                            expect(consentViewController.userConsents).toEventually(equal(consents))
                        }
                    }

                    it("calls the completion handler with a SPGDPRConsents") {
                        consentViewController.customConsentTo(vendors: [], categories: [], legIntCategories: []) { consents in
                            expect(consents).toEventually(equal(SPGDPRConsent(
                                acceptedVendors: ["vendor"],
                                acceptedCategories: ["category"],
                                legitimateInterestCategories: ["legInt"],
                                specialFeatures: ["specialFeature"],
                                vendorGrants: grants,
                                euconsent: "",
                                tcfData: SPJson()
                            )))
                        }
                    }
                }

                context("and the response is error") {
                    it("calls the onError method on its consent delegate") {
                        sourcePointClient.error = SPError()
                        consentViewController.customConsentTo(vendors: [], categories: [], legIntCategories: []) { _ in }
                        expect(mockConsentDelegate.isOnErrorCalled).to(beTrue())
                    }
                }
            }

            context("when the consentUUID is empty") {
                it("calls the onError method on its consent delegate") {
                    consentViewController.customConsentTo(vendors: [], categories: [], legIntCategories: []) { _ in }
                    expect(mockConsentDelegate.isOnErrorCalled).to(beTrue())
                }
            }
        }

        describe("load Privacy Manager") {
            it("Load privacy manager in webview") {
                consentViewController.loadPrivacyManager()
                expect(consentViewController.loading).to(equal(.Loading), description: "loadPrivacyManager method works as expected")
            }
        }

        describe("clearAllData") {
            it("calls clear on its localStorage") {
                consentViewController.clearAllData()
                expect(localStorage.clearWasCalled).to(beTrue())
            }
        }

        describe("GDPRConsentDelegate") {
            beforeEach {
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

            describe("onError") {
                it("calls the client's onError delegate method") {
                    consentViewController.onError(error: SPError())
                    expect(mockConsentDelegate.isOnErrorCalled).to(equal(true))
                }

                it("sends error metrics using SPClient") {
                    let error = SPError()
                    consentViewController.onError(error: error)
                    let errorMetricsCalledWith = sourcePointClient.errorMetricsCalledWith
                    expect(errorMetricsCalledWith?["error"] as? SPError).to(equal(error))
                    expect(errorMetricsCalledWith?["sdkVersion"] as? String).to(equal(GDPRConsentViewController.VERSION))
                    expect(errorMetricsCalledWith?["deviceFamily"] as? String).to(equal(mockDeviceManager.deviceFamily()))
                    expect(errorMetricsCalledWith?["OSVersion"] as? String).to(equal(mockDeviceManager.osVersion()))
                    expect(errorMetricsCalledWith?["legislation"] as? SPLegislation).to(equal(.GDPR))
                }
            }

            context("onAction") {
                describe("for actions that call the post consent API") {
                    let types: [SPActionType] = [.AcceptAll, .RejectAll, .SaveAndExit]

                    describe("and the local storage contains an consentUUID") {
                        beforeEach {
                            consentViewController.localStorage.consentUUID = "test"
                        }
                        describe("and the api returns a valid ActionResponse") {
                            beforeEach {
                                sourcePointClient.postActionResponse = ActionResponse(uuid: "test", userConsent: SPGDPRConsent.empty(), meta: "")
                            }
                            types.forEach { type in
                                describe(type.description) {
                                    it("calls onConsentReady") {
                                        consentViewController.onAction(SPAction(type: type))
                                        expect(mockConsentDelegate.isOnConsentReadyCalled).toEventually(beTrue(), description: type.description)
                                    }
                                }
                            }
                        }

                        describe("and the api returns an error") {
                            beforeEach {
                                sourcePointClient.error = SPError()
                            }
                            types.forEach { type in
                                describe(type.description) {
                                    it("calls onConsentReady") {
                                        consentViewController.onAction(SPAction(type: type))
                                        expect(mockConsentDelegate.isOnConsentReadyCalled).toEventually(beFalse(), description: type.description)
                                    }
                                }
                            }
                        }
                    }

                    describe("and the local storage doesn't contain an consentUUID") {
                        types.forEach { type in
                            describe(type.description) {
                                it("calls onConsentReady") {
                                    consentViewController.onAction(SPAction(type: type))
                                    expect(mockConsentDelegate.isOnConsentReadyCalled).toEventually(beFalse(), description: type.description)
                                }
                            }
                        }
                    }
                }

                let types: [SPActionType] = [.ShowPrivacyManager, .PMCancel]
                types.forEach { type in
                    describe(type.description) {
                        it("does not call onConsentReady") {
                            consentViewController.onAction(SPAction(type: type))
                            expect(mockConsentDelegate.isOnConsentReadyCalled).to(beFalse(), description: type.description)
                        }
                    }
                }

                describe("for an action with Dismiss type") {
                    it("calls the onConsentReady") {
                        consentViewController.onAction(SPAction(type: .Dismiss))
                        expect(mockConsentDelegate.isOnConsentReadyCalled).to(beTrue())
                    }
                }
            }

            context("onConsentReady") {
                beforeEach {
                    userConsents = SPGDPRConsent(
                        acceptedVendors: [],
                        acceptedCategories: [],
                        legitimateInterestCategories: [],
                        specialFeatures: [],
                        vendorGrants: GDPRVendorGrants(),
                        euconsent: "consent string",
                        tcfData: try! SPJson(["foo": "bar"])
                    )
                }

                it("calls onConsentReady delegate method") {
                    consentViewController.onConsentReady(consentUUID: "test", userConsent: userConsents)
                    expect(mockConsentDelegate.isOnConsentReadyCalled).to(equal(true), description: "onConsentReady delegate method calls successfully")
                }

                it("sets the consentUUID in its local storage") {
                    consentViewController.onConsentReady(consentUUID: "test", userConsent: userConsents)
                    expect(consentViewController.localStorage.consentUUID).to(equal("test"))
                    expect(consentViewController.consentUUID).to(equal("test"))
                }

                it("sets the userConsent in its local storage") {
                    consentViewController.onConsentReady(consentUUID: "test", userConsent: userConsents)
                    expect(consentViewController.localStorage.userConsents).to(equal(userConsents))
                    expect(consentViewController.userConsents).to(equal(userConsents))
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

            context("Test gdprPMWillShow delegate method") {
                it("Test GDPRMessageViewController calls gdprPMWillShow delegate method") {
                    consentViewController.gdprPMWillShow()
                    expect(mockConsentDelegate.isGdprPMWillShowCalled).to(equal(true), description: "gdprPMWillShow delegate method calls successfully")
                }
            }

            context("Test gdprPMDidDisappear delegate method") {
                it("Test GDPRMessageViewController calls gdprPMDidDisappear delegate method") {
                    consentViewController.gdprPMDidDisappear()
                    expect(mockConsentDelegate.isGdprPMDidDisappearCalled).to(equal(true), description: "gdprPMDidDisappear delegate method calls successfully")
                }
            }
        }

        describe("Test Add/Remove MessageViewController") {
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
