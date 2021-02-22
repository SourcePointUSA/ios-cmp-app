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

typealias MessageHandler<MessageType: Decodable & Equatable> = (Result<MessagesResponse<MessageType>, SPError>) -> Void
typealias WebMessageHandler = MessageHandler<SPJson>
typealias NativeMessageHandler = MessageHandler<SPJson>
typealias ConsentHandler = (Result<ActionResponse, SPError>) -> Void
typealias CustomConsentHandler = (Result<CustomConsentResponse, SPError>) -> Void

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
        legislation: SPLegislation,
        campaign: SPCampaign,
        uuid: SPConsentUUID,
        meta: SPMeta?,
        handler: @escaping ConsentHandler)

//    func customConsent(
//        toConsentUUID consentUUID: SPConsentUUID,
//        vendors: [String],
//        categories: [String],
//        legIntCategories: [String],
//        handler: @escaping CustomConsentHandler)

//    func errorMetrics(
//        _ error: SPError,
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
    static let GET_MESSAGE_CONTENTS_URL = URL(string: "v1/unified/native-message?env=localProd&inApp=true&sdkVersion=iOSLocal", relativeTo: SourcePointClient.WRAPPER_API)!
    static let GET_MESSAGE_URL_URL = URL(string: "v1/unified/message?env=localProd&inApp=true&sdkVersion=iOSLocal", relativeTo: SourcePointClient.WRAPPER_API)!
    static let GDPR_CONSENT_URL = URL(string: "tcfv2/v1/gdpr/consent?env=localProd&inApp=true&sdkVersion=iOSLocal", relativeTo: SourcePointClient.WRAPPER_API)!
    static let CCPA_CONSENT_URL = URL(string: "v1/ccpa/consent?env=localProd&inApp=true&sdkVersion=iOSLocal", relativeTo: SourcePointClient.WRAPPER_API)!
    static let CUSTOM_CONSENT_URL = URL(string: "v1/unified/gdpr/custom-consent?env=localProd&inApp=true&sdkVersion=iOSLocal", relativeTo: SourcePointClient.WRAPPER_API)!

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
            meta: meta,
            targetingParams: campaign.targetingParams
        )
    }

    func getNativeMessage(campaigns: SPCampaigns, profile: ConsentsProfile, handler: @escaping NativeMessageHandler) {
        /// TODO: implement native message
    }

    func getWebMessage(campaigns: SPCampaigns, profile: ConsentsProfile, handler: @escaping WebMessageHandler) {
        getMessage(native: false, campaigns: campaigns, profile: profile, handler: handler)
    }

    func getMessage<MessageType: Decodable>(
        native: Bool,
        authId: String? = nil,
        campaigns: SPCampaigns,
        profile: ConsentsProfile,
        handler: @escaping MessageHandler<MessageType>) {
        let url = native ?
            SourcePointClient.GET_MESSAGE_CONTENTS_URL :
            SourcePointClient.GET_MESSAGE_URL_URL
        _ = JSONEncoder().encode(MessageRequest(
            authId: profile.authId,
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

    func consentURL(_ legislation: SPLegislation) -> String {
        switch legislation {
        case .GDPR: return SourcePointClient.GDPR_CONSENT_URL.absoluteString
        case .CCPA: return SourcePointClient.CCPA_CONSENT_URL.absoluteString
        case .Unknown: return SourcePointClient.GDPR_CONSENT_URL.absoluteString
        }
    }

    func postAction(
        action: SPAction,
        legislation: SPLegislation,
        campaign: SPCampaign,
        uuid: SPConsentUUID,
        meta: SPMeta?,
        handler: @escaping ConsentHandler) {
        _ = JSONDecoder().decode(SPJson.self, from: action.payload).map { pmPayload in
            JSONEncoder().encode(ActionRequest(
                propertyId: campaign.propertyId,
                propertyHref: campaign.propertyName,
                accountId: campaign.accountId,
                actionType: action.type.rawValue,
                choiceId: action.id,
                privacyManagerId: campaign.pmId,
                requestFromPM: action.id == nil,
                uuid: uuid,
                requestUUID: requestUUID,
                pmSaveAndExitVariables: pmPayload,
                meta: meta ?? "{}",
                publisherData: action.publisherData,
                consentLanguage: action.consentLanguage
            )).map { body in
                client.post(urlString: consentURL(legislation), body: body) { result in
                    handler(Result {
                        try result.decoded() as ActionResponse
                    }.mapError {
                        InvalidResponseConsentError(error: $0)
                    })
                }
            }
        }
    }

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
//        _ error: SPError,
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
//            legislation: legislation
//        ))
//        client.post(urlString: SourcePointClient.ERROR_METRIS_URL.absoluteString, body: body) {_, _ in
//
//        }
//    }
}
