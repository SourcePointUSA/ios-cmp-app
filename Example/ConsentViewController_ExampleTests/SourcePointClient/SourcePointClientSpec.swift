//
//  SourcePointClientSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Vilas on 29/03/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

// swiftlint:disable force_try function_body_length force_cast

import Quick
import Nimble
@testable import ConsentViewController

class SourcePointClientSpec: QuickSpec {
    static let propertyId = 123

    func getClient(_ client: MockHttp) -> SourcePointClient {
        return SourcePointClient(
            accountId: 123,
            propertyId: SourcePointClientSpec.propertyId,
            propertyName: try! GDPRPropertyName("tcfv2.mobile.demo"),
            pmId: "123",
            campaignEnv: .Public,
            targetingParams: [:],
            client: client
        )
    }

    override func spec() {
        Nimble.AsyncDefaults.Timeout = 2

        var client: SourcePointClient!
        var httpClient: MockHttp?
        var mockedResponse: Data?

        describe("statics") {
            it("CUSTOM_CONSENT_URL") {
                expect(SourcePointClient.CUSTOM_CONSENT_URL.absoluteURL).to(equal(
                    URL(string: "https://wrapper-api.sp-prod.net/tcfv2/v1/gdpr/custom-consent?inApp=true")!.absoluteURL
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
                    expect(httpClient?.postWasCalledWithUrl).to(equal(URL(string: "https://wrapper-api.sp-prod.net/tcfv2/v1/gdpr/message-url?inApp=true")))
                }

                it("calls POST on the http client with the right body") {
                    let messageRequest = MessageRequest(
                        uuid: "uuid",
                        euconsent: "consent string",
                        authId: "auth id",
                        accountId: client.accountId,
                        propertyId: client.propertyId,
                        propertyHref: client.propertyName,
                        campaignEnv: client.campaignEnv,
                        targetingParams: "{}",
                        requestUUID: client.requestUUID,
                        meta: "meta"
                    )
                    client.getMessage(
                        native: false,
                        consentUUID: "uuid",
                        euconsent: "consent string",
                        authId: "auth id",
                        meta: "meta",
                        completionHandler: { _, _  in})
                    let parsed = try! JSONDecoder().decode(MessageRequest.self, from: httpClient!.postWasCalledWithBody!)
                    expect(parsed).to(equal(messageRequest))
                }

                context("when there are targeting params") {
                    it("gets parsed to 'stringified JSON'") {
                        let client = SourcePointClient(
                            accountId: 123,
                            propertyId: SourcePointClientSpec.propertyId,
                            propertyName: try! GDPRPropertyName("propertyName"),
                            pmId: "pmId",
                            campaignEnv: .Public,
                            targetingParams: ["foo": "bar"],
                            client: httpClient!
                        )
                        let messageRequest = MessageRequest(
                            uuid: "uuid",
                            euconsent: "consent string",
                            authId: "auth id",
                            accountId: client.accountId,
                            propertyId: client.propertyId,
                            propertyHref: client.propertyName,
                            campaignEnv: client.campaignEnv,
                            targetingParams: "{\"foo\":\"bar\"}",
                            requestUUID: client.requestUUID,
                            meta: "meta"
                        )
                        client.getMessage(
                            native: false,
                            consentUUID: "uuid",
                            euconsent: "consent string",
                            authId: "auth id",
                            meta: "meta",
                            completionHandler: { _, _  in})
                        let parsed = try! JSONDecoder().decode(MessageRequest.self, from: httpClient!.postWasCalledWithBody!)
                        expect(parsed).to(equal(messageRequest))
                    }
                }
            }

            describe("postAction") {
                it("calls post on the http client with the right url") {
                    let acceptAllAction = GDPRAction(type: .AcceptAll, id: "1234")
                    client.postAction(action: acceptAllAction, consentUUID: "consent uuid", meta: "meta", completionHandler: { _, _  in})
                    expect(httpClient?.postWasCalledWithUrl).to(equal(URL(string: "https://wrapper-api.sp-prod.net/tcfv2/v1/gdpr/consent?inApp=true")))
                }

                it("calls POST on the http client with the right body") {
                    let action = GDPRAction(type: .AcceptAll, id: "1234")
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
                        meta: "meta")
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
                    let http = MockHttp(success: "".data(using: .utf8)!)
                    self.getClient(http).customConsent(toConsentUUID: "", vendors: [], categories: [], legIntCategories: []) { _, _ in }
                    expect(http.postWasCalledWithUrl).to(equal(SourcePointClient.CUSTOM_CONSENT_URL.absoluteURL))
                }

                it("makes a POST with the correct body") {
                    var parsedRequest: [String: Any]?
                    let http = MockHttp(success: "".data(using: .utf8)!)
                    self.getClient(http).customConsent(toConsentUUID: "uuid", vendors: [], categories: [], legIntCategories: []) { _, _ in }
                    parsedRequest = try! JSONSerialization.jsonObject(with: http.postWasCalledWithBody!) as! [String: Any]

                    expect((parsedRequest?["consentUUID"] as! String)).to(equal("uuid"))
                    expect((parsedRequest?["vendors"] as! [String])).to(equal([]))
                    expect((parsedRequest?["categories"] as! [String])).to(equal([]))
                    expect((parsedRequest?["legIntCategories"] as! [String])).to(equal([]))
                    expect((parsedRequest?["propertyId"] as! Int)).to(equal(SourcePointClientSpec.propertyId))
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
                        client = self.getClient(MockHttp(error: APIParsingError("foo", nil)))
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
        }
    }
}
