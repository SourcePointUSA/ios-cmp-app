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
    let gppConfig: SPGPPConfig
    
    #if os(tvOS)
    let translateMessage = true
    #endif
}

extension IncludeData: Encodable {
    enum CodingKeys: String, CodingKey {
        case localState, TCData, webConsentPayload, categories
        case gppConfig = "GPPData"
        
        #if os(tvOS)
        case translateMessage
        #endif
    }

    var string: String? {
        if let encoded = try? JSONEncoder().encode(self),
           let stringified = String(data: encoded, encoding: .utf8) {
            return stringified
        }
        return nil
    }
}
