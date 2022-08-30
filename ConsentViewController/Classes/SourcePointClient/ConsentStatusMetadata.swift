//
//  ConsentStatusMetadata.swift
//  Pods
//
//  Created by Andre Herculano on 30.08.22.
//

import Foundation

protocol QueryParamEncodable: Encodable {
    func stringified() -> String
}

extension QueryParamEncodable {
    func stringified() -> String {
        guard let data = try? JSONEncoder().encode(self),
              let metadataString = String(data: data, encoding: .utf8) else {
                  return "{}"
              }

        return metadataString
    }
}

struct ConsentStatusMetaData: QueryParamEncodable {
    struct Campaign: Encodable {
        let hasLocalData, applies: Bool
        let dateCreated: SPDateCreated?
        let uuid: String?
    }

    let gdpr, ccpa: Campaign?
}
