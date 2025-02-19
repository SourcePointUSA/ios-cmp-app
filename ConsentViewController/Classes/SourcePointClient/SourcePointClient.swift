//
//  SourcePointClient.swift
//  GDPRConsentViewController
//
//  Created by Andre Herculano on 13.03.19.
//

// swiftlint:disable function_parameter_count file_length
import Foundation
import SPMobileCore

typealias CoreClient = SPMobileCore.SourcepointClient

extension Result where Success == Data? {
    func decoded<T: Decodable>(
        using decoder: JSONDecoder = .init()
    ) throws -> T {
        let result = try get()
        if let data = result {
            return try decoder.decode(T.self, from: data)
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Failed converting Result into Data"))
        }
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

typealias PrivacyManagerViewHandler = (Result<PrivacyManagerViewResponse, SPError>) -> Void
typealias GDPRPrivacyManagerViewHandler = (Result<GDPRPrivacyManagerViewResponse, SPError>) -> Void
typealias CCPAPrivacyManagerViewHandler = (Result<CCPAPrivacyManagerViewResponse, SPError>) -> Void
typealias MessageHandler = (Result<Message, SPError>) -> Void
typealias CCPAConsentHandler = (Result<SPMobileCore.CCPAChoiceResponse, SPError>) -> Void
typealias GDPRConsentHandler = (Result<SPMobileCore.GDPRChoiceResponse, SPError>) -> Void
typealias USNatConsentHandler = (Result<SPMobileCore.USNatChoiceResponse, SPError>) -> Void
typealias ConsentHandler<T: Decodable & Equatable> = (Result<(SPJson, T), SPError>) -> Void
typealias AddOrDeleteCustomConsentHandler = (Result<SPMobileCore.GDPRConsent, SPError>) -> Void
typealias ConsentStatusHandler = (Result<SPMobileCore.ConsentStatusResponse, SPError>) -> Void
typealias MessagesHandler = (Result<MessagesResponse, SPError>) -> Void
typealias PvDataHandler = (Result<SPMobileCore.PvDataResponse, SPError>) -> Void
typealias MetaDataHandler = (Result<SPMobileCore.MetaDataResponse, SPError>) -> Void
typealias ChoiceHandler = (Result<SPMobileCore.ChoiceAllResponse, SPError>) -> Void

protocol SourcePointProtocol {
    init(
        accountId: Int,
        propertyName: SPPropertyName,
        propertyId: Int,
        campaignEnv: SPCampaignEnv,
        timeout: TimeInterval
    )

    func getMessages(_ params: MessagesRequest, handler: @escaping MessagesHandler)

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
        handler: @escaping GDPRPrivacyManagerViewHandler
    )

    func ccpaPrivacyManagerView(
        propertyId: Int,
        consentLanguage: SPMessageLanguage,
        handler: @escaping CCPAPrivacyManagerViewHandler
    )

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
        handler: @escaping AddOrDeleteCustomConsentHandler
    )

    func errorMetrics(
        _ error: SPError,
        propertyId: Int?,
        sdkVersion: String,
        OSVersion: String,
        deviceFamily: String,
        campaignType: SPCampaignType
    )

    func deleteCustomConsentGDPR(
        toConsentUUID consentUUID: String,
        vendors: [String],
        categories: [String],
        legIntCategories: [String],
        propertyId: Int,
        handler: @escaping AddOrDeleteCustomConsentHandler
    )

    func consentStatus(
        metadata: SPMobileCore.ConsentStatusRequest.MetaData,
        authId: String?,
        handler: @escaping ConsentStatusHandler
    )

    func pvData(request: SPMobileCore.PvDataRequest, handler: @escaping PvDataHandler)

    func metaData(
        accountId: Int,
        propertyId: Int,
        campaigns: SPMobileCore.MetaDataRequest.Campaigns,
        handler: @escaping MetaDataHandler
    )

    func setRequestTimeout(_ timeout: TimeInterval)
}

/**
A Http client for SourcePoint's endpoints
 - Important: it should only be used the SDK as its public API is still in constant development and is probably going to change.
 */
class SourcePointClient: SourcePointProtocol {
    let accountId: Int
    let propertyId: Int
    let propertyName: SPPropertyName
    let campaignEnv: SPCampaignEnv
    var client: HttpClient
    let coreClient: CoreClient

    let requestUUID = UUID()

