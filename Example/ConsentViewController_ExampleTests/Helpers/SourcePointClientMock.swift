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
    var postActionCalled = false, getMessageCalled = false, customConsentCalled = false
    var customConsentWasCalledWith: [String: Any?]!
    var errorMetricsCalledWith: [String: Any?]!

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

    func consentStatus(propertyId: Int, metadata: ConsentStatusMetaData, authId: String?, handler: @escaping ConsentStatusHandler) {
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
    }

    func postGDPRAction(authId: String?, action: SPAction, localState: SPJson, handler: @escaping GDPRConsentHandler) {
    }

    func getMessages(campaigns: SPCampaigns, authId: String?, localState: SPJson, idfaStaus: SPIDFAStatus, consentLanguage: SPMessageLanguage, handler: @escaping MessagesHandler) {
    }

    func postCCPAAction(authId: String?, action: SPAction, localState: SPJson, idfaStatus: SPIDFAStatus, handler: @escaping CCPAConsentHandler) {
    }

    func postGDPRAction(actionType: ConsentViewController.SPActionType, body: ConsentViewController.GDPRChoiceBody, handler: @escaping ConsentViewController.GDPRConsentHandler) {
    }

    func pvData(pvDataRequestBody: ConsentViewController.PvDataRequestBody, handler: @escaping ConsentViewController.PvDataHandler) {
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
        metadata: MetaDataBodyRequest,
        handler: @escaping MetaDataHandler
    ) { }

    func choiceAll(
        actionType: SPActionType,
        accountId: Int,
        propertyId: Int,
        metadata: ChoiceAllBodyRequest,
        handler: @escaping ChoiceHandler
    ) { }
}
