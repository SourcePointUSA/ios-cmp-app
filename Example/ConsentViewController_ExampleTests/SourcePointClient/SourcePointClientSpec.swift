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
    static let propertyId = 123

    func getClient(_ client: MockHttp) -> SourcePointClient { SourcePointClient(
            accountId: 123,
            propertyId: SourcePointClientSpec.propertyId,
            propertyName: try! SPPropertyName("tcfv2.mobile.demo"),
            pmId: "123",
            campaignEnv: .Public,
            targetingParams: [:],
            client: client
        )
    }

    /// TODO: add CCPA campaign
    /// TODO: pass targeting params "encoding" to MessageRequest
    func getMessageRequest(_ client: SourcePointClient, _ targetingParams: String = "{}") -> MessageRequest { MessageRequest(
        authId: "auth id",
        requestUUID: client.requestUUID,
        campaigns: CampaignsRequest(
            gdpr: CampaignRequest(
                uuid: "uuid",
                accountId: client.accountId,
                propertyId: client.propertyId,
                propertyHref: client.propertyName,
                campaignEnv: client.campaignEnv,
                meta: "meta",
                targetingParams: targetingParams
            ),
            ccpa: nil
        ))
    }

    override func spec() {
        Nimble.AsyncDefaults.Timeout = 2

        var client: SourcePointClient!
        var httpClient: MockHttp?
        var mockedResponse: Data?

        describe("statics") {
            it("CUSTOM_CONSENT_URL") {
                expect(SourcePointClient.CUSTOM_CONSENT_URL.absoluteURL).to(equal(
                    URL(string: "https://cdn.privacy-mgmt.com/wrapper/tcfv2/v1/gdpr/custom-consent?inApp=true")!.absoluteURL
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
                    client.getMessage(
                        native: false,
                        consentUUID: "uuid",
                        euconsent: "consent string",
                        authId: "auth id",
                        meta: "meta",
                        completionHandler: { _, _  in})
                    expect(httpClient?.postWasCalledWithUrl).to(equal("https://cdn.privacy-mgmt.com/wrapper/tcfv2/v1/gdpr/message-url?inApp=true"))
                }

                it("calls POST on the http client with the right body") {
                    client.getMessage(
                        native: false,
                        consentUUID: "uuid",
                        euconsent: "consent string",
                        authId: "auth id",
                        meta: "meta",
                        completionHandler: { _, _  in})
                    let parsed = try! JSONDecoder().decode(MessageRequest.self, from: httpClient!.postWasCalledWithBody!)
                    expect(parsed).to(equal(self.getMessageRequest(client)))
                }

                context("when there are targeting params") {
                    it("gets parsed to 'stringified JSON'") {
                        let client = SourcePointClient(
                            accountId: 123,
                            propertyId: SourcePointClientSpec.propertyId,
                            propertyName: try! SPPropertyName("propertyName"),
                            pmId: "pmId",
                            campaignEnv: .Public,
                            targetingParams: ["foo": "bar"],
                            client: httpClient!
                        )
                        client.getMessage(
                            native: false,
                            consentUUID: "uuid",
                            euconsent: "consent string",
                            authId: "auth id",
                            meta: "meta",
                            completionHandler: { _, _  in})
                        let parsed = try! JSONDecoder().decode(MessageRequest.self, from: httpClient!.postWasCalledWithBody!)
                        expect(parsed).to(equal(self.getMessageRequest(client, "{\"foo\":\"bar\"}")))
                    }
                }
            }

            describe("postAction") {
                it("calls post on the http client with the right url") {
                    let acceptAllAction = GDPRAction(type: .AcceptAll, id: "1234")
                    client.postAction(action: acceptAllAction, consentUUID: "consent uuid", meta: "meta", completionHandler: { _, _  in})
                    expect(httpClient?.postWasCalledWithUrl).to(equal("https://cdn.privacy-mgmt.com/wrapper/tcfv2/v1/gdpr/consent?inApp=true"))
                }

                it("calls POST on the http client with the right body") {
                    let action = GDPRAction(type: .AcceptAll, id: "1234", consentLanguage: "EN")
                    action.publisherData = ["foo": try? SPGDPRArbitraryJson("bar")]
                    let actionRequest = ActionRequest(
                        propertyId: client.propertyId,
                        propertyHref: client.propertyName,
                        accountId: client.accountId,
                        actionType: action.type.rawValue,
                        choiceId: action.id,
                        privacyManagerId: client.pmId,
                        requestFromPM: false,
                        uuid: "uuid",
                        requestUUID: client.requestUUID,
                        pmSaveAndExitVariables: SPGDPRArbitraryJson(),
                        meta: "meta",
                        publisherData: action.publisherData,
                        consentLanguage: "EN"
                    )
                    client.postAction(
                        action: action,
                        consentUUID: "uuid",
                        meta: "meta",
                        completionHandler: { _, _  in}
                    )
                    let parsed = try! JSONDecoder().decode(ActionRequest.self, from: httpClient!.postWasCalledWithBody!)
                    expect(parsed).to(equal(actionRequest))
                }
            }

            describe("customConsent") {
                it("makes a POST to SourcePointClient.CUSTOM_CONSENT_URL") {
                    let http = MockHttp()
                    self.getClient(http).customConsent(toConsentUUID: "", vendors: [], categories: [], legIntCategories: []) { _, _ in }
                    expect(http.postWasCalledWithUrl).to(equal(SourcePointClient.CUSTOM_CONSENT_URL.absoluteURL.absoluteString))
                }

                it("makes a POST with the correct body") {
                    let http = MockHttp()
                    self.getClient(http).customConsent(toConsentUUID: "uuid", vendors: [], categories: [], legIntCategories: []) { _, _ in }
                    let parsedRequest = try? JSONSerialization.jsonObject(with: http.postWasCalledWithBody!) as? [String: Any]

                    expect((parsedRequest?["consentUUID"] as? String)).to(equal("uuid"))
                    expect((parsedRequest?["vendors"] as? [String])).to(equal([]))
                    expect((parsedRequest?["categories"] as? [String])).to(equal([]))
                    expect((parsedRequest?["legIntCategories"] as? [String])).to(equal([]))
                    expect((parsedRequest?["propertyId"] as? Int)).to(equal(SourcePointClientSpec.propertyId))
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
                        client.customConsent(toConsentUUID: "uuid", vendors: [], categories: [], legIntCategories: []) { response, _ in
                            consentsResponse = response
                        }
                        expect(consentsResponse).toEventually(equal(CustomConsentResponse(
                            vendors: ["aVendor"],
                            categories: ["aCategory"],
                            legIntCategories: ["aLegIntInterest"],
                            specialFeatures: ["aSpecialFeature"],
                            grants: [
                                "vendorId": GDPRVendorGrant(vendorGrant: true, purposeGrants: ["purposeId": true])
                            ]
                        )))
                    }

                    it("calls completion handler with nil as error") {
                        var error: GDPRConsentViewControllerError? = .none
                        client.customConsent(toConsentUUID: "uuid", vendors: [], categories: [], legIntCategories: []) { _, e in
                            error = e
                        }
                        expect(error).toEventually(beNil())
                    }
                }

                context("on failure") {
                    beforeEach {
                        client = self.getClient(MockHttp(error: GDPRConsentViewControllerError()))
                    }

                    it("calls the completion handler with an GDPRConsentViewControllerError") {
                        var error: GDPRConsentViewControllerError?
                        client.customConsent(toConsentUUID: "uuid", vendors: [], categories: [], legIntCategories: []) { _, e in
                            error = e
                        }
                        expect(error).toEventually(beAKindOf(GDPRConsentViewControllerError.self))
                    }
                }
            }

            describe("metrics") {
                it("makes a POST to https://cdn.privacy-mgmt.com/wrapper/metrics/v1/custom-metrics with correct body") {
                    let http = MockHttp()
                    let error = GDPRConsentViewControllerError()
                    self.getClient(http).errorMetrics(
                        error,
                        sdkVersion: "1.2.3",
                        OSVersion: "11.0",
                        deviceFamily: "iPhone 11 pro",
                        legislation: .GDPR
                    )
                    let parsedRequest = try? JSONSerialization.jsonObject(with: http.postWasCalledWithBody!) as? [String: Any]
                    expect(http.postWasCalledWithUrl).to(equal("https://cdn.privacy-mgmt.com/wrapper/metrics/v1/custom-metrics"))
                    expect((parsedRequest?["code"] as? String)).to(equal(error.spCode))
                    expect((parsedRequest?["accountId"] as? String)).to(equal("123"))
                    expect((parsedRequest?["propertyHref"] as? String)).to(equal("https://tcfv2.mobile.demo"))
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
