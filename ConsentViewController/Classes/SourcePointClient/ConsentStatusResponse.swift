//
//  ConsentStatusResponse.swift
//  Pods
//
//  Created by Andre Herculano on 29.08.22.
//

import Foundation

struct ConsentStatusResponse: Decodable, Equatable {
    struct Data: Decodable, Equatable {
        struct GDPR: Decodable, Equatable {
            let localDataCurrent: Bool
            let dateCreated: SPDateCreated
            let uuid, euconsent, addtlConsent: String
            let grants: SPGDPRVendorGrants
            let consentStatus: ConsentStatus
        }

        struct CCPA: Decodable, Equatable {
            let rejectedAll: Bool
            let dateCreated: SPDateCreated
            let uuid, uspstring: String
            let rejectedCategories, rejectedVendors: [String]
            let status: CCPAConsentStatus
        }

        let gdpr: GDPR?
        let ccpa: CCPA?
    }

    let consentStatusData: Data
    let localState: SPJson
}
