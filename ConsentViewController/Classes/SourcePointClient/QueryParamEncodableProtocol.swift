//
//  QueryParamEncodableProtocol.swift
//  Pods
//
//  Created by Andre Herculano on 31.08.22.
//

import Foundation

protocol QueryParamEncodable: Encodable {
    func stringified() -> String
    func stringifiedParams(sorted: Bool) -> [String: String]
}

extension QueryParamEncodable {
    func stringified() -> String {
        guard let data = try? JSONEncoder().encode(self),
              let metadataString = String(data: data, encoding: .utf8) else {
                  return ""
              }

        return metadataString
    }

    func stringifiedParams(sorted: Bool = true) -> [String: String] {
        Mirror(reflecting: self).children.sorted { $0.label ?? "" > $1.label ?? "" }.reduce(into: [:]) { (properties, property) in
            if let label = property.label, let value = property.value as? QueryParamEncodable {
                properties[label] = value.stringified()
            }
        }
    }
}
