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
    func get(urlString: String, completionHandler: @escaping CompletionHandler)
    func post(urlString: String, body: Data?, completionHandler: @escaping CompletionHandler)
}

class SimpleClient: HttpClient {
    let connectivityManager: Connectivity
    let logger: SPLogger
    let session: SPURLSession
    let dispatchQueue: SPDispatchQueue

    let logCalls: Bool = false

    func logRequest(_ type: String, _ request: URLRequest, _ body: Data?) {
        if logCalls, let method = request.httpMethod, let url = request.url {
            logger.debug("\(type) \(method) \(url)", [:])
            if let body = body, let bodyString = String(data: body, encoding: .utf8) {
                logger.debug(bodyString, [:])
            }
        }
    }

    func logRequest(_ request: URLRequest, _ body: Data?) {
        logRequest("REQUEST", request, body)
    }

    func logResponse(_ request: URLRequest, _ response: Data?) {
        logRequest("REQUEST", request, response)
    }

    init(connectivityManager: Connectivity, logger: SPLogger, urlSession: SPURLSession, dispatchQueue: SPDispatchQueue) {
        self.connectivityManager = connectivityManager
        self.logger = logger
        session = urlSession
        self.dispatchQueue = dispatchQueue
    }

    convenience init(timeoutAfter timeout: TimeInterval) {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForResource = timeout
        self.init(
            connectivityManager: ConnectivityManager(),
            logger: OSLogger(),
            urlSession: URLSession(configuration: config),
            dispatchQueue: DispatchQueue.main
        )
    }

    func request(_ urlRequest: URLRequest, _ completionHandler: @escaping CompletionHandler) {
        logRequest(urlRequest, urlRequest.httpBody)
        guard connectivityManager.isConnectedToNetwork() else {
            completionHandler(nil, NoInternetConnection())
            return
        }
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        session.dataTask(urlRequest) { [weak self] data, response, error in
            self?.dispatchQueue.async { [weak self] in
                self?.logResponse(urlRequest, data)

                if error != nil {
                    var spError = GenericNetworkError(request: urlRequest, response: response as? HTTPURLResponse)
                    if let response = response as? HTTPURLResponse {
                        switch response.statusCode {
                        case 400...499:
                            spError = ResourceNotFoundError(request: urlRequest, response: response)
                        case 500...599:
                            spError = InternalServerError(request: urlRequest, response: response)
                        default:
                            spError = GenericNetworkError(request: urlRequest, response: response)
                        }
                    }
                    completionHandler(nil, spError)
                } else {
                    completionHandler(data, nil)
                }
            }
        }.resume()
    }

    func post(urlString: String, body: Data?, completionHandler: @escaping CompletionHandler) {
        guard let url = URL(string: urlString) else {
            completionHandler(nil, InvalidURLError(urlString: urlString))
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = body
        request(urlRequest, completionHandler)
    }

    func get(urlString: String, completionHandler: @escaping CompletionHandler) {
        guard let url = URL(string: urlString) else {
            completionHandler(nil, InvalidURLError(urlString: urlString))
            return
        }
        request(URLRequest(url: url), completionHandler)
    }
}