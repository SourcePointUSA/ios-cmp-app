//
//  SourcePointClient.swift
//  GDPRConsentViewController
//
//  Created by Andre Herculano on 13.03.19.
//

import Foundation

extension Result where Success == Data? {
    func decoded<T: Decodable>(
        using decoder: JSONDecoder = .init()
    ) throws -> T {
        let data = try get()
        return try decoder.decode(T.self, from: data!)
    }
}

extension JSONEncoder {
    func encode<T: Encodable>(_ value: T) -> Result<Data, Error> {
        Result { try self.encode(value) }
    }
}

extension JSONDecoder {
    func decode<T: Decodable>(_ type: T.Type, from: Data) -> Result<T, Error> {
        Result { try self.decode(type, from: from) }
    }
}

/// TODO: move this code to their file
struct ConsentProfile<T: Codable> {
    let uuid: SPConsentUUID?
    let authId: String?
    let meta: String
    let consents: T
}

struct ConsentsProfile {
    let gdpr: ConsentProfile<SPGDPRUserConsent>?
    let ccpa: ConsentProfile<SPCCPAUserConsent>?

    init(gdpr: ConsentProfile<SPGDPRUserConsent>? = nil, ccpa: ConsentProfile<SPCCPAUserConsent>? = nil) {
        self.gdpr = gdpr
        self.ccpa = ccpa
    }
}

typealias MessageHandler<MessageType: Decodable & Equatable> = (Result<MessagesResponse<MessageType>, GDPRConsentViewControllerError>) -> Void
typealias WebMessageHandler = MessageHandler<SPJson>
typealias NativeMessageHandler = MessageHandler<SPJson>
typealias ConsentHandler = (Result<ActionResponse, GDPRConsentViewControllerError>) -> Void
typealias CustomConsentHandler = (Result<CustomConsentResponse, GDPRConsentViewControllerError>) -> Void

protocol SourcePointProtocol {
    init(timeout: TimeInterval)

    func getWebMessage(
        campaigns: SPCampaigns,
        profile: ConsentsProfile,
        handler: @escaping WebMessageHandler)

    func getNativeMessage(
        campaigns: SPCampaigns,
        profile: ConsentsProfile,
        handler: @escaping NativeMessageHandler)

    func postAction(
        action: SPAction,
        campaign: SPCampaign,
        profile: ConsentProfile<SPGDPRUserConsent>,
        handler: @escaping ConsentHandler)

//    /// TODO: add postAction for CCPA
//    func customConsent(
//        toConsentUUID consentUUID: SPConsentUUID,
//        vendors: [String],
//        categories: [String],
//        legIntCategories: [String],
//        handler: @escaping CustomConsentHandler)

//    func errorMetrics(
//        _ error: GDPRConsentViewControllerError,
//        campaign: SPCampaign,
//        sdkVersion: String,
//        OSVersion: String,
//        deviceFamily: String,
//        legislation: SPLegislation
//    )

    func setRequestTimeout(_ timeout: TimeInterval)
}

/**
A Http client for SourcePoint's endpoints
 - Important: it should only be used the SDK as its public API is still in constant development and is probably going to change.
 */
class SourcePointClient: SourcePointProtocol {
    static let WRAPPER_API = URL(string: "http://localhost:3000/wrapper/")! /// TODO: change to real URL
    static let ERROR_METRIS_URL = URL(string: "metrics/v1/custom-metrics", relativeTo: SourcePointClient.WRAPPER_API)!
    static let GET_MESSAGE_CONTENTS_URL = URL(string: "unified/v1/gdpr/native-message?inApp=true", relativeTo: SourcePointClient.WRAPPER_API)!
    static let GET_MESSAGE_URL_URL = URL(string: "unified/v1/gdpr/message-url?inApp=true", relativeTo: SourcePointClient.WRAPPER_API)!
    static let CONSENT_URL = URL(string: "unified/v1/gdpr/consent?inApp=true", relativeTo: SourcePointClient.WRAPPER_API)!
    static let CUSTOM_CONSENT_URL = URL(string: "unified/v1/gdpr/custom-consent?inApp=true", relativeTo: SourcePointClient.WRAPPER_API)!

    var client: HttpClient

    let requestUUID = UUID()

    init(client: HttpClient) {
        self.client = client
    }

    required convenience init(timeout: TimeInterval) {
        self.init(client: SimpleClient(timeoutAfter: timeout))
    }

    func setRequestTimeout(_ timeout: TimeInterval) {
        client = SimpleClient(timeoutAfter: timeout)
    }

    func campaignToRequest(_ campaign: SPCampaign?, uuid: SPConsentUUID?, meta: String?) -> CampaignRequest? {
        guard let campaign = campaign else { return nil }
        return CampaignRequest(
            uuid: uuid,
            accountId: campaign.accountId,
            propertyId: campaign.propertyId,
            propertyHref: campaign.propertyName,
            campaignEnv: campaign.environment,
            meta: meta ?? "{}", /// TODO: add meta
            targetingParams: campaign.targetingParams
        )
    }

