//
//  ErrorMetricsRequest.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 22.12.20.
//

import Foundation

/// Encapsulates the ErrorMetrics request body
struct ErrorMetricsRequest: Equatable {
    let code, accountId, description, sdkVersion, OSVersion, deviceFamily, propertyId: String
    let propertyName: SPPropertyName
    let legislation: SPCampaignType
}

extension ErrorMetricsRequest: Codable {
    enum CodingKeys: String, CodingKey {
        case code, accountId, description, deviceFamily, legislation, propertyId
        case OSVersion = "sdkOSVersion"
        case sdkVersion = "scriptVersion"
        case propertyName = "propertyHref"
    }
}
