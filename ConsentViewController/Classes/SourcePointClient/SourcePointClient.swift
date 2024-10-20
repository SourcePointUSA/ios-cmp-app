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
typealias CCPAConsentHandler = (Result<CCPAChoiceResponse, SPError>) -> Void
typealias GDPRConsentHandler = (Result<GDPRChoiceResponse, SPError>) -> Void
typealias USNatConsentHandler = (Result<SPUSNatConsent, SPError>) -> Void
typealias ConsentHandler<T: Decodable & Equatable> = (Result<(SPJson, T), SPError>) -> Void
typealias AddOrDeleteCustomConsentHandler = (Result<AddOrDeleteCustomConsentResponse, SPError>) -> Void
typealias ConsentStatusHandler = (Result<SPMobileCore.ConsentStatusResponse, SPError>) -> Void
typealias MessagesHandler = (Result<MessagesResponse, SPError>) -> Void
typealias PvDataHandler = (Result<PvDataResponse, SPError>) -> Void
typealias MetaDataHandler = (Result<SPMobileCore.MetaDataResponse, SPError>) -> Void
typealias ChoiceHandler = (Result<ChoiceAllResponse, SPError>) -> Void

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

    func postCCPAAction(
        actionType: SPActionType,
        body: CCPAChoiceBody,
        handler: @escaping CCPAConsentHandler
    )

    func postUSNatAction(
        actionType: SPActionType,
        body: USNatChoiceBody,
        handler: @escaping USNatConsentHandler
    )

    func postGDPRAction(
        actionType: SPActionType,
        body: GDPRChoiceBody,
        handler: @escaping GDPRConsentHandler
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

    func pvData(_ body: PvDataRequestBody, handler: @escaping PvDataHandler)

    func metaData(
        accountId: Int,
        propertyId: Int,
        campaigns: SPMobileCore.MetaDataRequest.Campaigns,
        handler: @escaping MetaDataHandler
    )

    func choiceAll(
        actionType: SPActionType,
        accountId: Int,
        propertyId: Int,
        idfaStatus: SPIDFAStatus,
        metadata: ChoiceAllMetaDataParam,
        includeData: IncludeData,
        handler: @escaping ChoiceHandler
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
            propertyName: propertyName.rawValue,
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

    func postCCPAAction(actionType: SPActionType, body: CCPAChoiceBody, handler: @escaping CCPAConsentHandler) {
        _ = JSONEncoder().encodeResult(body).map { body in
            client.post(urlString: consentUrl(Constants.Urls.CHOICE_CCPA_BASE_URL, actionType).absoluteString, body: body, apiCode: .CCPA_ACTION) {
                Self.parseResponse($0, InvalidResponseConsentError(), handler)
            }
        }
    }

    func postGDPRAction(actionType: SPActionType, body: GDPRChoiceBody, handler: @escaping GDPRConsentHandler) {
        _ = JSONEncoder().encodeResult(body).map { body in
            client.post(urlString: consentUrl(Constants.Urls.CHOICE_GDPR_BASE_URL, actionType).absoluteString, body: body, apiCode: .GDPR_ACTION) {
                Self.parseResponse($0, InvalidResponseConsentError(), handler)
            }
        }
    }

    func postUSNatAction(actionType: SPActionType, body: USNatChoiceBody, handler: @escaping USNatConsentHandler) {
        _ = JSONEncoder().encodeResult(body).map { encodedBody in
            client.post(
                urlString: consentUrl(
                    Constants.Urls.CHOICE_USNAT_BASE_URL, actionType
                ).absoluteString,
                body: encodedBody,
                apiCode: .USNAT_ACTION
            ) {
                Self.parseResponse($0, InvalidResponseConsentError(), handler)
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
            client.post(urlString: Constants.Urls.IDFA_RERPORT_URL.absoluteString, body: $0, apiCode: .IDFA_STATUS) { _ in }
        }
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
                legIntCategories: legIntCategories) { response, error in
                    if error != nil || response == nil {
                        handler(Result.failure(InvalidResponseCustomError()))
                    } else {
                        handler(Result.success(response!.toNativeAsAddOrDeleteCustomConsentResponse())) // swiftlint:disable:this force_unwrapping
                    }
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
                legIntCategories: legIntCategories) { response, error in
                    if error != nil || response == nil {
                        handler(Result.failure(InvalidResponseDeleteCustomError()))
                    } else {
                        handler(Result.success(response!.toNativeAsAddOrDeleteCustomConsentResponse())) // swiftlint:disable:this force_unwrapping
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
        ) { response, error in
            if error != nil || response == nil {
                handler(Result.failure(InvalidConsentStatusResponseError()))
            } else {
                handler(Result.success(response!)) // swiftlint:disable:this force_unwrapping
            }
        }
    }

    func metaData(
        accountId: Int,
        propertyId: Int,
        campaigns: SPMobileCore.MetaDataRequest.Campaigns,
        handler: @escaping MetaDataHandler
    ) {
        coreClient.getMetaData(campaigns: campaigns) { response, error in
            if error != nil || response == nil {
                handler(Result.failure(InvalidMetaDataResponseError()))
            } else {
                handler(Result.success(response!)) // swiftlint:disable:this force_unwrapping
            }
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

    func pvData(_ body: PvDataRequestBody, handler: @escaping PvDataHandler) {
        _ = JSONEncoder().encodeResult(body).map { body in
            client.post(urlString: Constants.Urls.PV_DATA_URL.absoluteString, body: body, apiCode: .PV_DATA) {
                Self.parseResponse($0, InvalidPvDataResponseError(), handler)
            }
        }
    }

    func choiceAllUrlWithParams(
        actionType: SPActionType,
        accountId: Int,
        hasCsp: Bool,
        propertyId: Int,
        withSiteActions: Bool,
        includeCustomVendorsRes: Bool,
        includeData: IncludeData,
        idfaStatus: String,
        metadata: ChoiceAllMetaDataParam
    ) -> URL? {
        var baseUrl: URL
        if actionType == .AcceptAll {
            baseUrl = Constants.Urls.CHOICE_CONSENT_ALL_URL
        } else if actionType == .RejectAll {
            baseUrl = Constants.Urls.CHOICE_REJECT_ALL_URL
        } else {
            return nil
        }
        return baseUrl.appendQueryItems([
            "accountId": String(accountId),
            "hasCsp": String(hasCsp),
            "propertyId": String(propertyId),
            "withSiteActions": String(withSiteActions),
            "includeCustomVendorsRes": String(includeCustomVendorsRes),
            "idfaStatus": idfaStatus,
            "metadata": metadata.stringified(),
            "includeData": includeData.string
        ])
    }

    func choiceAll(
        actionType: SPActionType,
        accountId: Int,
        propertyId: Int,
        idfaStatus: SPIDFAStatus,
        metadata: ChoiceAllMetaDataParam,
        includeData: IncludeData,
        handler: @escaping ChoiceHandler
    ) {
        guard let url = choiceAllUrlWithParams(
            actionType: actionType,
            accountId: accountId,
            hasCsp: true,
            propertyId: propertyId,
            withSiteActions: false,
            includeCustomVendorsRes: false,
            includeData: includeData,
            idfaStatus: idfaStatus.description,
            metadata: metadata
        ) else {
            handler(Result.failure(InvalidChoiceAllParamsError()))
            return
        }

        client.get(urlString: url.absoluteString, apiCode: .CHOICE_ALL) {
            Self.parseResponse($0, InvalidChoiceAllResponseError(), handler)
        }
    }
}

// swiftlint:enable function_parameter_count
