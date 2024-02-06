//
//  SPGCMConsentType.swift
//  Pods
//
//  Created by Andre Herculano on 02.02.24.
//

import Foundation

/// Mimics Firebase's Analytics ConsentType enums
@objc public enum SPGCMConsentType: Int, Hashable, Equatable, RawRepresentable {
    case adStorage, analyticsStorage, adUserData, adPersonalization

    var string: String {
        switch self {
            case .adStorage: return "ad_storage"
            case .analyticsStorage: return "analytics_storage"
            case .adUserData: return "ad_user_data"
            case .adPersonalization: return "ad_personalization"
        }
    }
}

extension SPGCMConsentType: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)
        switch stringValue {
            case "ad_storage": self = .adStorage
            case "analytics_storage": self = .analyticsStorage
            case "ad_user_data": self = .adUserData
            case "ad_personalization": self = .adPersonalization

            default:
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "\(stringValue) is not a known SPFirebaseConsentType"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(string)
    }
}
