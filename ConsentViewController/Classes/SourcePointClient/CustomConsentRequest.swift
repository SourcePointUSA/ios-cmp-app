//
//  CustomConsentRequest.swift
//  Pods
//
//  Created by Andre Herculano on 15.12.19.
//

import Foundation

struct CustomConsentRequest: Codable, Equatable {
    let consentUUID: String
    let propertyId: Int
    let vendors, categories, legIntCategories: [String]
}
