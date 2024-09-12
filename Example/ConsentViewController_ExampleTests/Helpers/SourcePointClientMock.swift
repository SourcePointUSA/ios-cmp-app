//
//  SourcePointClientMock.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 10.06.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

@testable import ConsentViewController
import Foundation
import SPMobileCore

typealias SPCampaignEnv = ConsentViewController.SPCampaignEnv
typealias MessageRequest = ConsentViewController.MessageRequest
typealias MessagesRequest = ConsentViewController.MessagesRequest
typealias IncludeData = ConsentViewController.IncludeData
typealias SPIDFAStatus = ConsentViewController.SPIDFAStatus
typealias SPCampaignType = ConsentViewController.SPCampaignType
typealias SPMessageLanguage = ConsentViewController.SPMessageLanguage

// swiftlint:disable function_parameter_count force_try

class SourcePointClientMock: SourcePointProtocol {
    var customConsentResponse: AddOrDeleteCustomConsentResponse?
    var error: SPError?
    var postGDPRActionCalled = false, postCCPAActionCalled = false,
        customConsentCalled = false, consentStatusCalled = false,
        pvDataCalled = false, getMessagesCalled = false
    var consentStatusCalledWith, customConsentWasCalledWith, errorMetricsCalledWith, postGDPRActionCalledWith, postCCPAActionCalledWith, postUSNatActionCalledWith: [String: Any?]?
    var pvDataCalledWith: PvDataRequestBody?

    var metadataResponse = SPMobileCore.MetaDataResponse(gdpr: nil, usnat: nil, ccpa: nil)
    var messagesResponse = MessagesResponse(
        propertyId: 0,
        localState: SPJson(),
        campaigns: [],
        nonKeyedLocalState: SPJson()
    )

    required init(
        accountId: Int,
        propertyName: SPPropertyName,
        propertyId: Int,
        campaignEnv: SPCampaignEnv,
        timeout: TimeInterval
    ) {}

    convenience init(
        accountId: Int = 0,
        propertyName: SPPropertyName = try! SPPropertyName(""),
        propertyId: Int = 0,
        campaignEnv: SPCampaignEnv = .Public,
        timout: TimeInterval = 1.0
    ) {
        self.init(
            accountId: accountId,
            propertyName: propertyName,
            propertyId: propertyId,
            campaignEnv: campaignEnv,
            timeout: timout
        )
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
            dateCreated: SPDate.now(),
            webConsentPayload: nil
        )
    }

    func consentStatus(
        metadata: SPMobileCore.ConsentStatusRequest.MetaData,
        authId: String?,
        handler: @escaping ConsentStatusHandler) {
            consentStatusCalled = true
            consentStatusCalledWith = [
                "metadata": metadata,
                "authId": authId,
            ]

            if let error = error {
                handler(.failure(error))
            } else {
                handler(.success(
                    SPMobileCore.ConsentStatusResponse(
                        consentStatusData: .init(gdpr: nil, usnat: nil, ccpa: nil),
                        localState: ""
                    )
                ))
            }
    }

    func getMessages(_ params: MessagesRequest, handler: @escaping MessagesHandler) {
        getMessagesCalled = true
        if let error = error {
            handler(.failure(error))
        } else {
            handler(.success(messagesResponse))
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
                expirationDate: .distantFuture(),
                TCData: nil,
                euconsent: nil,
                consentStatus: nil,
                grants: nil,
                webConsentPayload: nil,
                gcmStatus: nil,
                acceptedLegIntCategories: nil,
                acceptedLegIntVendors: nil,
                acceptedVendors: nil,
                acceptedCategories: nil,
                acceptedSpecialFeatures: nil
            )))
        }
    }

    func postUSNatAction(
        actionType: SPActionType,
        body: USNatChoiceBody,
        handler: @escaping USNatConsentHandler
    ) {
        postUSNatActionCalledWith = [
            "actionType": actionType,
            "body": body,
            "handler": handler
        ]
        if let error = error {
            handler(.failure(error))
        } else {
            handler(.success(SPUSNatConsent.empty()))
        }
    }

    func pvData(_ pvDataRequestBody: PvDataRequestBody, handler: @escaping PvDataHandler) {
        pvDataCalled = true
        pvDataCalledWith = pvDataRequestBody
        if let error = error {
            handler(.failure(error))
        } else {
            handler(.success(.init(gdpr: nil, ccpa: nil, usnat: nil)))
        }
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
        campaigns: SPMobileCore.MetaDataRequest.Campaigns,
        handler: @escaping MetaDataHandler
    ) {
        if let error = error {
            handler(.failure(error))
        } else {
            handler(.success(metadataResponse))
        }
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
        handler(.success(ChoiceAllResponse(gdpr: nil, ccpa: nil, usnat: nil)))
    }
}
