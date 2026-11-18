//
//  Config.swift
//  ConsentViewController_Example
//
//  Created by Andre Herculano on 02.02.23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import ConsentViewController
import Foundation

/// Didomi shows the notice of a single regulation per `loadMessage` call, so the example app
/// runs one campaign at a time. It's picked at launch with the `-campaign=<gdpr|ccpa|usnat>` argument.
enum ExampleCampaign: String, CaseIterable {
    case gdpr, ccpa, usnat

    /// Name of the local Didomi config (bundled json) used for this campaign.
    var configFileName: String {
        switch self {
            case .gdpr: return "SourcepointConfigGDPR"
            case .ccpa: return "SourcepointConfigCCPA"
            case .usnat: return "SourcepointConfigUSNAT"
        }
    }
}

struct Config {
    enum Keys: String, CaseIterable {
        case accountId, propertyId, propertyName, campaign, language,
             gdprPmId, ccpaPmId, usnatPmId
    }

    let accountId, propertyId: Int
    let propertyName: String
    let campaign: ExampleCampaign
    let gdprPmId, ccpaPmId, usnatPmId: String?
    var language: SPMessageLanguage?

    let didomiApiKey = "eea5ad63-29d4-4552-9dac-2edebe1fe518"
    let didomiNoticeId = "BVP3EcHb"

    let myVendorId = "5ff4d000a228633ac048be41"
    let myPurposesId = ["608bad95d08d3112188e0e36", "608bad95d08d3112188e0e2f"]

    var campaigns: SPCampaigns {
        SPCampaigns(
            gdpr: campaign == .gdpr ? SPCampaign() : nil,
            ccpa: campaign == .ccpa ? SPCampaign() : nil,
            usnat: campaign == .usnat ? SPCampaign() : nil,
            environment: .Public
        )
    }
}

extension Config {
    init(fromStorageWithDefaults defaults: Config) {
        let values = UserDefaults.standard.dictionaryRepresentation()
        accountId = (values["accountId"] as? NSString)?.integerValue ?? defaults.accountId
        propertyId = (values["propertyId"] as? NSString)?.integerValue ?? defaults.propertyId
        propertyName = values["propertyName"] as? String ?? defaults.propertyName
        campaign = (values["campaign"] as? String).flatMap { ExampleCampaign(rawValue: $0.lowercased()) } ?? defaults.campaign
        gdprPmId = defaults.gdprPmId
        ccpaPmId = defaults.ccpaPmId
        usnatPmId = defaults.usnatPmId
        language = (values["language"] as? String).flatMap { SPMessageLanguage(rawValue: $0) } ?? defaults.language
    }
}
