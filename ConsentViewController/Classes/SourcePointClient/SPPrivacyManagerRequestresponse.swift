//
//  PrivacyManagerRequestresponse.swift
//  Pods
//
//  Created by Vilas on 15/04/21.
//

import Foundation

@objc public enum SPCategoryType: Int, Equatable {
    case IAB_PURPOSE, IAB, unknown
}

extension SPCategoryType: Codable {
    public typealias RawValue = String

    public var rawValue: String {
        switch self {
        case .IAB_PURPOSE: return "IAB_PURPOSE"
        case .IAB: return "IAB"
        default: return "unknown"
        }
    }

    public init(rawValue: String) {
        switch rawValue {
        case "IAB_PURPOSE": self = .IAB_PURPOSE
        case "IAB": self = .IAB
        default: self = .unknown
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.init(rawValue: try container.decode(String.self))
    }
}

@objcMembers class VendorListCategory: Codable {
    struct Vendor: Codable {
        let name: String
        let vendorId: String?
        let policyUrl: URL?
        let vendorType: SPVendorType?
    }

    let iabId: Int?
    let _id, name, description: String
    let type: SPCategoryType?
    let legIntVendors: [Vendor]?
    let requiringConsentVendors: [Vendor]?
    var uniqueVendorIds: [String] {
        Array(Set<String>(
            (legIntVendors?.filter { $0.vendorId != nil }.map { $0.vendorId! } ?? []) +
                (requiringConsentVendors?.filter { $0.vendorId != nil }.map { $0.vendorId! } ?? [])
        ))
    }
}

extension VendorListCategory: Identifiable, Hashable, Equatable {
    var id: String { _id }

    static func == (lhs: VendorListCategory, rhs: VendorListCategory) -> Bool {
        lhs._id == rhs._id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(_id)
    }
}

@objcMembers class SPPrivacyManagerResponse: NSObject, Decodable {
    let categories: [VendorListCategory]
    let message: SPNativeView

    enum CodingKeys: String, CodingKey {
        case categories
        case message = "message_json"
    }
}
