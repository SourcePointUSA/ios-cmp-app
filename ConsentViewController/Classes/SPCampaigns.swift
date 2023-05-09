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
    let groupPmId: String?

    override public var description: String {
        "SPCampaign(targetingParams: \(targetingParams), groupPmId: \(groupPmId as Any))"
    }

    public init(
        targetingParams: SPTargetingParams = [:],
        groupPmId: String? = nil
    ) {
        self.targetingParams = targetingParams
        self.groupPmId = groupPmId
    }
}

/// Set `gdpr` and/or `ccpa` if you wish to cover any of those legislations.
/// It's important to notice the campaign you passed as parameter needs to have
/// a active vendor list of that legislation.
@objcMembers public class SPCampaigns: NSObject {
    public let environment: SPCampaignEnv
    public let gdpr, ccpa, ios14: SPCampaign?

    override public var description: String {
        """
        SPCampaigns
            - gdpr: \(gdpr as Any)
            - cppa: \(ccpa as Any)
            - ios14: \(ios14 as Any)
            - environment: \(environment)
        """
    }

    public init(
        gdpr: SPCampaign? = nil,
        ccpa: SPCampaign? = nil,
        ios14: SPCampaign? = nil,
        environment: SPCampaignEnv = .Public
    ) {
        self.gdpr = gdpr
        self.ccpa = ccpa
        self.ios14 = ios14
        self.environment = environment
    }
}
