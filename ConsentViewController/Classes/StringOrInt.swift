//
//  StringOrInt.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 19.02.20.
//

import Foundation

public struct StringOrInt: Codable {
    var value: Any

    struct CodingKeys: CodingKey {
        var stringValue: String
        var intValue: Int?
        init?(intValue: Int) {
            self.stringValue = "\(intValue)"
            self.intValue = intValue
        }
        init?(stringValue: String) { self.stringValue = stringValue }
    }

    init(value: Any) {
        self.value = value
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let intVal = value as? Int {
            try container.encode(intVal)
        } else if let stringVal = value as? String {
            try container.encode(stringVal)
        } else {
            throw EncodingError.invalidValue(value, EncodingError.Context.init(codingPath: [], debugDescription: "The value is not encodable"))
        }
    }

    public init(from decoder: Decoder) throws {
        if let container = try? decoder.singleValueContainer() {
            if let intVal = try? container.decode(Int.self) {
                value = intVal
            } else if let stringVal = try? container.decode(String.self) {
                value = stringVal
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "the container contains nothing serialisable")
            }
        } else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Could not serialise"))
        }
    }
}
