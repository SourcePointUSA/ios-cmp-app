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
                accountId: 22,
                propertyName: try! SPPropertyName("mobile.multicampaign.demo"),
                propertyId: 16_893,
                campaigns: SPCampaigns(
                    gdpr: SPCampaign(),
                    ccpa: SPCampaign()
                ),
                storage: LocalStorageMock()
            )
        }

        describe("a property with GDPR and CCPA campaigns") {
            describe("loadMessage") {
                it("should return 2 messages and consents") {
                    waitUntil { done in
                        coordinator.loadMessages(forAuthId: nil) { result in
                            switch result {
                                case .success(let (messages, consents)):
                                    expect(messages.count) == 2
                                    expect(consents.gdpr?.consents?.applies).to(beTrue())
                                    expect(consents.gdpr?.consents?.euconsent).notTo(beEmpty())
                                    expect(consents.gdpr?.consents?.vendorGrants).notTo(beEmpty())
                                    expect(consents.ccpa?.consents?.uspstring) == "1YNN"
                                case .failure(let error):
                                    fail(error.failureReason)
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
                    coordinator.loadMessages(forAuthId: nil) { guestUserResponse in
                        let (_, guestUserData) = try! guestUserResponse.get()
                        let guestGDPRUUID = guestUserData.gdpr?.consents?.uuid
                        let guestCCPAUUID = guestUserData.ccpa?.consents?.uuid
                        expect(guestGDPRUUID).notTo(beNil())
                        expect(guestCCPAUUID).notTo(beNil())

                        coordinator.loadMessages(forAuthId: UUID().uuidString) { loggedInResponse in
                            let (_, loggedInUserData) = try! loggedInResponse.get()
                            let loggedInGDPRUUID = loggedInUserData.gdpr?.consents?.uuid
                            let loggedInCCPAUUID = loggedInUserData.ccpa?.consents?.uuid
                            expect(loggedInGDPRUUID).to(equal(guestGDPRUUID))
                            expect(loggedInCCPAUUID).to(equal(guestCCPAUUID))

                            coordinator.loadMessages(forAuthId: nil) { loggedOutResponse in
                                let (_, loggedOutUserData) = try! loggedOutResponse.get()
                                let loggedOutGDPRUUID = loggedOutUserData.gdpr?.consents?.uuid
                                let loggedOutCCPAUUID = loggedOutUserData.ccpa?.consents?.uuid
                                expect(loggedInGDPRUUID).to(equal(loggedOutGDPRUUID))
                                expect(loggedInCCPAUUID).to(equal(loggedOutCCPAUUID))

                                coordinator.loadMessages(forAuthId: UUID().uuidString) { differentUserResponse in
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
    }
}
