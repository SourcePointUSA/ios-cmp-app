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
    static func getMessageResponse<C: Decodable>(_ c: C) -> MessageResponse<C, SPJson> {
        MessageResponse<C, SPJson>(
            message: try! SPJson([:]),
            applies: true,
            uuid: "uuid",
            userConsent: c,
            meta: ""
        )
    }
    var getMessagesResponse = MessagesResponse<SPJson>(
        gdpr: SourcePointClientMock.getMessageResponse(SPGDPRConsent.empty()),
        ccpa: SourcePointClientMock.getMessageResponse(SPCCPAConsent.empty())
    )
    var postActionResponse = ActionResponse(
        uuid: "",
        userConsent: SPGDPRConsent.empty(),
        meta: ""
    )
    var error: SPError?
    var postActionCalled = false, getMessageCalled = false, customConsentCalled = false
    var customConsentWasCalledWith: [String: Any?]!
    var errorMetricsCalledWith: [String: Any?]!

    required init(timeout: TimeInterval) { }

    func getWebMessage(campaigns: SPCampaigns, profile: ConsentsProfile, handler: @escaping WebMessageHandler) {
        getMessageCalled = true
        if let error = error {
            handler(.failure(error))
        } else {
            handler(.success(self.getMessagesResponse))
        }
    }

    func getNativeMessage(campaigns: SPCampaigns, profile: ConsentsProfile, handler: @escaping NativeMessageHandler) {
        getMessageCalled = true
        if let error = error {
            handler(.failure(error))
        } else {
            handler(.success(self.getMessagesResponse))
        }
    }

    func postAction(action: SPAction, legislation: SPLegislation, campaign: SPCampaign, uuid: SPConsentUUID, meta: SPMeta?, handler: @escaping ConsentHandler) {
        postActionCalled = true
        if let error = error {
            handler(.failure(error))
        } else {
            handler(.success(postActionResponse))
        }
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
