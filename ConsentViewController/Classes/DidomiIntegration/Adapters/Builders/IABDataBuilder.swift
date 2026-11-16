//
//  IABDataBuilder.swift
//  ConsentViewController
//
//  Created by Claude on 27/08/2026.
//

import Foundation

enum IABDataBuilder {
    static func buildTCFData() -> SPJson {
        buildIABData(prefix: "IABTCF_")
    }

    static func buildGPPData() -> SPJson {
        buildIABData(prefix: "IABGPP_")
    }

    private static func buildIABData(prefix: String) -> SPJson {
        let filteredData = UserDefaults.standard.dictionaryRepresentation()
            .filter { $0.key.hasPrefix(prefix) }
            .compactMap { key, value -> (SPJson.Key, SPJson)? in
                guard let json = try? SPJson(value) else { return nil }
                return (SPJson.Key(key), json)
            }

        return .object(Dictionary(uniqueKeysWithValues: filteredData))
    }
}
