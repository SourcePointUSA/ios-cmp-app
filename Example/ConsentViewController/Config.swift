//
//  Config.swift
//  ConsentViewController_Example
//
//  Created by Andre Herculano on 02.02.23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import ConsentViewController
import Foundation

struct Config {
    enum Keys: String, CaseIterable {
        case accountId, propertyId, propertyName,
             gdpr, ccpa, usnat, att, language, gdprPmId,
             ccpaPmId, usnatPmId
    }

    let accountId, propertyId: Int
    let propertyName: String
    let campaigns: SPCampaigns
    let gdprPmId, ccpaPmId, usnatPmId: String?
    var language: SPMessageLanguage?

    let myVendorId = "5ff4d000a228633ac048be41"
    let myPurposesId = ["608bad95d08d3112188e0e36", "608bad95d08d3112188e0e2f"]
}

extension Config {
    init(fromStorageWithDefaults defaults: Config) {
        let values = UserDefaults.standard.dictionaryRepresentation()
        accountId = (values["accountId"] as? NSString)?.integerValue ?? defaults.accountId
        propertyId = (values["propertyId"] as? NSString)?.integerValue ?? defaults.propertyId
        propertyName = values["propertyName"] as? String ?? defaults.propertyName
        gdprPmId = defaults.gdprPmId
        ccpaPmId = defaults.ccpaPmId
        usnatPmId = defaults.usnatPmId
        if let langArg = values["language"] as? String,
            let langEnum = SPMessageLanguage(rawValue: langArg) {
            language = langEnum
        } else {
            language = defaults.language
        }

        campaigns = SPCampaigns(
            gdpr: (values["gdpr"] as? NSString)?.boolValue == true ? SPCampaign(
                // sets the withoutBrowserDefault targeting param so we can test a message
                // without the browser default settings enabled (otherwise, setting the language
                // param has no effect).
                targetingParams: language != nil ? ["withoutBrowserDefault": "true"] : [:]
            ) : defaults.campaigns.gdpr,
            ccpa: (values["ccpa"] as? NSString)?.boolValue == true ? SPCampaign() : defaults.campaigns.ccpa,
            usnat: (values["usnat"] as? NSString)?.boolValue == true ? SPCampaign() : defaults.campaigns.usnat,
            ios14: (values["att"] as? NSString)?.boolValue == true ? SPCampaign() : defaults.campaigns.ios14
        )
    }
}
