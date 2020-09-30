//
//  SourcePointClient.swift
//  GDPRConsentViewController
//
//  Created by Andre Herculano on 13.03.19.
//

import Foundation

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
    static let WRAPPER_API = URL(string: "https://wrapper-api.sp-prod.net/gdpr/")!
    static let GET_MESSAGE_CONTENTS_URL = URL(string: "native-message", relativeTo: SourcePointClient.WRAPPER_API)!
    static let GET_MESSAGE_URL_URL = URL(string: "message-url", relativeTo: SourcePointClient.WRAPPER_API)!
    static let CONSENT_URL = URL(string: "consent", relativeTo: SourcePointClient.WRAPPER_API)!
    static let GET_GDPR_STATUS_URL = URL(string: "https://sourcepoint.mgr.consensu.org/consent/v2/gdpr-status")!

    private var client: HttpClient
    private lazy var json: JSON = { return JSON() }()

    let requestUUID = UUID()

    private let accountId: Int
    private let propertyId: Int
    private let propertyName: GDPRPropertyName
    private let pmId: String
    private let campaignEnv: GDPRCampaignEnv
    private let targetingParams: TargetingParams?

    init(accountId: Int, propertyId:Int, propertyName: GDPRPropertyName, pmId:String, campaignEnv: GDPRCampaignEnv, targetingParams: TargetingParams?, client: HttpClient) {
        self.accountId = accountId
        self.propertyId = propertyId
        self.propertyName = propertyName
        self.pmId = pmId
        self.campaignEnv = campaignEnv
        self.targetingParams = targetingParams
        self.client = client
    }

    convenience init(accountId: Int, propertyId: Int, propertyName: GDPRPropertyName, pmId: String, campaignEnv: GDPRCampaignEnv) {
        self.init(accountId: accountId, propertyId: propertyId, propertyName: propertyName, pmId: pmId, campaignEnv: campaignEnv, targetingParams: nil, client: SimpleClient())
    }

    convenience init(accountId: Int, propertyId: Int, propertyName: GDPRPropertyName, pmId: String, campaignEnv: GDPRCampaignEnv, targetingParams: TargetingParams) {
        self.init(accountId: accountId, propertyId: propertyId, propertyName: propertyName, pmId: pmId, campaignEnv: campaignEnv, targetingParams: targetingParams, client: SimpleClient())
    }

    func getGdprStatus(completionHandler: @escaping (Bool?, APIParsingError? ) -> Void) {
        client.get(url: SourcePointClient.GET_GDPR_STATUS_URL) { [weak self] data, error in
            do {
                if let gdprStatus = data {
                    completionHandler(try (self?.json.decode(GdprStatus.self, from: gdprStatus).gdprApplies), nil)
                } else {
                    completionHandler(nil, APIParsingError(SourcePointClient.GET_GDPR_STATUS_URL.absoluteString, error))
                }
            } catch {
                completionHandler(nil, APIParsingError(SourcePointClient.GET_GDPR_STATUS_URL.absoluteString, error))
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

    private func getMessage(url: URL, consentUUID: GDPRUUID?, euconsent: ConsentString?, authId: String?, completionHandler: @escaping (MessageResponse?, APIParsingError?) -> Void) {
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

    func getMessageUrl(consentUUID: GDPRUUID?, euconsent: ConsentString?, authId: String?, completionHandler: @escaping (MessageResponse?, APIParsingError?) -> Void) {
        getMessage(
            url: SourcePointClient.GET_MESSAGE_URL_URL,
            consentUUID: consentUUID,
            euconsent: euconsent,
            authId: authId,
            completionHandler: completionHandler
        )
    }

    func getMessageContents(consentUUID: GDPRUUID?, euconsent: ConsentString?, authId: String?, completionHandler: @escaping (MessageResponse?, APIParsingError?) -> Void) {
        getMessage(
            url: SourcePointClient.GET_MESSAGE_CONTENTS_URL,
            consentUUID: consentUUID,
            euconsent: euconsent,
            authId: authId,
            completionHandler: completionHandler
        )
    }

    func postAction(action: GDPRAction, consentUUID: GDPRUUID, consents: GDPRPMConsents?, completionHandler: @escaping (ActionResponse?, APIParsingError?) -> Void) {
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
            consents: PMConsents(
                acceptedVendors: consents?.vendors.accepted ?? [],
                acceptedCategories: consents?.categories.accepted ?? []
            ),
            meta: UserDefaults.standard.string(forKey: GDPRConsentViewController.META_KEY) ?? "{}"
        )) else {
            completionHandler(nil, APIParsingError(url.absoluteString, nil))
            return
        }
        client.post(url: url, body: body) { [weak self] data, error in
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

