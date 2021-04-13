//
//  SourcePointClientSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Vilas on 29/03/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

// swiftlint:disable force_try function_body_length

import Quick
import Nimble
@testable import ConsentViewController

class SourcePointClientSpec: QuickSpec {
    let propertyId = 123
    let accountId = 1, propertyName = try! SPPropertyName("test")

    func getClient(_ client: MockHttp) -> SourcePointClient {
        SourcePointClient(accountId: accountId, propertyName: propertyName, client: client)
    }
    var campaign: SPCampaign { SPCampaign(environment: .Public, targetingParams: [:]) }
    var campaigns: SPCampaigns { SPCampaigns(gdpr: campaign) }
    var gdprProfile: ConsentProfile<SPGDPRConsent> { ConsentProfile<SPGDPRConsent>(
        applies: true,
        consents: SPGDPRConsent.empty()
    )}
    var profile: ConsentsProfile { ConsentsProfile(gdpr: gdprProfile) }

    /// TODO: add CCPA campaign
    func getMessageRequest(_ client: SourcePointClient, _ targetingParams: SPTargetingParams = [:]) -> Data {
        try! JSONEncoder().encode(
            MessageRequest(
                authId: "auth id",
                requestUUID: UUID(),
                propertyHref: propertyName,
                accountId: accountId,
                idfaStatus: .unknown,
                localState: "",
                campaigns: CampaignsRequest(
                    gdpr: CampaignRequest(
                        campaignEnv: campaign.environment,
                        targetingParams: targetingParams
                    ),
                    ccpa: nil,
                    ios14: nil
                )))
    }

