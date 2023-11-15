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
            let dateCreated, expirationDate: SPDate
            let uuid, euconsent, addtlConsent: String
            let TCData: SPJson
            let grants: SPGDPRVendorGrants
            let consentStatus: ConsentStatus
            let webConsentPayload: SPWebConsentPayload?
            let legIntCategories: [String]
            let legIntVendors: [String]
            let vendors: [String]
            let categories: [String]
            let specialFeatures: [String]
        }

        struct CCPA: Decodable, Equatable {
            let rejectedAll: Bool
            let dateCreated, expirationDate: SPDate
            let uuid, uspstring: String
            let rejectedCategories, rejectedVendors: [String]
            let status: CCPAConsentStatus
            let webConsentPayload: SPWebConsentPayload?
            let GPPData: SPJson?
        }

        let gdpr: GDPR?
        let ccpa: CCPA?
    }

    let consentStatusData: Data
    let localState: SPJson
}
