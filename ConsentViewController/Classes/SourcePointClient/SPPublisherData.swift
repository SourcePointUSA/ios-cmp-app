//
//  SPPublisherData.swift
//  Pods
//
//  Created by Andre Herculano on 03.02.22.
//

import Foundation

/// A dictionary of `[String: String]` of arbitrary key/values used to send data from the publisher
/// app to our data pipeline so it can be later retrieved by the publisher via specific APIs.
///
/// Example: The publisher can send user identifiers that will be aggregated to our data. When the publisher
/// pull the data from our APIs they will be able to match our data against the data they have sent.
public typealias SPPublisherData = [String: AnyEncodable]

extension Encodable {
    fileprivate func encode(to container: inout SingleValueEncodingContainer) throws {
        try container.encode(self)
    }

    func toJsonString(_ encoder: JSONEncoder = JSONEncoder()) throws -> String {
        let data = try encoder.encode(self)
        return String(decoding: data, as: UTF8.self)
    }
}

@objcMembers public class AnyEncodable: NSObject, Encodable {
    var value: Encodable?

    public init(_ value: Encodable?) {
        self.value = value
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let value = value {
            try value.encode(to: &container)
        } else {
            try container.encodeNil()
        }
    }

    override public func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? AnyEncodable else {
            return false
        }
        return other.value.debugDescription == value.debugDescription
    }
}
