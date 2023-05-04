//
//  UnmockedSourcepointClientSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 30.08.22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

@testable import ConsentViewController
import Foundation
import Nimble
import Quick

// swiftlint:disable force_try line_length function_body_length cyclomatic_complexity

class UnmockedSourcepointClientSpec: QuickSpec {
    override func spec() {
        let emptyMetaData = ConsentStatusMetaData(gdpr: nil, ccpa: nil)
        let propertyName = try! SPPropertyName("tests.unified-script.com")
        let accountId = 22
        let propertyId = 17_801

        var client: SourcePointClient!

        beforeSuite { AsyncDefaults.timeout = .seconds(20) }
        afterSuite { AsyncDefaults.timeout = .seconds(1) }

        beforeEach {
            client = SourcePointClient(
                accountId: accountId,
                propertyName: propertyName,
                campaignEnv: .Public,
                client: SimpleClient(timeoutAfter: TimeInterval(10))
            )
        }

        describe("consentStatusURLWithParams") {
            describe("with auth id") {
                it("should add the authId query param") {
                    let url = client.consentStatusURLWithParams(propertyId: propertyId, metadata: emptyMetaData, authId: "john doe")
                    expect(url?.query).to(contain("authId=john%20doe"))
                }
            }

            describe("without auth id") {
                it("should not add the authId query param") {
                    let url = client.consentStatusURLWithParams(propertyId: propertyId, metadata: emptyMetaData, authId: nil)
                    expect(url?.query).notTo(contain("authId="))
                }
            }

            it("should contain all query params") {
                let url = client.consentStatusURLWithParams(propertyId: propertyId, metadata: emptyMetaData, authId: nil)
                let paramsRaw = "env=\(Constants.Urls.envParam)&scriptType=ios&scriptVersion=\(SPConsentManager.VERSION)&hasCsp=true&includeData={\"TCData\":{\"type\":\"RecordString\"},\"webConsentPayload\":{\"type\":\"string\"},\"localState\":{\"type\":\"RecordString\"},\"categories\":true,\"translateMessage\":true}&metadata={}&propertyId=17801&withSiteActions=false"
                expect(url?.query) == paramsRaw.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            }
        }

        describe("consentStatus") {
            it("should call the endpoint and parse the response into ConsentStatusResponse") {
                waitUntil { done in
                    client.consentStatus(
                        propertyId: propertyId,
                        metadata: ConsentStatusMetaData(gdpr: ConsentStatusMetaData.Campaign(hasLocalData: false, applies: true, dateCreated: nil, uuid: nil), ccpa: ConsentStatusMetaData.Campaign(hasLocalData: false, applies: true, dateCreated: nil, uuid: nil)),
                        authId: "user_auth_id") { result in
                            switch result {
                            case .success(let response):
                                expect(response).to(beAnInstanceOf(ConsentStatusResponse.self))
                                expect(response.consentStatusData.gdpr).notTo(beNil())
                                expect(response.consentStatusData.ccpa).notTo(beNil())

                            case .failure(let error):
                                fail(error.failureReason)
                            }
                            done()
                    }
                }
            }
        }

        describe("getMessages") {
            it("should call the endpoint and parse the response into MessagesResponse") {
                waitUntil { done in
                    client.getMessages(MessagesRequest(
                        body: MessagesRequest.Body(
                            propertyHref: propertyName,
                            accountId: accountId,
                            campaigns: MessagesRequest.Body.Campaigns(
                                ccpa: MessagesRequest.Body.Campaigns.CCPA(
                                    targetingParams: nil,
                                    hasLocalData: false,
                                    status: nil
                                ),
                                gdpr: MessagesRequest.Body.Campaigns.GDPR(
                                    targetingParams: nil,
                                    hasLocalData: false,
                                    consentStatus: ConsentStatus()
                                ),
                                ios14: nil
                            ),
                            consentLanguage: .Spanish,
                            campaignEnv: nil,
                            idfaStatus: nil
                        ),
                        metadata: MessagesRequest.MetaData(
                            ccpa: MessagesRequest.MetaData.Campaign(applies: true),
                            gdpr: MessagesRequest.MetaData.Campaign(applies: true)
                        ),
                        localState: MessagesRequest.LocalState(localState: SPJson()),
                        nonKeyedLocalState: MessagesRequest.NonKeyedLocalState(nonKeyedLocalState: SPJson())
                    )) {
                            switch $0 {
                            case .success(let response):
                                expect(response).to(beAnInstanceOf(MessagesResponse.self))
                                expect(response.campaigns.count) == 2
                                response.campaigns.forEach { campaign in
                                    expect(campaign.url).to(containQueryParam(("consentLanguage", "ES")))
                                }

                            case .failure(let error):
                                fail(error.failureReason)
                            }
                            done()
                    }
                }
            }
        }

        describe("pvData") {
            it("should call the endpoint and parse the response into PvDataResponse") {
                waitUntil { done in
                    client.pvData(
                        .init(
                            gdpr: .init(
                                applies: true,
                                uuid: nil,
                                accountId: accountId,
                                siteId: 17_801,
                                consentStatus: ConsentStatus(),
                                pubData: nil,
                                sampleRate: 5,
                                euconsent: nil,
                                msgId: nil,
                                categoryId: nil,
                                subCategoryId: nil,
                                prtnUUID: nil
                            ),
                             ccpa: .init(
                                applies: true,
                                uuid: nil,
                                accountId: accountId,
                                siteId: 17_801,
                                consentStatus: ConsentStatus(rejectedVendors: [], rejectedCategories: []),
                                pubData: nil,
                                messageId: nil,
                                sampleRate: 5
                             )
                        )
                    ) { result in
                        switch result {
                        case .success(let response):
                            expect(response).to(beAnInstanceOf(PvDataResponse.self))
                            expect(response.gdpr).notTo(beNil())

                        case .failure(let error):
                            fail(error.failureReason)
                        }
                        done()
                    }
                }
            }
        }

        describe("meta-data") {
            it("should call the endpoint and parse the response into MetaDataResponse") {
                waitUntil { done in
                    client.metaData(accountId: accountId,
                                    propertyId: 17_801,
                                    metadata: MetaDataBodyRequest(
                                        gdpr: MetaDataBodyRequest.Campaign(hasLocalData: true, dateCreated: nil, uuid: nil),
                                        ccpa: MetaDataBodyRequest.Campaign(hasLocalData: false, dateCreated: nil, uuid: nil))) {
                            switch $0 {
                            case .success(let response):
                                let GDPR = response.gdpr
                                let CCPA = response.ccpa
                                expect(response).to(beAnInstanceOf(MetaDataResponse.self))
                                expect(GDPR).notTo(beNil())
                                expect(CCPA).notTo(beNil())

                            case .failure(let error):
                                fail(error.failureReason)
                            }
                            done()
                    }
                }
            }
        }

        describe("choice/reject-all") {
            it("should call the endpoint and parse the response into ChoiceAllResponse") {
                waitUntil { done in
                    client.choiceAll(
                        actionType: .RejectAll,
                        accountId: accountId,
                        propertyId: propertyId,
                        metadata: .init(
                            gdpr: .init(applies: true),
                            ccpa: .init(applies: true)
                        )
                    ) { result in
                        switch result {
                        case .success(let response):
                            expect(response).to(beAnInstanceOf(ChoiceAllResponse.self))
                            expect(response.gdpr).notTo(beNil())
                            expect(response.ccpa).notTo(beNil())

                        case .failure(let error):
                            fail(error.failureReason)
                        }
                        done()
                    }
                }
            }
        }

        describe("choice/consent-all") {
            it("should call the endpoint and parse the response into ChoiceAllResponse") {
                waitUntil { done in
                    client.choiceAll(
                        actionType: .AcceptAll,
                        accountId: accountId,
                        propertyId: propertyId,
                        metadata: .init(
                            gdpr: .init(applies: true),
                            ccpa: .init(applies: true)
                        )
                    ) { result in
                        switch result {
                        case .success(let response):
                            expect(response).to(beAnInstanceOf(ChoiceAllResponse.self))
                            expect(response.gdpr).notTo(beNil())
                            expect(response.ccpa).notTo(beNil())

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
