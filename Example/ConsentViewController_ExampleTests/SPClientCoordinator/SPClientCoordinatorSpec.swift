//
//  SPClientCoordinatorSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 06.02.23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import ConsentViewController

// swiftlint:disable force_try

class SPClientCoordinatorSpec: QuickSpec {
    override func spec() {
        describe("a property without campaigns") {
            SPConsentManager.clearAllData()

            let coordinator: SPClientCoordinator = SourcepointClientCoordinator(
                accountId: 22,
                propertyName: try! SPPropertyName("mobile.multicampaign.demo"),
                propertyId: 16893,
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
                                    expect(messages.count).to(equal(2))
                                    expect(consents.gdpr?.consents?.euconsent).notTo(beEmpty())
                                    expect(consents.gdpr?.consents?.vendorGrants).notTo(beEmpty())
                                    expect(consents.ccpa?.consents?.uspstring).to(equal("1YNN"))
                                    expect(defaults.integer(forKey: "IABTCF_gdprApplies")).to(equal(1))
                                    expect(defaults.string(forKey: "IABUSPrivacy_String")).to(equal("1YNN"))
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
