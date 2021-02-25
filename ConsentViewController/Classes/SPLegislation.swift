//
//  SPLegislation.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 22.12.20.
//

import Foundation

/// Legislations supported by Sourcepoint
@objc public enum SPLegislation: Int, CaseIterable {
    private static let string = [
        "Unknown": SPLegislation.Unknown,
        "GDPR": SPLegislation.GDPR,
        "CCPA": SPLegislation.CCPA
    ]

    /// Unknown Legislation
    case Unknown = 0
    /// General Data Protection Regulation
    case GDPR = 1
    /// California Consumer Protection Act
    case CCPA = 2

    var stringValue: String {
        SPLegislation.string.first { $0.value == self }?.key ??
            SPLegislation.Unknown.stringValue
    }
    var description: String { stringValue }

    public init(stringValue: String) {
        self = SPLegislation.string[stringValue] ?? SPLegislation.Unknown
    }
}

/// JSONDecoder and Encoder do not work for single valued elements prior to iOS 11
/// Example:
///   try JSONEncoder().encode(SPLegislation.GDPR) will throw an exception
///        -> "Top-level SPLegislation encoded as number JSON fragment."
/// As a workaround, for iOS < 11, we encode it to an array [0] or [1]
/// because that works as expected when encoding/decoding
/// https://forums.swift.org/t/top-level-t-self-encoded-as-number-json-fragment/11001/3
extension SPLegislation: Codable {
    static func decodeFromSingleValue(_ decoder: Decoder) throws -> SPLegislation? {
        let container = try decoder.singleValueContainer()
        return SPLegislation(stringValue: try container.decode(String.self))
    }

    static func decodeFromArray(_ decoder: Decoder) throws -> SPLegislation? {
        var container = try decoder.unkeyedContainer()
        return SPLegislation(stringValue: try container.decode(String.self))
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
                self = try SPLegislation.decodeFromSingleValue(decoder)!
            } else {
                self = try SPLegislation.decodeFromArray(decoder)!
            }
        } catch {
            throw DecodingError.dataCorrupted(DecodingError.Context(
                codingPath: [],
                debugDescription: "Unknown SPLegislation"
            ))
        }
    }
}
