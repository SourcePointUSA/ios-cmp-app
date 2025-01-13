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
import SPMobileCore

// swiftlint:disable force_unwrapping force_try function_body_length file_length type_body_length cyclomatic_complexity

class SPClientCoordinatorSpec: QuickSpec {
    override func spec() {
        SPConsentManager.clearAllData()

        let accountId = 22, propertyId = 16893
        let propertyName = try! SPPropertyName("mobile.multicampaign.demo")
        let gdprCcpaCampaigns = SPCampaigns(gdpr: SPCampaign(), ccpa: SPCampaign())
        var spClientMock: SourcePointClientMock!
        var coordinator: SourcepointClientCoordinator!

        func coordinatorFor(
            accountId: Int = accountId,
            propertyName: SPPropertyName = propertyName,
            propertyId: Int = propertyId,
            campaigns: SPCampaigns,
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

        beforeEach {
            coordinator = coordinatorFor(campaigns: gdprCcpaCampaigns)
        }

        describe("a property with GDPR and CCPA campaigns") {
            describe("loadMessage") {
                it("should return gpoupPmId from metaData and save") {
                    coordinator = coordinatorFor(
                        propertyName: try! SPPropertyName("mobile.prop-1"),
                        propertyId: 24188,
                        campaigns: SPCampaigns(
                            gdpr: SPCampaign(groupPmId: "613056"),
                            ccpa: SPCampaign()
                        )
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
                                    fail(error.description)
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
                                    expect(consents.ccpa?.consents?.GPPData.dictionaryValue).notTo(beEmpty())

                                case .failure(let error):
                                    fail(error.description)
                            }
                            done()
                        }
                    }
                }

                it("calls pv-data with correct values") {
                    spClientMock = SourcePointClientMock(
                        accountId: accountId,
                        propertyName: propertyName,
                        propertyId: propertyId,
                        campaignEnv: .Public,
                        timeout: 999
                    )
                    spClientMock.messagesResponse = .init(
                        propertyId: 0,
                        localState: SPJson(),
                        campaigns: [
                            .init(
                                type: .gdpr,
                                url: URL(string: "https://example.com")!,
                                message: try? Message(
                                    propertyId: 0,
                                    language: nil,
                                    category: .gdpr,
                                    subCategory: .TCFv2,
                                    messageChoices: SPJson(),
                                    webMessageJson: SPJson(),
                                    categories: nil
                                ),
                                userConsent: .gdpr(consents: .empty()),
                                messageMetaData: .init(
                                    categoryId: .gdpr,
                                    subCategoryId: .TCFv2,
                                    messageId: "0",
                                    messagePartitionUUID: "bar"
                                ),
                                dateCreated: nil,
                                webConsentPayload: nil
                            )
                        ],
                        nonKeyedLocalState: SPJson()
                    )
                    spClientMock.metadataResponse = SPMobileCore.MetaDataResponse(
                        gdpr: SPMobileCore.MetaDataResponse.MetaDataResponseGDPR(
                            applies: true,
                            sampleRate: 1.0,
                            additionsChangeDate: SPDate.distantFuture().originalDateString,
                            legalBasisChangeDate: "",
                            childPmId: nil,
                            vendorListId: ""
                        ),
                        usnat: nil,
                        ccpa: nil
                    )
                    coordinator = coordinatorFor(
                        campaigns: SPCampaigns(gdpr: SPCampaign()),
                        spClient: spClientMock
                    )
                    coordinator.loadMessages(forAuthId: nil, pubData: nil) { _ in }
                    expect(spClientMock.pvDataCalled)
                        .toEventually(beTrue())
                    expect(spClientMock.pvDataCalledWith?.gdpr?.msgId)
                        .toEventually(equal(0))
                    expect(spClientMock.pvDataCalledWith?.gdpr?.prtnUUID)
                        .toEventually(equal("bar"))
                }
            }

            describe("reportAction") {
                beforeEach {
                    spClientMock = SourcePointClientMock(
                        accountId: accountId,
                        propertyName: propertyName,
                        propertyId: propertyId,
                        campaignEnv: .Public,
                        timeout: 999
                    )
                    coordinator = coordinatorFor(campaigns: gdprCcpaCampaigns, spClient: spClientMock)
                }

                it("should include right payload for GDPR") {
                    let gdprAction = SPAction(
                        type: .AcceptAll,
                        campaignType: .gdpr,
                        messageId: "1234"
                    )
                    gdprAction.encodablePubData = ["foo": .init("gdpr")]
                    let publisherData = JsonKt.encodeToJsonObject(gdprAction.encodablePubData.toCore())

                    waitUntil { done in
                        coordinator.reportAction(gdprAction) { response in
                            switch response {
                                case .failure: fail("failed reporting gdpr action")

                                case .success:
                                    expect(spClientMock.postGDPRActionCalled).to(beTrue())
                                    let request = spClientMock.postGDPRActionCalledWith?["request"] as? GDPRChoiceRequest
                                    expect(request?.pubData).to(equal(publisherData))
                                    expect(request?.messageId).to(equal("1234"))
                            }
                            done()
                        }
                    }
                }

                it("should include the right payload for CCPA") {
                    let ccpaAction = SPAction(
                        type: .AcceptAll,
                        campaignType: .ccpa,
                        messageId: "321"
                    )
                    ccpaAction.encodablePubData = ["foo": .init("ccpa")]
                    let publisherData = JsonKt.encodeToJsonObject(ccpaAction.encodablePubData.toCore())

                    waitUntil { done in
                        coordinator.reportAction(ccpaAction) { response in
                            switch response {
                                case .failure: fail("failed reporting ccpa action")

                                case .success:
                                    expect(spClientMock.postCCPAActionCalled).to(beTrue())
                                    let request = spClientMock.postCCPAActionCalledWith?["request"] as? CCPAChoiceRequest
                                    expect(request?.pubData).to(equal(publisherData))
                                    expect(request?.messageId).to(equal("321"))
                            }
                            done()
                        }
                    }
                }
            }
        }

