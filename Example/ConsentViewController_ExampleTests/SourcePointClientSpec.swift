//
//  SourcePointClientSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Vilas on 29/03/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import ConsentViewController

public class MockHttp: HttpClient {
    public var defaultOnError: OnError?
    var getCalledWith: URL?
    var success: Data?
    var error: Error?

    init(success: Data?) {
        self.success = success
    }

    init(error: Error?) {
        self.error = error
    }

    public func get(url: URL?, onSuccess: @escaping OnSuccess) {
        getCalledWith = url?.absoluteURL
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            onSuccess(self.success!)
        })
    }

    func request(_ urlRequest: URLRequest, _ onSuccess: @escaping OnSuccess) {
        getCalledWith = urlRequest.url?.absoluteURL
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            onSuccess(self.success!)
        })
    }

    public func post(url: URL?, body: Data?, onSuccess: @escaping OnSuccess) {
        getCalledWith = url?.absoluteURL
        var urlRequest = URLRequest(url: getCalledWith!)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = body
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            onSuccess(self.success!)
        })
    }
}

class SourcePointClientSpec: QuickSpec {

    func getClient(_ client: MockHttp) -> SourcePointClient {
        return SourcePointClient(accountId: 123, propertyId: 123, propertyName: try! GDPRPropertyName("tcfv2.mobile.demo"), pmId: "123", campaignEnv: .Public, targetingParams: ["native": "false"], client: client)
    }

    override func spec() {
        var client: SourcePointClient!
        var httpClient: MockHttp?
        var mockedResponse: Data?

        describe("Test SourcePointClient Methods") {

            beforeEach {
                mockedResponse = "{\"url\": \"https://notice.sp-prod.net/?message_id=59706\"}".data(using: .utf8)
                httpClient = MockHttp(success: mockedResponse)
                client = self.getClient(httpClient!)
            }

            context("Test getMessage") {
                it("calls get on the http client with the right url") {
                    client.getMessage(native: false, consentUUID: "744BC49E-7327-4255-9794-FB07AA43E1DF", euconsent: "COwkbAyOwkbAyAGABBENAeCAAAAAAAAAAAAAAAAAAAAA", authId: "test", onSuccess: { _ in})
                    expect(httpClient?.getCalledWith).to(equal(URL(string: "https://wrapper-api.sp-prod.net/tcfv2/v1/gdpr/message-url?inApp=true")))
                }

                it("calls get on the http client with the right url") {
                    client.getMessage(url: SourcePointClient.GET_MESSAGE_URL_URL, consentUUID: "744BC49E-7327-4255-9794-FB07AA43E1DF", euconsent: "COwkbAyOwkbAyAGABBENAeCAAAAAAAAAAAAAAAAAAAAA", authId: nil, onSuccess: { _ in})
                    expect(httpClient?.getCalledWith).to(equal(URL(string: "https://wrapper-api.sp-prod.net/tcfv2/v1/gdpr/message-url?inApp=true")))
                }
            }

            context("Test postAction") {
                it("calls post on the http client with the right url") {
                    let acceptAllAction = GDPRAction(type: .AcceptAll, id: "1234")
                    let vendors = PMConsent(accepted: [])
                    let purposes = PMConsent(accepted: [])
                    let mockConsents = PMConsents(vendors: vendors, categories: purposes)
                    client.postAction(action: acceptAllAction, consentUUID: "744BC49E-7327-4255-9794-FB07AA43E1DF", consents: mockConsents, onSuccess: { _ in})
                    expect(httpClient?.getCalledWith).to(equal(URL(string: "https://wrapper-api.sp-prod.net/tcfv2/v1/gdpr/consent?inApp=true")))
                }
            }

            context("Test targetingParamsToString") {
                it("Test TargetingParamsToString with parameter") {
                    let targetingParams = ["native": "false"]
                    let targetingParamString = client.targetingParamsToString(targetingParams)
                    let encodeTargetingParam = "{\"native\":\"false\"}".data(using: .utf8)
                    let encodedString = String(data: encodeTargetingParam!, encoding: .utf8)
                    expect(targetingParamString).to(equal(encodedString))
                }
            }
        }
    }
}