    init(
        accountId: Int,
        propertyName: SPPropertyName,
        propertyId: Int,
        campaignEnv: SPCampaignEnv,
        client: HttpClient
    ) {
        self.accountId = accountId
        self.propertyName = propertyName
        self.propertyId = propertyId
        self.campaignEnv = campaignEnv
        self.client = client
        self.coreClient = CoreClient(
            accountId: Int32(accountId),
            propertyId: Int32(propertyId),
            // swiftlint:disable:next force_try
            propertyName: try! SPMobileCore.SPPropertyName.companion.create(rawValue: propertyName.rawValue),
            requestTimeoutInSeconds: Int32(5)
        )
    }

    required convenience init(
        accountId: Int,
        propertyName: SPPropertyName,
        propertyId: Int,
        campaignEnv: SPCampaignEnv,
        timeout: TimeInterval
    ) {
        self.init(
            accountId: accountId,
            propertyName: propertyName,
            propertyId: propertyId,
            campaignEnv: campaignEnv,
            client: SimpleClient(timeoutAfter: timeout))
    }

    static func parseResponse<T: Decodable>(
        _ result: Result<Data?, SPError>,
        _ error: SPError,
        _ handler: (Result<T, SPError>) -> Void
    ) {
        switch result {
            case .success:
                handler(Result { try result.decoded() as T }.mapError { _ in error })

            case .failure(let error):
                handler(Result.failure(error))
        }
    }

    static func coreHandler<T: Any>(
        responseCore: T?,
        errorCore: (any Error)?,
        errorNative: SPError,
        handlerNative: (Result<T, SPError>) -> Void
    ) {
        if errorCore != nil || responseCore == nil {
            handlerNative(Result.failure(errorNative))
        } else {
            handlerNative(Result.success(responseCore!)) // swiftlint:disable:this force_unwrapping
        }
    }

    func setRequestTimeout(_ timeout: TimeInterval) {
        client = SimpleClient(timeoutAfter: timeout)
    }

    func getGDPRMessage(
        propertyId: String,
        consentLanguage: SPMessageLanguage,
        messageId: String,
        handler: @escaping MessageHandler
    ) {
        let url = Constants.Urls.GDPR_MESSAGE_URL.appendQueryItems([
            "env": Constants.Urls.envParam,
            "consentLanguage": consentLanguage.rawValue,
            "propertyId": propertyId,
            "messageId": messageId,
            "includeData": "{\"categories\":{\"type\":\"RecordString\"},\"translateMessage\":true}"
        ])! // swiftlint:disable:this force_unwrapping
        client.get(urlString: url.absoluteString, apiCode: .GDPR_MESSAGE) {
            Self.parseResponse($0, InvalidResponseMessageGDPREndpointError()) { (parsingResult: Result<MessageResponse, SPError>) in
                handler(parsingResult.map { $0.message })
            }
        }
    }

    func getCCPAMessage(
        propertyId: String,
        consentLanguage: SPMessageLanguage,
        messageId: String,
        handler: @escaping MessageHandler
    ) {
        let url = Constants.Urls.CCPA_MESSAGE_URL.appendQueryItems([
            "env": Constants.Urls.envParam,
            "consentLanguage": consentLanguage.rawValue,
            "propertyId": propertyId,
            "messageId": messageId,
            "includeData": "{\"translateMessage\":true}"
        ])! // swiftlint:disable:this force_unwrapping
        client.get(urlString: url.absoluteString, apiCode: .CCPA_MESSAGE) {
            Self.parseResponse($0, InvalidResponseMessageCCPAEndpointError()) { (parsingResult: Result<MessageResponse, SPError>) in
                handler(parsingResult.map { $0.message })
            }
        }
    }

    func gdprPrivacyManagerView(propertyId: Int, consentLanguage: SPMessageLanguage, handler: @escaping GDPRPrivacyManagerViewHandler) {
        let url = Constants.Urls.GDPR_PRIVACY_MANAGER_VIEW_URL.appendQueryItems([
            "siteId": String(propertyId),
            "consentLanguage": consentLanguage.rawValue
        ])! // swiftlint:disable:this force_unwrapping
        client.get(urlString: url.absoluteString, apiCode: .GDPR_PRIVACY_MANAGER) {
            Self.parseResponse($0, InvalidResponseGDPRPMViewEndpointError(), handler)
        }
    }

    func ccpaPrivacyManagerView(propertyId: Int, consentLanguage: SPMessageLanguage, handler: @escaping CCPAPrivacyManagerViewHandler) {
        let url = Constants.Urls.CCPA_PRIVACY_MANAGER_VIEW_URL.appendQueryItems([
                "siteId": String(propertyId),
                "consentLanguage": consentLanguage.rawValue
        ])! // swiftlint:disable:this force_unwrapping
        client.get(urlString: url.absoluteString, apiCode: .CCPA_PRIVACY_MANAGER) {
            Self.parseResponse($0, InvalidResponseCCPAPMViewEndpointError(), handler)
        }
    }