        describe("consent-status") {
            it("is called when an authId is passed") {
                waitUntil { done in
                    spClientMock = SourcePointClientMock()
                    coordinator = coordinatorFor(campaigns: gdprCcpaCampaigns, spClient: spClientMock)
                    coordinator.loadMessages(forAuthId: "test", pubData: nil) { _ in
                        expect(spClientMock.consentStatusCalled).to(beTrue())
                        expect(coordinator.shouldCallConsentStatus).to(beTrue())
                        done()
                    }
                }
            }

            it("is called when the SDK detects local data from v6") {
                waitUntil { done in
                    let storage = LocalStorageMock()
                    storage.localState = try? SPJson([
                        "gdpr": [
                            "uuid": "test"
                        ]
                    ])
                    spClientMock = SourcePointClientMock()
                    coordinator = coordinatorFor(campaigns: gdprCcpaCampaigns, spClient: spClientMock, storage: storage)
                    coordinator.loadMessages(forAuthId: nil, pubData: nil) { _ in
                        expect(spClientMock.consentStatusCalled).to(beTrue())
                        done()
                    }
                }
            }

            describe("when local data is outdated") {
                describe("and it has NO uuid stored") {
                    it("consent-status is not called") {
                        waitUntil { done in
                            let storage = LocalStorageMock()
                            spClientMock = SourcePointClientMock()
                            storage.spState = SourcepointClientCoordinator.State(localVersion: 0)
                            coordinator = coordinatorFor(campaigns: gdprCcpaCampaigns, spClient: spClientMock, storage: storage)
                            coordinator.loadMessages(forAuthId: nil, pubData: nil) { _ in
                                expect(spClientMock.consentStatusCalled).to(beFalse())
                                done()
                            }
                        }
                    }
                }

                describe("and it has any uuid stored") {
                    it("consent-status is called") {
                        waitUntil { done in
                            let storage = LocalStorageMock()
                            let consents = SPGDPRConsent.empty()
                            consents.uuid = "test"
                            storage.spState = SourcepointClientCoordinator.State(
                                gdpr: consents,
                                localVersion: 0
                            )
                            spClientMock = SourcePointClientMock()
                            coordinator = coordinatorFor(campaigns: gdprCcpaCampaigns, spClient: spClientMock, storage: storage)
                            coordinator.loadMessages(forAuthId: nil, pubData: nil) { _ in
                                expect(spClientMock.consentStatusCalled).to(beTrue())
                                done()
                            }
                        }
                    }
                }

                it("is not called again after it's been called first time") {
                    waitUntil { done in
                        let storage = LocalStorageMock()
                        let consents = SPGDPRConsent.empty()
                        consents.uuid = "test"
                        storage.spState = SourcepointClientCoordinator.State(
                            gdpr: consents,
                            localVersion: 0
                        )
                        spClientMock = SourcePointClientMock()
                        coordinator = coordinatorFor(campaigns: gdprCcpaCampaigns, spClient: spClientMock, storage: storage)
                        coordinator.loadMessages(forAuthId: nil, pubData: nil) { _ in
                            expect(spClientMock.consentStatusCalled).to(beTrue())
                            spClientMock.consentStatusCalled = false

                            coordinator.loadMessages(forAuthId: nil, pubData: nil) { _ in
                                expect(spClientMock.consentStatusCalled).to(beFalse())
                                done()
                            }
                        }
                    }
                }
            }

            describe("when succeeds") {
                it("sets the localDataVersion attribute to be the same as the hardcoded one") {
                    waitUntil { done in
                        let storage = LocalStorageMock()
                        let consents = SPGDPRConsent.empty()
                        consents.uuid = "test"
                        storage.spState = SourcepointClientCoordinator.State(
                            gdpr: consents,
                            localVersion: 0
                        )
                        spClientMock = SourcePointClientMock()
                        coordinator = coordinatorFor(campaigns: gdprCcpaCampaigns, spClient: spClientMock, storage: storage)
                        coordinator.loadMessages(forAuthId: nil, pubData: nil) { _ in
                            expect(coordinator.state.localVersion)
                                .to(equal(SourcepointClientCoordinator.State.version))
                            done()
                        }
                    }
                }
            }

            describe("when it fails") {
                it("leaves localDataVersion as is") {
                    waitUntil { done in
                        let storage = LocalStorageMock()
                        let consents = SPGDPRConsent.empty()
                        consents.uuid = "test"
                        storage.spState = SourcepointClientCoordinator.State(
                            gdpr: consents,
                            localVersion: 0
                        )
                        spClientMock = SourcePointClientMock()
                        spClientMock.error = SPError()
                        coordinator = coordinatorFor(campaigns: gdprCcpaCampaigns, spClient: spClientMock, storage: storage)
                        coordinator.loadMessages(forAuthId: nil, pubData: nil) { _ in
                            expect(coordinator.state.localVersion).to(equal(0))
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
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                            // uuids are only set after /pv-data is called, and /pv-data
                            // is called right after /messages.
                            // That's why we need to wait a bit before making assertion
                            // against the state's uuids
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

                                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
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
            }
        }

        describe("when user has consent stored") {
            it("keeps it unchanged after calling loadMessage") {
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

            describe("and expiration date is greater than current date") {
                it("erases consent data and returns a message") {
                    waitUntil { done in
                        coordinator.loadMessages(forAuthId: nil, pubData: nil) { firstLoadMessages in
                            let (firstMessages, _) = try! firstLoadMessages.get()
                            expect(firstMessages.filter { $0.type == .gdpr }).notTo(beEmpty())
                            expect(firstMessages.filter { $0.type == .ccpa }).notTo(beEmpty())

                            coordinator.reportAction(SPAction(type: .AcceptAll, campaignType: .gdpr)) { _ in
                                coordinator.reportAction(SPAction(type: .AcceptAll, campaignType: .ccpa)) { _ in
                                    expect(coordinator.state.gdpr?.consentStatus.consentedToAny).to(beTrue())
                                    expect(coordinator.state.ccpa?.status).to(equal(.ConsentedAll))

                                    coordinator.loadMessages(forAuthId: nil, pubData: nil) { secondLoadMessages in
                                        let (secondMessages, _) = try! secondLoadMessages.get()
                                        expect(secondMessages.filter { $0.type == .gdpr }).to(beEmpty())
                                        expect(secondMessages.filter { $0.type == .ccpa }).to(beEmpty())
                                        expect(coordinator.state.gdpr?.consentStatus.consentedToAny).to(beTrue())
                                        expect(coordinator.state.ccpa?.status).to(equal(.ConsentedAll))

                                        coordinator.state.gdpr?.expirationDate = SPDate(date: .yesterday)
                                        coordinator.state.ccpa?.expirationDate = SPDate(date: .yesterday)

                                        coordinator.loadMessages(forAuthId: nil, pubData: nil) { thirdLoadMessages in
                                            let (thirdMessages, _) = try! thirdLoadMessages.get()
                                            expect(thirdMessages.filter { $0.type == .gdpr }).notTo(beEmpty())
                                            expect(thirdMessages.filter { $0.type == .ccpa }).notTo(beEmpty())
                                            expect(coordinator.state.gdpr?.consentStatus.consentedToAny).notTo(beTrue())
                                            expect(coordinator.state.ccpa?.status).to(equal(.RejectedNone))
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

        it("shouldCallGETChoice") {
            [
                SPAction(type: .AcceptAll, campaignType: .gdpr),
                SPAction(type: .RejectAll, campaignType: .gdpr),
                SPAction(type: .AcceptAll, campaignType: .ccpa),
                SPAction(type: .RejectAll, campaignType: .ccpa),
                SPAction(type: .AcceptAll, campaignType: .usnat),
                SPAction(type: .RejectAll, campaignType: .usnat)
            ].forEach {
                expect(coordinator.shouldCallGetChoice(for: $0))
                    .to(beTrue(), description: "For action \($0.type), \($0.campaignType.rawValue)")
            }

            [
                SPAction(type: .SaveAndExit, campaignType: .gdpr),
                SPAction(type: .SaveAndExit, campaignType: .ccpa),
                SPAction(type: .SaveAndExit, campaignType: .usnat)
            ].forEach {
                expect(coordinator.shouldCallGetChoice(for: $0))
                    .to(beFalse(), description: "For action \($0.type), \($0.campaignType.rawValue)")
            }
        }

        describe("a property with USNat campaign") {
            let saveAndExitAction = SPAction(
                type: .SaveAndExit,
                campaignType: .usnat,
                publisherData: ["foo": "bar"],
                pmPayload: try! SPJson([
                    "shownCategories": ["6568ae4503cf5cf81eb79fa5"],
                    "categories": ["6568ae4503cf5cf81eb79fa5"],
                    "lan": "EN",
                    "privacyManagerId": "943890",
                    "vendors": []
                ])
            )

            beforeEach {
                coordinator = coordinatorFor(campaigns: SPCampaigns(usnat: SPCampaign()))
            }

            describe("with the supportLegacyUSPString flag") {
                it("receives the IABUSPrivacy_String on GPPData") {
                    coordinator = coordinatorFor(
                        campaigns: SPCampaigns(
                            usnat: SPCampaign(supportLegacyUSPString: true)
                        )
                    )
                    waitUntil { done in
                        coordinator.loadMessages(forAuthId: nil, pubData: nil) { _ in
                            let optedOutUspString = "1YYN"
                            let optedInUspString = "1YNN"
                            let newUserUspString = coordinator.userData.usnat?.consents?.GPPData?["IABUSPrivacy_String"]?.stringValue
                            expect(newUserUspString).to(equal(optedOutUspString))

                            let saveAndExitAcceptAction = SPAction(
                                type: .SaveAndExit,
                                campaignType: .usnat,
                                pmPayload: try! SPJson([
                                    "shownCategories": [
                                        "65a6a785cc78fac48ab34e65",
                                        "65a6a785cc78fac48ab34e6a",
                                        "65a6a785cc78fac48ab34e6f",
                                        "65a6a785cc78fac48ab34e74",
                                        "65a6a785cc78fac48ab34e79",
                                        "65a6a785cc78fac48ab34e7e",
                                        "65a6a785cc78fac48ab34e83",
                                        "65a6a785cc78fac48ab34e88",
                                        "65a6a785cc78fac48ab34e8d",
                                        "65a6a785cc78fac48ab34e92",
                                        "65a6a785cc78fac48ab34e97",
                                        "65a6a785cc78fac48ab34e9c"
                                    ],
                                    "privacyManagerId": "995256",
                                    "lan": "EN",
                                    "vendors": [],
                                    "categories": [
                                        "65a6a785cc78fac48ab34e65",
                                        "65a6a785cc78fac48ab34e6a",
                                        "65a6a785cc78fac48ab34e6f",
                                        "65a6a785cc78fac48ab34e74",
                                        "65a6a785cc78fac48ab34e79",
                                        "65a6a785cc78fac48ab34e7e",
                                        "65a6a785cc78fac48ab34e83",
                                        "65a6a785cc78fac48ab34e88",
                                        "65a6a785cc78fac48ab34e8d",
                                        "65a6a785cc78fac48ab34e92",
                                        "65a6a785cc78fac48ab34e97",
                                        "65a6a785cc78fac48ab34e9c",
                                        "648c9c48e17a3c7a82360c54"
                                    ]
                                ])
                            )
                            coordinator.reportAction(saveAndExitAcceptAction) { result in
                                let actionUserData = try? result.get()
                                let actionUspString = actionUserData?.usnat?.consents?.GPPData?["IABUSPrivacy_String"]?.stringValue
                                expect(actionUspString).to(equal(optedInUspString))
                                done()
                            }
                        }
                    }
                }
            }

            describe("with authId") {
                it("persists consent even after cleaning all data") {
                    waitUntil { done in
                        let authId = UUID().uuidString

                        coordinator.loadMessages(forAuthId: authId, pubData: nil) { _ in
                        coordinator.reportAction(saveAndExitAction) { result in
                            let actionUserData = try? result.get()
                            let actionUuid = actionUserData?.usnat?.consents?.uuid
                            expect(actionUuid).notTo(beNil())
                            expect(coordinator.userData.usnat?.consents?.uuid).to(equal(actionUuid))

                            coordinator = coordinatorFor(campaigns: SPCampaigns(usnat: SPCampaign()))

                            expect(coordinator.userData.usnat?.consents?.uuid).to(beNil())
                                coordinator.loadMessages(forAuthId: authId, pubData: nil) { messagesResult in
                                    let (messages, userData) = try! messagesResult.get()
                                    expect(messages).to(beEmpty())
                                    expect(userData.usnat?.consents?.uuid).to(equal(actionUuid))

                                    done()
                                }
                            }
                        }
                    }
                }

                describe("and the transitionCCPAAuth campaign config is true") {
                    it("sets the flag transitionCCPAAuth in consent-status' metadata param") {
                        coordinator = coordinatorFor(campaigns: SPCampaigns(ccpa: SPCampaign()))
                        let ccpaAuthId = UUID().uuidString

                        waitUntil { done in
                            coordinator.loadMessages(forAuthId: ccpaAuthId, pubData: nil) { _ in
                                coordinator.reportAction(SPAction(type: .RejectAll, campaignType: .ccpa)) { actionResult in
                                    let userData = try? actionResult.get()
                                    expect(userData?.ccpa?.consents?.status).to(equal(.RejectedAll))

                                    coordinator = coordinatorFor(
                                        campaigns: SPCampaigns(usnat: SPCampaign(transitionCCPAAuth: true))
                                    )

                                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                                        coordinator.loadMessages(forAuthId: ccpaAuthId, pubData: nil) { usnatMessages in
                                            let (messages, usnatUserData) = try! usnatMessages.get()
                                            expect(messages).to(beEmpty())
                                            expect(usnatUserData.usnat?.consents?.consentStatus.rejectedAny).to(beTrue())
                                            expect(usnatUserData.usnat?.consents?.consentStatus.consentedToAll).to(beFalse())
                                            done()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            describe("handles ccpa opt-outs") {
                describe("when there's no authId") {
                    it("transitionCCPAAuth in consent-status' metadata param is nil") {
                        let spClientMock = SourcePointClientMock()
                        coordinator = coordinatorFor(
                            campaigns: SPCampaigns(usnat: SPCampaign(transitionCCPAAuth: true)),
                            spClient: spClientMock
                        )

                        waitUntil { done in
                            coordinator.loadMessages(forAuthId: nil, pubData: nil) { _ in
                                let consentStatusMetadata = spClientMock.consentStatusCalledWith?["metadata"] as? SPMobileCore.ConsentStatusRequest.MetaData
                                expect(consentStatusMetadata?.usnat?.transitionCCPAAuth).to(beNil())
                                done()
                            }
                        }
                    }
                }

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
                                    expect(coordinator.ccpaUUID).notTo(beNil())
                                    coordinator = coordinatorFor(campaigns: campaignsWithUSNat, storage: storage)

                                    coordinator.loadMessages(forAuthId: nil, pubData: nil) { response in
                                        let (messages, userData) = try! response.get()
                                        expect(messages).to(beEmpty())
                                        expect(userData.usnat?.consents?.uuid).notTo(beNil())
                                        done()
                                    }
                                }
                            }
                        }
                    }
                }
            }

            it("returns usnat consents data with applies true") {
                waitUntil { done in
                    coordinator.loadMessages(forAuthId: nil, pubData: nil) { result in
                        switch result {
                            case .success(let (messages, consents)):
                                expect(coordinator.state.usNatMetaData?.vendorListId).notTo(beNil())
                                expect(coordinator.state.usNatMetaData?.additionsChangeDate).notTo(beNil())
                                expect(consents.usnat?.consents?.applies).to(beTrue())
                                expect(consents.usnat?.consents?.consentStrings).notTo(beEmpty())
                                expect(consents.usnat?.consents?.webConsentPayload).notTo(beNil())
                                expect(consents.usnat?.consents?.GPPData?.dictionaryValue).notTo(beEmpty())
                                expect(messages).notTo(beEmpty())

                            case .failure(let error):
                                fail(error.description)
                        }
                        done()
                    }
                }
            }

            it("calls pv-data when calling loadMessage") {
                spClientMock = SourcePointClientMock(
                    accountId: accountId,
                    propertyName: propertyName,
                    propertyId: propertyId,
                    campaignEnv: .Public,
                    timeout: 999
                )
                coordinator = coordinatorFor(campaigns: SPCampaigns(usnat: SPCampaign()), spClient: spClientMock)
                coordinator.loadMessages(forAuthId: nil, pubData: nil) { _ in }
                expect(spClientMock.pvDataCalled).toEventually(beTrue())
            }

            describe("when calling reportAction") {
                it("returns a usnat consent") {
                    waitUntil { done in
                        coordinator.reportAction(saveAndExitAction) { result in
                            switch result {
                                case .success(let userData):
                                    expect(userData.usnat?.consents?.uuid).notTo(beNil())
                                    expect(coordinator.userData.usnat).to(equal(userData.usnat))

                                case .failure(let error):
                                    fail(error.description)
                            }
                            done()
                        }
                    }
                }
            }

            describe("and expiration date is greater than current date") {
                it("erases consent data and returns a message") {
                    waitUntil { done in
                        coordinator.loadMessages(forAuthId: nil, pubData: nil) { _ in
                            coordinator.reportAction(saveAndExitAction) { _ in
                                let firstUUID = coordinator.state.usnat?.uuid
                                expect(firstUUID).notTo(beNil())

                                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                                    coordinator.loadMessages(forAuthId: nil, pubData: nil) { _ in
                                        expect(coordinator.state.usnat?.uuid).to(equal(firstUUID))

                                        coordinator.state.usnat?.expirationDate = SPDate(date: .yesterday)

                                        coordinator.loadMessages(forAuthId: nil, pubData: nil) { _ in
                                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                                                expect(coordinator.state.usnat?.uuid).notTo(equal(firstUUID))
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

            describe("when dealing with a re-consent scenario") {
                describe("when additionsChangeDate bigger than consent dateCreated") {
                    it("should show a message") {
                        waitUntil { done in
                            coordinator.loadMessages(forAuthId: nil, pubData: nil) { firstMessages in
                                let (messages, _) = try! firstMessages.get()
                                expect(messages.count).to(equal(1))

                                coordinator.reportAction(saveAndExitAction) { _ in
                                    coordinator.loadMessages(forAuthId: nil, pubData: nil) { secondMessages in
                                        let (messages, _) = try! secondMessages.get()
                                        expect(messages.count).to(equal(0))

                                        coordinator.state.usnat?.dateCreated = SPDate(date: coordinator.state.usNatMetaData!.additionsChangeDate.date.dayBefore
                                        )

                                        coordinator.loadMessages(forAuthId: nil, pubData: nil) { thirdMessages in
                                            let (messages, _) = try! thirdMessages.get()
                                            expect(messages.count).to(equal(1))

                                            done()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            describe("when usnat applicableSections change") {
                it("should call consent-status") {
                    let clientMock = SourcePointClientMock()
                    let firstApplicableSection = 1
                    let differentApplicableSection = 2
                    clientMock.metadataResponse = SPMobileCore.MetaDataResponse(
                        gdpr: nil,
                        usnat: .init(
                            applies: true,
                            sampleRate: 1.0,
                            additionsChangeDate: SPDate.now().originalDateString,
                            applicableSections: [KotlinInt(int: Int32(firstApplicableSection))],
                            vendorListId: ""
                        ),
                        ccpa: nil
                    )
                    coordinator = coordinatorFor(campaigns: SPCampaigns(usnat: SPCampaign()), spClient: clientMock)
                    waitUntil { done in
                        coordinator.loadMessages(forAuthId: nil, pubData: nil) { _ in
                            expect(clientMock.consentStatusCalled).to(beFalse())

                            clientMock.metadataResponse = SPMobileCore.MetaDataResponse(
                                gdpr: nil,
                                usnat: .init(
                                    applies: true,
                                    sampleRate: 1.0,
                                    additionsChangeDate: SPDate.now().originalDateString,
                                    applicableSections: [KotlinInt(int: Int32(differentApplicableSection))],
                                    vendorListId: ""
                                ),
                                ccpa: nil
                            )
                            coordinator.loadMessages(forAuthId: nil, pubData: nil) { _ in
                                expect(clientMock.consentStatusCalled).to(beTrue())
                                done()
                            }
                        }
                    }
                }
            }
        }

        describe("flushing consent") {
            it("when gdpr vendorListId changes") {
                waitUntil { done in
                    coordinator.loadMessages(forAuthId: nil, pubData: nil) { firstLoadMessages in
                        let (firstMessages, _) = try! firstLoadMessages.get()
                        expect(firstMessages.filter { $0.type == .gdpr }).notTo(beEmpty())

                        coordinator.reportAction(SPAction(type: .AcceptAll, campaignType: .gdpr)) { _ in
                            coordinator.state.gdprMetaData?.vendorListId = "foo"
                            coordinator.storage.spState = coordinator.state

                            coordinator.loadMessages(forAuthId: nil, pubData: nil) { secondLoadMessages in
                                let (secondMessages, _) = try! secondLoadMessages.get()
                                expect(secondMessages.filter { $0.type == .gdpr }).notTo(beEmpty())
                                done()
                            }
                        }
                    }
                }
            }

            it("when usnat vendorListId changes") {
                waitUntil { done in
                    coordinator = coordinatorFor(campaigns: SPCampaigns(usnat: SPCampaign()))
                    coordinator.loadMessages(forAuthId: nil, pubData: nil) { firstLoadMessages in
                        let (firstMessages, _) = try! firstLoadMessages.get()
                        expect(firstMessages.filter { $0.type == .usnat }).notTo(beEmpty())

                        coordinator.reportAction(SPAction(type: .AcceptAll, campaignType: .usnat)) { _ in
                            coordinator.state.usNatMetaData?.vendorListId = "foo"
                            coordinator.storage.spState = coordinator.state

                            coordinator.loadMessages(forAuthId: nil, pubData: nil) { secondLoadMessages in
                                let (secondMessages, _) = try! secondLoadMessages.get()
                                expect(secondMessages.filter { $0.type == .usnat }).notTo(beEmpty())
                                done()
                            }
                        }
                    }
                }
            }

            it("when propertyId changes") {
                let sameStorage = LocalStorageMock()
                coordinator = coordinatorFor(propertyId: 999, campaigns: gdprCcpaCampaigns, storage: sameStorage)
                coordinator.state.gdpr?.uuid = "foo"
                expect(coordinator.state.gdpr?.uuid).to(equal("foo"))

                coordinator = coordinatorFor(propertyId: 123, campaigns: gdprCcpaCampaigns, storage: sameStorage)
                expect(coordinator.state.gdpr?.uuid).to(beNil())
            }

            it("when accountId changes") {
                let sameStorage = LocalStorageMock()
                coordinator = coordinatorFor(accountId: 999, campaigns: gdprCcpaCampaigns, storage: sameStorage)
                coordinator.state.gdpr?.uuid = "foo"
                expect(coordinator.state.gdpr?.uuid).to(equal("foo"))

                coordinator = coordinatorFor(accountId: 123, campaigns: gdprCcpaCampaigns, storage: sameStorage)
                expect(coordinator.state.gdpr?.uuid).to(beNil())
            }
        }
    }
}
