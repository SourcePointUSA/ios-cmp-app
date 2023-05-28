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
        dataTask(with: request, completionHandler: completionHandler)
    }
}

extension URLSessionDataTask: SPURLSessionDataTask {}

extension DispatchQueue: SPDispatchQueue {
    func async(execute work: @escaping () -> Void) {
        async(group: nil, qos: .unspecified, flags: [], execute: work)
    }
}

typealias ResponseHandler = (Result<Data?, SPError>) -> Void

protocol HttpClient {
    func get(urlString: String, apiCode: InvalidResponsAPICode, handler: @escaping ResponseHandler)
    func post(urlString: String, body: Data?, apiCode: InvalidResponsAPICode, handler: @escaping ResponseHandler)
    func delete(urlString: String, body: Data?, apiCode: InvalidResponsAPICode, handler: @escaping ResponseHandler)
}

class SimpleClient: HttpClient {
    let connectivityManager: Connectivity
    let logger: SPLogger
    let session: SPURLSession
    let dispatchQueue: SPDispatchQueue

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
            logger: OSLogger.standard,
            urlSession: URLSession(configuration: config),
            dispatchQueue: DispatchQueue.main
        )
    }

    func logRequest(_ type: String, _ request: URLRequest, _ body: Data?) {
        if let method = request.httpMethod, let url = request.url {
            logger.debug("\(type) \(method) \(url)")
            if let body = body, let bodyString = String(data: body, encoding: .utf8) {
                logger.debug(bodyString)
            }
        }
    }

    func logRequest(_ request: URLRequest, _ body: Data?) {
        logRequest("request -", request, body)
    }

    func logResponse(_ request: URLRequest, _ response: Data?) {
        logRequest("response -", request, response)
    }

    func request(_ urlRequest: URLRequest, apiCode: InvalidResponsAPICode, _ handler: @escaping ResponseHandler) {
        logRequest(urlRequest, urlRequest.httpBody)
        guard connectivityManager.isConnectedToNetwork() else {
            handler(.failure(NoInternetConnection()))
            return
        }
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        session.dataTask(urlRequest) { [weak self] data, response, error in
            self?.dispatchQueue.async { [weak self] in
                self?.logResponse(urlRequest, data)

                if error != nil {
                    if let response = response as? HTTPURLResponse {
                        switch response.statusCode {
                        case 408:
                            handler(.failure(ConnectionTimeoutAPIError(apiCode: apiCode)))

                        case 400...407, 409...499, 500...599:
                            handler(.failure(InvalidResponseAPIError(apiCode: apiCode)))

                        default:
                            handler(.failure(GenericNetworkError(request: urlRequest, response: response)))
                        }
                    }
                } else {
                    handler(.success(data))
                }
            }
        }.resume()
    }

    func post(urlString: String, body: Data?, apiCode: InvalidResponsAPICode = .EMPTY, handler: @escaping ResponseHandler) {
        guard let url = URL(string: urlString) else {
            handler(.failure(InvalidURLError(urlString: urlString)))
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = body
        request(urlRequest, apiCode: apiCode, handler)
    }

    func get(urlString: String, apiCode: InvalidResponsAPICode = .EMPTY, handler: @escaping ResponseHandler) {
        guard let url = URL(string: urlString) else {
            handler(.failure(InvalidURLError(urlString: urlString)))
            return
        }
        request(URLRequest(url: url), apiCode: apiCode, handler)
    }

    func delete(urlString: String, body: Data?, apiCode: InvalidResponsAPICode = .EMPTY, handler: @escaping ResponseHandler) {
        guard let url = URL(string: urlString) else {
            handler(.failure(InvalidURLError(urlString: urlString)))
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "DELETE"
        urlRequest.httpBody = body
        request(urlRequest, apiCode: apiCode, handler)
    }
}
