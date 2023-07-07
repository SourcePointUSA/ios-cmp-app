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

// swiftlint:disable force_try function_body_length line_length force_unwrapping

class SPConsentManagerSpec: QuickSpec {
    override func spec() {
        let accountId = 22, propertyId = 16_893
        let propertyName = try! SPPropertyName("mobile.multicampaign.demo")
        let campaigns = SPCampaigns(gdpr: SPCampaign(), ccpa: SPCampaign())

        var manager: SPConsentManager!

        beforeSuite {
            SPConsentManager.clearAllData()
            Nimble.AsyncDefaults.timeout = .seconds(30)
            Nimble.AsyncDefaults.pollInterval = .milliseconds(100)
        }

        afterSuite {
            Nimble.AsyncDefaults.timeout = .seconds(1)
            Nimble.AsyncDefaults.pollInterval = .milliseconds(10)
        }

        beforeEach {
            manager = SPConsentManager(
                accountId: accountId,
                propertyId: propertyId,
                propertyName: propertyName,
                campaigns: campaigns,
                delegate: nil
            )
        }

        describe("selectPrivacyManagerId") {
            it("сhecks logic of selectPrivacyManagerId") {
                expect(manager.selectPrivacyManagerId(fallbackId: "1", groupPmId: "2", childPmId: "3")).to(equal("3"))
                expect(manager.selectPrivacyManagerId(fallbackId: "1", groupPmId: nil, childPmId: "3")).to(equal("1"))
                expect(manager.selectPrivacyManagerId(fallbackId: "1", groupPmId: "2", childPmId: nil)).to(equal("1"))
                expect(manager.selectPrivacyManagerId(fallbackId: "1", groupPmId: nil, childPmId: nil)).to(equal("1"))
            }
        }

        describe("buildPrivacyManagerUrl") {
            describe("gdpr") {
                it("build URL with the right parameters") {
                    manager.messageLanguage = .Spanish
                    let idfaStatus = manager.idfaStatus.description
                    let pmUrl = manager.buildGDPRPmUrl(usedId: "1")
                    let uuid = manager.userData.gdpr?.consents?.uuid
                    let uuidParam = uuid != nil ? "=\(uuid!)" : ""

                    let testUrl = "https://cdn.privacy-mgmt.com/privacy-manager/index.html?consentLanguage=ES&consentUUID\(uuidParam )&idfaStatus=\(idfaStatus)&message_id=1&pmTab=&site_id=\(propertyId)"

                    expect(pmUrl?.absoluteString).to(equal(testUrl))
                }
            }
            describe("ccpa") {
                it("build URL with the right parameters") {
                    manager.messageLanguage = .Spanish
                    let idfaStatus = manager.idfaStatus.description
                    let pmUrl = manager.buildCCPAPmUrl(usedId: "1")
                    let uuid = manager.userData.ccpa?.consents?.uuid
                    let uuidParam = uuid != nil ? "=\(uuid!)" : ""

                    let testUrl = "https://cdn.privacy-mgmt.com/ccpa_pm/index.html?ccpaUUID\(uuidParam)&consentLanguage=ES&idfaStatus=\(idfaStatus)&message_id=1&pmTab=&site_id=\(propertyId)"

                    expect(pmUrl?.absoluteString).to(equal(testUrl))
                }
            }
        }

        describe("userData") {
            it("has default data before loadMessage is called") {
                let userData = manager.userData
                expect(userData.gdpr).to(equal(SPConsent(consents: SPGDPRConsent.empty(), applies: false)))
                expect(userData.ccpa).to(equal(SPConsent(consents: SPCCPAConsent.empty(), applies: false)))
            }

            it("returns cached data if there's some") {
                let cachedUserData = SPUserData(
                    gdpr: .init(
                        consents: .init(
                            uuid: "GDPR uuid",
                            vendorGrants: [:],
                            euconsent: "",
                            tcfData: SPJson()
                        ),
                        applies: true
                    ),
                    ccpa: .init(
                        consents: .init(
                            uuid: "CCPA uuid",
                            status: .Unknown,
                            rejectedVendors: [],
                            rejectedCategories: [],
                            signedLspa: true
                        ),
                        applies: true
                    )
                )
                let mockStorage = LocalStorageMock()
                mockStorage.userData = cachedUserData
                let mockCoordinator = SourcepointClientCoordinator(
                    accountId: accountId,
                    propertyName: propertyName,
                    propertyId: propertyId,
                    campaigns: campaigns,
                    storage: mockStorage
                )
                manager = SPConsentManager(
                    propertyId: propertyId,
                    campaigns: campaigns,
                    language: .BrowserDefault,
                    delegate: nil,
                    spClient: SourcePointClientMock(
                        accountId: accountId,
                        propertyName: propertyName,
                        campaignEnv: .Public,
                        timeout: 999
                    ),
                    storage: mockStorage,
                    spCoordinator: mockCoordinator
                )
                expect(manager.userData).to(equal(cachedUserData))
            }
        }
    }
}
