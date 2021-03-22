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
    func encodeResult<T: Encodable>(_ value: T) -> Result<Data, Error> {
        Result { try self.encode(value) }
    }
}

extension JSONDecoder {
    func decode<T: Decodable>(_ type: T.Type, from: Data) -> Result<T, Error> {
        Result { try self.decode(type, from: from) }
    }
}

typealias MessagesHandler = (Result<MessagesResponse, SPError>) -> Void
typealias CCPAConsentHandler = ConsentHandler<SPCCPAConsent>
typealias GDPRConsentHandler = ConsentHandler<SPGDPRConsent>
typealias ConsentHandler<T: Decodable & Equatable> = (Result<ActionResponse<T>, SPError>) -> Void
typealias CustomConsentHandler = (Result<CustomConsentResponse, SPError>) -> Void

protocol SourcePointProtocol {
    init(accountId: Int, propertyName: SPPropertyName, timeout: TimeInterval)

    func getMessages(
        campaigns: SPCampaigns,
        authId: String?,
        localState: String,
        idfaStaus: SPIDFAStatus,
        handler: @escaping MessagesHandler)

    func postCCPAAction(
        action: SPAction,
        campaign: SPCampaign,
        localState: String,
        handler: @escaping CCPAConsentHandler)

    func postGDPRAction(
        action: SPAction,
        campaign: SPCampaign,
        localState: String,
        handler: @escaping GDPRConsentHandler)

    func postAction<T: Decodable & Equatable>(
        action: SPAction,
        legislation: SPLegislation,
        campaign: SPCampaign,
        localState: String,
        handler: @escaping ConsentHandler<T>)

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
//    static let GET_MESSAGES_URL = URL(string: "v1/unified/message?env=localProd&inApp=true&sdkVersion=iOSLocal", relativeTo: SourcePointClient.WRAPPER_API)!
    static let GET_MESSAGES_URL = URL(string: "https://fake-wrapper-api.herokuapp.com/all/v1/multi-campaign")!
    static let GDPR_CONSENT_URL = URL(string: "tcfv2/v1/gdpr/consent?env=localProd&inApp=true&sdkVersion=iOSLocal", relativeTo: SourcePointClient.WRAPPER_API)!
    static let CCPA_CONSENT_URL = URL(string: "v1/ccpa/consent?env=localProd&inApp=true&sdkVersion=iOSLocal", relativeTo: SourcePointClient.WRAPPER_API)!
    static let CUSTOM_CONSENT_URL = URL(string: "v1/unified/gdpr/custom-consent?env=localProd&inApp=true&sdkVersion=iOSLocal", relativeTo: SourcePointClient.WRAPPER_API)!

    let accountId: Int
    let propertyName: SPPropertyName
    var client: HttpClient

    let requestUUID = UUID()

    init(accountId: Int, propertyName: SPPropertyName, client: HttpClient) {
        self.accountId = accountId
        self.propertyName = propertyName
        self.client = client
    }

    required convenience init(accountId: Int, propertyName: SPPropertyName, timeout: TimeInterval) {
        self.init(
            accountId: accountId,
            propertyName: propertyName,
            client: SimpleClient(timeoutAfter: timeout))
    }

    func setRequestTimeout(_ timeout: TimeInterval) {
        client = SimpleClient(timeoutAfter: timeout)
    }

    func campaignToRequest(_ campaign: SPCampaign?) -> CampaignRequest? {
        guard let campaign = campaign else { return nil }
        return CampaignRequest(
            campaignEnv: campaign.environment,
            targetingParams: campaign.targetingParams
        )
    }

    func getMessages(
        campaigns: SPCampaigns,
        authId: String?,
        localState: String,
        idfaStaus: SPIDFAStatus,
        handler: @escaping MessagesHandler) {

        _ = JSONEncoder().encodeResult(MessageRequest(
            authId: authId,
            requestUUID: requestUUID,
            propertyHref: propertyName,
            accountId: accountId,
            idfaStatus: idfaStaus,
            localState: localState,
            campaigns: CampaignsRequest(
                gdpr: campaignToRequest(campaigns.gdpr),
                ccpa: campaignToRequest(campaigns.ccpa),
                ios14: campaignToRequest(campaigns.ccpa)
            )
        )).map { body in
            client.post(urlString: SourcePointClient.GET_MESSAGES_URL.absoluteString, body: body) { result in
                handler(Result {
                    try result.decoded() as MessagesResponse
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

    func postCCPAAction(action: SPAction, campaign: SPCampaign, localState: String, handler: @escaping CCPAConsentHandler) {
        postAction(
            action: action,
            legislation: .CCPA,
            campaign: campaign,
            localState: localState,
            handler: handler
        )
    }

    func postGDPRAction(action: SPAction, campaign: SPCampaign, localState: String, handler: @escaping GDPRConsentHandler) {
        postAction(
            action: action,
            legislation: .GDPR,
            campaign: campaign,
            localState: localState,
            handler: handler
        )
    }

    func postAction<T: Decodable & Equatable>(
        action: SPAction,
        legislation: SPLegislation,
        campaign: SPCampaign,
        localState: String,
        handler: @escaping ConsentHandler<T>) {
        _ = JSONEncoder().encodeResult(ActionRequest(
            propertyHref: propertyName,
            accountId: accountId,
            actionType: action.type.rawValue,
            choiceId: action.id,
            privacyManagerId: "1", /// TODO: use real PM id
            requestFromPM: action.id == nil,
            requestUUID: requestUUID,
            pmSaveAndExitVariables: action.pmPayload,
            localState: localState,
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
