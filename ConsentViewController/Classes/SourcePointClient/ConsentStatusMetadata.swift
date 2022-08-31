//
//  ConsentStatusMetadata.swift
//  Pods
//
//  Created by Andre Herculano on 30.08.22.
//

import Foundation

/// Data Transfer Class used to encapsulate the meta data of `/consent-status` network call
struct ConsentStatusMetaData: QueryParamEncodable {
    struct Campaign: Encodable {
        let hasLocalData, applies: Bool
        let dateCreated: SPDateCreated?
        let uuid: String?
    }

    let gdpr, ccpa: Campaign?
}
