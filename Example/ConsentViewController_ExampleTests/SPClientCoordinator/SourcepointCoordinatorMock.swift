//
//  SourcepointCoordinatorMock.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 28.07.23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
@testable import ConsentViewController

// swiftlint:disable force_try

class CoordinatorMock: SPClientCoordinator {
    var gdprChildPmId: String?
    
    var ccpaChildPmId: String?
    
    var authId: String?
    var deviceManager: SPDeviceManager = SPDevice()
    var userData: SPUserData = SPUserData()
    var language: SPMessageLanguage = .BrowserDefault
    var spClient: SourcePointProtocol = SourcePointClientMock(
        accountId: 0,
        propertyName: try! SPPropertyName(""),
        propertyId: 0,
        campaignEnv: SPCampaignEnv.Public,
        timeout: 10
    )

    var loadMessagesResult: Result<LoadMessagesReturnType, SPError>!

    func loadMessages(forAuthId: String?, pubData: SPPublisherData?, _ handler: @escaping MessagesAndConsentsHandler) {
        handler(loadMessagesResult)
    }

    func reportAction(_ action: SPAction, handler: @escaping (Result<SPUserData, SPError>) -> Void) {}

    func reportIdfaStatus(status: SPIDFAStatus, osVersion: String) {}

    func logErrorMetrics(_ error: SPError) {}

    func deleteCustomConsentGDPR(vendors: [String], categories: [String], legIntCategories: [String], handler: @escaping (Result<SPGDPRConsent, SPError>) -> Void) {}

    func customConsentGDPR(vendors: [String], categories: [String], legIntCategories: [String], handler: @escaping GDPRCustomConsentHandler) {}

    func setRequestTimeout(_ timeout: TimeInterval) {}
}
