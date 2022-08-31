//
//  UnmockedSourcepointClientSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 30.08.22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import ConsentViewController

// swiftlint:disable force_try line_length

class UnmockedConnectivityManagerSpec: QuickSpec {
    override func spec() {
        let emptyMetaData = ConsentStatusMetaData(gdpr: nil, ccpa: nil)
        var client: SourcePointClient!

        describe("UnmockedConnectivityManager") {
            beforeSuite { AsyncDefaults.timeout = .seconds(20) }
            afterSuite { AsyncDefaults.timeout = .seconds(1) }

            beforeEach {
                client = SourcePointClient(
                    accountId: 22,
                    propertyName: try! SPPropertyName("test"),
                    campaignEnv: .Public,
                    client: SimpleClient(timeoutAfter: TimeInterval(10))
                )
            }

            describe("consentStatusURLWithParams") {
                describe("with auth id") {
                    it("should add the authId query param") {
                        let url = client.consentStatusURLWithParams(propertyId: 123, metadata: emptyMetaData, authId: "john doe")
                        expect(url?.query).to(contain("authId=john%20doe"))
                    }
                }

                describe("without auth id") {
                    it("should not add the authId query param") {
                        let url = client.consentStatusURLWithParams(propertyId: 123, metadata: emptyMetaData, authId: nil)
                        expect(url?.query).notTo(contain("authId="))
                    }
                }

                it("should contain all query params") {
                    let url = client.consentStatusURLWithParams(propertyId: 123, metadata: emptyMetaData, authId: nil)
                    let paramsRaw = "env=\(Constants.Urls.envParam)&hasCsp=true&metadata={}&propertyId=123&withSiteActions=false"
                    expect(url?.query).to(equal(
                        paramsRaw.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    ))
                }
            }

            describe("consentStatus") {
                it("should call the endpoint and parse the response into ConsentStatusResponse") {
                    waitUntil { done in
                        client.consentStatus(
                            propertyId: 17801,
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
        }
    }
}
