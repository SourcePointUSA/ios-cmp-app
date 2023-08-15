//
//  SPClientCoordinatorSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 06.02.23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

@testable import ConsentViewController
import Foundation
import Nimble
import Quick

// swiftlint:disable force_try function_body_length

class SPClientCoordinatorSpec: QuickSpec {
    override func spec() {
        SPConsentManager.clearAllData()

        let accountId = 22, propertyId = 16_893
        let propertyName = try! SPPropertyName("mobile.multicampaign.demo")
        let campaigns = SPCampaigns(gdpr: SPCampaign(), ccpa: SPCampaign())
        var spClientMock: SourcePointClientMock!
        var coordinator: SourcepointClientCoordinator!

        beforeSuite {
            Nimble.AsyncDefaults.timeout = .seconds(30)
            Nimble.AsyncDefaults.pollInterval = .milliseconds(100)
        }

        afterSuite {
            Nimble.AsyncDefaults.timeout = .seconds(1)
            Nimble.AsyncDefaults.pollInterval = .milliseconds(10)
        }

        beforeEach {
            coordinator = SourcepointClientCoordinator(
                accountId: accountId,
                propertyName: propertyName,
                propertyId: propertyId,
                campaigns: campaigns,
                storage: LocalStorageMock()
            )
        }

        describe("a property with GDPR and CCPA campaigns") {
            describe("loadMessage") {
                it("should return gpoupPmId from metaData and save") {
                    coordinator = SourcepointClientCoordinator(
                        accountId: 22,
                        propertyName: try! SPPropertyName("mobile.prop-1"),
                        propertyId: 24188,
                        campaigns: SPCampaigns(
                            gdpr: SPCampaign(groupPmId: "613056"),
                            ccpa: SPCampaign()
                        ),
                        storage: LocalStorageMock()
                    )
                    waitUntil { done in
                        coordinator.loadMessages(forAuthId: nil, pubData: nil) { result in
                            switch result {
                            case .success(let (_, consents)):
                                    expect(consents.gdpr?.consents?.applies).to(beTrue())
                                    expect(consents.gdpr?.consents?.euconsent).notTo(beEmpty())
                                    expect(consents.gdpr?.consents?.vendorGrants).notTo(beEmpty())
                                    expect(consents.ccpa?.consents?.uspstring) == "1---"

                                case .failure(let error):
                                    fail(error.failureReason)
                            }
                            expect(coordinator.storage.gdprChildPmId)=="613057"
                            done()
                        }
                    }
                }
                it("should return 2 messages and consents") {
                    waitUntil { done in
                        coordinator.loadMessages(forAuthId: nil, pubData: nil) { result in
                            switch result {
                                case .success(let (messages, consents)):
                                    expect(messages.count) == 2
                                    expect(consents.gdpr?.consents?.applies).to(beTrue())
                                    expect(consents.gdpr?.consents?.euconsent).notTo(beEmpty())
                                    expect(consents.gdpr?.consents?.vendorGrants).notTo(beEmpty())
                                    expect(consents.ccpa?.consents?.uspstring) == "1YNN"

                                    // TODO: remove this conditional once GPP changes are in prod
                                    if prod {
                                        expect(consents.ccpa?.consents?.GPPData.dictionaryValue).to(beEmpty())
                                    } else {
                                        expect(consents.ccpa?.consents?.GPPData.dictionaryValue).notTo(beEmpty())
                                    }

                                case .failure(let error):
                                    fail(error.failureReason)
                            }
                            done()
                        }
                    }
                }
            }

            describe("reportAction") {
                beforeEach {
                    spClientMock = SourcePointClientMock(
                        accountId: accountId,
                        propertyName: propertyName,
                        campaignEnv: .Public,
                        timeout: 999
                    )
                    coordinator = SourcepointClientCoordinator(
                        accountId: accountId,
                        propertyName: propertyName,
                        propertyId: propertyId,
                        campaigns: campaigns,
                        storage: LocalStorageMock(),
                        spClient: spClientMock
                    )
                }

                it("should include pubData in its payload for GDPR") {
                    let gdprAction = SPAction(type: .AcceptAll, campaignType: .gdpr)
                    gdprAction.encodablePubData = ["foo": .init("gdpr")]

                    waitUntil { done in
                        coordinator.reportAction(gdprAction) { response in
                            switch response {
                                case .failure: fail("failed reporting gdpr action")

                                case .success:
                                    expect(spClientMock.postGDPRActionCalled).to(beTrue())
                                    let body = spClientMock.postGDPRActionCalledWith["body"] as? GDPRChoiceBody
                                    expect(body?.pubData).to(equal(gdprAction.encodablePubData))
                            }
                            done()
                        }
                    }
                }

                it("should include pubData in its payload for CCPA") {
                    let ccpaAction = SPAction(type: .AcceptAll, campaignType: .ccpa)
                    ccpaAction.encodablePubData = ["foo": .init("ccpa")]

                    waitUntil { done in
                        coordinator.reportAction(ccpaAction) { response in
                            switch response {
                                case .failure: fail("failed reporting ccpa action")

                                case .success:
                                    expect(spClientMock.postCCPAActionCalled).to(beTrue())
                                    let body = spClientMock.postCCPAActionCalledWith["body"] as? CCPAChoiceBody
                                    expect(body?.pubData).to(equal(ccpaAction.encodablePubData))
                            }
                            done()
                        }
                    }
                }
            }
        }

        describe("resetStateIfAuthIdChanged") {
            describe("when previous auth Id is nil and new auth id is different than nil") {
                it("does not reset state and sets stored auth id to the new one") {
                    coordinator.state.storedAuthId = nil
                    let gdprCampaignState = coordinator.state.gdpr
                    let gdprMetadataState = coordinator.state.gdprMetaData
                    let ccpaCampaignState = coordinator.state.ccpa
                    let ccpaMetadataState = coordinator.state.ccpaMetaData

                    coordinator.authId = "foo"
                    coordinator.resetStateIfAuthIdChanged()

                    expect(gdprCampaignState).to(be(coordinator.state.gdpr))
                    expect(gdprMetadataState).to(equal(coordinator.state.gdprMetaData))
                    expect(ccpaCampaignState).to(be(coordinator.state.ccpa))
                    expect(ccpaMetadataState).to(equal(coordinator.state.ccpaMetaData))
                    expect(coordinator.state.storedAuthId).to(equal("foo"))
                }
            }

            describe("when new auth id is nil") {
                it("does not reset state nor stored auth id") {
                    coordinator.state.storedAuthId = "foo"
                    let gdprCampaignState = coordinator.state.gdpr
                    let gdprMetadataState = coordinator.state.gdprMetaData
                    let ccpaCampaignState = coordinator.state.ccpa
                    let ccpaMetadataState = coordinator.state.ccpaMetaData

                    coordinator.authId = nil
                    coordinator.resetStateIfAuthIdChanged()

                    expect(gdprCampaignState).to(be(coordinator.state.gdpr))
                    expect(gdprMetadataState).to(equal(coordinator.state.gdprMetaData))
                    expect(ccpaCampaignState).to(be(coordinator.state.ccpa))
                    expect(ccpaMetadataState).to(equal(coordinator.state.ccpaMetaData))
                    expect(coordinator.state.storedAuthId).to(equal("foo"))
                }
            }

            describe("when previous stored auth id is different than current auth id (and both are not nil)") {
                it("resets state and overwrites stored auth id with the new one") {
                    coordinator.state.storedAuthId = "foo"
                    let gdprCampaignState = coordinator.state.gdpr
                    let gdprMetadataState = coordinator.state.gdprMetaData
                    let ccpaCampaignState = coordinator.state.ccpa
                    // changing a single value so we can see it has changed in the expectations below
                    coordinator.state.ccpaMetaData?.sampleRate = 0.5
                    let ccpaMetadataState = coordinator.state.ccpaMetaData

                    coordinator.authId = "bar"
                    coordinator.resetStateIfAuthIdChanged()

                    expect(gdprCampaignState).notTo(be(coordinator.state.gdpr))
                    expect(gdprMetadataState).notTo(equal(coordinator.state.gdprMetaData))
                    expect(ccpaCampaignState).notTo(be(coordinator.state.ccpa))
                    expect(ccpaMetadataState).notTo(equal(coordinator.state.ccpaMetaData))
                    expect(coordinator.state.storedAuthId).to(equal("bar"))
                }
            }
        }

        describe("authenticated consent") {
            it("only changes consent uuid after a different auth id is used") {
                waitUntil { done in
                    coordinator.loadMessages(forAuthId: nil, pubData: nil) { _ in
                        // uuids are only set after /pv-data is called, and /pv-data
                        // is called right after /messages.
                        // That's why we get the uuid from state instead of uuid from
                        // message's response
                        let guestGDPRUUID = coordinator.state.gdpr?.uuid
                        let guestCCPAUUID = coordinator.state.ccpa?.uuid

                        expect(guestGDPRUUID).notTo(beNil())
                        expect(guestCCPAUUID).notTo(beNil())

                        coordinator.loadMessages(forAuthId: UUID().uuidString, pubData: nil) { loggedInResponse in
                            let (_, loggedInUserData) = try! loggedInResponse.get()
                            let loggedInGDPRUUID = loggedInUserData.gdpr?.consents?.uuid
                            let loggedInCCPAUUID = loggedInUserData.ccpa?.consents?.uuid
                            expect(loggedInGDPRUUID).to(equal(guestGDPRUUID))
                            expect(loggedInCCPAUUID).to(equal(guestCCPAUUID))

                            coordinator.loadMessages(forAuthId: nil, pubData: nil) { loggedOutResponse in
                                let (_, loggedOutUserData) = try! loggedOutResponse.get()
                                let loggedOutGDPRUUID = loggedOutUserData.gdpr?.consents?.uuid
                                let loggedOutCCPAUUID = loggedOutUserData.ccpa?.consents?.uuid
                                expect(loggedInGDPRUUID).to(equal(loggedOutGDPRUUID))
                                expect(loggedInCCPAUUID).to(equal(loggedOutCCPAUUID))

                                coordinator.loadMessages(forAuthId: UUID().uuidString, pubData: nil) { differentUserResponse in
                                    let (_, differentUserData) = try! differentUserResponse.get()
                                    let differentUserGDPRUUID = differentUserData.gdpr?.consents?.uuid
                                    let differentUserCCPAUUID = differentUserData.ccpa?.consents?.uuid
                                    expect(differentUserGDPRUUID).notTo(equal(loggedOutGDPRUUID))
                                    expect(differentUserCCPAUUID).notTo(equal(loggedOutCCPAUUID))

                                    done()
                                }
                            }
                        }
                    }
                }
            }
        }

        describe("when user has consent stored") {
            it("keeps it unchanged after calling loadMessage") {
                SPConsentManager.clearAllData()

                waitUntil { done in
                    coordinator.loadMessages(forAuthId: nil, pubData: nil) { messagesResponse in
                        let (_, messagesUserData) = try! messagesResponse.get()

                        coordinator.reportAction(SPAction(type: .RejectAll, campaignType: .gdpr)) { actionResult in
                            let actionUserData = try! actionResult.get()
                            expect(messagesUserData).notTo(equal(actionUserData))

                            coordinator.loadMessages(forAuthId: nil, pubData: nil) { secondMessagesResponse in
                                let (_, secMessagesUserData) = try! secondMessagesResponse.get()

                                expect(secMessagesUserData).to(equal(actionUserData))
                                done()
                            }
                        }
                    }
                }
            }
        }
    }
}
