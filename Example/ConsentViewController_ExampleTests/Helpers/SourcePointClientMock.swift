//
//  SourcePointClientMock.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 10.06.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
@testable import ConsentViewController

// swiftlint:disable force_try
class SourcePointClientMock: SourcePointProtocol {
    var customConsentResponse: CustomConsentResponse?
    static func getCampaign(_ type: CampaignType, _ consent: Consent) -> Campaign {
        Campaign(
            type: type,
            message: .none,
            userConsent: consent,
            applies: true,
            messageMetaData: MessageMetaData(
                categoryId: .unknown,
                subCategoryId: .TCFv2,
                messageId: 1
            )
        )
    }
    var getMessagesResponse = MessagesResponse(
        campaigns: [
            SourcePointClientMock.getCampaign(.ccpa, .unknown),
            SourcePointClientMock.getCampaign(.gdpr, .unknown)
        ],
        localState: ""
    )

    var error: SPError?
    var postActionCalled = false, getMessageCalled = false, customConsentCalled = false
    var customConsentWasCalledWith: [String: Any?]!
    var errorMetricsCalledWith: [String: Any?]!

    required init(accountId: Int, propertyName: SPPropertyName, timeout: TimeInterval) {

    }

    func getMessages(
        campaigns: SPCampaigns,
        authId: String?,
        localState: String,
        idfaStaus: SPIDFAStatus,
        handler: @escaping MessagesHandler
    ) {
        getMessageCalled = true
        if let error = error {
            handler(.failure(error))
        } else {
            handler(.success(self.getMessagesResponse))
        }
    }

    func postAction<T: Decodable & Equatable>(
        action: SPAction,
        legislation: SPLegislation,
        campaign: SPCampaign,
        localState: String,
        handler: @escaping ConsentHandler<T>
    ) {
        postActionCalled = true
        if let error = error {
            handler(.failure(error))
        } else {
            fatalError("Implement here!")
//            handler(.success(postActionResponse))
        }
    }

    func postCCPAAction(action: SPAction, campaign: SPCampaign, localState: String, handler: @escaping CCPAConsentHandler) {

    }

    func postGDPRAction(action: SPAction, campaign: SPCampaign, localState: String, handler: @escaping GDPRConsentHandler) {

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

    func errorMetrics(_ error: SPError, sdkVersion: String, OSVersion: String, deviceFamily: String, legislation: SPLegislation) {
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
