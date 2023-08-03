//
//  IncludeData.swift
//  Pods
//
//  Created by Andre Herculano on 18.04.23.
//

import Foundation

struct IncludeData: Equatable {
    let localState = ["type": "RecordString"]
    let TCData = ["type": "RecordString"]
    let webConsentPayload = ["type": "string"]
    let categories = true
    let translateMessage = true
    let gppConfig: SPGPPConfig?
}

extension IncludeData: Encodable {
    enum CodingKeys: String, CodingKey {
        case localState, TCData, webConsentPayload, categories, translateMessage
        case gppConfig = "GPPData"
    }

    var string: String? {
        if let encoded = try? JSONEncoder().encode(self),
           let stringified = String(data: encoded, encoding: .utf8) {
            return stringified
        }
        return nil
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(localState, forKey: .localState)
        try container.encode(TCData, forKey: .TCData)
        try container.encode(webConsentPayload, forKey: .webConsentPayload)
        try container.encode(categories, forKey: .categories)
        try container.encode(translateMessage, forKey: .translateMessage)
        try container.encodeIfPresent(gppConfig, forKey: .gppConfig)
    }
}
