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

struct CCPAPrivacyManagerViewResponse: Decodable {
    let vendors: [GDPRVendor]
    let categories: [GDPRCategory]
    var grants: SPGDPRVendorGrants?
}
