//
//  SourcePointClientMock.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 10.06.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
@testable import ConsentViewController

// swiftlint:disable function_parameter_count

class SourcePointClientMock: SourcePointProtocol {
    required init(accountId: Int, propertyName: SPPropertyName, campaignEnv: SPCampaignEnv, timeout: TimeInterval) {
    }

    var customConsentResponse: CustomConsentResponse?
    static func getCampaign(_ type: SPCampaignType, _ consent: Consent) -> Campaign {
        Campaign(
            type: type,
            message: .none,
            userConsent: consent,
            applies: true,
            messageMetaData: MessageMetaData(
                categoryId: .unknown,
                subCategoryId: .TCFv2,
                messageId: "1",
                messagePartitionUUID: "1234"
            )
        )
    }

    var error: SPError?
    var postActionCalled = false, getMessageCalled = false, customConsentCalled = false
    var customConsentWasCalledWith: [String: Any?]!
    var errorMetricsCalledWith: [String: Any?]!

    func getMessages(
        campaigns: SPCampaigns,
        authId: String?,
        localState: SPJson,
        idfaStaus: SPIDFAStatus,
        handler: @escaping MessagesHandler
    ) {
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

    func postCCPAAction(authId: String?, action: SPAction, localState: SPJson, handler: @escaping CCPAConsentHandler) {

    }

    func postGDPRAction(authId: String?, action: SPAction, localState: SPJson, handler: @escaping GDPRConsentHandler) {

    }

    func getMessages(campaigns: SPCampaigns, authId: String?, localState: SPJson, idfaStaus: SPIDFAStatus, consentLanguage: SPMessageLanguage, handler: @escaping MessagesHandler) {

    }

    func postCCPAAction(authId: String?, action: SPAction, localState: SPJson, idfaStatus: SPIDFAStatus, handler: @escaping CCPAConsentHandler) {

    }

    func postGDPRAction(authId: String?, action: SPAction, localState: SPJson, idfaStatus: SPIDFAStatus, handler: @escaping GDPRConsentHandler) {

    }

    func reportIdfaStatus(propertyId: Int?, uuid: String?, uuidType: SPCampaignType?, messageId: Int?, idfaStatus: SPIDFAStatus, iosVersion: String, partitionUUID: String?) {

    }

    func customConsentGDPR(
        toConsentUUID consentUUID: String,
        vendors: [String],
        categories: [String],
        legIntCategories: [String],
        propertyId: Int,
        handler: @escaping CustomConsentHandler) {

    }

    func errorMetrics(_ error: SPError, propertyId: Int?, sdkVersion: String, OSVersion: String, deviceFamily: String, campaignType: SPCampaignType) {

    }

    func customConsent(toConsentUUID consentUUID: String,
                       vendors: [String],
                       categories: [String],
                       legIntCategories: [String],
                       completionHandler: @escaping (CustomConsentResponse?, SPError?) -> Void) {
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
}