    override func spec() {
        Nimble.AsyncDefaults.timeout = .seconds(2)

        var client: SourcePointClient!
        var httpClient: MockHttp?
        var mockedResponse: Data?

        describe("statics") {
            it("CUSTOM_CONSENT_URL") {
                expect(SourcePointClient.CUSTOM_CONSENT_URL.absoluteURL).to(equal(
                    URL(string: "https://cdn.privacy-mgmt.com/wrapper/unified/v1/gdpr/custom-consent?inApp=true")!.absoluteURL
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
                    client.getMessages(campaigns: self.campaigns, authId: nil, localState: "", idfaStaus: .unknown) { _ in }
                    expect(httpClient?.postWasCalledWithUrl).to(equal("https://cdn.privacy-mgmt.com/wrapper/unified/v1/gdpr/message?inApp=true"))
                }

                it("calls POST on the http client with the right body") {
                    client.getMessages(campaigns: self.campaigns, authId: nil, localState: "", idfaStaus: .unknown) { _ in }
                    let parsed = httpClient!.postWasCalledWithBody!
                    expect(parsed).toEventually(equal(self.getMessageRequest(client)))
                }
            }

            describe("postAction") {
                it("calls post on the http client with the right url") {
                    let acceptAllAction = SPAction(type: .AcceptAll, id: "1234")
//                    client.postAction(
//                        action: acceptAllAction,
//                        legislation: .GDPR,
//                        campaign: self.campaign,
//                        localState: ""
//                    ) { _ in }
                    expect(httpClient?.postWasCalledWithUrl).to(equal("https://cdn.privacy-mgmt.com/wrapper/unified/v1/gdpr/consent?inApp=true"))
                }

                it("calls POST on the http client with the right body") {
                    let action = SPAction(type: .AcceptAll, id: "1234", consentLanguage: "EN")
                    action.publisherData = ["foo": try? SPJson("bar")]
                    let actionRequest = GDPRActionRequest(
                        propertyHref: self.propertyName,
                        accountId: self.accountId,
                        actionType: action.type.rawValue,
                        choiceId: action.id,
                        privacyManagerId: "1",
                        requestFromPM: false,
                        requestUUID: client.requestUUID,
                        pmSaveAndExitVariables: SPJson(),
                        localState: "{}",
                        publisherData: action.publisherData,
                        consentLanguage: "EN"
                    )
//                    client.postAction(
//                        action: action,
//                        legislation: .GDPR,
//                        campaign: self.campaign,
//                        localState: ""
//                    ) { _ in }
                    let parsed = try? JSONDecoder().decode(GDPRActionRequest.self, from: httpClient!.postWasCalledWithBody ?? "".data(using: .utf8)!).get()
                    expect(parsed).toEventually(equal(actionRequest))
                }
            }

            xdescribe("customConsent") {
//                it("makes a POST to SourcePointClient.CUSTOM_CONSENT_URL") {
//                    let http = MockHttp()
//                    self.getClient(http).customConsent(toConsentUUID: "", vendors: [], categories: [], legIntCategories: []) { _, _ in }
//                    expect(http.postWasCalledWithUrl).to(equal(SourcePointClient.CUSTOM_CONSENT_URL.absoluteURL.absoluteString))
//                }
//
//                it("makes a POST with the correct body") {
//                    let http = MockHttp()
//                    self.getClient(http).customConsent(toConsentUUID: "uuid", vendors: [], categories: [], legIntCategories: []) { _, _ in }
//                    let parsedRequest = try? JSONSerialization.jsonObject(with: http.postWasCalledWithBody!) as? [String: Any]
//
//                    expect((parsedRequest?["consentUUID"] as? String)).to(equal("uuid"))
//                    expect((parsedRequest?["vendors"] as? [String])).to(equal([]))
//                    expect((parsedRequest?["categories"] as? [String])).to(equal([]))
//                    expect((parsedRequest?["legIntCategories"] as? [String])).to(equal([]))
//                    expect((parsedRequest?["propertyId"] as? Int)).to(equal(SourcePointClientSpec.propertyId))
//                }
//
//                context("on success") {
//                    beforeEach {
//                        client = self.getClient(MockHttp(success: """
//                        {
//                            "vendors": ["aVendor"],
//                            "categories": ["aCategory"],
//                            "legIntCategories": ["aLegIntInterest"],
//                            "specialFeatures": ["aSpecialFeature"],
//                            "grants": {
//                                "vendorId": {
//                                    "vendorGrant": true,
//                                    "purposeGrants": {
//                                        "purposeId": true
//                                    }
//                                }
//                            }
//                        }
//                        """.data(using: .utf8)!))
//                    }
//
//                    it("calls the completion handler with a CustomConsentResponse") {
//                        var consentsResponse: CustomConsentResponse?
//                        client.customConsent(toConsentUUID: "uuid", vendors: [], categories: [], legIntCategories: []) { response, _ in
//                            consentsResponse = response
//                        }
//                        expect(consentsResponse).toEventually(equal(CustomConsentResponse(
//                            vendors: ["aVendor"],
//                            categories: ["aCategory"],
//                            legIntCategories: ["aLegIntInterest"],
//                            specialFeatures: ["aSpecialFeature"],
//                            grants: [
//                                "vendorId": GDPRVendorGrant(vendorGrant: true, purposeGrants: ["purposeId": true])
//                            ]
//                        )))
//                    }
//
//                    it("calls completion handler with nil as error") {
//                        var error: SPError? = .none
//                        client.customConsent(toConsentUUID: "uuid", vendors: [], categories: [], legIntCategories: []) { _, e in
//                            error = e
//                        }
//                        expect(error).toEventually(beNil())
//                    }
//                }
//
//                context("on failure") {
//                    beforeEach {
//                        client = self.getClient(MockHttp(error: SPError()))
//                    }
//
//                    it("calls the completion handler with an SPError") {
//                        var error: SPError?
//                        client.customConsent(toConsentUUID: "uuid", vendors: [], categories: [], legIntCategories: []) { _, e in
//                            error = e
//                        }
//                        expect(error).toEventually(beAKindOf(SPError.self))
//                    }
//                }
            }

            xdescribe("metrics") {
//                it("makes a POST to https://cdn.privacy-mgmt.com/wrapper/metrics/v1/custom-metrics with correct body") {
//                    let http = MockHttp()
//                    let error = SPError()
//                    self.getClient(http).errorMetrics(
//                        error,
//                        sdkVersion: "1.2.3",
//                        OSVersion: "11.0",
//                        deviceFamily: "iPhone 11 pro",
//                        legislation: .GDPR
//                    )
//                    let parsedRequest = try? JSONSerialization.jsonObject(with: http.postWasCalledWithBody!) as? [String: Any]
//                    expect(http.postWasCalledWithUrl).to(equal("https://cdn.privacy-mgmt.com/wrapper/metrics/v1/custom-metrics"))
//                    expect((parsedRequest?["code"] as? String)).to(equal(error.spCode))
//                    expect((parsedRequest?["accountId"] as? String)).to(equal("123"))
//                    expect((parsedRequest?["propertyHref"] as? String)).to(equal("https://tcfv2.mobile.demo"))
//                    expect((parsedRequest?["propertyId"] as? String)).to(equal("123"))
//                    expect((parsedRequest?["description"] as? String)).to(equal(error.description))
//                    expect((parsedRequest?["scriptVersion"] as? String)).to(equal("1.2.3"))
//                    expect((parsedRequest?["sdkOSVersion"] as? String)).to(equal("11.0"))
//                    expect((parsedRequest?["deviceFamily"] as? String)).to(equal("iPhone 11 pro"))
//                    expect((parsedRequest?["legislation"] as? String)).to(equal("GDPR"))
//                }
            }
        }
    }
}
