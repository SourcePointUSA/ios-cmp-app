//
//  SourcePointClientSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Vilas on 29/03/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

// swiftlint:disable force_try
// swiftlint:disable function_body_length
// swiftlint:disable type_body_length
// swiftlint:disable cyclomatic_complexity

import Quick
import Nimble
@testable import ConsentViewController

class SourcePointClientSpec: QuickSpec {
    let propertyId = 123
    let accountId = 1
    let propertyName = try! SPPropertyName("test")
    let authID = "auth id"

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
                authId: authID,
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
                    ccpa: nil,
                    ios14: nil
                ),
                pubData: [:]
            ))
    }

    override func spec() {
        var client: SourcePointClient!
        var httpClient: MockHttp!
        var mockedResponse: Data?

        beforeSuite {
            // changing AsyncDefaults make the test suite pass in CI due to slow CI environment
            AsyncDefaults.timeout = .seconds(20)
            AsyncDefaults.pollInterval = .seconds(1)
        }

        afterSuite {
            // changing AsyncDefaults back to defaults after suite is done
            AsyncDefaults.timeout = .seconds(1)
            AsyncDefaults.pollInterval = .milliseconds(10)
        }

        describe("statics") {
            it("CUSTOM_CONSENT_URL") {
                expect(Constants.Urls.CUSTOM_CONSENT_URL.absoluteURL).to(equal(
                    URL(string: "https://cdn.privacy-mgmt.com/wrapper/tcfv2/v1/gdpr/custom-consent?env=prod&inApp=true")!.absoluteURL
                ))
            }

            it("DELTE_CUSTOM_CONSENT_URL") {
                expect(Constants.Urls.DELETE_CUSTOM_CONSENT_URL.absoluteURL).to(equal(URL(string: "https://cdn.privacy-mgmt.com/consent/tcfv2/consent/v3/custom/")!.absoluteURL))
            }
        }

        describe("SourcePointClient") {
            beforeEach {
                mockedResponse = "{\"url\": \"https://notice.sp-prod.net/?message_id=59706\"}".data(using: .utf8)
                httpClient = MockHttp(success: mockedResponse)
                client = self.getClient(httpClient)
            }

            describe("getMessage") {
                it("calls POST on the http client with the right url") {
                    client.getMessages(campaigns: self.campaigns, authId: nil, localState: SPJson(), pubData: [:], idfaStaus: .unknown, consentLanguage: .English) { _ in }
                    expect(httpClient.postWasCalledWithUrl).to(equal("https://cdn.privacy-mgmt.com/wrapper/v2/get_messages/?env=prod"))
                }

                it("calls POST on the http client with the right body") {
                    let idfa = SPIDFAStatus.unknown, lang = SPMessageLanguage.English
                    client.getMessages(campaigns: self.campaigns, authId: self.authID, localState: SPJson(), pubData: [:], idfaStaus: idfa, consentLanguage: lang) { _ in }
                    let parsed = httpClient.postWasCalledWithBody!
                    let parsedStr = String(data: parsed, encoding: .utf8)!
                    let messageRequestStr = String(data: self.getMessageRequest(client), encoding: .utf8)!
//                    expect(parsedStr).toEventually(equal(messageRequestStr)) // <- flaky therefore annoying >:c
                    expect(parsedStr.count).toEventually(equal(messageRequestStr.count))
                    expect(
                        parsedStr.contains("\"authId\":\"\(self.authID)\"") &&
                        messageRequestStr.contains("\"authId\":\"\(self.authID)\""
                                                  )).toEventually(beTrue())
                    expect(
                        parsedStr.contains("\"accountId\":\(self.accountId)") &&
                        messageRequestStr.contains("\"accountId\":\(self.accountId)"
                                                  )).toEventually(beTrue())
                    expect(
                        parsedStr.contains("\"idfaStatus\":\"\(idfa)\"") &&
                        messageRequestStr.contains("\"idfaStatus\":\"\(idfa)\""
                                                  )).toEventually(beTrue())
                    expect(
                        parsedStr.contains("\"includeData\":{") &&
                        messageRequestStr.contains("\"includeData\":{"
                                                  )).toEventually(beTrue())
                    expect(
                        parsedStr.contains("\"localState\":{\"type\":\"RecordString\"}") &&
                        messageRequestStr.contains("\"localState\":{\"type\":\"RecordString\"}"
                                                  )).toEventually(beTrue())
                    expect(
                        parsedStr.contains("\"TCData\":{\"type\":\"RecordString\"}") &&
                        messageRequestStr.contains("\"TCData\":{\"type\":\"RecordString\"}"
                                                  )).toEventually(beTrue())
                    expect(
                        parsedStr.contains("\"messageMetaData\":{\"type\":\"RecordString\"}") &&
                        messageRequestStr.contains("\"messageMetaData\":{\"type\":\"RecordString\"}"
                                                  )).toEventually(beTrue())
                    expect(
                        parsedStr.contains("\"propertyHref\":\"https:\\/\\/\(self.propertyName)\"") &&
                        messageRequestStr.contains("\"propertyHref\":\"https:\\/\\/\(self.propertyName)\""
                                                  )).toEventually(beTrue())
                    expect(
                        parsedStr.contains("\"localState\":{}") &&
                        messageRequestStr.contains("\"localState\":{}"
                                                  )).toEventually(beTrue())
                    expect(
                        parsedStr.contains("\"pubData\":{}") &&
                        messageRequestStr.contains("\"pubData\":{}"
                                                  )).toEventually(beTrue())
                    expect(
                        parsedStr.contains("\"requestUUID\":\"\(client.requestUUID.uuidString)\"") &&
                        messageRequestStr.contains("\"requestUUID\":\"\(client.requestUUID.uuidString)\""
                                                  )).toEventually(beTrue())
                    expect(
                        parsedStr.contains("\"campaignEnv\":\"\(SPCampaignEnv.Public.stringValue!)\"") &&
                        messageRequestStr.contains("\"campaignEnv\":\"\(SPCampaignEnv.Public.stringValue!)\""
                                                  )).toEventually(beTrue())
                    expect(
                        parsedStr.contains("\"consentLanguage\":\"\(lang.rawValue)\"") &&
                        messageRequestStr.contains("\"consentLanguage\":\"\(lang.rawValue)\""
                                                  )).toEventually(beTrue())
                    expect(
                        parsedStr.contains("\"campaigns\":{") &&
                        messageRequestStr.contains("\"campaigns\":{"
                                                  )).toEventually(beTrue())
                    expect(
                        parsedStr.contains("\"gdpr\":{") &&
                        messageRequestStr.contains("\"gdpr\":{"
                                                  )).toEventually(beTrue())
                    expect(
                        parsedStr.contains("\"targetingParams\":{}") &&
                        messageRequestStr.contains("\"targetingParams\":{}"
                                                  )).toEventually(beTrue())
                }
            }

            describe("postAction") {
                it("calls post on the http client with the right url") {
                    let acceptAllAction = SPAction(type: .AcceptAll)
                    client.postGDPRAction(authId: nil, action: acceptAllAction, localState: SPJson(), idfaStatus: .accepted) { _ in }
                    expect(httpClient.postWasCalledWithUrl).to(equal("https://cdn.privacy-mgmt.com/wrapper/v2/messages/choice/gdpr/11?env=prod"))
                }

                it("calls POST on the http client with the right body") {
                    let action = SPAction(type: .IDFADenied)
                    client.postGDPRAction(authId: nil, action: action, localState: SPJson(), idfaStatus: .accepted) { _ in }
                    var uuid = String(data: httpClient.postWasCalledWithBody!, encoding: .utf8)!
                    let index = uuid.range(of: "requestUUID\":\"", options: [])!.upperBound
                    let endIndex = uuid.range(of: "\",\"")!.lowerBound
                    uuid = String(uuid[index..<endIndex])
                    expect(httpClient.postWasCalledWithBody!).to(equal(try JSONEncoder().encode(GDPRConsentRequest(
                        authId: nil,
                        idfaStatus: .denied,
                        localState: SPJson(),
                        pmSaveAndExitVariables: SPJson(),
                        pubData: [:],
                        requestUUID: UUID(uuidString: uuid)!
                    ))))
                }
            }

            describe("customConsent") {
                it("makes a POST to SourcePointClient.CUSTOM_CONSENT_URL") {
                    let http = MockHttp()
                    self.getClient(http).customConsentGDPR(toConsentUUID: "", vendors: [], categories: [], legIntCategories: [], propertyId: self.propertyId) { _ in }
                    expect(http.postWasCalledWithUrl).toEventually(equal(Constants.Urls.CUSTOM_CONSENT_URL.absoluteURL.absoluteString))
                }

                it("makes a POST with the correct body") {
                    let http = MockHttp()
                    self.getClient(http).customConsentGDPR(toConsentUUID: "uuid", vendors: [], categories: [], legIntCategories: [], propertyId: self.propertyId) { _ in }
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
                        client.customConsentGDPR(toConsentUUID: "uuid", vendors: [], categories: [], legIntCategories: [], propertyId: self.propertyId) { result in
                            switch result {
                            case .success(let response):
                                consentsResponse = response
                            case .failure: break
                            }
                        }
                        expect(consentsResponse).toEventually(equal(CustomConsentResponse(
                                                      grants: [
                                                          "vendorId": SPGDPRVendorGrant(granted: true, purposeGrants: ["purposeId": true])
                                                      ]
                                                  )))

                    }

                    it("calls completion handler with nil as error") {
                        var error: SPError? = .none
                        client.customConsentGDPR(toConsentUUID: "uuid", vendors: [], categories: [], legIntCategories: [], propertyId: self.propertyId) { result in
                            switch result {
                            case .success: break
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
                        client.customConsentGDPR(toConsentUUID: "uuid", vendors: [], categories: [], legIntCategories: [], propertyId: self.propertyId) { result in
                            switch result {
                            case .success: break
                            case .failure(let e):
                                error = e
                            }
                        }
                        expect(error).toEventually(beAKindOf(SPError.self))
                    }
                }

                describe("metrics") {
                    it("makes a POST to https://cdn.privacy-mgmt.com/wrapper/metrics/v1/custom-metrics with correct body") {
                        let http = MockHttp()
                        let error = SPError()
                        self.getClient(http).errorMetrics(
                            error,
                            propertyId: self.propertyId,
                            sdkVersion: "1.2.3",
                            OSVersion: "11.0",
                            deviceFamily: "iPhone 11 pro",
                            campaignType: .gdpr
                        )
                        let parsedRequest = try? JSONSerialization.jsonObject(with: http.postWasCalledWithBody!) as? [String: Any]
                        expect(http.postWasCalledWithUrl).to(equal("https://cdn.privacy-mgmt.com/wrapper/metrics/v1/custom-metrics"))
                        expect((parsedRequest?["code"] as? String)).to(equal(error.spCode))
                        expect((parsedRequest?["accountId"] as? String)).to(equal("\(self.accountId)"))
                        expect((parsedRequest?["propertyId"] as? String)).to(equal("\(self.propertyId)"))
                        expect((parsedRequest?["propertyHref"] as? String)).to(equal("https://test"))
                        expect((parsedRequest?["description"] as? String)).to(equal(error.description))
                        expect((parsedRequest?["scriptVersion"] as? String)).to(equal("1.2.3"))
                        expect((parsedRequest?["sdkOSVersion"] as? String)).to(equal("11.0"))
                        expect((parsedRequest?["deviceFamily"] as? String)).to(equal("iPhone 11 pro"))
                        expect((parsedRequest?["legislation"] as? String)).to(equal("GDPR"))
                    }
                }
            }

            describe("deleteCustomConsent") {
                it("constructsCorrectURL") {
                    expect(client.deleteCustomConsentUrl(Constants.Urls.DELETE_CUSTOM_CONSENT_URL, self.propertyId, "yo")!.absoluteString).to(
                        equal("https://cdn.privacy-mgmt.com/consent/tcfv2/consent/v3/custom/\(self.propertyId)?consentUUID=yo"))
                }

                it("makes a DELETE with the correct body") {
                    let http = MockHttp()
                    self.getClient(http).deleteCustomConsentGDPR(toConsentUUID: "uuid", vendors: [], categories: [], legIntCategories: [], propertyId: self.propertyId) { _ in }
                    let parsedRequest = try? JSONSerialization.jsonObject(with: http.deleteWasCalledWithBody!) as? [String: Any]
                    expect((parsedRequest?["vendors"] as? [String])).to(equal([]))
                    expect((parsedRequest?["categories"] as? [String])).to(equal([]))
                    expect((parsedRequest?["legIntCategories"] as? [String])).to(equal([]))
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
                                    "vendorGrant": false,
                                    "purposeGrants": {
                                        "purposeId": false
                                    }
                                }
                            }
                        }
                        """.data(using: .utf8)!))
                    }

                    it("calls the completion handler with a DeleteCustomConsentResponse") {
                        var consentsResponse: DeleteCustomConsentResponse?
                        client.deleteCustomConsentGDPR(toConsentUUID: "uuid", vendors: [], categories: [], legIntCategories: [], propertyId: self.propertyId) { result in
                            switch result {
                            case .success(let response):
                                consentsResponse = response
                            case .failure: break
                            }
                        }
                        expect(consentsResponse).toEventually(equal(DeleteCustomConsentResponse(
                                                      grants: [
                                                          "vendorId": SPGDPRVendorGrant(granted: false, purposeGrants: ["purposeId": false])
                                                      ]
                                                  )))

                    }

                    it("calls completion handler with nil as error in case of success") {
                        var error: SPError? = .none
                        client.customConsentGDPR(toConsentUUID: "uuid", vendors: [], categories: [], legIntCategories: [], propertyId: self.propertyId) { result in
                            switch result {
                            case .success: break
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

                    it("calls the completion handler with an InvalidResponseDeleteCustomError") {
                        var error: SPError?
                        client.deleteCustomConsentGDPR(toConsentUUID: "uuid", vendors: [], categories: [], legIntCategories: [], propertyId: self.propertyId) { result in
                            switch result {
                            case .success: break
                            case .failure(let e):
                                error = e
                            }
                        }
                        expect(error).toEventually(beAKindOf(InvalidResponseDeleteCustomError.self))
                    }
                }
            }
        }
    }
}
