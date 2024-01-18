//
//  IncludeData.swift
//  Pods
//
//  Created by Andre Herculano on 18.04.23.
//

import Foundation

struct IncludeData: Equatable {
    static let standard = IncludeData(gppConfig: SPGPPConfig())

    let localState = ["type": "RecordString"]
    let TCData = ["type": "RecordString"]
    let webConsentPayload = ["type": "string"]
    let categories = true
    let translateMessage = true
    let gppConfig: SPGPPConfig
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
}
