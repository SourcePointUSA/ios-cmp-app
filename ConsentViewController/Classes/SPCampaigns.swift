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
@objcMembers public class SPCampaign: NSObject {
    let targetingParams: SPTargetingParams

    public init(
        targetingParams: SPTargetingParams = [:]
    ) {
        self.targetingParams = targetingParams
    }
}

/// Set `gdpr` and/or `ccpa` if you wish to cover any of those legislations.
/// It's important to notice the campaign you passed as parameter needs to have
/// a active vendor list of that legislation.
@objcMembers public class SPCampaigns: NSObject {
    let gdpr, ccpa, ios14: SPCampaign?

    public init(gdpr: SPCampaign? = nil, ccpa: SPCampaign? = nil, ios14: SPCampaign? = nil) {
        self.gdpr = gdpr
        self.ccpa = ccpa
        self.ios14 = ios14
    }
}
