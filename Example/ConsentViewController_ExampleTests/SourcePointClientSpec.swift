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
    var getCalledWith: URL?
    let response: Data?

    init(response: Data?) {
        self.response = response
    }

    public func get(url: URL, completionHandler handler: @escaping (Data?, Error?) -> Void) {
        getCalledWith = url.absoluteURL
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            handler(self.response, nil)
        })
    }
}

class SourcePointClientSpec: QuickSpec {
    func getClient(_ client: MockHttp) -> SourcePointClient {
        return try! SourcePointClient(
            accountId: 123,
            propertyId: 123,
            pmId: "abc",
            showPM: true,
            propertyUrl: URL(string: "https://demo.com")!,
            campaign: "public",
            mmsUrl: URL(string: "https://demo.com")!,
            cmpUrl: URL(string: "https://demo.com")!,
            messageUrl: URL(string: "https://demo.com")!,
            client: client
        )
    }

    override func spec() {
        var client: SourcePointClient!
        var httpClient: MockHttp?
        var mockedResponse: Data?

        describe("getMessageUrl") {
            beforeEach {
                mockedResponse = "\"https://notice.sp-prod.net/?message_id=59706\"".data(using: .utf8)
                httpClient = MockHttp(response: mockedResponse)
                client = self.getClient(httpClient!)
            }

            it("calls get on the http client with the right url") {
                client.getMessageUrl(accountId: 123, propertyId: 123) { _, _ in }
                expect(httpClient?.getCalledWith).to(equal(URL(string: "https://fake_wrapper_api.com/getMessageUrl")))
            }

            it("returns the url of a message") {
                var messageUrl: URL?
                client.getMessageUrl(accountId: 123, propertyId: 123) { url, _ in messageUrl = url }
                expect(messageUrl).toEventually(equal(URL(string: "https://notice.sp-prod.net/?message_id=59706")), timeout: 5)
            }
        }
    }
}
