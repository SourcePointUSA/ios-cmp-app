//
//  SPCampaigns.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 31.01.21.
//

import Foundation

/// A collection of key/value pairs passed to the scenario builder on SP's dashboard
public typealias SPTargetingParams = [String: String]

/// Contains information about the property/campaign.
@objcMembers public class SPCampaign {
    let accountId, propertyId: Int
    let pmId: String
    let propertyName: SPPropertyName
    let environment: SPCampaignEnv
    let targetingParams: SPTargetingParams

    public init(
        accountId: Int,
        propertyId: Int,
        pmId: String,
        propertyName: SPPropertyName,
        environment: SPCampaignEnv = .Public,
        targetingParams: SPTargetingParams = [:]
    ) {
        self.accountId = accountId
        self.propertyId = propertyId
        self.pmId = pmId
        self.propertyName = propertyName
        self.environment = environment
        self.targetingParams = targetingParams
    }
}

/// Set `gdpr` and/or `ccpa` if you wish to cover any of those legislations.
/// It's important to notice the campaign you passed as parameter needs to have
/// a active vendor list of that legislation.
@objcMembers public class SPCampaigns {
    let gdpr, ccpa: SPCampaign?
    //    let adblock, idfaPrompt: SPCampaign?

    public init(gdpr: SPCampaign? = nil, ccpa: SPCampaign? = nil) {
        self.gdpr = gdpr
        self.ccpa = ccpa
    }
}
