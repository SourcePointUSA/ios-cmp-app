//
//  SourcePointClient.swift
//  GDPRConsentViewController
//
//  Created by Andre Herculano on 13.03.19.
//

import Foundation

//extension Result where Success == Data {
//    func decoded<T: Decodable>(using decoder: JSONDecoder = .init()) throws -> T {
//        let data = try get()
//        return try decoder.decode(T.self, from: data)
//    }
//
//    func encoded<T: Encodable>(value: T, using encoder: JSONEncoder = .init()) throws -> Data {
//        return try encoder.encode(value)
//    }
//}

struct ConsentProfile<T: Codable> {
    let uuid: SPConsentUUID?
    let authId: String?
    let meta: String
    let consents: T
}

struct ConsentsProfile {
    let gdpr: ConsentProfile<GDPRUserConsent>?
    let ccpa: ConsentProfile<GDPRUserConsent>? /// TODO: change to CCPAUserConsents

    init(gdpr: ConsentProfile<GDPRUserConsent>? = nil, ccpa: ConsentProfile<GDPRUserConsent>? = nil) {
        self.gdpr = gdpr
        self.ccpa = ccpa
    }
}

enum MessageResult<MessageResponse, Error: GDPRConsentViewControllerError> {
    case success(MessageResponse)
    case failure(Error)
}
typealias MessageHandler = (MessageResult<MessageResponse, GDPRConsentViewControllerError>) -> Void

enum ConsentResult<ActionResponse, Error: GDPRConsentViewControllerError> {
    case success(ActionResponse)
    case failure(Error)
}
typealias ConsentHandler = (ConsentResult<ActionResponse, GDPRConsentViewControllerError>) -> Void

enum CustomConsentResult<CustomConsentResponse, Error: GDPRConsentViewControllerError> {
    case success(CustomConsentResponse)
    case failure(Error)
}
typealias CustomConsentHandler = (ConsentResult<CustomConsentResponse, GDPRConsentViewControllerError>) -> Void

protocol SourcePointProtocol {
    init(timeout: TimeInterval)

    // swiftlint:disable:next function_parameter_count
    func getMessage(
        native: Bool,
        campaigns: SPCampaigns,
        profile: ConsentsProfile,
        handler: @escaping MessageHandler)

    func postAction(
        action: GDPRAction,
        campaign: SPCampaign,
        profile: ConsentProfile<GDPRUserConsent>,
        handler: @escaping ConsentHandler)

//    /// TODO: add postAction for CCPA
//    func customConsent(
//        toConsentUUID consentUUID: SPConsentUUID,
//        vendors: [String],
//        categories: [String],
//        legIntCategories: [String],
//        handler: @escaping CustomConsentHandler)

    func errorMetrics(
        _ error: GDPRConsentViewControllerError,
        campaign: SPCampaign,
        sdkVersion: String,
        OSVersion: String,
        deviceFamily: String,
        legislation: SPLegislation
    )

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

    func campaignToRequest(_ campaign: SPCampaign?, uuid: SPConsentUUID?) -> CampaignRequest? {
        guard let campaign = campaign else { return nil }
        return CampaignRequest(
            uuid: uuid,
            accountId: campaign.accountId,
            propertyId: campaign.propertyId,
            propertyHref: campaign.propertyName,
            campaignEnv: campaign.environment,
            meta: "", /// TODO: add meta
            targetingParams: campaign.targetingParams
        )
    }

    func getMessage(
        native: Bool,
        campaigns: SPCampaigns,
        profile: ConsentsProfile,
        handler: @escaping MessageHandler) {
        let url = native ?
            SourcePointClient.GET_MESSAGE_CONTENTS_URL :
            SourcePointClient.GET_MESSAGE_URL_URL
        do {
            let body = try JSONEncoder().encode(MessageRequest(
                authId: "", /// handle auth id
                requestUUID: requestUUID,
                campaigns: CampaignsRequest(
                    gdpr: campaignToRequest(campaigns.gdpr, uuid: profile.gdpr?.uuid),
                    ccpa: campaignToRequest(campaigns.ccpa, uuid: profile.ccpa?.uuid)
                )
            ))
            client.post(urlString: url.absoluteString, body: body) { data, error in
                if let error = error {
                    handler(.failure(error))
                } else {
                    do {
                        handler(.success(try JSONDecoder().decode(MessageResponse.self, from: data!)))
                    } catch {
                        handler(.failure(InvalidResponseWebMessageError(error as? DecodingError)))
                    }
                }
            }
        } catch {
            handler(.failure(InvalidRequestError(error as? DecodingError)))
        }
    }

    func postAction(
        action: GDPRAction,
        campaign: SPCampaign,
        profile: ConsentProfile<GDPRUserConsent>,
        handler: @escaping ConsentHandler) {
        do {
            let pmPayload = try JSONDecoder().decode(SPGDPRArbitraryJson.self, from: action.payload)
            let body = try JSONEncoder().encode(ActionRequest(
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
            ))
            /// TODO: pick right url for ccpa vs gdpr
            client.post(urlString: SourcePointClient.CONSENT_URL.absoluteString, body: body) { data, error  in
                if let error = error {
                    handler(.failure(error))
                } else {
                    do {
                        handler(.success(try JSONDecoder().decode(ActionResponse.self, from: data!)))
                    } catch {
                        handler(.failure(InvalidResponseConsentError(error as? DecodingError)))
                    }
                }
            }
        } catch {
            handler(.failure(InvalidResponseConsentError(error as? DecodingError)))
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

    func errorMetrics(
        _ error: GDPRConsentViewControllerError,
        campaign: SPCampaign,
        sdkVersion: String,
        OSVersion: String,
        deviceFamily: String,
        legislation: SPLegislation
    ) {
        let body = try? JSONEncoder().encode(ErrorMetricsRequest(
            code: error.spCode,
            accountId: String(campaign.accountId),
            description: error.description,
            sdkVersion: sdkVersion,
            OSVersion: OSVersion,
            deviceFamily: deviceFamily,
            propertyId: String(campaign.propertyId),
            propertyName: campaign.propertyName,
            legislation: legislation /// TODO: move legislation to campaign type?
        ))
        client.post(urlString: SourcePointClient.ERROR_METRIS_URL.absoluteString, body: body) {_, _ in }
    }
}
