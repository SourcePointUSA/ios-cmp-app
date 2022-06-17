//
//  DeleteCustomConsentRequestResponse.swift
//  Pods
//
//  Created by Dmytro Fedko on 17.06.2022.
//

import Foundation

struct DeleteCustomConsentResponse: Codable, Equatable {
    let grants: SPGDPRVendorGrants
}

struct DeleteCustomConsentRequest: Codable, Equatable {
    let vendors, categories, legIntCategories: [String]
}
