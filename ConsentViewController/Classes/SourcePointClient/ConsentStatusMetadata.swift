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
        let applies: Bool
        let dateCreated: SPDateCreated?
        let uuid: String?
        let hasLocalData: Bool
        let idfaStatus: SPIDFAStatus?
    }

    let gdpr, ccpa: Campaign?
}
