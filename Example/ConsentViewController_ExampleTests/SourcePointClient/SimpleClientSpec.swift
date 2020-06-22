//
//  SimpleClientSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 26.05.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import ConsentViewController

// swiftlint:disable force_cast function_body_length

class ConnectivityMock: Connectivity {
    let isConnected: Bool
    init(connected: Bool) {
        isConnected = connected
    }
    func isConnectedToNetwork() -> Bool {
        return isConnected
    }
}

class URLSessionDataTaskMock: SPURLSessionDataTask {
    var resumeWasCalled = false

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

    func dataTask(_ request: URLRequest, completionHandler: @escaping DataTaskResult) -> SPURLSessionDataTask {
        dataTaskCalledWith = request
        completionHandler(result, URLResponse(), error)
        return dataTaskResult
    }

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
}

class DispatchQueueMock: SPDispatchQueue {
    var asyncCalled: Bool?

    func async(execute work: @escaping () -> Void) {
        asyncCalled = true
        work()
    }
}

class SimpleClientSpec: QuickSpec {
    let exampleRequest = URLRequest(url: URL(string: "http://example")!)

    override func spec() {
        describe("init(timeoutAfter: TimeInterval)") {
            it("sets the dispatchQueue to DispatchQueue.main") {
                let dispatchQueue = SimpleClient(timeoutAfter: 1).dispatchQueue as! DispatchQueue
                expect(dispatchQueue).to(equal(DispatchQueue.main))
            }

            it("sets the timeout in its URLSession") {
                let session = SimpleClient(timeoutAfter: 10.0).session as! URLSession
                expect(session.configuration.timeoutIntervalForResource).to(equal(10.0))
            }
        }

        describe("request") {
            it("calls dataTask on its urlSession passing the urlRequest as param") {
                let session = URLSessionMock()
                let client = SimpleClient(
                    connectivityManager: ConnectivityMock(connected: true),
                    logger: OSLogger(),
                    urlSession: session,
                    dispatchQueue: DispatchQueue.main
                )
                client.request(self.exampleRequest) { _, _ in }
                expect(session.dataTaskCalledWith).to(equal(self.exampleRequest))
            }

            it("calls requestCachePolicy on its urlSession configuration") {
                let session = URLSessionMock()
                session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
                let client = SimpleClient(
                    connectivityManager: ConnectivityMock(connected: true),
                    logger: OSLogger(),
                    urlSession: session,
                    dispatchQueue: DispatchQueue.main
                )
                client.request(self.exampleRequest) { _, _ in }
                expect(session.configuration.requestCachePolicy).to(equal(.reloadIgnoringLocalCacheData))
            }

            it("calls async on its dispatchQueue with the result of the dataTask") {
                let queue = DispatchQueueMock()
                let client = SimpleClient(
                    connectivityManager: ConnectivityMock(connected: true),
                    logger: OSLogger(),
                    urlSession: URLSession.shared,
                    dispatchQueue: queue
                )
                client.request(self.exampleRequest) { _, _ in }
                expect(queue.asyncCalled).toEventually(beTrue())
            }

            it("calls resume on the result of the dataTask") {
                let dataTaskResult = URLSessionDataTaskMock()
                let session = URLSessionMock(
                    configuration: URLSessionConfiguration.default,
                    dataTaskResult: dataTaskResult
                )
                let client = SimpleClient(
                    connectivityManager: ConnectivityMock(connected: true),
                    logger: OSLogger(),
                    urlSession: session,
                    dispatchQueue: DispatchQueue.main
                )
                client.request(self.exampleRequest) { _, _ in }
                expect(dataTaskResult.resumeWasCalled).to(beTrue())
            }

            describe("when the result data from the call is different than nil") {
                it("calls the completionHandler with it") {
                    var result: Data?
                    let session = URLSessionMock(
                        configuration: URLSessionConfiguration.default,
                        data: "".data(using: .utf8),
                        error: nil
                    )
                    let client = SimpleClient(
                        connectivityManager: ConnectivityMock(connected: true),
                        logger: OSLogger(),
                        urlSession: session,
                        dispatchQueue: DispatchQueueMock()
                    )
                    client.request(self.exampleRequest) { data, _ in result = data }
                    expect(result).toEventuallyNot(beNil())
                }
            }

            describe("when the result data from the call is nil") {
                it("calls the completionHandler with the error") {
                    var error: GDPRConsentViewControllerError?
                    let session = URLSessionMock(
                        configuration: URLSessionConfiguration.default,
                        data: nil,
                        error: GeneralRequestError(nil, nil, nil)
                    )
                    let client = SimpleClient(
                        connectivityManager: ConnectivityMock(connected: true),
                        logger: OSLogger(),
                        urlSession: session,
                        dispatchQueue: DispatchQueueMock()
                    )
                    client.request(self.exampleRequest) { _, e in error = e }
                    expect(error).toEventuallyNot(beNil())
                }
            }
        }

        describe("when there's no internet connection") {
            it("calls the completionHandler with an NoInternetConnection error") {
                var error: GDPRConsentViewControllerError?
                let client = SimpleClient(
                    connectivityManager: ConnectivityMock(connected: false),
                    logger: OSLogger(),
                    urlSession: URLSession.shared,
                    dispatchQueue: DispatchQueue.main
                )
                client.request(self.exampleRequest) { _, e in error = e! }
                expect(error).toEventually(beAKindOf(NoInternetConnection.self))
            }
        }
    }
}
