//
//  HttpMock.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 10.06.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
@testable import ConsentViewController

class MockHttp: HttpClient {
    var getWasCalledWithUrl: URL?
    var postWasCalledWithUrl: URL?
    var postWasCalledWithBody: Data?
    var success: Data?
    var error: Error?

    init(success: Data?) {
        self.success = success
    }

    init(error: Error?) {
        self.error = error
    }

    public func get(url: URL?, completionHandler: @escaping CompletionHandler) {}

    func request(_ urlRequest: URLRequest, _ completionHandler: @escaping CompletionHandler) {}

    public func post(url: URL?, body: Data?, completionHandler: @escaping CompletionHandler) {
        postWasCalledWithUrl = url?.absoluteURL
        postWasCalledWithBody = body
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.success != nil ?
                completionHandler(self.success!, nil) :
                completionHandler(nil, APIParsingError(url!.absoluteString, self.error))
        })
    }
}
