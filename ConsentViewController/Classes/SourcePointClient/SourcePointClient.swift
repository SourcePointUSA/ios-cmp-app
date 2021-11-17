//
//  SourcePointClient.swift
//  GDPRConsentViewController
//
//  Created by Andre Herculano on 13.03.19.
//

// swiftlint:disable function_parameter_count

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
typealias PrivacyManagerViewHandler = (Result<PrivacyManagerViewResponse, SPError>) -> Void
typealias GDPRPrivacyManagerViewHandler = (Result<GDPRPrivacyManagerViewResponse, SPError>) -> Void
typealias CCPAPrivacyManagerViewHandler = (Result<CCPAPrivacyManagerViewResponse, SPError>) -> Void
typealias MessageHandler = (Result<Message, SPError>) -> Void
typealias CCPAConsentHandler = ConsentHandler<SPCCPAConsent>
typealias GDPRConsentHandler = ConsentHandler<SPGDPRConsent>
typealias ConsentHandler<T: Decodable & Equatable> = (Result<(SPJson, T), SPError>) -> Void
typealias CustomConsentHandler = (Result<CustomConsentResponse, SPError>) -> Void

protocol SourcePointProtocol {
    init(accountId: Int, propertyName: SPPropertyName, campaignEnv: SPCampaignEnv, timeout: TimeInterval)

    func getMessages(
        campaigns: SPCampaigns,
        authId: String?,
        localState: SPJson,
        idfaStaus: SPIDFAStatus,
        consentLanguage: SPMessageLanguage,
        handler: @escaping MessagesHandler)

    func getGDPRMessage(
        propertyId: String,
        consentLanguage: SPMessageLanguage,
        messageId: String,
        handler: @escaping MessageHandler
    )

    func getCCPAMessage(
        propertyId: String,
        consentLanguage: SPMessageLanguage,
        messageId: String,
        handler: @escaping MessageHandler
    )

    func gdprPrivacyManagerView(
        propertyId: Int,
        consentLanguage: SPMessageLanguage,
        handler: @escaping GDPRPrivacyManagerViewHandler)

    func ccpaPrivacyManagerView(
        propertyId: Int,
        consentLanguage: SPMessageLanguage,
        handler: @escaping CCPAPrivacyManagerViewHandler)

    func postCCPAAction(
        authId: String?,
        action: SPAction,
        localState: SPJson,
        idfaStatus: SPIDFAStatus,
        handler: @escaping CCPAConsentHandler)

    func postGDPRAction(
        authId: String?,
        action: SPAction,
        localState: SPJson,
        idfaStatus: SPIDFAStatus,
        handler: @escaping GDPRConsentHandler)

    func reportIdfaStatus(
        propertyId: Int?,
        uuid: String?,
        uuidType: SPCampaignType?,
        messageId: Int?,
        idfaStatus: SPIDFAStatus,
        iosVersion: String,
        partitionUUID: String?
    )

    func customConsentGDPR(
        toConsentUUID consentUUID: String,
        vendors: [String],
        categories: [String],
        legIntCategories: [String],
        propertyId: Int,
        handler: @escaping CustomConsentHandler)

    func errorMetrics(
        _ error: SPError,
        propertyId: Int?,
        sdkVersion: String,
        OSVersion: String,
        deviceFamily: String,
        campaignType: SPCampaignType
    )

    func setRequestTimeout(_ timeout: TimeInterval)
}

/**
A Http client for SourcePoint's endpoints
 - Important: it should only be used the SDK as its public API is still in constant development and is probably going to change.
 */
class SourcePointClient: SourcePointProtocol {
    let accountId: Int
    let propertyName: SPPropertyName
    let campaignEnv: SPCampaignEnv
    var client: HttpClient

    let requestUUID = UUID()

    init(accountId: Int, propertyName: SPPropertyName, campaignEnv: SPCampaignEnv, client: HttpClient) {
        self.accountId = accountId
        self.propertyName = propertyName
        self.campaignEnv = campaignEnv
        self.client = client
    }

    required convenience init(accountId: Int, propertyName: SPPropertyName, campaignEnv: SPCampaignEnv, timeout: TimeInterval) {
        self.init(
            accountId: accountId,
            propertyName: propertyName,
            campaignEnv: campaignEnv,
            client: SimpleClient(timeoutAfter: timeout))
    }

