//
//  SPCampaigns.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 31.01.21.
//

import Foundation

/// A collection of key/value pairs passed to the scenario builder on SP's dashboard
public typealias SPTargetingParams = [String: String]

@objc public enum SPOptinalBool: Int {
    case yes, no, unset

    public var string: String {
        switch self {
            case .no: return "false"
            case .yes: return "true"
            case .unset: return "unset(nil)"
        }
    }

    var boolValue: Bool? {
        switch self {
            case .no: return false
            case .yes: return true
            case .unset: return nil
        }
    }
}

/// Contains information about the property/campaign.
@objc public class SPCampaign: NSObject {
    @objc let targetingParams: SPTargetingParams

    @objc let groupPmId: String?

    /// Class to encapsulate GPP configuration. This parameter has only effect in CCPA campaigns.
    let GPPConfig: SPGPPConfig?

    /**
     Used by USNat campaigns only. Set this flag only if your app used an SDK older than `7.6.0`, use authenticated consent
     and has a CCPA campaign.
     */
    let transitionCCPAAuth: Bool?

    /**
     Used by USNat campaigns. Set this flag if you want to continue having the value `IABUSPrivacy_String`
     stored in the `UserDefaults`. Useful during the transition between CCPA and USNat campaigns.
    */
    let supportLegacyUSPString: Bool?

    @objc override public var description: String {
        """
        SPCampaign
            - targetingParams: \(targetingParams)
            - groupPmId: \(groupPmId as Any)
            - GPPConfig: \(GPPConfig as Any)
            - transitionCCPAAuth: \(transitionCCPAAuth as Any)
            - supportLegacyUSPString: \(supportLegacyUSPString as Any)
        """
    }

    @nonobjc public init(
        targetingParams: SPTargetingParams = [:],
        groupPmId: String? = nil,
        gppConfig: SPGPPConfig? = nil,
        transitionCCPAAuth: Bool? = nil,
        supportLegacyUSPString: Bool? = nil
    ) {
        self.targetingParams = targetingParams
        self.groupPmId = groupPmId
        self.GPPConfig = gppConfig
        self.transitionCCPAAuth = transitionCCPAAuth
        self.supportLegacyUSPString = supportLegacyUSPString
    }

    @available(swift, obsoleted: 1.0)
    @objc public init(
        targetingParams: SPTargetingParams = [:],
        groupPmId: String? = nil
    ) {
        self.targetingParams = targetingParams
        self.groupPmId = groupPmId
        self.GPPConfig = nil
        self.transitionCCPAAuth = nil
        self.supportLegacyUSPString = nil
    }

    @available(swift, obsoleted: 1.0)
    @objc public init(
        targetingParams: SPTargetingParams = [:],
        groupPmId: String? = nil,
        gppConfig: SPGPPConfig? = nil,
        transitionCCPAAuth: SPOptinalBool = .unset,
        supportLegacyUSPString: SPOptinalBool = .unset
    ) {
        self.targetingParams = targetingParams
        self.groupPmId = groupPmId
        self.GPPConfig = gppConfig
        self.transitionCCPAAuth = transitionCCPAAuth.boolValue
        self.supportLegacyUSPString = supportLegacyUSPString.boolValue
    }
}

/// It's important to notice the campaign you passed as parameter needs to have
/// a active vendor list of that legislation.
@objcMembers public class SPCampaigns: NSObject {
    public let environment: SPCampaignEnv
    public let gdpr, ccpa, usnat, ios14, preferences: SPCampaign?

    override public var description: String {
        """
        SPCampaigns
            - gdpr: \(gdpr as Any)
            - cppa: \(ccpa as Any)
            - usnat: \(usnat as Any)
            - ios14: \(ios14 as Any)
            - environment: \(environment)
        """
    }

    public init(
        gdpr: SPCampaign? = nil,
        ccpa: SPCampaign? = nil,
        usnat: SPCampaign? = nil,
        ios14: SPCampaign? = nil,
        preferences: SPCampaign? = nil,
        environment: SPCampaignEnv = .Public
    ) {
        self.gdpr = gdpr
        self.ccpa = ccpa
        self.usnat = usnat
        self.ios14 = ios14
        self.preferences = preferences
        self.environment = environment
    }
}
