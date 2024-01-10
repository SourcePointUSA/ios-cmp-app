//
//  SimpleClientSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 26.05.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

@testable import ConsentViewController
import Foundation
import Nimble
import Quick

// swiftlint:disable force_cast function_body_length

class URLSessionDataTaskMock: SPURLSessionDataTask {
    var resumeWasCalled = false

    var priority: Float = 1.0

    func resume() {
        resumeWasCalled = true
    }
}

class URLSessionMock: SPURLSession {
    let configuration: URLSessionConfiguration
    let dataTaskResult: SPURLSessionDataTask
    let result: Data?
    let error: Error?
    var dataTaskCalledWith: URLRequest?

    init(
        configuration: URLSessionConfiguration = URLSessionConfiguration.default,
        dataTaskResult: SPURLSessionDataTask = URLSessionDataTaskMock(),
        data: Data? = nil,
        error: Error? =  nil
    ) {
        self.configuration = configuration
        self.error = error
        self.dataTaskResult = dataTaskResult
        result = data
    }

    func dataTask(_ request: URLRequest, completionHandler: @escaping DataTaskResult) -> SPURLSessionDataTask {
        dataTaskCalledWith = request
        completionHandler(result, URLResponse(), error)
        return dataTaskResult
    }
}

class SimpleClientSpec: QuickSpec {
    // swiftlint:disable:next force_unwrapping
    let exampleRequest = URLRequest(url: URL(string: "http://example.com")!)

    override func spec() {
        describe("init(timeoutAfter: TimeInterval)") {
            it("sets the timeout in its URLSession") {
                let session = SimpleClient(timeoutAfter: 10.0).session as! URLSession
                expect(session.configuration.timeoutIntervalForResource) == 10.0
            }
        }

        describe("request") {
            it("calls dataTask on its urlSession passing the urlRequest as param") {
                let session = URLSessionMock()
                let client = SimpleClient(
                    connectivityManager: ConnectivityMock(connected: true),
                    logger: NoopLogger(),
                    urlSession: session
                )
                client.request(self.exampleRequest, apiCode: .EMPTY) { _ in }
                expect(session.dataTaskCalledWith) == self.exampleRequest
            }

            it("calls resume on the result of the dataTask") {
                let dataTaskResult = URLSessionDataTaskMock()
                let session = URLSessionMock(
                    configuration: URLSessionConfiguration.default,
                    dataTaskResult: dataTaskResult
                )
                let client = SimpleClient(
                    connectivityManager: ConnectivityMock(connected: true),
                    logger: NoopLogger(),
                    urlSession: session
                )
                client.request(self.exampleRequest, apiCode: .EMPTY) { _ in }
                expect(dataTaskResult.resumeWasCalled) == true
            }

            describe("when the result data from the call is different than nil") {
                it("calls the completionHandler with it") {
                    var result: Result<Data?, SPError>?
                    let session = URLSessionMock(
                        configuration: URLSessionConfiguration.default,
                        data: "".data(using: .utf8),
                        error: nil
                    )
                    let client = SimpleClient(
                        connectivityManager: ConnectivityMock(connected: true),
                        logger: NoopLogger(),
                        urlSession: session
                    )
                    client.request(self.exampleRequest, apiCode: .EMPTY) { result = $0 }
                    expect(result).toEventuallyNot(beNil())
                }
            }

            describe("when the error from the call is not nil") {
                it("calls the completionHandler with the error") {
                    let session = URLSessionMock(
                        configuration: URLSessionConfiguration.default,
                        data: nil,
                        error: SPError()
                    )
                    let client = SimpleClient(
                        connectivityManager: ConnectivityMock(connected: true),
                        logger: NoopLogger(),
                        urlSession: session
                    )
                    client.request(self.exampleRequest, apiCode: .EMPTY) { result in
                        switch result {
                        case .success: fail("call should fail")

                        case .failure(let e):
                            expect(e).toEventuallyNot(beNil())
                        }
                    }
                }
            }
        }

        describe("when there's no internet connection") {
            it("calls the completionHandler with an NoInternetConnection error") {
                let client = SimpleClient(
                    connectivityManager: ConnectivityMock(connected: false),
                    logger: NoopLogger(),
                    urlSession: URLSession.shared
                )
                client.request(self.exampleRequest, apiCode: .EMPTY) { result in
                    switch result {
                    case .success: fail("call should fail")

                    case .failure(let e):
                        expect(e).toEventually(beAKindOf(NoInternetConnection.self))
                    }
                }
            }
        }
    }
}
