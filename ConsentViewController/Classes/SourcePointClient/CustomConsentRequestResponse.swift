//
//  SourcePointRequestsResponses.swift
//  GDPRConsentViewController
//
//  Created by Andre Herculano on 15.12.19.
//

struct CustomConsentResponse: Codable, Equatable {
    let grants: SPGDPRVendorGrants
}

struct CustomConsentRequest: Codable, Equatable {
    let consentUUID: String
    let propertyId: Int
    let vendors, categories, legIntCategories: [String]
}
