//
//  SPCampaigns.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 31.01.21.
//

import Foundation

/// TODO: understand if the different types of Campaigns can be generalised into the same data structure
/// E.g. do they all have the same attributes?
@objcMembers class SPCampaign {
    let accountId, propertyId: Int
    let propertyName: SPPropertyName
    let environment: SPCampaignEnv
    let targetingParams: SPTargetingParams

    init(
        accountId: Int,
        propertyId: Int,
        propertyName: SPPropertyName,
        environment: SPCampaignEnv = .Public,
        targetingParams: SPTargetingParams = [:]
    ) {
        self.accountId = accountId
        self.propertyId = propertyId
        self.propertyName = propertyName
        self.environment = environment
        self.targetingParams = targetingParams
    }
}

@objcMembers class SPCampaigns {
    let gdpr, ccpa: SPCampaign?
    //    let adblock, idfaPrompt: SPCampaign?

    init(gdpr: SPCampaign? = nil, ccpa: SPCampaign? = nil) {
        self.gdpr = gdpr
        self.ccpa = ccpa
    }
}