    func setRequestTimeout(_ timeout: TimeInterval) {
        client = SimpleClient(timeoutAfter: timeout)
    }

    func getMessages(
        campaigns: SPCampaigns,
        authId: String?,
        localState: SPJson,
        idfaStaus: SPIDFAStatus,
        consentLanguage: SPMessageLanguage,
        handler: @escaping MessagesHandler) {
        _ = JSONEncoder().encodeResult(MessageRequest(
            authId: authId,
            requestUUID: requestUUID,
            propertyHref: propertyName,
            accountId: accountId,
            campaignEnv: campaignEnv,
            idfaStatus: idfaStaus,
            localState: localState,
            consentLanguage: consentLanguage,
            campaigns: CampaignsRequest(from: campaigns)
        )).map { body in
            client.post(urlString: Constants.GET_MESSAGES_URL.absoluteString, body: body) { result in
                handler(Result {
                    try result.decoded() as MessagesResponse
                }.mapError({
                    InvalidResponseWebMessageError(error: $0)
                }))
            }
        }
    }

    func getGDPRMessage(
        propertyId: String,
        consentLanguage: SPMessageLanguage,
        messageId: String,
        handler: @escaping MessageHandler
    ) {
        let url = Constants.GDPR_MESSAGE_URL.appendQueryItems([
            "env": Constants.envParam,
            "consentLanguage": consentLanguage.rawValue,
            "propertyId": propertyId,
            "messageId": messageId,
            "includeData": "{\"categories\": {\"type\": \"RecordString\"}}"
        ])!
        client.get(urlString: url.absoluteString) { result in
            handler(Result {
                (try result.decoded() as MessageResponse).message
            }.mapError({
                InvalidResponseWebMessageError(error: $0) // TODO: create custom error for this case
            }))
        }
    }

    func getCCPAMessage(
        propertyId: String,
        consentLanguage: SPMessageLanguage,
        messageId: String,
        handler: @escaping MessageHandler
    ) {
        let url = Constants.CCPA_MESSAGE_URL.appendQueryItems([
            "env": Constants.envParam,
            "consentLanguage": consentLanguage.rawValue,
            "propertyId": propertyId,
            "messageId": messageId
        ])!
        client.get(urlString: url.absoluteString) { result in
            handler(Result {
                (try result.decoded() as MessageResponse).message
            }.mapError({
                InvalidResponseWebMessageError(error: $0) // TODO: create custom error for this case
            }))
        }
    }

    func gdprPrivacyManagerView(propertyId: Int, consentLanguage: SPMessageLanguage, handler: @escaping GDPRPrivacyManagerViewHandler) {
        let url = Constants.GDPR_PRIVACY_MANAGER_VIEW_URL.appendQueryItems([
            "siteId": String(propertyId),
            "consentLanguage": consentLanguage.rawValue
        ])!
        client.get(urlString: url.absoluteString) { result in
            handler(Result {
                try result.decoded() as GDPRPrivacyManagerViewResponse
            }.mapError({
                InvalidResponseWebMessageError(error: $0) // TODO: create custom error for this case
            }))
        }
    }

    func ccpaPrivacyManagerView(propertyId: Int, consentLanguage: SPMessageLanguage, handler: @escaping CCPAPrivacyManagerViewHandler) {
            let url = Constants.CCPA_PRIVACY_MANAGER_VIEW_URL.appendQueryItems([
                "siteId": String(propertyId),
                "consentLanguage": consentLanguage.rawValue
            ])!
            client.get(urlString: url.absoluteString) { result in
                handler(Result {
                    try result.decoded() as CCPAPrivacyManagerViewResponse
                }.mapError({
                    InvalidResponseWebMessageError(error: $0) // TODO: create custom error for this case
                }))
            }
    }

    func consentUrl(_ baseUrl: URL, _ actionType: SPActionType) -> URL? {
        guard let actionUrl = URL(string: "\(actionType.rawValue)") else { return nil }

        var components = URLComponents(url: actionUrl, resolvingAgainstBaseURL: true)
        components?.queryItems = [URLQueryItem(name: "env", value: Constants.envParam)]
        return components?.url(relativeTo: baseUrl)
    }

