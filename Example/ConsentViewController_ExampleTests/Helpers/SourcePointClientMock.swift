//
//  SourcePointClientMock.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 10.06.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
@testable import ConsentViewController

class SourcePointClientMock: SourcePointProtocol {
    var customConsentResponse: CustomConsentResponse?
    var getMessageResponse: MessageResponse = MessageResponse(
        url: nil,
        msgJSON: nil,
        uuid: "",
        userConsent: GDPRUserConsent.empty(),
        meta: ""
    )
    var postActionResponse: ActionResponse = ActionResponse(
        uuid: "",
        userConsent: GDPRUserConsent.empty(),
        meta: ""
    )
    var error: GDPRConsentViewControllerError?
    var postActionCalled = false, getMessageCalled = false, customConsentCalled = false
    var customConsentWasCalledWith: [String: Any?]!
    var errorMetricsCalledWith: [String: Any?]!

    required init(timeout: TimeInterval) { }

    func getMessage(native: Bool, campaigns: SPCampaigns, profile: ConsentsProfile, handler: @escaping MessageHandler) {
        getMessageCalled = true
        if let error = error {
            handler(.failure(error))
        } else {
            handler(.success(getMessageResponse))
        }
    }

    func postAction(action: GDPRAction, campaign: SPCampaign, profile: ConsentProfile<GDPRUserConsent>, handler: @escaping ConsentHandler) {
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
                       completionHandler: @escaping (CustomConsentResponse?, GDPRConsentViewControllerError?) -> Void) {
        customConsentWasCalledWith = [
            "consentUUID": consentUUID,
            "vendors": vendors,
            "categories": categories,
            "legIntCategories": legIntCategories
        ]
        completionHandler(customConsentResponse, error)
    }

    func errorMetrics(_ error: GDPRConsentViewControllerError, sdkVersion: String, OSVersion: String, deviceFamily: String, legislation: SPLegislation) {
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