    func consentUrl(_ baseUrl: URL, _ actionType: SPActionType) -> URL {
        // swiftlint:disable:next force_unwrapping
        URL(string: "./\(actionType.rawValue)?env=\(Constants.Urls.envParam)", relativeTo: baseUrl)!
    }

    func reportIdfaStatus(propertyId: Int?, uuid: String?, uuidType: SPCampaignType?, messageId: Int?, idfaStatus: SPIDFAStatus, iosVersion: String, partitionUUID: String?) {
        coreClient.postReportIdfaStatus(
            propertyId: KotlinInt(int: propertyId),
            uuid: uuid,
            requestUUID: UUID().uuidString,
            uuidType: uuidType?.toCore(),
            messageId: KotlinInt(int: messageId),
            idfaStatus: idfaStatus.toCore(),
            iosVersion: iosVersion,
            partitionUUID: partitionUUID
        ) { _ in }
    }

    func customConsentGDPR(
        toConsentUUID consentUUID: String,
        vendors: [String],
        categories: [String],
        legIntCategories: [String],
        propertyId: Int,
        handler: @escaping AddOrDeleteCustomConsentHandler) {
            coreClient.customConsentGDPR(
                consentUUID: consentUUID,
                propertyId: Int32(propertyId),
                vendors: vendors,
                categories: categories,
                legIntCategories: legIntCategories) {
                    SourcePointClient.coreHandler(responseCore: $0, errorCore: $1, errorNative: InvalidResponseCustomError(), handlerNative: handler)
                }
    }

    func deleteCustomConsentGDPR(
        toConsentUUID consentUUID: String,
        vendors: [String], categories: [String],
        legIntCategories: [String],
        propertyId: Int,
        handler: @escaping AddOrDeleteCustomConsentHandler) {
            coreClient.deleteCustomConsentGDPR(
                consentUUID: consentUUID,
                propertyId: Int32(propertyId),
                vendors: vendors,
                categories: categories,
                legIntCategories: legIntCategories) {
                    SourcePointClient.coreHandler(responseCore: $0, errorCore: $1, errorNative: InvalidResponseDeleteCustomError(), handlerNative: handler)
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
            propertyId: propertyId != nil ? String(propertyId!) : "", // swiftlint:disable:this force_unwrapping
            propertyName: propertyName,
            campaignType: campaignType
        )).map {
            client.post(urlString: Constants.Urls.ERROR_METRIS_URL.absoluteString, body: $0, apiCode: .ERROR_METRICS) { _ in }
        }
    }
}

// MARK: V7 - cost optimised APIs
extension SourcePointClient {
    func consentStatus(
        metadata: SPMobileCore.ConsentStatusRequest.MetaData,
        authId: String?,
        handler: @escaping ConsentStatusHandler
    ) {
        coreClient.getConsentStatus(
            authId: authId,
            metadata: metadata
        ) {
            SourcePointClient.coreHandler(responseCore: $0, errorCore: $1, errorNative: InvalidConsentStatusResponseError(), handlerNative: handler)
        }
    }

    func metaData(
        accountId: Int,
        propertyId: Int,
        campaigns: SPMobileCore.MetaDataRequest.Campaigns,
        handler: @escaping MetaDataHandler
    ) {
        coreClient.getMetaData(campaigns: campaigns) {
            SourcePointClient.coreHandler(responseCore: $0, errorCore: $1, errorNative: InvalidMetaDataResponseError(), handlerNative: handler)
        }
    }

    func getMessages(_ params: MessagesRequest, handler: @escaping MessagesHandler) {
        guard let url = Constants.Urls.GET_MESSAGES_URL.appendQueryItems(params.stringifiedParams())
        else {
            handler(Result.failure(InvalidGetMessagesParams()))
            return
        }

        client.get(urlString: url.absoluteString, apiCode: .MESSAGES) {
            Self.parseResponse($0, InvalidResponseGetMessagesEndpointError(), handler)
        }
    }

    func pvData(request: SPMobileCore.PvDataRequest, handler: @escaping PvDataHandler) {
        coreClient.postPvData(request: request) {
            SourcePointClient.coreHandler(responseCore: $0, errorCore: $1, errorNative: InvalidPvDataResponseError(), handlerNative: handler)
        }
    }
}

// swiftlint:enable function_parameter_count
