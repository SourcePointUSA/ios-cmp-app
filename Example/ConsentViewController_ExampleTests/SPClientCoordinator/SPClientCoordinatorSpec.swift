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

// swiftlint:disable force_try

class SPClientCoordinatorSpec: QuickSpec {
    override func spec() {
        describe("a property without campaigns") {
            SPConsentManager.clearAllData()

            let coordinator: SPClientCoordinator = SourcepointClientCoordinator(
                accountId: 22,
                propertyName: try! SPPropertyName("mobile.multicampaign.demo"),
                propertyId: 16_893,
                campaigns: SPCampaigns(
                    gdpr: SPCampaign(),
                    ccpa: SPCampaign()
                )
            )

            let defaults = UserDefaults.standard

            describe("loadMessage") {
                it("should return 2 messages and consents") {
                    waitUntil { done in
                        coordinator.loadMessages(forAuthId: nil) { result in
                            switch result {
                                case .success(let (messages, consents)):
                                    expect(messages.count) == 2
                                    expect(consents.gdpr?.consents?.euconsent).notTo(beEmpty())
                                    expect(consents.gdpr?.consents?.vendorGrants).notTo(beEmpty())
                                    expect(consents.ccpa?.consents?.uspstring) == "1YNN"
                                    expect(defaults.integer(forKey: "IABTCF_gdprApplies")) == 1
                                    expect(defaults.string(forKey: "IABUSPrivacy_String")) == "1YNN"
                                case .failure(let error):
                                    fail(error.failureReason)
                            }
                            done()
                        }
                    }
                }
            }
        }
    }
}