    func getNativeMessage(campaigns: SPCampaigns, profile: ConsentsProfile, handler: @escaping NativeMessageHandler) {
        /// TODO:
    }

    func getWebMessage(campaigns: SPCampaigns, profile: ConsentsProfile, handler: @escaping WebMessageHandler) {
        getMessage(native: false, campaigns: campaigns, profile: profile, handler: handler)
    }

    func getMessage<MessageType: Decodable>(
        native: Bool,
        campaigns: SPCampaigns,
        profile: ConsentsProfile,
        handler: @escaping MessageHandler<MessageType>) {
        let url = native ?
            SourcePointClient.GET_MESSAGE_CONTENTS_URL :
            SourcePointClient.GET_MESSAGE_URL_URL
        JSONEncoder().encode(MessageRequest(
            authId: profile.gdpr?.authId, /// handle auth id
            requestUUID: requestUUID,
            campaigns: CampaignsRequest(
                gdpr: campaignToRequest(
                    campaigns.gdpr,
                    uuid: profile.gdpr?.uuid,
                    meta: profile.gdpr?.meta
                ),
                ccpa: campaignToRequest(
                    campaigns.ccpa,
                    uuid: profile.ccpa?.uuid,
                    meta: profile.ccpa?.meta
                )
            )
        )).map { body in
            client.post(urlString: url.absoluteString, body: body) { result in
                handler(Result {
                    try result.decoded() as MessagesResponse<MessageType>
                }.mapError({
                    InvalidResponseWebMessageError(error: $0)
                }))
            }
        }
    }

    func postAction(
        action: SPAction,
        campaign: SPCampaign,
        profile: ConsentProfile<SPGDPRUserConsent>,
        handler: @escaping ConsentHandler)
    {
        JSONDecoder().decode(SPJson.self, from: action.payload).map { pmPayload in
            JSONEncoder().encode(ActionRequest(
                propertyId: campaign.propertyId,
                propertyHref: campaign.propertyName,
                accountId: campaign.accountId,
                actionType: action.type.rawValue,
                choiceId: action.id,
                privacyManagerId: "", /// TODO: add privacy manager id
                requestFromPM: action.id == nil,
                uuid: profile.uuid ?? "", /// TODO: can uuid be "" ??
                requestUUID: requestUUID,
                pmSaveAndExitVariables: pmPayload,
                meta: profile.meta,
                publisherData: action.publisherData,
                consentLanguage: action.consentLanguage
            )).map { body in
                client.post(urlString: SourcePointClient.CONSENT_URL.absoluteString, body: body) { result in
                    handler(Result {
                        try result.decoded() as ActionResponse
                    }.mapError {
                        InvalidResponseConsentError(error: $0)
                    })
                }
            }
        }
    }

/// TODO: definie if customConsents will work for both campaigns
//    func customConsent(
//        toConsentUUID consentUUID: String,
//        vendors: [String],
//        categories: [String],
//        legIntCategories: [String],
//        handler: @escaping CustomConsentHandler) {
//        do {
//            let body = try JSONEncoder().encode(CustomConsentRequest(
//                consentUUID: consentUUID,
//                propertyId: propertyId,
//                vendors: vendors,
//                categories: categories,
//                legIntCategories: legIntCategories
//            ))
//            client.post(urlString: SourcePointClient.CUSTOM_CONSENT_URL.absoluteString, body: body) { data, error in
//                if let error = error {
//                    completionHandler(nil, error)
//                } else {
//                    do {
//                        completionHandler(try JSONDecoder().decode(CustomConsentResponse.self, from: data!), nil)
//                    } catch {
//                        completionHandler(nil, InvalidResponseConsentError(error as? DecodingError))
//                    }
//                }
//            }
//        } catch {
//            completionHandler(nil, InvalidRequestError(error as? DecodingError))
//        }
//    }

//    func errorMetrics(
//        _ error: GDPRConsentViewControllerError,
//        campaign: SPCampaign,
//        sdkVersion: String,
//        OSVersion: String,
//        deviceFamily: String,
//        legislation: SPLegislation
//    ) {
//        let body = try? JSONEncoder().encode(ErrorMetricsRequest(
//            code: error.spCode,
//            accountId: String(campaign.accountId),
//            description: error.description,
//            sdkVersion: sdkVersion,
//            OSVersion: OSVersion,
//            deviceFamily: deviceFamily,
//            propertyId: String(campaign.propertyId),
//            propertyName: campaign.propertyName,
//            legislation: legislation /// TODO: move legislation to campaign type?
//        ))
//        client.post(urlString: SourcePointClient.ERROR_METRIS_URL.absoluteString, body: body) {_, _ in
//
//        }
//    }
}
