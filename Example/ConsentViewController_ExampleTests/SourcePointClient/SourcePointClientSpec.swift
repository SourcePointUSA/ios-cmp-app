//
//  SourcePointClientSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Vilas on 29/03/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

// swiftlint:disable force_try
// swiftlint:disable function_body_length

import Quick
import Nimble
@testable import ConsentViewController

class SourcePointClientSpec: QuickSpec {
    let propertyId = 123
    let accountId = 1, propertyName = try! SPPropertyName("test")

    func getClient(_ client: MockHttp) -> SourcePointClient {
        SourcePointClient(accountId: accountId, propertyName: propertyName, campaignEnv: .Public, client: client)
    }
    var campaign: SPCampaign { SPCampaign(targetingParams: [:]) }
    var campaigns: SPCampaigns { SPCampaigns(gdpr: campaign) }
    var gdprProfile: SPConsent<SPGDPRConsent> { SPConsent<SPGDPRConsent>(
        consents: SPGDPRConsent.empty(),
        applies: true
    )}
    var profile: SPUserData { SPUserData(gdpr: gdprProfile) }

    func getMessageRequest(_ client: SourcePointClient, _ targetingParams: SPTargetingParams = [:]) -> Data {
        try! JSONEncoder().encode(
            MessageRequest(
                authId: "auth id",
                requestUUID: client.requestUUID,
                propertyHref: propertyName,
                accountId: accountId,
                campaignEnv: .Public,
                idfaStatus: .unknown,
                localState: SPJson(),
                consentLanguage: .English,
                campaigns: CampaignsRequest(
                    gdpr: CampaignRequest(
                        groupPmId: nil, targetingParams: targetingParams
                    ),
                    ccpa: nil, // CampaignRequest(groupPmId: nil, targetingParams: [:]),
                    ios14: nil // CampaignRequest(groupPmId: nil, targetingParams: [:])
                ),
                pubData: [:]
            ))
    }

