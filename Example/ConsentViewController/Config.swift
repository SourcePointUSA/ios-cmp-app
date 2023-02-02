//
//  Config.swift
//  ConsentViewController_Example
//
//  Created by Andre Herculano on 02.02.23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import ConsentViewController

struct Config {
    let accountId, propertyId: Int
    let propertyName: String
    let gdpr, ccpa, att: Bool
    let language: SPMessageLanguage
    let gdprPmId, ccpaPmId: String?

    let myVendorId = "5ff4d000a228633ac048be41"
    let myPurposesId = ["608bad95d08d3112188e0e36", "608bad95d08d3112188e0e2f"]

    enum Keys: String, CaseIterable {
        case accountId, propertyId, propertyName, gdpr, ccpa, att, language, gdprPmId, ccpaPmId
    }
}

extension Config {
    init(fromStorageWithDefaults defaults: Config) {
        let values = UserDefaults.standard.dictionaryRepresentation()
        accountId = (values["accountId"] as? NSString)?.integerValue ?? defaults.accountId
        propertyId = (values["propertyId"] as? NSString)?.integerValue ?? defaults.propertyId
        propertyName = values["propertyName"] as? String ?? defaults.propertyName
        gdpr = (values["gdpr"] as? NSString)?.boolValue ?? defaults.gdpr
        ccpa = (values["ccpa"] as? NSString)?.boolValue ?? defaults.ccpa
        att = (values["att"] as? NSString)?.boolValue ?? defaults.att
        language = SPMessageLanguage(rawValue: values["language"] as? String ?? "xx") ?? defaults.language
        gdprPmId = defaults.gdprPmId
        ccpaPmId = defaults.ccpaPmId
    }
}

