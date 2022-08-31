//
//  QueryParamEncodableProtocol.swift
//  Pods
//
//  Created by Andre Herculano on 31.08.22.
//

import Foundation

protocol QueryParamEncodable: Encodable {
    func stringified() -> String
}

extension QueryParamEncodable {
    func stringified() -> String {
        guard let data = try? JSONEncoder().encode(self),
              let metadataString = String(data: data, encoding: .utf8) else {
                  return ""
              }

        return metadataString
    }
}
