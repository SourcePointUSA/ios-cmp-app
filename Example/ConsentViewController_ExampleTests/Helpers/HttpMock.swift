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
    var error = SPError()

    init(success: Data? = nil) {
        self.success = success
    }

    init(error: SPError) {
        self.error = error
    }

    private func successOrError(_ handler: @escaping ResponseHandler) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1)) {
            self.success != nil ?
                handler(.success(self.success)) :
                handler(.failure(self.error))
        }
    }

    public func get(urlString: String, apiCode: InvalidResponsAPICode = .EMPTY, handler: @escaping ResponseHandler) {
        self.getWasCalledWithUrl = urlString
        successOrError(handler)
    }

    func request(_ urlRequest: URLRequest, apiCode: InvalidResponsAPICode = .EMPTY, _ handler: @escaping ResponseHandler) {}

    public func post(urlString: String, body: Data?, apiCode: InvalidResponsAPICode = .EMPTY, handler: @escaping ResponseHandler) {
        postWasCalledWithUrl = urlString
        postWasCalledWithBody = body
        successOrError(handler)
    }

    public func delete(urlString: String, body: Data?, apiCode: InvalidResponsAPICode = .EMPTY, handler: @escaping ResponseHandler) {
        deleteWasCalledWithBody = body
        successOrError(handler)
    }
}
