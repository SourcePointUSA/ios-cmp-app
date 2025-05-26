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

// swiftlint:disable force_unwrapping force_try function_body_length file_length type_body_length cyclomatic_complexity

class SPClientCoordinatorSpec: QuickSpec {
    override func spec() {
        SPConsentManager.clearAllData()

        let accountId = 22, propertyId = 16893
        let propertyName = try! SPPropertyName("mobile.multicampaign.demo")
        var coordinator: SourcepointClientCoordinator!

        func coordinatorFor(
            accountId: Int = accountId,
            propertyName: ConsentViewController.SPPropertyName = propertyName,
            propertyId: Int = propertyId,
            campaigns: ConsentViewController.SPCampaigns,
            spClient: SourcePointProtocol? = nil,
            storage: SPLocalStorage = LocalStorageMock()
        ) -> SourcepointClientCoordinator {
            SourcepointClientCoordinator(
                accountId: accountId,
                propertyName: propertyName,
                propertyId: propertyId,
                campaigns: campaigns,
                storage: storage,
                spClient: spClient
            )
        }

        beforeSuite {
            Nimble.AsyncDefaults.timeout = .seconds(5)
            Nimble.AsyncDefaults.pollInterval = .milliseconds(100)
        }

        afterSuite {
            Nimble.AsyncDefaults.timeout = .seconds(1)
            Nimble.AsyncDefaults.pollInterval = .milliseconds(10)
        }

        describe("a property with USNat campaign") {
            describe("handles ccpa opt-outs") {
                describe("and there is ccpa consent data") {
                    // FIXME: waiting on an API deploy to fix this issue
                    xit("returns a rejected-all usnat consent") {
                        let storage = LocalStorageMock()
                        let campaignsWithCCPA = SPCampaigns(ccpa: SPCampaign())
                        let campaignsWithUSNat = SPCampaigns(usnat: SPCampaign())
                        coordinator = coordinatorFor(campaigns: campaignsWithCCPA, storage: storage)

                        waitUntil { done in
                            coordinator.loadMessages(forAuthId: nil, pubData: nil) { _ in
                                coordinator.reportAction(SPAction(type: .RejectAll, campaignType: .ccpa)) { _ in
                                    expect(coordinator.state.ccpa?.uuid).notTo(beNil())
                                    coordinator = coordinatorFor(campaigns: campaignsWithUSNat, storage: storage)

                                    coordinator.loadMessages(forAuthId: nil, pubData: nil) { response in
                                        let messages = try! response.get()
                                        expect(messages).to(beEmpty())
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
}
