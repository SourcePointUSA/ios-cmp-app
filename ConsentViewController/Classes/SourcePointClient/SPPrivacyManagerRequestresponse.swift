//
//  PrivacyManagerRequestresponse.swift
//  Pods
//
//  Created by Vilas on 15/04/21.
//

import Foundation

@objcMembers class GDPRCategory: Codable {
    @objc public enum CategoryType: Int, Equatable {
        case IAB_PURPOSE, IAB, unknown
    }

    struct Vendor: Codable {
        let name: String
        let vendorId: String?
        let policyUrl: URL?
        let vendorType: GDPRVendor.VendorType?
        
        enum Keys: String, CodingKey {
            case name
            case vendorId
            case policyUrl
            case vendorType
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: Keys.self)
            do {
                policyUrl = try container.decodeIfPresent(URL.self, forKey: .policyUrl)
            } catch {
                policyUrl = nil
            }
            vendorId = try container.decodeIfPresent(String.self, forKey: .vendorId)
            name = try container.decode(String.self, forKey: .name)
            vendorType = try container.decodeIfPresent(GDPRVendor.VendorType.self, forKey: .vendorType)        }
    }

    let iabId: Int?
    let _id, name, description: String
    let type: GDPRCategory.CategoryType?
    let legIntVendors: [Vendor]?
    let requiringConsentVendors: [Vendor]?
    var uniqueVendorIds: [String] {
        Array(Set<String>(
            (legIntVendors?.filter { $0.vendorId != nil }.map { $0.vendorId! } ?? []) +
                (requiringConsentVendors?.filter { $0.vendorId != nil }.map { $0.vendorId! } ?? [])
        ))
    }
}

extension GDPRCategory: Identifiable, Hashable, Equatable {
    var id: String { _id }

    static func == (lhs: GDPRCategory, rhs: GDPRCategory) -> Bool {
        lhs._id == rhs._id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(_id)
    }
}

extension GDPRCategory.CategoryType: Codable {
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
