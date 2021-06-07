//
//  PrivacyManagerViewResponse.swift
//  Pods
//
//  Created by Andre Herculano on 01.06.21.
//

import Foundation

struct PrivacyManagerViewResponse: Decodable {
    struct VendorListVendor: Decodable {
        enum SPVendorType: String, Decodable {
            case IAB, CUSTOM
        }

        let vendorId, name: String
        let iabId: Int?
        let policyUrl: URL?
        let cookieHeader: String?
        let vendorType: SPVendorType
    }

    let vendors: [VendorListVendor]
    let categories: [VendorListCategory]
}
