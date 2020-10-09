//
//  SimpleClient.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 26.05.20.
//

import Foundation

protocol SPURLSessionDataTask {
    func resume()
}

protocol SPURLSession { typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    var configuration: URLSessionConfiguration { get }
    func dataTask(_ request: URLRequest, completionHandler: @escaping DataTaskResult) -> SPURLSessionDataTask
}

protocol SPDispatchQueue {
    func async(execute work: @escaping () -> Void)
}

extension URLSession: SPURLSession {
    func dataTask(_ request: URLRequest, completionHandler: @escaping DataTaskResult) -> SPURLSessionDataTask {
        return dataTask(with: request, completionHandler: completionHandler)
    }
}

extension URLSessionDataTask: SPURLSessionDataTask {}

extension DispatchQueue: SPDispatchQueue {
    func async(execute work: @escaping () -> Void) {
        async(group: nil, qos: .unspecified, flags: [], execute: work)
    }
}

typealias CompletionHandler = (Data?, GDPRConsentViewControllerError?) -> Void

protocol HttpClient {
    func get(url: URL?, completionHandler: @escaping CompletionHandler)
    func post(url: URL?, body: Data?, completionHandler: @escaping CompletionHandler)
}

class SimpleClient: HttpClient {
    let connectivityManager: Connectivity
    let logger: SPLogger
    let session: SPURLSession
    let dispatchQueue: SPDispatchQueue

    let logCalls: Bool = false

    func logRequest(_ type: String, _ request: URLRequest, _ body: Data?) {
        if logCalls, let method = request.httpMethod, let url = request.url {
            logger.debug("\(type) \(method) \(url)")
            if let body = body, let bodyString = String(data: body, encoding: .utf8) {
                logger.debug(bodyString)
            }
        }
    }

    func logRequest(_ request: URLRequest, _ body: Data?) {
        logRequest("REQUEST", request, body)
    }

    func logResponse(_ request: URLRequest, _ response: Data?) {
        logRequest("RESPONSE", request, response)
    }

    init(connectivityManager: Connectivity, logger: SPLogger, urlSession: SPURLSession, dispatchQueue: SPDispatchQueue) {
        self.connectivityManager = connectivityManager
        self.logger = logger
        session = urlSession
        self.dispatchQueue = dispatchQueue
    }

    convenience init() {
        self.init(
            connectivityManager: ConnectivityManager(),
            logger: OSLogger(),
            urlSession: URLSession(configuration: URLSessionConfiguration.default),
            dispatchQueue: DispatchQueue.main
        )
    }

    func request(_ urlRequest: URLRequest, _ completionHandler: @escaping CompletionHandler) {
        logRequest(urlRequest, urlRequest.httpBody)
        guard connectivityManager.isConnectedToNetwork() else {
            completionHandler(nil, GDPRNoInternetConnection())
            return
        }
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        session.dataTask(urlRequest) { [weak self] data, response, error in
            self?.dispatchQueue.async { [weak self] in
                self?.logResponse(urlRequest, data)
                data != nil ?
                    completionHandler(data, nil) :
                    completionHandler(nil, GDPRGeneralRequestError(urlRequest.url, response, error))
            }
        }.resume()
    }

    func post(url: URL?, body: Data?, completionHandler: @escaping CompletionHandler) {
        guard let _url = url else {
            completionHandler(nil, GDPRGeneralRequestError(url, nil, nil))
            return
        }
        var urlRequest = URLRequest(url: _url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = body
        request(urlRequest, completionHandler)
    }

    func get(url: URL?, completionHandler: @escaping CompletionHandler) {
        guard let _url = url else {
            completionHandler(nil, GDPRGeneralRequestError(url, nil, nil))
            return
        }
        request(URLRequest(url: _url), completionHandler)
    }
}
