//
//  HttpMock.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 10.06.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

@testable import ConsentViewController
import Foundation

class MockHttp: HttpClient {
    var postWasCalledWithUrl: String!
    var postWasCalledWithBody: Data?
    var deleteWasCalledWithBody: Data?
    var getWasCalledWithUrl: String?
    var success: Data?
    var error: Error?

    init(success: Data? = nil) {
        self.success = success
    }

    init(error: Error?) {
        self.error = error
    }

    public func get(urlString: String, apiCode: InvalidResponsAPICode?, handler: @escaping ResponseHandler) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1)) {
            self.getWasCalledWithUrl = urlString
            if self.success != nil {
                handler(.success(self.success))
            } else {
                // swiftlint:disable:next force_unwrapping
                handler(.failure(SPError(error: self.error!)))
            }
        }
    }

    func request(_ urlRequest: URLRequest, apiCode: InvalidResponsAPICode?, _ handler: @escaping ResponseHandler) {}

    public func post(urlString: String, body: Data?, apiCode: InvalidResponsAPICode?, handler: @escaping ResponseHandler) {
        postWasCalledWithUrl = urlString
        postWasCalledWithBody = body
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1)) {
            self.success != nil ?
                handler(.success(self.success)) :
                handler(.failure(InvalidURLError(urlString: urlString)))
        }
    }

    public func delete(urlString: String, body: Data?, apiCode: InvalidResponsAPICode?, handler: @escaping ResponseHandler) {
        self.deleteWasCalledWithBody = body
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1)) {
            self.success != nil ?
                handler(.success(self.success)) :
                handler(.failure(InvalidURLError(urlString: urlString)))
        }
    }
}
