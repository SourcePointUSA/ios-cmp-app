//
//  SourcePointClientMock.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 10.06.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
@testable import ConsentViewController

// swiftlint:disable force_try function_parameter_count

class SourcePointClientMock: SourcePointProtocol {
    var customConsentResponse: CustomConsentResponse?
    var getMessageResponse: MessageResponse?
    var postActionResponse: ActionResponse?
    var error: GDPRConsentViewControllerError?
    var postActionCalled = false, getMessageCalled = false, customConsentCalled = false
    var customConsentWasCalledWith: [String: Any?]!
    var errorMetricsCalledWith: [String: Any?]!

    convenience init() {
        self.init(accountId: 0, propertyId: 0, propertyName: try! SPPropertyName("test"), pmId: "", campaignEnv: .Stage, targetingParams: [:], timeout: 0.0)
    }

    required init(accountId: Int,
                  propertyId: Int,
                  propertyName: SPPropertyName,
                  pmId: String,
                  campaignEnv: GDPRCampaignEnv,
                  targetingParams: TargetingParams,
                  timeout: TimeInterval) {}

    func getMessage(native: Bool,
                    consentUUID: SPConsentUUID?,
                    euconsent: String,
                    authId: String?,
                    meta: Meta,
                    completionHandler: @escaping (MessageResponse?, GDPRConsentViewControllerError?) -> Void) {
        getMessageCalled = true
        completionHandler(getMessageResponse, error)
    }

    func postAction(action: GDPRAction, consentUUID: SPConsentUUID, meta: Meta, completionHandler: @escaping (ActionResponse?, GDPRConsentViewControllerError?) -> Void) {
        postActionCalled = true
        completionHandler(postActionResponse, error)
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
