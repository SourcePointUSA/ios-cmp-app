//
//  SourcePointClientMock.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 10.06.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

@testable import ConsentViewController
import Foundation

// swiftlint:disable function_parameter_count

class SourcePointClientMock: SourcePointProtocol {
    var customConsentResponse: AddOrDeleteCustomConsentResponse?
    var error: SPError?
    var postGDPRActionCalled = false, postCCPAActionCalled = false,
        getMessageCalled = false, customConsentCalled = false
    var customConsentWasCalledWith: [String: Any?]!
    var errorMetricsCalledWith: [String: Any?]!
    var postGDPRActionCalledWith: [String: Any?]!
    var postCCPAActionCalledWith: [String: Any?]!

    required init(accountId: Int, propertyName: SPPropertyName, campaignEnv: SPCampaignEnv, timeout: TimeInterval) {
    }

    static func getCampaign(_ type: SPCampaignType) -> Campaign {
        Campaign(
            type: type,
            message: .none,
            userConsent: .unknown,
            messageMetaData: MessageMetaData(
                categoryId: .unknown,
                subCategoryId: .TCFv2,
                messageId: "1",
                messagePartitionUUID: "1234"
            ),
            consentStatus: ConsentStatus(
                granularStatus: ConsentStatus.GranularStatus(
                    vendorConsent: "",
                    vendorLegInt: "",
                    purposeConsent: "",
                    purposeLegInt: "",
                    previousOptInAll: false,
                    defaultConsent: false
                ),
                rejectedAny: false,
                rejectedLI: false,
                consentedAll: false,
                consentedToAny: false,
                hasConsentData: false,
                rejectedVendors: [],
                rejectedCategories: []
            ),
            dateCreated: SPDateCreated.now(),
            webConsentPayload: nil
        )
    }

    func consentStatus(
        propertyId: Int,
        metadata: ConsentStatusMetaData,
        authId: String?,
        includeData: IncludeData,
        handler: @escaping ConsentStatusHandler) {
    }

    func getMessages(_ params: MessagesRequest, handler: @escaping MessagesHandler) {
        getMessageCalled = true
        if let error = error {
            handler(.failure(error))
        }
    }

    func getGDPRMessage(propertyId: String, consentLanguage: SPMessageLanguage, messageId: String, handler: @escaping MessageHandler) {
    }

    func getCCPAMessage(propertyId: String, consentLanguage: SPMessageLanguage, messageId: String, handler: @escaping MessageHandler) {
    }

    func gdprPrivacyManagerView(propertyId: Int, consentLanguage: SPMessageLanguage, handler: @escaping GDPRPrivacyManagerViewHandler) {
    }

    func ccpaPrivacyManagerView(propertyId: Int, consentLanguage: SPMessageLanguage, handler: @escaping CCPAPrivacyManagerViewHandler) {
    }

    func postCCPAAction(actionType: SPActionType, body: CCPAChoiceBody, handler: @escaping CCPAConsentHandler) {
        postCCPAActionCalled = true
        postCCPAActionCalledWith = [
            "actionType": actionType,
            "body": body,
            "handler": handler
        ]
        if let error = error {
            handler(.failure(error))
        } else {
            handler(.success(CCPAChoiceResponse(
                uuid: "",
                dateCreated: .now(),
                consentedAll: nil,
                rejectedAll: nil,
                status: nil,
                uspstring: nil,
                gpcEnabled: nil,
                rejectedVendors: nil,
                rejectedCategories: nil,
                webConsentPayload: nil,
                GPPData: SPJson()
            )))
        }
    }

    func postGDPRAction(actionType: SPActionType, body: GDPRChoiceBody, handler: @escaping GDPRConsentHandler) {
        postGDPRActionCalled = true
        postGDPRActionCalledWith = [
            "actionType": actionType,
            "body": body,
            "handler": handler
        ]
        if let error = error {
            handler(.failure(error))
        } else {
            handler(.success(GDPRChoiceResponse(
                uuid: "",
                dateCreated: .now(),
                TCData: nil,
                euconsent: nil,
                consentStatus: nil,
                grants: nil,
                webConsentPayload: nil
            )))
        }
    }

    func getMessages(campaigns: SPCampaigns, authId: String?, localState: SPJson, idfaStaus: SPIDFAStatus, consentLanguage: SPMessageLanguage, handler: @escaping MessagesHandler) {
    }

    func pvData(_ pvDataRequestBody: PvDataRequestBody, handler: @escaping PvDataHandler) {
    }

    func reportIdfaStatus(propertyId: Int?, uuid: String?, uuidType: SPCampaignType?, messageId: Int?, idfaStatus: SPIDFAStatus, iosVersion: String, partitionUUID: String?) {
    }

    func customConsentGDPR(
        toConsentUUID consentUUID: String,
        vendors: [String],
        categories: [String],
        legIntCategories: [String],
        propertyId: Int,
        handler: @escaping AddOrDeleteCustomConsentHandler) {
    }

    func errorMetrics(_ error: SPError, propertyId: Int?, sdkVersion: String, OSVersion: String, deviceFamily: String, campaignType: SPCampaignType) {
    }

    func deleteCustomConsentGDPR(toConsentUUID consentUUID: String,
                                 vendors: [String],
                                 categories: [String],
                                 legIntCategories: [String],
                                 propertyId: Int,
                                 handler: @escaping AddOrDeleteCustomConsentHandler) {
    }

    func customConsent(toConsentUUID consentUUID: String,
                       vendors: [String],
                       categories: [String],
                       legIntCategories: [String],
                       completionHandler: @escaping (AddOrDeleteCustomConsentResponse?, SPError?) -> Void) {
        customConsentWasCalledWith = [
            "consentUUID": consentUUID,
            "vendors": vendors,
            "categories": categories,
            "legIntCategories": legIntCategories
        ]
        completionHandler(customConsentResponse, error)
    }

    func errorMetrics(_ error: SPError, sdkVersion: String, OSVersion: String, deviceFamily: String, legislation: SPCampaignType) {
        errorMetricsCalledWith = [
            "error": error,
            "sdkVersion": sdkVersion,
            "OSVersion": OSVersion,
            "deviceFamily": deviceFamily,
            "legislation": legislation
        ]
    }

    func setRequestTimeout(_ timeout: TimeInterval) {}

    func metaData(
        accountId: Int,
        propertyId: Int,
        metadata: MetaDataQueryParam,
        handler: @escaping MetaDataHandler
    ) { }

    func choiceAll(
        actionType: SPActionType,
        accountId: Int,
        propertyId: Int,
        metadata: ChoiceAllMetaDataParam,
        includeData: IncludeData,
        handler: @escaping ChoiceHandler
    ) {
        handler(.success(ChoiceAllResponse(gdpr: nil, ccpa: nil)))
    }
}
