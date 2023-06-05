//
//  SPConsentManagerSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by main on 01/06/2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

@testable import ConsentViewController
import Foundation
import Nimble
import Quick

// swiftlint:disable force_try

class SPConsentManagerSpec: QuickSpec {
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

        describe("selectPrivacyManagerId") {
            it("сhecks logic of selectPrivacyManagerId") {
                var manager = SPConsentManager(accountId: 1, propertyId: 1, propertyName: coordinator.propertyName, campaigns: coordinator.campaigns, delegate: nil)
                expect(manager.selectPrivacyManagerId(fallbackId: "1", groupPmId: "2", childPmId: "3"))=="3"
                expect(manager.selectPrivacyManagerId(fallbackId: "1", groupPmId: nil, childPmId: "3"))=="1"
                expect(manager.selectPrivacyManagerId(fallbackId: "1", groupPmId: "2", childPmId: nil))=="1"
                expect(manager.selectPrivacyManagerId(fallbackId: "1", groupPmId: nil, childPmId: nil))=="1"
            }
        }

        describe("buildPrivacyManagerUrl") {
            describe("gdpr") {
                it("build URL with the right parameters") {
                    var manager = SPConsentManager(accountId: 1, propertyId: 1, propertyName: coordinator.propertyName, campaigns: coordinator.campaigns, delegate: nil)
                    manager.messageLanguage = .Spanish
                    var idfaStatus: String = manager.idfaStatus.description
                    var pmUrl = manager.buildGDPRPmUrl(usedId: "1")

                    let testUrl = "https://cdn.privacy-mgmt.com/privacy-manager/index.html?consentLanguage=ES&consentUUID&idfaStatus=\(idfaStatus)&message_id=1&pmTab=&site_id=1"

                    expect(pmUrl?.absoluteString)==testUrl
                }
            }
            describe("ccpa") {
                it("build URL with the right parameters") {
                    var manager = SPConsentManager(accountId: 1, propertyId: 1, propertyName: coordinator.propertyName, campaigns: coordinator.campaigns, delegate: nil)
                    manager.messageLanguage = .Spanish
                    var idfaStatus: String = manager.idfaStatus.description
                    var pmUrl = manager.buildCCPAPmUrl(usedId: "1")

                    let testUrl = "https://cdn.privacy-mgmt.com/ccpa_pm/index.html?consentLanguage=ES&consentUUID&idfaStatus=\(idfaStatus)&message_id=1&pmTab=&site_id=1"

                    expect(pmUrl?.absoluteString)==testUrl
                }
            }
        }
    }
}
