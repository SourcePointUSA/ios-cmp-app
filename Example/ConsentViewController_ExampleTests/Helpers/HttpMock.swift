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
    var postWasCalledWithUrl: String!
    var postWasCalledWithBody: Data?
    var deleteWasCalledWithBody: Data?
    var success: Data?
    var error: Error?

    init(success: Data? = nil) {
        self.success = success
    }

    init(error: Error?) {
        self.error = error
    }

    public func get(urlString: String, handler: @escaping ResponseHandler) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1), execute: {
            self.success != nil ?
            handler(.success(self.success)) :
            handler(.failure(SPError(error: self.error!)))
        })
    }

    func request(_ urlRequest: URLRequest, _ handler: @escaping ResponseHandler) {}

    public func post(urlString: String, body: Data?, handler: @escaping ResponseHandler) {
        postWasCalledWithUrl = urlString
        postWasCalledWithBody = body
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.success != nil ?
                handler(.success(self.success)) :
                handler(.failure(InvalidURLError(urlString: urlString)))
        })
    }

    public func delete(urlString: String, body: Data?, handler: @escaping ResponseHandler) {
        self.deleteWasCalledWithBody = body
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.success != nil ?
                handler(.success(self.success)) :
                handler(.failure(InvalidURLError(urlString: urlString)))
        })
    }
}
