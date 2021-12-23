//
//  PrivacyManagerViewResponse.swift
//  Pods
//
//  Created by Andre Herculano on 01.06.21.
//

import Foundation

struct GDPRVendor: Decodable {
    enum VendorType: String, Codable {
        case IAB, CUSTOM
    }

    struct Category: Decodable {
        let type: GDPRCategory.CategoryType
        let iabId: Int?
        let name: String
    }

    let vendorId, name: String
    let iabId: Int?
    let policyUrl: URL?
    let description, cookieHeader: String?
    let vendorType: VendorType
    let consentCategories, legIntCategories: [Category]
    let iabSpecialPurposes, iabFeatures, iabSpecialFeatures: [String]
}

extension GDPRVendor: Identifiable, Equatable, Hashable {
    var id: String { vendorId }

    static func == (lhs: GDPRVendor, rhs: GDPRVendor) -> Bool {
        lhs.vendorId == rhs.vendorId
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(vendorId)
    }
}

enum PrivacyManagerViewResponse {
    case gdpr(_ response: GDPRPrivacyManagerViewResponse)
    case ccpa(_ response: CCPAPrivacyManagerViewResponse)
    case unknown
}

extension PrivacyManagerViewResponse: Decodable {
    init(from decoder: Decoder) throws {
        self = .unknown
    }

    init(campaignType: SPCampaignType, decoder: Decoder) throws {
        switch campaignType {
        case .gdpr:
            self = .gdpr(try GDPRPrivacyManagerViewResponse(from: decoder))
        case .ccpa:
            self = .ccpa(try CCPAPrivacyManagerViewResponse(from: decoder))
        default:
            self = .unknown
        }
    }
}

struct GDPRPrivacyManagerViewResponse: Decodable {
    let vendors: [GDPRVendor]
    let categories, specialPurposes, features, specialFeatures: [GDPRCategory]
    var grants: SPGDPRVendorGrants?
}

struct CCPAVendor: Hashable {
    let _id, name: String
    let policyUrl: URL?
    private let nullablePurposes: [String?]?
    var purposes: [String] { nullablePurposes?.compactMap { $0 }  ?? [] }
}

/// TODO: remove if the CCPA Vendors stop returning `null` inside its purposes
extension CCPAVendor: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        _id = try container.decode(String.self, forKey: ._id)
        name = try container.decode(String.self, forKey: .name)
        policyUrl = try container.decodeIfPresent(URL.self, forKey: .policyUrl)
        nullablePurposes = try container.decodeIfPresent([String?].self, forKey: .nullablePurposes)
    }

    enum Keys: String, CodingKey {
        case _id, name, policyUrl
        case nullablePurposes = "purposes"
    }
}

struct CCPACategory: Decodable, Hashable {
    let _id, name, description: String
    let requiringConsentVendors, legIntVendors: [CCPAVendor]
    let defaultOptedIn: Bool
}

struct CCPAPrivacyManagerViewResponse: Decodable {
    let vendors: [CCPAVendor]
    let categories: [CCPACategory]
    var rejectedCategories, rejectedVendors: [String]?
    var consentStatus: CCPAConsentStatus?
}
