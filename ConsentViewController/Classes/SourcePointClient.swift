//
//  SourcePointClient.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 13.03.19.
//

import Foundation

typealias OnSuccess = (Data) -> Void
typealias OnError = (ConsentViewControllerError?) -> Void

protocol HttpClient {
    var defaultOnError: OnError? { get set }
    
    func get(url: URL?, onSuccess: @escaping OnSuccess)
    func post(url: URL?, body: Data?, onSuccess: @escaping OnSuccess)
}

class SimpleClient: HttpClient {
    var defaultOnError: OnError?
    let connectivityManager: Connectivity
    
    init(connectivityManager: Connectivity) {
        self.connectivityManager = connectivityManager
    }
    
    convenience init() {
        self.init(connectivityManager: ConnectivityManager.shared)
    }
    
    func request(_ urlRequest: URLRequest, _ onSuccess: @escaping OnSuccess) {
        if(connectivityManager.isConnectedToNetwork()) {
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                DispatchQueue.main.async { [weak self] in
                    guard let data = data else {
                        self?.defaultOnError?(GeneralRequestError(urlRequest.url, response, error))
                        return
                    }
                    onSuccess(data)
                }
            }.resume()
        } else {
            defaultOnError?(NoInternetConnection())
        }
    }
    
    func post(url: URL?, body: Data?, onSuccess: @escaping OnSuccess) {
        guard let _url = url else {
            defaultOnError?(GeneralRequestError(url, nil, nil))
            return
        }
        var urlRequest = URLRequest(url: _url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = body
        request(urlRequest, onSuccess)
    }
    
    func get(url: URL?, onSuccess: @escaping OnSuccess) {
        guard let _url = url else {
            defaultOnError?(GeneralRequestError(url, nil, nil))
            return
        }
        request(URLRequest(url: _url), onSuccess)
    }
}

typealias TargetingParams = [String:Codable]

struct JSON {
    private lazy var jsonDecoder: JSONDecoder = { return JSONDecoder() }()
    private lazy var jsonEncoder: JSONEncoder = { return JSONEncoder() }()
    
    mutating func decode<T: Decodable>(_ decodable: T.Type, from data: Data) throws -> T {
        return try jsonDecoder.decode(decodable, from: data)
    }
    
    mutating func encode<T: Encodable>(_ encodable: T) throws -> Data {
        return try jsonEncoder.encode(encodable)
    }
}

class SourcePointClient {
    static let WRAPPER_API = URL(string: "https://fake-wrapper-api.herokuapp.com")!
    static let CMP_URL = URL(string: "https://sourcepoint.mgr.consensu.org")!
    static let GET_GDPR_STATUS_URL = URL(string: "consent/v2/gdpr-status", relativeTo: CMP_URL)!
    
    private let client: HttpClient
    private lazy var json: JSON = { return JSON() }()
    
    let requestUUID = UUID()
    
    private let accountId: Int
    private let propertyId: Int
    private let pmId: String
    private let campaign: String
    
    private let onError: OnError?

    init(accountId: Int, propertyId:Int, pmId:String, campaign: String, client: HttpClient, onError: OnError?) {
        self.accountId = accountId
        self.propertyId = propertyId
        self.pmId = pmId
        self.campaign = campaign
        self.onError = onError
        self.client = client
    }
    
    convenience init(accountId: Int, propertyId: Int, pmId: String, campaign: String, onError: OnError?) {
        let client = SimpleClient()
        client.defaultOnError = onError
        self.init(accountId: accountId, propertyId: propertyId, pmId: pmId, campaign: campaign, client: client, onError: onError)
    }

    func getGdprStatus(onSuccess: @escaping (Bool) -> Void) {
        client.get(url: SourcePointClient.GET_GDPR_STATUS_URL) { [weak self] data in
            do {
                onSuccess(try (self?.json.decode(GdprStatus.self, from: data))!.gdprApplies)
            } catch {
                self?.onError?(APIParsingError(SourcePointClient.GET_GDPR_STATUS_URL.absoluteString, error))
            }
        }
    }
    
    func getCustomConsentsUrl(uuid: UUID) -> URL? {
        return URL(
            string: "consent/v2/\(propertyId)/custom-vendors?consentUUID=\(uuid.uuidString.lowercased())",
            relativeTo: SourcePointClient.CMP_URL
        )
    }

    func getCustomConsents(consentUUID: UUID, onSuccess: @escaping (ConsentsResponse) -> Void) {
        let url = getCustomConsentsUrl(uuid: consentUUID)
        client.get(url: url) { [weak self] data in
            do {
                onSuccess(try (self?.json.decode(ConsentsResponse.self, from: data))!)
            } catch {
                self?.onError?(APIParsingError(url?.absoluteString ?? "getCustomConsents", error))
            }
        }
    }
    
    func getMessageUrl() -> URL? {
        var components = URLComponents(url: SourcePointClient.WRAPPER_API, resolvingAgainstBaseURL: true)
        components?.path = "/message"
        components?.queryItems = [
            URLQueryItem(name: "propertyId", value: String(propertyId)),
            URLQueryItem(name: "accountId", value: String(accountId)),
            URLQueryItem(name: "requestUUID", value: requestUUID.uuidString)
//            TODO: add propertyHref
//            URLQueryItem(name: "propertyHref", value: String(),
        ]
        return components?.url
    }

    func getMessage(accountId: Int, propertyId: Int, onSuccess: @escaping (MessageResponse) -> Void) {
        let url = getMessageUrl()
        client.get(url: url) { [weak self] data in
            do {
                onSuccess(try (self?.json.decode(MessageResponse.self, from: data))!)
            } catch {
                self?.onError?(APIParsingError(url?.absoluteString ?? "getMessage", error))
            }
        }
    }
    
    func postActionUrl(_ actionType: Int) -> URL? {
        return URL(
            string: "action/\(actionType)",
            relativeTo: SourcePointClient.WRAPPER_API
        )
    }
    
    func postAction(action: Action, consentUUID: UUID?, onSuccess: @escaping (ActionResponse) -> Void) {
        let url = postActionUrl(action.rawValue)
        guard let body = try? json.encode(ActionRequest(propertyId: propertyId, accountId: accountId, actionType: action.rawValue, privacyManagerId: pmId, uuid: consentUUID, requestUUID: requestUUID)) else {
            self.onError?(APIParsingError(url?.absoluteString ?? "postAction", nil))
            return
        }
        
        client.post(url: url, body: body) { [weak self] data in
            do {
                onSuccess(try (self?.json.decode(ActionResponse.self, from: data))!)
            } catch {
                self?.onError?(APIParsingError(url?.absoluteString ?? "postAction", error))
            }
        }
    }
}
