//
//  PrivacyManagerRequestResponse.swift
//  Pods
//
//  Created by Vilas on 15/04/21.
//

import Foundation

@objcMembers class GDPRCategory: Codable {
    @objc public enum CategoryType: Int, Equatable {
        case IAB_PURPOSE, IAB, unknown, CUSTOM
    }

    struct Vendor: Codable {
        let name: String
        let vendorId: String?
        let policyUrl: URL?
        let vendorType: GDPRVendor.VendorType?

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: Keys.self)
            name = try container.decode(String.self, forKey: .name)
            policyUrl = try? container.decodeIfPresent(URL.self, forKey: .policyUrl)
            vendorId = try container.decodeIfPresent(String.self, forKey: .vendorId)
            vendorType = try container.decodeIfPresent(GDPRVendor.VendorType.self, forKey: .vendorType)
        }

        enum Keys: String, CodingKey {
            case name, vendorId, policyUrl, vendorType
        }
    }

    enum Keys: String, CodingKey {
        case iabId
        case _id, name, description
        case type
        case disclosureOnly, requireConsent
        case legIntVendors, requiringConsentVendors, disclosureOnlyVendors
    }

    let iabId: Int?
    let _id, name, description: String
    let type: GDPRCategory.CategoryType?
    let disclosureOnly: Bool?
    let requireConsent: Bool?
    let legIntVendors: [Vendor]?
    let requiringConsentVendors: [Vendor]?
    let disclosureOnlyVendors: [Vendor]
    var uniqueVendorIds: [String] {
        Array(Set<String>(
            ((legIntVendors ?? []).compactMap { $0.vendorId } +
             ((requiringConsentVendors ?? []).compactMap { $0.vendorId })
        )))
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        self.iabId = try container.decodeIfPresent(Int.self, forKey: .iabId)
        self._id = try container.decode(String.self, forKey: ._id)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decode(String.self, forKey: .description)
        self.type = try container.decodeIfPresent(GDPRCategory.CategoryType.self, forKey: .type)
        self.disclosureOnly = try container.decodeIfPresent(Bool.self, forKey: .disclosureOnly)
        self.requireConsent = try container.decodeIfPresent(Bool.self, forKey: .requireConsent)
        self.legIntVendors = try container.decodeIfPresent([GDPRCategory.Vendor].self, forKey: .legIntVendors)
        self.requiringConsentVendors = try container.decodeIfPresent([GDPRCategory.Vendor].self, forKey: .requiringConsentVendors)
        self.disclosureOnlyVendors = try container.decodeIfPresent([GDPRCategory.Vendor].self, forKey: .disclosureOnlyVendors) ?? []
    }

    init(
        name: String,
        description: String = "",
        disclosureOnly: Bool = false,
        legIntVendors: [Vendor]? = nil,
        requiringConsentVendors: [Vendor]? = nil,
        disclosureOnlyVendors: [Vendor]? = nil
    ) {
        self.iabId = 0
        self._id = "id"
        self.name = name
        self.description = description
        self.type = GDPRCategory.CategoryType.CUSTOM
        self.disclosureOnly = disclosureOnly
        self.requireConsent = false
        self.legIntVendors = legIntVendors
        self.requiringConsentVendors = requiringConsentVendors
        self.disclosureOnlyVendors = disclosureOnlyVendors ?? []
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
        case .CUSTOM: return "CUSTOM"
        default: return "unknown"
        }
    }

    public init(rawValue: String) {
        switch rawValue {
        case "IAB_PURPOSE": self = .IAB_PURPOSE
        case "IAB": self = .IAB
        case "CUSTOM": self = .CUSTOM
        default: self = .unknown
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.init(rawValue: try container.decode(String.self))
    }
}
