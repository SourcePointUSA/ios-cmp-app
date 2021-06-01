//
//  PrivacyManagerViewResponse.swift
//  Pods
//
//  Created by Andre Herculano on 01.06.21.
//

import Foundation

struct PrivacyManagerViewResponse: Decodable {
    struct Vendor: Decodable {
        enum SPType: String, Decodable {
            case IAB, CUSTOM
        }

        let vendorId, name: String
        let iabId: Int?
        let policyUrl: URL?
        let cookieHeader: String?
        let vendorType: SPType
    }

    struct Category: Decodable {
        enum SPType: String, Decodable {
            case IAB_PURPOSE, CUSTOM
        }

        let _id, name, description: String
        let friendlyDescription: String?
        let iabId: Int?
        let type: SPType
    }

    let vendors: [Vendor]
    let categories: [Category]
}
