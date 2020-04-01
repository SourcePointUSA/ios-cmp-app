//
//  SourcePointClient.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 25.11.19.
//  Copyright © 2019 CocoaPods. All rights reserved.
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
        return SourcePointClient(accountId: 123, propertyId: 123, propertyName: try! GDPRPropertyName("tcfv2.mobile.demo"), pmId: "123", campaignEnv: .Public, targetingParams: [:], client: client)
    }

    override func spec() {
        var client: SourcePointClient!
        var httpClient: MockHttp?
        var mockedResponse: Data?

        describe("getMessageUrl") {
            describe("with a valid MessageResponse") {
                beforeEach {
                    mockedResponse = "{\"url\": \"https://notice.sp-prod.net/?message_id=59706\"}".data(using: .utf8)
                    httpClient = MockHttp(success: mockedResponse)
                    client = self.getClient(httpClient!)
                }

//                it("calls get on the http client with the right url") {
//                    client.getMessageUrl(accountId: 123, propertyId: 123, onSuccess: {_ in}, onError: nil)
//                    expect(httpClient?.getCalledWith).to(equal(URL(string: "https://fake_wrapper_api.com/getMessageUrl")))
//                }
//
//                it("returns the url of a message") {
//                    var messageResponse: MessageResponse?
//                    client.get
//                    client.getMessageUrl(accountId: 123, propertyId: 123, onSuccess: { response in messageResponse = response}, onError: nil)
//                    expect(messageResponse).toEventually(equal(MessageResponse(url: URL(string: "https://notice.sp-prod.net/?message_id=59706")!)), timeout: 5)
//                }
            }

            describe("with an invalid MessageResponse") {
                beforeEach {
                    mockedResponse = "{\"url\": \"a invalid url\"}".data(using: .utf8)
                    httpClient = MockHttp(success: mockedResponse)
                    client = self.getClient(httpClient!)
                }

//                it("calls the onError callback with a GetMessageAPIError") {
//                    var messageError: Error?
//                    client.getMessageUrl(accountId: 123, propertyId: 123, onSuccess: { _ in }, onError: { error in messageError = error })
//                    expect(messageError).toEventually(beAKindOf(GetMessageAPIError?.self), timeout: 5)
//                }
            }
        }
    }
}
