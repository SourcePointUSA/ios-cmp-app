//
//  PrivacyManagerViewResponse.swift
//  Pods
//
//  Created by Andre Herculano on 01.06.21.
//

import Foundation

enum SPVendorType: String, Codable {
    case IAB, CUSTOM
}

struct VendorListVendor: Decodable {
    struct Category: Decodable {
        let type: SPCategoryType
        let iabId: Int?
        let name: String
    }

    let vendorId, name: String
    let iabId: Int?
    let policyUrl: URL?
    let description, cookieHeader: String?
    let vendorType: SPVendorType
    let consentCategories, legIntCategories: [Category]
    let iabSpecialPurposes, iabFeatures, iabSpecialFeatures: [String]
}

extension VendorListVendor: Identifiable, Equatable, Hashable {
    var id: String { vendorId }

    static func == (lhs: VendorListVendor, rhs: VendorListVendor) -> Bool {
        lhs.vendorId == rhs.vendorId
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(vendorId)
    }
}

struct PrivacyManagerViewResponse: Decodable {
    let vendors: [VendorListVendor]
    let categories, specialPurposes, features, specialFeatures: [VendorListCategory]
    var grants: SPGDPRVendorGrants?
}
