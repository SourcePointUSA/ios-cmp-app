//
//  SourcePointClient.swift
//  GDPRConsentViewController
//
//  Created by Andre Herculano on 13.03.19.
//

import Foundation

typealias CompletionHandler = (Data?, GDPRConsentViewControllerError?) -> Void

protocol HttpClient {

    func get(url: URL?, completionHandler: @escaping CompletionHandler)
    func post(url: URL?, body: Data?, completionHandler: @escaping CompletionHandler)
}

class SimpleClient: HttpClient {
    let connectivityManager: Connectivity
    let logger: SPLogger
    let printCalls: Bool = false

    func logRequest(_ request: URLRequest) {
        if printCalls {
            if let method = request.httpMethod, let url = request.url {
                logger.debug("\(method) \(url)")
            }
            if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
                logger.debug("REQUEST: \(bodyString)")
            }
            logger.debug("\n")
        }
    }

    func logResponse(_ request: URLRequest, response: Data) {
        if printCalls {
            if let method = request.httpMethod, let url = request.url {
                logger.debug("\(method) \(url)")
            }
            if let responseString =  String(data: response, encoding: .utf8) {
                logger.debug("RESPONSE: \(responseString)")
            }
            logger.debug("\n")
        }
    }

    init(connectivityManager: Connectivity, logger: SPLogger) {
        self.connectivityManager = connectivityManager
        self.logger = logger
    }

    convenience init() {
        self.init(connectivityManager: ConnectivityManager(), logger: OSLogger())
    }

    func request(_ urlRequest: URLRequest, _ completionHandler: @escaping CompletionHandler) {
        if connectivityManager.isConnectedToNetwork() {
            logRequest(urlRequest)
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                DispatchQueue.main.async { [weak self] in
                    guard let data = data else {
                        completionHandler(nil, GeneralRequestError(urlRequest.url, response, error))
                        return
                    }
                    self?.logResponse(urlRequest, response: data)
                    completionHandler(data, nil)
                }
            }.resume()
        } else {
            completionHandler(nil, NoInternetConnection())
        }
    }

    func post(url: URL?, body: Data?, completionHandler: @escaping CompletionHandler) {
        guard let _url = url else {
            completionHandler(nil, GeneralRequestError(url, nil, nil))
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
            completionHandler(nil, GeneralRequestError(url, nil, nil))
            return
        }
        request(URLRequest(url: _url), completionHandler)
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
    static let WRAPPER_API = URL(string: "https://wrapper-api.sp-prod.net/tcfv2/v1/gdpr/")!
    static let GET_MESSAGE_CONTENTS_URL = URL(string: "native-message?inApp=true", relativeTo: SourcePointClient.WRAPPER_API)!
    static let GET_MESSAGE_URL_URL = URL(string: "message-url?inApp=true", relativeTo: SourcePointClient.WRAPPER_API)!
    static let CONSENT_URL = URL(string: "consent?inApp=true", relativeTo: SourcePointClient.WRAPPER_API)!

    private var client: HttpClient
    private lazy var json: JSON = { return JSON() }()

    let requestUUID = UUID()

    private let accountId: Int
    private let propertyId: Int
    private let propertyName: GDPRPropertyName
    private let pmId: String
    private let campaignEnv: GDPRCampaignEnv
    private let targetingParams: TargetingParams?

    init(
        accountId: Int,
        propertyId: Int,
        propertyName: GDPRPropertyName,
        pmId: String,
        campaignEnv: GDPRCampaignEnv,
        targetingParams: TargetingParams?,
        client: HttpClient
    ) {
        self.accountId = accountId
        self.propertyId = propertyId
        self.propertyName = propertyName
        self.pmId = pmId
        self.campaignEnv = campaignEnv
        self.targetingParams = targetingParams
        self.client = client
    }

    convenience init(accountId: Int,
                     propertyId: Int,
                     propertyName: GDPRPropertyName,
                     pmId: String,
                     campaignEnv: GDPRCampaignEnv
    ) {
        self.init(accountId: accountId,
                  propertyId: propertyId,
                  propertyName: propertyName,
                  pmId: pmId,
                  campaignEnv: campaignEnv,
                  targetingParams: nil,
                  client: SimpleClient()
        )
    }

    convenience init(
        accountId: Int,
        propertyId: Int,
        propertyName: GDPRPropertyName,
        pmId: String,
        campaignEnv: GDPRCampaignEnv,
        targetingParams: TargetingParams
    ) {
        self.init(
            accountId: accountId,
            propertyId: propertyId,
            propertyName: propertyName,
            pmId: pmId,
            campaignEnv: campaignEnv,
            targetingParams: targetingParams,
            client: SimpleClient()
        )
    }

    func targetingParamsToString(_ params: TargetingParams?) -> String {
        let emptyParams = "{}"
        do {
            let data = try JSONSerialization.data(withJSONObject: params!)
            return String(data: data, encoding: .utf8) ?? emptyParams
        } catch {
            return emptyParams
        }
    }

    func getMessage(url: URL, consentUUID: GDPRUUID?, euconsent: String, authId: String?, completionHandler: @escaping (MessageResponse?, APIParsingError? ) -> Void) {
        guard let body = try? json.encode(MessageRequest(
            uuid: consentUUID,
            euconsent: euconsent,
            authId: authId,
            accountId: accountId,
            propertyId: propertyId,
            propertyHref: propertyName,
            campaignEnv: campaignEnv,
            targetingParams: targetingParamsToString(targetingParams),
            requestUUID: requestUUID,
            meta: UserDefaults.standard.string(forKey: GDPRConsentViewController.META_KEY) ?? "{}"
        )) else {
            completionHandler(nil, APIParsingError(url.absoluteString, nil))
            return
        }
        client.post(url: url, body: body) { [weak self] data, error in
            do {
                if let messageData = data {
                    let messageResponse = try (self?.json.decode(MessageResponse.self, from: messageData))
                    UserDefaults.standard.setValue(messageResponse?.meta, forKey: GDPRConsentViewController.META_KEY)
                    completionHandler(messageResponse, nil)
                } else {
                    completionHandler(nil, APIParsingError(url.absoluteString, error))
                }
            } catch {
                completionHandler(nil, APIParsingError(url.absoluteString, error))
            }
        }
    }

    func getMessage(native: Bool, consentUUID: GDPRUUID?, euconsent: String, authId: String?, completionHandler: @escaping (MessageResponse?, APIParsingError?) -> Void) {
        getMessage(
            url: native ?
                SourcePointClient.GET_MESSAGE_CONTENTS_URL :
                SourcePointClient.GET_MESSAGE_URL_URL,
            consentUUID: consentUUID,
            euconsent: euconsent,
            authId: authId,
            completionHandler: completionHandler
        )
    }

    func postAction(action: GDPRAction, consentUUID: GDPRUUID, completionHandler: @escaping (ActionResponse?, APIParsingError?) -> Void) {
        let url = SourcePointClient.CONSENT_URL

        guard
            let pmPayload = try? JSONDecoder().decode(SPGDPRArbitraryJson.self, from: action.payload),
            let body = try? json.encode(ActionRequest(
                propertyId: propertyId,
                propertyHref: propertyName,
                accountId: accountId,
                actionType: action.type.rawValue,
                choiceId: action.id,
                privacyManagerId: pmId,
                requestFromPM: action.id == nil,
                uuid: consentUUID,
                requestUUID: requestUUID,
                pmSaveAndExitVariables: pmPayload,
                meta: UserDefaults.standard.string(forKey: GDPRConsentViewController.META_KEY) ?? "{}"
            )) else {
                completionHandler(nil, APIParsingError(url.absoluteString, nil))
                return
        }
        client.post(url: url, body: body) { [weak self] data, error  in
            do {
                if let actionData = data {
                    let actionResponse = try (self?.json.decode(ActionResponse.self, from: actionData))
                    UserDefaults.standard.setValue(actionResponse?.meta, forKey: GDPRConsentViewController.META_KEY)
                    completionHandler(actionResponse, nil)
                } else {
                    completionHandler(nil, APIParsingError(url.absoluteString, error))
                }
            } catch {
                completionHandler(nil, APIParsingError(url.absoluteString, error))
            }
        }
    }
}
