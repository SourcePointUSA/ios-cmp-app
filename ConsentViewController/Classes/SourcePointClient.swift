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

/**
A Http client for SourcePoint's endpoints
 - Important: it should only be used the SDK as its public API is still in constant development and is probably going to change.
 */
class SourcePointClient {
    static let WRAPPER_API = URL(string: "https://wrapper-api.sp-prod.net")!
    static let GET_MESSAGE_URL = URL(string: "gdpr/message-url", relativeTo: SourcePointClient.WRAPPER_API)!
    static let CONSENT_URL = URL(string: "gdpr/consent", relativeTo: SourcePointClient.WRAPPER_API)!
    static let GET_GDPR_STATUS_URL = URL(string: "https://sourcepoint.mgr.consensu.org/consent/v2/gdpr-status")!
    
    private var client: HttpClient
    private lazy var json: JSON = { return JSON() }()
    
    let requestUUID = UUID()
    
    private let accountId: Int
    private let propertyId: Int
    private let propertyName: PropertyName
    private let pmId: String
    private let campaignEnv: CampaignEnv
    private let targetingParams: TargetingParams?
    
    public var onError: OnError? { didSet { client.defaultOnError = onError } }

    init(accountId: Int, propertyId:Int, propertyName: PropertyName, pmId:String, campaignEnv: CampaignEnv, targetingParams: TargetingParams?, client: HttpClient) {
        self.accountId = accountId
        self.propertyId = propertyId
        self.propertyName = propertyName
        self.pmId = pmId
        self.campaignEnv = campaignEnv
        self.targetingParams = targetingParams
        self.client = client
    }
    
    convenience init(accountId: Int, propertyId: Int, propertyName: PropertyName, pmId: String, campaignEnv: CampaignEnv) {
        self.init(accountId: accountId, propertyId: propertyId, propertyName: propertyName, pmId: pmId, campaignEnv: campaignEnv, targetingParams: nil, client: SimpleClient())
    }
    
    convenience init(accountId: Int, propertyId: Int, propertyName: PropertyName, pmId: String, campaignEnv: CampaignEnv, targetingParams: TargetingParams) {
        self.init(accountId: accountId, propertyId: propertyId, propertyName: propertyName, pmId: pmId, campaignEnv: campaignEnv, targetingParams: targetingParams, client: SimpleClient())
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
    
    private func targetingParamsToString(_ params: TargetingParams?) -> String {
        let emptyParams = "{}"
        do {
            let data = try JSONSerialization.data(withJSONObject: params!)
            return String(data: data, encoding: .utf8) ?? emptyParams
        } catch {
            return emptyParams
        }
    }

    func getMessage(consentUUID: ConsentUUID?, euconsent: ConsentString?, onSuccess: @escaping (MessageResponse) -> Void) {
        let url = SourcePointClient.GET_MESSAGE_URL
        guard let body = try? json.encode(MessageRequest(
            uuid: consentUUID,
            euconsent: euconsent,
            accountId: accountId,
            propertyId: propertyId,
            propertyHref: propertyName,
            campaignEnv: campaignEnv,
            targetingParams: targetingParamsToString(targetingParams),
            requestUUID: requestUUID,
            meta: UserDefaults.standard.string(forKey: ConsentViewController.META_KEY) ?? "{}"
        )) else {
            self.onError?(APIParsingError(url.absoluteString, nil))
            return
        }
        print("MESSAGE-URL REQUEST: ", String(data: body, encoding: .utf8)!)
        client.post(url: url, body: body) { [weak self] data in
            do {
                print("MESSAGE-URL RESPONSE: ", String(data: data, encoding: .utf8)!)
                let messageResponse = try (self?.json.decode(MessageResponse.self, from: data))!
                UserDefaults.standard.setValue(messageResponse.meta, forKey: ConsentViewController.META_KEY)
                onSuccess(messageResponse)
            } catch {
                self?.onError?(APIParsingError(url.absoluteString, error))
            }
        }
    }

    func postAction(action: Action, consentUUID: ConsentUUID, consents: PMConsents?, onSuccess: @escaping (ActionResponse) -> Void) {
        let url = SourcePointClient.CONSENT_URL
        guard let body = try? json.encode(ActionRequest(
            propertyId: propertyId,
            propertyHref: propertyName,
            accountId: accountId,
            actionType: action.type.rawValue,
            choiceId: action.id,
            privacyManagerId: pmId,
            requestFromPM: action.id == nil,
            uuid: consentUUID,
            requestUUID: requestUUID,
            consents: GDPRPMConsents(
                acceptedVendors: consents?.vendors.accepted ?? [],
                acceptedCategories: consents?.categories.accepted ?? []
            ),
            meta: UserDefaults.standard.string(forKey: ConsentViewController.META_KEY) ?? "{}"
        )) else {
            self.onError?(APIParsingError(url.absoluteString, nil))
            return
        }
        print("CONSENT REQUEST: ", String(data: body, encoding: .utf8)!)
        client.post(url: url, body: body) { [weak self] data in
            do {
                print("CONSENT RESPONSE: ", String(data: data, encoding: .utf8)!)
                let actionResponse = try (self?.json.decode(ActionResponse.self, from: data))!
                UserDefaults.standard.setValue(actionResponse.meta, forKey: ConsentViewController.META_KEY)
                onSuccess(actionResponse)
            } catch {
                self?.onError?(APIParsingError(url.absoluteString, error))
            }
        }
    }
}
