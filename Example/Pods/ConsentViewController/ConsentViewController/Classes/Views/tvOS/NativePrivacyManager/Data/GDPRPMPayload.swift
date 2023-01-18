//
//  PMPayload.swift
//  ConsentViewController-tvOS
//
//  Created by Andre Herculano on 29.07.21.
//

import Foundation

protocol JSONAble {
    func json() -> SPJson?
}

struct GDPRPMPayload: Codable, JSONAble {
    struct Category: Codable {
        let _id: String
        let iabId: Int?
        let consent, legInt: Bool
        let type: GDPRCategory.CategoryType?
    }
    struct Vendor: Codable {
        let _id: String
        let iabId: Int?
        let consent, legInt: Bool
        let vendorType: GDPRVendor.VendorType?
    }
    struct Feature: Codable {
        let _id: String
        let iabId: Int?
    }
    let lan: SPMessageLanguage
    let privacyManagerId: String
    let categories: [Category]
    let vendors: [Vendor]
    var specialFeatures: [Feature] = []

    func json() -> SPJson? {
        guard
            let data = try? JSONEncoder().encode(self),
            let object = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
            let json = try? SPJson(object) else {
            return nil
        }
        return json
    }
}

struct CCPAPMPayload: Codable, JSONAble {
    let lan: SPMessageLanguage
    let privacyManagerId: String
    let rejectedCategories: [String]
    let rejectedVendors: [String]

    func json() -> SPJson? {
        guard
            let data = try? JSONEncoder().encode(self),
            let object = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
            let json = try? SPJson(object) else {
            return nil
        }
        return json
    }
}
