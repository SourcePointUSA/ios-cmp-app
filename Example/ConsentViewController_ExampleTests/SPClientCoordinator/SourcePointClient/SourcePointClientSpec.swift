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
        }
    }
}
