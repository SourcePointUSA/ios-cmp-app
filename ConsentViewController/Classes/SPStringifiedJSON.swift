//
//  SPStringifiedJSON.swift
//  Pods
//
//  Created by Andre Herculano on 01.06.21.
//

import Foundation

class SPStringifiedJSON: Codable {
    typealias DictionaryType = [String: Any?]
    var raw = DictionaryType()

    required init(from decoder: Decoder) throws {
        let data = try decoder.singleValueContainer().decode(String.self).data(using: .utf8)!
        raw = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? [:]
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(String(data: JSONSerialization.data(withJSONObject: raw, options: .fragmentsAllowed), encoding: .utf8))
    }
}

extension SPStringifiedJSON: Collection {
    typealias Index = DictionaryType.Index
    typealias Element = DictionaryType.Element
    var startIndex: Index { raw.startIndex }
    var endIndex: Index { raw.endIndex }

    subscript(index: Index) -> DictionaryType.Element {
        raw[index]
    }

    subscript(_ key: DictionaryType.Key) -> DictionaryType.Value {
        get {
            raw[key] as SPStringifiedJSON.DictionaryType.Value
        }
        set {
            raw[key] = newValue
        }
    }

    func index(after i: SPStringifiedJSON.DictionaryType.Index) -> SPStringifiedJSON.DictionaryType.Index {
        raw.index(after: i)
    }
}
