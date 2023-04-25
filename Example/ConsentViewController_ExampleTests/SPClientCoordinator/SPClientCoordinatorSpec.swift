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

        var coordinator: SPClientCoordinator!

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

        describe("authenticated consent") {
            it("only changes consent uuid after a different auth id is used") {
                waitUntil { done in
                    coordinator.loadMessages(forAuthId: nil) { guestUserResponse in
                        let (_, guestUserData) = try! guestUserResponse.get()
                        let guestGDPRUUID = guestUserData.gdpr?.consents?.uuid
                        let guestCCPAUUID = guestUserData.ccpa?.consents?.uuid
                        expect(guestGDPRUUID).to(beNil())
                        expect(guestCCPAUUID).to(beNil())

                        coordinator.loadMessages(forAuthId: UUID().uuidString) { loggedInResponse in
                            let (_, loggedInUserData) = try! loggedInResponse.get()
                            let loggedInGDPRUUID = loggedInUserData.gdpr?.consents?.uuid
                            let loggedInCCPAUUID = loggedInUserData.ccpa?.consents?.uuid
                            expect(loggedInGDPRUUID).notTo(beNil())
                            expect(loggedInCCPAUUID).notTo(beNil())

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
