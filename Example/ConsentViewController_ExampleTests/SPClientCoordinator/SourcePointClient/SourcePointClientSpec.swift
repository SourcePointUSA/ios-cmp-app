//
//  SourcePointClientSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Vilas on 29/03/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

// swiftlint:disable force_try function_body_length type_body_length force_unwrapping line_length cyclomatic_complexity file_length

@testable import ConsentViewController
import Nimble
import Quick

class SourcePointClientSpec: QuickSpec {
    let propertyId = 123
    let accountId = 1
    let propertyName = try! SPPropertyName("test")
    let authID = "auth id"
    var campaign: SPCampaign { SPCampaign(targetingParams: [:]) }
    var campaigns: SPCampaigns { SPCampaigns(gdpr: campaign) }
    var gdprProfile: SPConsent<SPGDPRConsent> { SPConsent<SPGDPRConsent>(
        consents: SPGDPRConsent.empty(),
        applies: true
    )}
    var profile: SPUserData { SPUserData(gdpr: gdprProfile) }
    var wrapperHost: String {
        Constants.prod ? "cdn.privacy-mgmt.com" : "preprod-cdn.privacy-mgmt.com"
    }

    func getClient(_ client: MockHttp) -> SourcePointClient { SourcePointClient(
        accountId: accountId,
        propertyName: propertyName,
        propertyId: propertyId,
        campaignEnv: .Public,
        client: client
    )}

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
                pubData: [:],
                includeData: .standard
            ))
    }

    override func spec() {
        var client: SourcePointClient!
        var httpClient: MockHttp!
        var mockedResponse: Data?

        beforeSuite {
            // changing AsyncDefaults make the test suite pass in CI due to slow CI environment
            AsyncDefaults.timeout = .seconds(20)
            AsyncDefaults.pollInterval = .milliseconds(100)
        }

        afterSuite {
            // changing AsyncDefaults back to defaults after suite is done
            AsyncDefaults.timeout = .seconds(1)
            AsyncDefaults.pollInterval = .milliseconds(10)
        }

        describe("SourcePointClient") {
            beforeEach {
                mockedResponse = "{\"url\": \"https://notice.sp-prod.net/?message_id=59706\"}".data(using: .utf8)
                httpClient = MockHttp(success: mockedResponse)
                client = self.getClient(httpClient)
            }

            describe("parseResponse") {
                it("returns a failure Result if the result it receives is a failure") {
                    let httpError = SPError()
                    let result = Result<Data?, SPError>.failure(httpError)
                    waitUntil { done in
                        SourcePointClient.parseResponse(result, SPError()) { (parsingResult: Result<CodableMock, SPError>) in
                            switch parsingResult {
                                case .success: fail("expected call to fail, but it succeeded")

                                case .failure(let error):
                                    expect(error).to(be(httpError))
                            }
                            done()
                        }
                    }
                }

                it("returns a failure Result if parsing the response fails") {
                    let parsingError = SPError()
                    let result = Result<Data?, SPError>.success(nil)
                    waitUntil { done in
                        SourcePointClient.parseResponse(result, parsingError) { (parsingResult: Result<CodableMock, SPError>) in
                            switch parsingResult {
                                case .success: fail("expected call to fail, but it succeeded")

                                case .failure(let error):
                                    expect(error).to(be(parsingError))
                            }
                            done()
                        }
                    }
                }

                it("returns a success Result when both the result it receives and response parsing succeeds") {
                    let codableMock = CodableMock(0)
                    let result = Result<Data?, SPError>.success(try? JSONEncoder().encode(codableMock))
                    waitUntil { done in
                        SourcePointClient.parseResponse(result, SPError()) { (parsingResult: Result<CodableMock, SPError>) in
                            switch parsingResult {
                                case .success(let parsedObject):
                                    expect(parsedObject).to(equal(codableMock))

                                case .failure:
                                    fail("expected call to succeed, but it failed")
                            }
                            done()
                        }
                    }
                }
            }

            describe("getMessages") {
                it("calls GET on the http client with the right URL") {
                    client.getMessages(MessagesRequest(
                        body: MessagesRequest.Body(
                            propertyHref: self.propertyName,
                            accountId: self.accountId,
                            campaigns: MessagesRequest.Body.Campaigns(),
                            consentLanguage: .BrowserDefault,
                            campaignEnv: nil,
                            idfaStatus: nil,
                            includeData: .standard
                        ),
                        metadata: MessagesRequest.MetaData(ccpa: nil, gdpr: nil, usnat: nil),
                        nonKeyedLocalState: MessagesRequest.NonKeyedLocalState(nonKeyedLocalState: SPJson()),
                        localState: nil
                    )) { _ in }
                    expect(httpClient.getWasCalledWithUrl).toEventually(contain("/v2/messages"))
                }
            }

            describe("choiceAll") {
                it("should contain the correct query params") {
                    let includeData = IncludeData.standard
                    client.choiceAll(
                        actionType: .AcceptAll, 
                        accountId: 123,
                        propertyId: 321,
                        idfaStatus: .accepted,
                        metadata: .init(gdpr: .init(applies: true), ccpa: .init(applies: false), usnat: .init(applies: false)),
                        includeData: includeData
                    ) { _ in }
                    let choiceAllUrl = URL(string: httpClient.getWasCalledWithUrl!)
                    expect(choiceAllUrl).to(
                        containQueryParams([
                            "accountId": "123",
                            "hasCsp": "true",
                            "propertyId": "321",
                            "withSiteActions": "false",
                            "includeCustomVendorsRes": "false",
                            "idfaStatus": "accepted",
                            "metadata": #"{"ccpa":{"applies":false},"gdpr":{"applies":true},"usnat":{"applies":false}}"#
                        ])
                    )
                    expect(choiceAllUrl).to(containQueryParam("includeData"))
                }
            }

            describe("postAction") {
                describe("gdpr") {
                    it("calls post on the http client with the right url") {
                        client.postGDPRAction(
                            actionType: .AcceptAll,
                            body: .init(
                                authId: nil,
                                uuid: nil,
                                messageId: nil,
                                consentAllRef: nil,
                                vendorListId: nil,
                                pubData: [:],
                                pmSaveAndExitVariables: nil,
                                sendPVData: true,
                                propertyId: 0,
                                sampleRate: 1,
                                idfaStatus: nil,
                                granularStatus: .init(),
                                includeData: .standard
                            )
                        ) { _ in }
                        expect(httpClient.postWasCalledWithUrl) == "https://\(self.wrapperHost)/wrapper/v2/choice/gdpr/11?env=prod"
                    }

                    it("calls POST on the http client with the right body") {
                        let body = GDPRChoiceBody(
                            authId: nil,
                            uuid: nil,
                            messageId: nil,
                            consentAllRef: nil,
                            vendorListId: nil,
                            pubData: [:],
                            pmSaveAndExitVariables: nil,
                            sendPVData: true,
                            propertyId: 0,
                            sampleRate: 1,
                            idfaStatus: nil,
                            granularStatus: .init(),
                            includeData: .standard
                        )
                        client.postGDPRAction(
                            actionType: .AcceptAll,
                            body: body
                        ) { _ in }
                        let encoded = try JSONEncoder().encode(body)
                        expect(httpClient.postWasCalledWithBody!).to(equal(encoded))
                    }
                }

                describe("ccpa") {
                    it("calls post on the http client with the right url") {
                        client.postCCPAAction(
                            actionType: .AcceptAll,
                            body: .init(
                                authId: nil,
                                uuid: nil,
                                messageId: "",
                                pubData: [:],
                                pmSaveAndExitVariables: nil,
                                sendPVData: true,
                                propertyId: 1,
                                sampleRate: 1,
                                includeData: .standard
                            )
                        ) { _ in }
                        expect(httpClient.postWasCalledWithUrl) == "https://\(self.wrapperHost)/wrapper/v2/choice/ccpa/11?env=prod"
                    }

                    it("calls POST on the http client with the right body") {
                        let body = CCPAChoiceBody(
                            authId: nil,
                            uuid: nil,
                            messageId: "",
                            pubData: [:],
                            pmSaveAndExitVariables: nil,
                            sendPVData: true,
                            propertyId: 1,
                            sampleRate: 1,
                            includeData: .standard
                        )
                        client.postCCPAAction(
                            actionType: .AcceptAll,
                            body: body
                        ) { _ in }
                        let encoded = try JSONEncoder().encode(body)
                        expect(httpClient.postWasCalledWithBody!).to(equal(encoded))
                    }
                }
                describe("usnat") {
                    it("calls post on the http client with the right url") {
                        client.postUSNatAction(
                            actionType: .AcceptAll,
                            body: .init(
                                authId: nil,
                                uuid: nil,
                                messageId: "",
                                vendorListId: nil,
                                pubData: [:],
                                pmSaveAndExitVariables: nil,
                                sendPVData: true,
                                propertyId: 1,
                                sampleRate: 1,
                                idfaStatus: nil,
                                granularStatus: nil,
                                includeData: .standard
                            )
                        ) { _ in }
                        expect(httpClient.postWasCalledWithUrl) == "https://\(self.wrapperHost)/wrapper/v2/choice/usnat/11?env=prod"
                    }

                    it("calls POST on the http client with the right body") {
                        let body = USNatChoiceBody(
                            authId: nil,
                            uuid: nil,
                            messageId: "",
                            vendorListId: nil,
                            pubData: [:],
                            pmSaveAndExitVariables: nil,
                            sendPVData: true,
                            propertyId: 1,
                            sampleRate: 1,
                            idfaStatus: nil,
                            granularStatus: nil,
                            includeData: .standard
                        )
                        client.postUSNatAction(
                            actionType: .AcceptAll,
                            body: body
                        ) { _ in }
                        let encoded = try JSONEncoder().encode(body)
                        expect(httpClient.postWasCalledWithBody!).to(equal(encoded))
                    }
                }
            }
        }
    }
}
