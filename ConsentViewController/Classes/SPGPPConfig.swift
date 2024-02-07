//
//  GPPConfig.swift
//  Pods
//
//  Created by Andre Herculano on 18.01.24.
//

import Foundation

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

    let uspString: Bool?

    public init(
        MspaCoveredTransaction: SPMspaBinaryFlag? = nil,
        MspaOptOutOptionMode: SPMspaTernaryFlag? = nil,
        MspaServiceProviderMode: SPMspaTernaryFlag? = nil
    ) {
        self.MspaCoveredTransaction = MspaCoveredTransaction
        self.MspaOptOutOptionMode = MspaOptOutOptionMode
        self.MspaServiceProviderMode = MspaServiceProviderMode
        uspString = nil
    }

    public init(
        MspaCoveredTransaction: SPMspaBinaryFlag,
        MspaOptOutOptionMode: SPMspaTernaryFlag,
        MspaServiceProviderMode: SPMspaTernaryFlag
    ) {
        self.MspaCoveredTransaction = MspaCoveredTransaction
        self.MspaOptOutOptionMode = MspaOptOutOptionMode
        self.MspaServiceProviderMode = MspaServiceProviderMode
        uspString = nil
    }

    init(uspString: Bool?) {
        self.uspString = uspString
        MspaCoveredTransaction = nil
        MspaOptOutOptionMode = nil
        MspaServiceProviderMode = nil
    }
}
