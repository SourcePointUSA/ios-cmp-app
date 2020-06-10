//
//  GDPRCampaignEnv.swift
//  GDPRConsentViewController
//
//  Created by Andre Herculano on 08.01.20.
//

import Foundation

/// Tells the SDK if we should load stage or public campaigns.
/// - 0 -> `GDPRCampaignEnv.Stage`
/// - 1 -> `GDPRCampaignEnv.Public`
@objc public enum GDPRCampaignEnv: Int {
    private static let string = [
        "stage": GDPRCampaignEnv.Stage,
        "prod": GDPRCampaignEnv.Public
    ]

    case Stage = 0
    case Public = 1

    var stringValue: String? { GDPRCampaignEnv.string.first { $0.value == self }?.key }
    var description: String { stringValue ?? "unkown" }

    public init?(stringValue: String) {
        if let env = GDPRCampaignEnv.string[stringValue] {
            self = env
        } else {
            return nil
        }
    }
}

extension GDPRCampaignEnv: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(stringValue)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            let env = GDPRCampaignEnv.string[try container.decode(String.self)]
            self = env!
        } catch {
            throw DecodingError.dataCorrupted(DecodingError.Context(
                codingPath: [],
                debugDescription: "Unknown GDPRCampaignEnv"
            ))
        }
    }
}
