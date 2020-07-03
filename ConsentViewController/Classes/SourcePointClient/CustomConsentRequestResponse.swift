//
//  SourcePointRequestsResponses.swift
//  GDPRConsentViewController
//
//  Created by Andre Herculano on 15.12.19.
//

struct CustomConsentResponse: Codable, Equatable {
    let vendors, categories, legIntCategories, specialFeatures: [String]
    let grants: GDPRVendorGrants
}

struct CustomConsentRequest: Codable, Equatable {
    let consentUUID: GDPRUUID
    let propertyId: Int
    let vendors, categories, legIntCategories: [String]
}