    func postCCPAAction(authId: String?, action: SPAction, localState: SPJson, idfaStatus: SPIDFAStatus, handler: @escaping CCPAConsentHandler) {
        _ = JSONEncoder().encodeResult(CCPAConsentRequest(
            authId: authId,
            localState: localState,
            publisherData: action.publisherData,
            pmSaveAndExitVariables: action.pmPayload,
            requestUUID: requestUUID
        )).map { body in
            client.post(urlString: consentUrl(Constants.CCPA_CONSENT_URL, action.type)!.absoluteString, body: body) { result in
                handler(Result {
                    let response = try result.decoded() as ConsentResponse
                    switch response.userConsent {
                    case .ccpa(let consents): return (response.localState, consents)
                    default: throw InvalidResponseConsentError(campaignType: .ccpa)
                    }
                }.mapError {
                    InvalidResponseConsentError(error: $0, campaignType: .ccpa)
                })
            }
        }
    }

    func postGDPRAction(authId: String?, action: SPAction, localState: SPJson, idfaStatus: SPIDFAStatus, handler: @escaping GDPRConsentHandler) {
        _ = JSONEncoder().encodeResult(GDPRConsentRequest(
            authId: authId,
            idfaStatus: SPIDFAStatus.current(),
            localState: localState,
            pmSaveAndExitVariables: action.pmPayload,
            publisherData: action.publisherData,
            requestUUID: requestUUID
        )).map { body in
            client.post(urlString: consentUrl(Constants.GDPR_CONSENT_URL, action.type)!.absoluteString, body: body) { result in
                handler(Result {
                    let response = try result.decoded() as ConsentResponse
                    switch response.userConsent {
                    case .gdpr(let consents): return (response.localState, consents)
                    default: throw InvalidResponseConsentError(campaignType: .gdpr)
                    }
                }.mapError {
                    InvalidResponseConsentError(error: $0, campaignType: .gdpr)
                })
            }
        }
    }

    func reportIdfaStatus(propertyId: Int?, uuid: String?, uuidType: SPCampaignType?, messageId: Int?, idfaStatus: SPIDFAStatus, iosVersion: String, partitionUUID: String?) {
        _ = JSONEncoder().encodeResult(IDFAStatusReportRequest(
            accountId: accountId,
            propertyId: propertyId,
            uuid: uuid,
            uuidType: uuidType,
            requestUUID: UUID(),
            iosVersion: iosVersion,
            appleTracking: AppleTrackingPayload(appleChoice: idfaStatus, appleMsgId: messageId, messagePartitionUUID: partitionUUID)
        )).map {
            client.post(urlString: Constants.IDFA_RERPORT_URL.absoluteString, body: $0) { _ in }
        }
    }

    func customConsentGDPR(
        toConsentUUID consentUUID: String,
        vendors: [String],
        categories: [String],
        legIntCategories: [String],
        propertyId: Int,
        handler: @escaping CustomConsentHandler) {
        _ = JSONEncoder().encodeResult(CustomConsentRequest(
            consentUUID: consentUUID,
            propertyId: propertyId,
            vendors: vendors,
            categories: categories,
            legIntCategories: legIntCategories
        )).map { body in
            client.post(urlString: Constants.CUSTOM_CONSENT_URL.absoluteString, body: body) { result in
                handler(Result {
                    try result.decoded() as CustomConsentResponse
                }.mapError {
                    InvalidResponseCustomError(error: $0, campaignType: .gdpr)
                })
            }
        }
    }

    func errorMetrics(
        _ error: SPError,
        propertyId: Int?,
        sdkVersion: String,
        OSVersion: String,
        deviceFamily: String,
        campaignType: SPCampaignType
    ) {
        _ = JSONEncoder().encodeResult(ErrorMetricsRequest(
            code: error.spCode,
            accountId: String(accountId),
            description: error.description,
            sdkVersion: sdkVersion,
            OSVersion: OSVersion,
            deviceFamily: deviceFamily,
            propertyId: propertyId != nil ? String(propertyId!) : "",
            propertyName: propertyName,
            campaignType: campaignType
        )).map {
            client.post(urlString: Constants.ERROR_METRIS_URL.absoluteString, body: $0) { _ in }
        }
    }
}
