//
//  SPGCMData.swift
//  Pods
//
//  Created by Andre Herculano on 02.02.24.
//

import Foundation

@objcMembers public class SPGCMData: NSObject, Codable {
    enum CodingKeys: String, CodingKey {
        case adStorage = "ad_storage"
        case analyticsStorage = "analytics_storage"
        case adUserData = "ad_user_data"
        case adPersonalization = "ad_personalization"
    }

    let adStorage, analyticsStorage, adUserData, adPersonalization: SPGCMConsentStatus?

    init(adStorage: SPGCMConsentStatus? = nil, analyticsStorage: SPGCMConsentStatus? = nil, adUserData: SPGCMConsentStatus? = nil, adPersonalization: SPGCMConsentStatus? = nil) {
        self.adStorage = adStorage
        self.analyticsStorage = analyticsStorage
        self.adUserData = adUserData
        self.adPersonalization = adPersonalization
    }
}
