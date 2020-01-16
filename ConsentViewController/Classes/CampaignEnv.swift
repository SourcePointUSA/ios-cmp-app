//
//  CampaignEnv.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 08.01.20.
//

import Foundation

/// Tells the SDK if we should load stage or public campaigns.
@objc public enum CampaignEnv: Int, Encodable {
    case Stage = 0
    case Public = 1

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue == 0 ? "stage" : "prod")
    }
}
