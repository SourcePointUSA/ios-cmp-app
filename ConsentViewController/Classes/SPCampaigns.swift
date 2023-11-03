//
//  SPCampaigns.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 31.01.21.
//

import Foundation

/// A collection of key/value pairs passed to the scenario builder on SP's dashboard
public typealias SPTargetingParams = [String: String]

/// Class to encapsulate GPP configuration. This config can be used with CCPA campaigns and have
/// no effect in campaigns of other legislations.
@objcMembers public class SPGPPConfig: NSObject, Encodable {
    @objc public enum SPMspaBinaryFlag: Int, Encodable, Equatable {
        case yes, no

        public var string: String { self == .yes ? "yes" : "no" }

        public func encode(to encoder: Encoder) throws {
            var valueContainer = encoder.singleValueContainer()
            try valueContainer.encode(string)
        }
    }

    @objc public enum SPMspaTernaryFlag: Int, Encodable, Equatable {
        case yes, no, notApplicable

        public var string: String {
            switch self {
                case .yes: return "yes"
                case .no: return "no"
                case .notApplicable: return "na"
            }
        }

        public func encode(to encoder: Encoder) throws {
            var valueContainer = encoder.singleValueContainer()
            try valueContainer.encode(string)
        }
    }

    let MspaCoveredTransaction: SPMspaBinaryFlag?
    let MspaOptOutOptionMode: SPMspaTernaryFlag?
    let MspaServiceProviderMode: SPMspaTernaryFlag?

    public init(
        MspaCoveredTransaction: SPMspaBinaryFlag? = nil,
        MspaOptOutOptionMode: SPMspaTernaryFlag? = nil,
        MspaServiceProviderMode: SPMspaTernaryFlag? = nil
    ) {
        self.MspaCoveredTransaction = MspaCoveredTransaction
        self.MspaOptOutOptionMode = MspaOptOutOptionMode
        self.MspaServiceProviderMode = MspaServiceProviderMode
    }

    public init(
        MspaCoveredTransaction: SPMspaBinaryFlag,
        MspaOptOutOptionMode: SPMspaTernaryFlag,
        MspaServiceProviderMode: SPMspaTernaryFlag
    ) {
        self.MspaCoveredTransaction = MspaCoveredTransaction
        self.MspaOptOutOptionMode = MspaOptOutOptionMode
        self.MspaServiceProviderMode = MspaServiceProviderMode
    }
}

/// Contains information about the property/campaign.
@objcMembers public class SPCampaign: NSObject {
    let targetingParams: SPTargetingParams

    let groupPmId: String?

    /// Class to encapsulate GPP configuration. This parameter has only effect in CCPA campaigns.
    let GPPConfig: SPGPPConfig

    override public var description: String {
        """
        SPCampaign
            - targetingParams: \(targetingParams)
            - groupPmId: \(groupPmId as Any)
            - GPPConfig: \(GPPConfig as Any)
        """
    }

    public init(
        targetingParams: SPTargetingParams = [:],
        groupPmId: String? = nil,
        gppConfig: SPGPPConfig? = SPGPPConfig()
    ) {
        self.targetingParams = targetingParams
        self.groupPmId = groupPmId
        if let gppConfig = gppConfig {
            self.GPPConfig = gppConfig
        } else {
            self.GPPConfig = SPGPPConfig()
        }
    }
}

/// It's important to notice the campaign you passed as parameter needs to have
/// a active vendor list of that legislation.
@objcMembers public class SPCampaigns: NSObject {
    public let environment: SPCampaignEnv
    public let gdpr, ccpa, usnat, ios14: SPCampaign?

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
        environment: SPCampaignEnv = .Public
    ) {
        self.gdpr = gdpr
        self.ccpa = ccpa
        self.usnat = usnat
        self.ios14 = ios14
        self.environment = environment
    }
}
