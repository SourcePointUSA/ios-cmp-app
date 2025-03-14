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

    enum Keys: String, CodingKey {
        case policyUrl, legIntUrl, vendorId, name
        case iabId
        case iabSpecialPurposes, iabSpecialPurposesObjs, iabFeatures, iabSpecialFeatures, iabDataCategories
        case description, cookieHeader
        case vendorType
        case consentCategories, legIntCategories, disclosureOnlyCategories
    }

    struct Category: Decodable {
        let type: GDPRCategory.CategoryType?
        let iabId: Int?
        let name: String
        var retention: String?

        enum CodingKeys: CodingKey {
            case type
            case iabId
            case name
            case retention
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            type = try container.decodeIfPresent(GDPRCategory.CategoryType.self, forKey: .type)
            iabId = try container.decodeIfPresent(Int.self, forKey: .iabId)
            name = try container.decode(String.self, forKey: .name)
            do {
                retention = try container.decodeIfPresent(String.self, forKey: .retention)
            } catch DecodingError.typeMismatch {
                retention = try String(container.decode(Int.self, forKey: .retention))
            }
        }
    }

    struct DataCategories: Decodable {
        let name: String
        let description: String
    }

    let vendorId, name: String
    let iabId: Int?
    let policyUrl: URL?
    let legIntUrl: URL?
    let description, cookieHeader: String?
    let vendorType: VendorType
    let consentCategories, legIntCategories, disclosureOnlyCategories: [Category]
    var iabSpecialPurposes, iabFeatures, iabSpecialFeatures: [String]
    let iabSpecialPurposesObjs: [Category]?
    let iabDataCategories: [DataCategories]?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        name = try container.decode(String.self, forKey: .name)
        policyUrl = try container.decodeIfPresent(URL.self, forKey: .policyUrl)
        legIntUrl = try container.decodeIfPresent(URL.self, forKey: .legIntUrl)
        vendorId = try container.decode(String.self, forKey: .vendorId)
        vendorType = try container.decode(Self.VendorType.self, forKey: .vendorType)
        iabId = try container.decodeIfPresent(Int.self, forKey: .iabId)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        cookieHeader = try container.decodeIfPresent(String.self, forKey: .cookieHeader)
        consentCategories = try container.decode([Category].self, forKey: .consentCategories)
        legIntCategories = try container.decode([Category].self, forKey: .legIntCategories)
        disclosureOnlyCategories = try container.decode([Category].self, forKey: .disclosureOnlyCategories)
        iabSpecialPurposes = try container.decode([String].self, forKey: .iabSpecialPurposes)
        iabSpecialPurposesObjs = try container.decodeIfPresent([Category].self, forKey: .iabSpecialPurposesObjs)
        iabDataCategories = try container.decodeIfPresent([DataCategories].self, forKey: .iabDataCategories)
        if disclosureOnlyCategories.isNotEmpty() {
            for category in disclosureOnlyCategories {
                iabSpecialPurposes.append(category.name)
            }
        }
        iabFeatures = try container.decode([String].self, forKey: .iabFeatures)
        iabSpecialFeatures = try container.decode([String].self, forKey: .iabSpecialFeatures)
    }
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
    var legIntCategories, legIntVendors, acceptedVendors, acceptedCategories, acceptedSpecialFeatures: [String]?
    var hasConsentData: Bool?
}

struct CCPAVendor: Hashable {
    let _id, name: String
    let policyUrl: URL?
    private let nullablePurposes: [String?]?
    var purposes: [String] { nullablePurposes?.compactMap { $0 }  ?? [] }
}

extension CCPAVendor: Decodable {
    enum Keys: String, CodingKey {
        case _id, name, policyUrl
        case nullablePurposes = "purposes"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        _id = try container.decode(String.self, forKey: ._id)
        name = try container.decode(String.self, forKey: .name)
        do {
            policyUrl = try container.decodeIfPresent(URL.self, forKey: .policyUrl)
        } catch {
            policyUrl = nil
        }
        nullablePurposes = try container.decodeIfPresent([String?].self, forKey: .nullablePurposes)
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
