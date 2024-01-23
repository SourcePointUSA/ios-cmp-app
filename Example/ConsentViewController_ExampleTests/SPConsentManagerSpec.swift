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

// swiftlint:disable force_try function_body_length line_length

class SPConsentManagerSpec: QuickSpec {
    var wrapperHost: String {
        Constants.prod ? "cdn.privacy-mgmt.com" : "preprod-cdn.privacy-mgmt.com"
    }

    override func spec() {
        let accountId = 22, propertyId = 16_893
        let propertyName = try! SPPropertyName("mobile.multicampaign.demo")
        let campaigns = SPCampaigns(
            gdpr: SPCampaign(),
            ccpa: SPCampaign(),
            usnat: SPCampaign()
        )

        var manager = SPConsentManager(
            accountId: accountId,
            propertyId: propertyId,
            propertyName: propertyName,
            campaigns: campaigns,
            delegate: nil
        )

        beforeEach {
            SPConsentManager.clearAllData()
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
            beforeEach {
                manager.messageLanguage = .Spanish
            }

            let idfaStatus = manager.idfaStatus.description
            let usedId = "1"

            describe("gdpr") {
                it("build URL with the right parameters") {
                    expect(manager.buildGDPRPmUrl(usedId: usedId, uuid: nil)?.absoluteString)
                        .to(equal("https://\(self.wrapperHost)/privacy-manager/index.html?consentLanguage=ES&idfaStatus=\(idfaStatus)&message_id=1&pmTab=&site_id=\(propertyId)"))
                }

                describe("when there's uuid") {
                    it("includes the uuid query param") {
                        expect(manager.buildGDPRPmUrl(usedId: usedId, uuid: "gdprUUID")?.absoluteString)
                            .to(equal("https://\(self.wrapperHost)/privacy-manager/index.html?consentLanguage=ES&idfaStatus=\(idfaStatus)&message_id=1&pmTab=&site_id=\(propertyId)&uuid=gdprUUID"))
                    }
                }
            }

            describe("ccpa") {
                it("build URL with the right parameters") {
                    expect(manager.buildCCPAPmUrl(usedId: "1", uuid: nil)?.absoluteString)
                        .to(equal("https://\(self.wrapperHost)/ccpa_pm/index.html?consentLanguage=ES&idfaStatus=\(idfaStatus)&message_id=1&pmTab=&site_id=\(propertyId)"))
                }

                describe("when there's uuid") {
                    it("includes the uuid query param") {
                        expect(manager.buildCCPAPmUrl(usedId: usedId, uuid: "ccpaUUID")?.absoluteString)
                            .to(equal("https://\(self.wrapperHost)/ccpa_pm/index.html?ccpaUUID=ccpaUUID&consentLanguage=ES&idfaStatus=\(idfaStatus)&message_id=1&pmTab=&site_id=\(propertyId)"))
                    }
                }
            }

            describe("usnat") {
                it("build URL with the right parameters") {
                    expect(manager.buildUSNatPmUrl(usedId: "1", uuid: nil)?.absoluteString)
                        .to(equal("https://\(self.wrapperHost)/us_pm/index.html?consentLanguage=ES&idfaStatus=\(idfaStatus)&message_id=1&pmTab=&site_id=\(propertyId)"))
                }

                describe("when there's uuid") {
                    it("includes the uuid query param") {
                        expect(manager.buildUSNatPmUrl(usedId: usedId, uuid: "usnatUUID")?.absoluteString)
                            .to(equal("https://\(self.wrapperHost)/us_pm/index.html?consentLanguage=ES&idfaStatus=\(idfaStatus)&message_id=1&pmTab=&site_id=\(propertyId)&uuid=usnatUUID"))
                    }
                }
            }
        }

        describe("userData") {
            it("has default data before loadMessage is called") {
                let userData = manager.userData
                expect(userData.gdpr).to(equal(SPConsent(consents: SPGDPRConsent.empty(), applies: false)))
                expect(userData.ccpa).to(equal(SPConsent(consents: SPCCPAConsent.empty(), applies: false)))
                expect(userData.usnat).to(equal(SPConsent(consents: SPUSNatConsent.empty(), applies: false)))
            }

            it("returns cached data if there's some") {
                let cachedUserData = SPUserData(
                    gdpr: .init(consents: SPGDPRConsent.empty(), applies: true),
                    ccpa: .init(consents: SPCCPAConsent.empty(), applies: true),
                    usnat: .init(consents: SPUSNatConsent.empty(), applies: true)
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

        it("stores legislation data when there are no messages to show") {
            let coordinatorMock = CoordinatorMock()
            let gdpr = SPConsent(consents: SPGDPRConsent.empty(), applies: false)
            gdpr.consents?.tcfData = try! SPJson(["tcf key": "tcf value"])
            let ccpa = SPConsent(consents: SPCCPAConsent.empty(), applies: false)
            ccpa.consents?.GPPData = try! SPJson([
                "ccpa gpp key": "ccpa gpp value",
                "common gpp key": "common ccpa"
            ])
            let usnat = SPConsent(consents: SPUSNatConsent.empty(), applies: false)
            usnat.consents?.GPPData = try! SPJson([
                "usnat gpp key": "usnat gpp value",
                "common gpp key": "common usnat"
            ])

            let userData = SPUserData(
                gdpr: gdpr,
                ccpa: ccpa,
                usnat: usnat
            )
            coordinatorMock.loadMessagesResult = .success(([], userData))
            manager.spCoordinator = coordinatorMock

            manager.loadMessage(forAuthId: nil, pubData: nil)

            let storedValuePairs = UserDefaults.standard.dictionaryRepresentation().map {
                [$0.key, $0.value as? String]
            }
            expect(storedValuePairs).toEventually(contain([SPUserDefaults.US_PRIVACY_STRING_KEY, userData.ccpa?.consents?.uspstring]))
            expect(storedValuePairs).toEventually(contain(["tcf key", "tcf value"]))
            expect(storedValuePairs).toEventually(contain(["ccpa gpp key", "ccpa gpp value"]))
            expect(storedValuePairs).toEventually(contain(["usnat gpp key", "usnat gpp value"]))

            // asserts that if ccpa gpp data has a key in common with usnat gpp data, usnat
            // gpp data is the one stored
            expect(storedValuePairs).toEventually(contain(["common gpp key", "common usnat"]))
            expect(storedValuePairs).toEventuallyNot(contain(["common gpp key", "common ccpa"]))
        }
    }
}
