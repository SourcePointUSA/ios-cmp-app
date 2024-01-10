//
//  SimpleClient.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 26.05.20.
//

import Foundation

protocol SPURLSessionDataTask {
    var priority: Float { get set }
    func resume()
}

protocol SPURLSession { typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    var configuration: URLSessionConfiguration { get }
    func dataTask(_ request: URLRequest, completionHandler: @escaping DataTaskResult) -> SPURLSessionDataTask
}

extension URLSession: SPURLSession {
    func dataTask(_ request: URLRequest, completionHandler: @escaping DataTaskResult) -> SPURLSessionDataTask {
        let task = dataTask(with: request, completionHandler: completionHandler)
        task.priority = 1.0
        return task
    }
}

extension URLSessionDataTask: SPURLSessionDataTask {
    public override var priority: Float { get { URLSessionTask.highPriority } set {} }
}

typealias ResponseHandler = (Result<Data?, SPError>) -> Void

protocol HttpClient {
    func get(urlString: String, apiCode: InvalidResponsAPICode, handler: @escaping ResponseHandler)
    func post(urlString: String, body: Data?, apiCode: InvalidResponsAPICode, handler: @escaping ResponseHandler)
    func delete(urlString: String, body: Data?, apiCode: InvalidResponsAPICode, handler: @escaping ResponseHandler)
}

class SimpleClient: HttpClient {
    static func sessionConfig(withTimeout timeout: TimeInterval) -> URLSessionConfiguration {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForResource = timeout
        config.requestCachePolicy = .useProtocolCachePolicy
        config.urlCache = .shared
        config.networkServiceType = .responsiveData
        config.httpCookieStorage = .shared
        config.allowsCellularAccess = true
        config.httpCookieAcceptPolicy = .always
        config.httpMaximumConnectionsPerHost = 10
        config.isDiscretionary = false
        config.shouldUseExtendedBackgroundIdleMode = true
        if #available(iOS 11.0, tvOS 11.0, *) {
            config.waitsForConnectivity = false
        }
        if #available(iOS 13.0, tvOS 13.0, *) {
            config.allowsExpensiveNetworkAccess = true
            config.allowsConstrainedNetworkAccess = true
        }
        return config
    }

    let connectivityManager: Connectivity
    let logger: SPLogger
    let session: SPURLSession

    init(connectivityManager: Connectivity, logger: SPLogger, urlSession: SPURLSession) {
        self.connectivityManager = connectivityManager
        self.logger = logger
        session = urlSession
    }

    convenience init(timeoutAfter timeout: TimeInterval) {
        let session = URLSession(configuration: Self.sessionConfig(withTimeout: timeout))
        session.sessionDescription = "SourcepointSession"
        self.init(
            connectivityManager: ConnectivityManager(),
            logger: OSLogger.standard,
            urlSession: session
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
        session.dataTask(urlRequest) { [weak self] data, response, error in
            self?.logResponse(urlRequest, data)
            if error != nil {
                if let response = response as? HTTPURLResponse {
                    handler(.failure(InvalidResponseAPIError(
                        apiCode: apiCode,
                        statusCode: String(response.statusCode)
                    )))
                }
            } else {
                handler(.success(data))
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
