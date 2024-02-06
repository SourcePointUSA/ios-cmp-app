//
//  SPGCMConsentStatus.swift
//  Pods
//
//  Created by Andre Herculano on 02.02.24.
//

import Foundation

/// Mimics Firebase's Analytics ConsentStatus enums
@objc public enum SPGCMConsentStatus: Int, Hashable, Equatable, RawRepresentable {
    case granted, denied

    var string: String {
        switch self {
            case .granted: return "granted"
            case .denied: return "denied"
        }
    }
}

extension SPGCMConsentStatus: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)
        switch stringValue {
            case "granted": self = .granted
            case "denied": self = .denied

            default:
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "\(stringValue) is not a known SPFirebaseConsentType"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(string)
    }
}