    override func spec() {
        Nimble.AsyncDefaults.timeout = .seconds(2)

        var client: SourcePointClient!
        var httpClient: MockHttp?
        var mockedResponse: Data?

        describe("statics") {
            it("CUSTOM_CONSENT_URL") {
                expect(Constants.Urls.CUSTOM_CONSENT_URL.absoluteURL).to(equal(
                    URL(string: "https://cdn.privacy-mgmt.com/wrapper/tcfv2/v1/gdpr/custom-consent?env=prod&inApp=true")!.absoluteURL
                ))
            }
        }

        describe("SourcePointClient") {
            beforeEach {
                mockedResponse = "{\"url\": \"https://notice.sp-prod.net/?message_id=59706\"}".data(using: .utf8)
                httpClient = MockHttp(success: mockedResponse)
                client = self.getClient(httpClient!)
            }

            describe("getMessage") {
                it("calls POST on the http client with the right url") {
                    client.getMessages(campaigns: self.campaigns, authId: nil, localState: SPJson(), pubData: [:], idfaStaus: .unknown, consentLanguage: .English) { _ in }
                    expect(httpClient?.postWasCalledWithUrl).to(equal("https://cdn.privacy-mgmt.com/wrapper/v2/get_messages/?env=prod"))
                }

                it("calls POST on the http client with the right body") {
                    client.getMessages(campaigns: self.campaigns, authId: "auth id", localState: SPJson(), pubData: [:], idfaStaus: .unknown, consentLanguage: .English) { _ in
                        let parsed = httpClient!.postWasCalledWithBody!
                        expect(parsed).toEventually(equal(self.getMessageRequest(client)))
                    }
                }
            }

            describe("postAction") {
                it("calls post on the http client with the right url") {
                    let acceptAllAction = SPAction(type: .AcceptAll)
                    client.postGDPRAction(authId: nil, action: acceptAllAction, localState: SPJson(), idfaStatus: .accepted) { _ in }
                    expect(httpClient?.postWasCalledWithUrl).to(equal("https://cdn.privacy-mgmt.com/wrapper/v2/messages/choice/gdpr/11?env=prod"))
                }

                it("calls POST on the http client with the right body") {
                    let action = SPAction(type: .AcceptAll, consentLanguage: "EN")
                    action.publisherData = ["foo": "bar"]
                    let consentRequest = GDPRConsentRequest(
                        authId: nil,
                        idfaStatus: .accepted,
                        localState: SPJson(),
                        pmSaveAndExitVariables: nil,
                        pubData: [:],
                        requestUUID: UUID()
                    )
//                    client.postAction(
//                        action: action,
//                        campaignType: .GDPR,
//                        campaign: self.campaign,
//                        localState: ""
//                    ) { _ in }
//                    let parsed = try? JSONDecoder().decode(GDPRConsentRequest.self, from: httpClient!.postWasCalledWithBody ?? "".data(using: .utf8)!).get()
//                    expect(parsed).toEventually(equal(consentRequest))
                }
            }

            describe("customConsent") {
                it("makes a POST to SourcePointClient.CUSTOM_CONSENT_URL") {
                    let http = MockHttp()
                    self.getClient(http).customConsentGDPR(toConsentUUID: "", vendors: [], categories: [], legIntCategories: [], propertyId: 1) { _ in
                        expect(http.postWasCalledWithUrl).to(equal(Constants.Urls.CUSTOM_CONSENT_URL.absoluteURL.absoluteString))
                    }
                }

                it("makes a POST with the correct body") {
                    let http = MockHttp()
                    self.getClient(http).customConsentGDPR(toConsentUUID: "uuid", vendors: [], categories: [], legIntCategories: [], propertyId: 123) { _ in }
                    let parsedRequest = try? JSONSerialization.jsonObject(with: http.postWasCalledWithBody!) as? [String: Any]

                    expect((parsedRequest?["consentUUID"] as? String)).to(equal("uuid"))
                    expect((parsedRequest?["vendors"] as? [String])).to(equal([]))
                    expect((parsedRequest?["categories"] as? [String])).to(equal([]))
                    expect((parsedRequest?["legIntCategories"] as? [String])).to(equal([]))
                    expect((parsedRequest?["propertyId"] as? Int)).to(equal(self.propertyId))
                }

                context("on success") {
                    beforeEach {
                        client = self.getClient(MockHttp(success: """
                        {
                            "vendors": ["aVendor"],
                            "categories": ["aCategory"],
                            "legIntCategories": ["aLegIntInterest"],
                            "specialFeatures": ["aSpecialFeature"],
                            "grants": {
                                "vendorId": {
                                    "vendorGrant": true,
                                    "purposeGrants": {
                                        "purposeId": true
                                    }
                                }
                            }
                        }
                        """.data(using: .utf8)!))
                    }

                    it("calls the completion handler with a CustomConsentResponse") {
                        var consentsResponse: CustomConsentResponse?
                        client.customConsentGDPR(toConsentUUID: "uuid", vendors: [], categories: [], legIntCategories: [], propertyId: 1) { result in
                            switch result {
                            case .success(let response):
                                consentsResponse = response
                            case .failure(_): break
                            }
                            expect(consentsResponse).toEventually(equal(CustomConsentResponse(
                                grants: [
                                    "vendorId": SPGDPRVendorGrant(granted: true, purposeGrants: ["purposeId": true])
                                ]
                            )))
                        }
                    }

                    it("calls completion handler with nil as error") {
                        var error: SPError? = .none
                        client.customConsentGDPR(toConsentUUID: "uuid", vendors: [], categories: [], legIntCategories: [], propertyId: 1) { result in
                            switch result {
                            case .success(_): break
                            case .failure(let e):
                                error = e
                            }
                        }
                        expect(error).toEventually(beNil())
                    }
                }

                context("on failure") {
                    beforeEach {
                        client = self.getClient(MockHttp(error: SPError()))
                    }

                    it("calls the completion handler with an SPError") {
                        var error: SPError?
                        client.customConsentGDPR(toConsentUUID: "uuid", vendors: [], categories: [], legIntCategories: [], propertyId: 1) { result in
                            switch result {
                            case .success(_): break
                            case .failure(let e):
                                error = e
                            }
                        expect(error).toEventually(beAKindOf(SPError.self))
                        }
                    }
                }

                describe("metrics") {
                    it("makes a POST to https://cdn.privacy-mgmt.com/wrapper/metrics/v1/custom-metrics with correct body") {
                        let http = MockHttp()
                        let error = SPError()
                        self.getClient(http).errorMetrics(
                            error,
                            propertyId: 123,
                            sdkVersion: "1.2.3",
                            OSVersion: "11.0",
                            deviceFamily: "iPhone 11 pro",
                            campaignType: .gdpr
                        )
                        let parsedRequest = try? JSONSerialization.jsonObject(with: http.postWasCalledWithBody!) as? [String: Any]
                        expect(http.postWasCalledWithUrl).to(equal("https://cdn.privacy-mgmt.com/wrapper/metrics/v1/custom-metrics"))
                        expect((parsedRequest?["code"] as? String)).to(equal(error.spCode))
                        expect((parsedRequest?["accountId"] as? String)).to(equal("1"))
                        expect((parsedRequest?["propertyId"] as? String)).to(equal("123"))
                        expect((parsedRequest?["propertyHref"] as? String)).to(equal("https://test"))
                        expect((parsedRequest?["propertyId"] as? String)).to(equal("123"))
                        expect((parsedRequest?["description"] as? String)).to(equal(error.description))
                        expect((parsedRequest?["scriptVersion"] as? String)).to(equal("1.2.3"))
                        expect((parsedRequest?["sdkOSVersion"] as? String)).to(equal("11.0"))
                        expect((parsedRequest?["deviceFamily"] as? String)).to(equal("iPhone 11 pro"))
                        expect((parsedRequest?["legislation"] as? String)).to(equal("GDPR"))
                    }
                }
            }
        }
    }
}
