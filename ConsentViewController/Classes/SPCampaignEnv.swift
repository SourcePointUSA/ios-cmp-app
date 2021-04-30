//
//  SPCampaignEnv.swift
//  GDPRConsentViewController
//
//  Created by Andre Herculano on 08.01.20.
//

import Foundation

/// Tells the SDK if we should load stage or public campaigns.
/// - 0 -> `SPCampaignEnv.Stage`
/// - 1 -> `SPCampaignEnv.Public`
@objc public enum SPCampaignEnv: Int {
    private static let string = [
        "stage": SPCampaignEnv.Stage,
        "prod": SPCampaignEnv.Public
    ]

    case Stage = 0
    case Public = 1

    var stringValue: String? { SPCampaignEnv.string.first { $0.value == self }?.key }
    var description: String { stringValue ?? "unkown" }

    public init?(stringValue: String) {
        if let env = SPCampaignEnv.string[stringValue] {
            self = env
        } else {
            return nil
        }
    }
}

/// JSONDecoder and Encoder do not work for single valued elements prior to iOS 11
/// Example:
///   try JSONEncoder().encode(SPCampaignEnv.Stage) will throw an exception
///        -> "Top-level SPCampaignEnv encoded as number JSON fragment."
/// As a workaround, for iOS < 11, we encode it to an array [0] or [1]
/// because that works as expected when encoding/decoding
/// https://forums.swift.org/t/top-level-t-self-encoded-as-number-json-fragment/11001/3
extension SPCampaignEnv: Codable {
    static func decodeFromSingleValue(_ decoder: Decoder) throws -> SPCampaignEnv? {
        let container = try decoder.singleValueContainer()
        return SPCampaignEnv(stringValue: try container.decode(String.self))
    }

    static func decodeFromArray(_ decoder: Decoder) throws -> SPCampaignEnv? {
        var container = try decoder.unkeyedContainer()
        return SPCampaignEnv(stringValue: try container.decode(String.self))
    }

    public func encode(to encoder: Encoder) throws {
        if #available(iOS 11, *) {
            var container = encoder.singleValueContainer()
            try container.encode(stringValue)
        } else {
            var container = encoder.unkeyedContainer()
            try container.encode(stringValue)
        }
    }

    public init(from decoder: Decoder) throws {
        do {
            if #available(iOS 11, *) {
                self = try SPCampaignEnv.decodeFromSingleValue(decoder)!
            } else {
                self = try SPCampaignEnv.decodeFromArray(decoder)!
            }
        } catch {
            throw DecodingError.dataCorrupted(DecodingError.Context(
               codingPath: [],
               debugDescription: "Unknown SPCampaignEnv"
            ))
        }
    }
}
