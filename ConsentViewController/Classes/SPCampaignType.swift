//
//  SPCampaignType.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 07.04.21.
//

import Foundation

@objc public enum SPCampaignType: Int, Equatable {
    case gdpr, ios14, ccpa, usnat, globalcmp, preferences, unknown
}

extension SPCampaignType: Codable {
    public typealias RawValue = String

    public var rawValue: String {
        switch self {
        case .gdpr: return "GDPR"
        case .ccpa: return "CCPA"
        case .ios14: return "ios14"
        case .usnat: return "usnat"
        case .globalcmp: return "globalcmp"
        case .preferences: return "preferences"
        default: return "unknown"
        }
    }

    public init(rawValue: String) {
        switch rawValue {
        case "GDPR": self = .gdpr
        case "CCPA": self = .ccpa
        case "ios14": self = .ios14
        case "usnat": self = .usnat
        case "globalcmp": self = .globalcmp
        case "preferences": self = .preferences
        default: self = .unknown
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.init(rawValue: try container.decode(String.self))
    }
}
