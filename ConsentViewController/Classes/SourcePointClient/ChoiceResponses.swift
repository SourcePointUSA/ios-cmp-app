//
//  ChoiceResponses.swift
//  Pods
//
//  Created by Andre Herculano on 17.10.22.
//

import Foundation

struct GDPRChoiceResponse: Equatable {
    let uuid: String
    let dateCreated, expirationDate: SPDate
    let TCData: SPJson?
    let euconsent: String?
    let consentStatus: ConsentStatus?
    let grants: SPGDPRVendorGrants?
    let webConsentPayload: SPWebConsentPayload?
    let acceptedLegIntCategories: [String]?
    let acceptedLegIntVendors: [String]?
    let acceptedVendors: [String]?
    let acceptedCategories: [String]?
    let acceptedSpecialFeatures: [String]?
}

struct CCPAChoiceResponse: Equatable {
    let uuid: String
    let dateCreated: SPDate
    let consentedAll: Bool?
    let rejectedAll: Bool?
    let status: CCPAConsentStatus?
    let uspstring: String?
    let gpcEnabled: Bool?
    let rejectedVendors: [String]?
    let rejectedCategories: [String]?
    let webConsentPayload: SPWebConsentPayload?
    let GPPData: SPJson
}

struct USNatChoiceResponse: Equatable, Decodable {
    let uuid: String
    let consentStrings: [SPUSNatConsent.ConsentString]
    let categories: [String]
    let dateCreated, expirationDate: SPDate
    let webConsentPayload: SPWebConsentPayload?
    let consentStatus: ConsentStatus
    let GPPData: SPJson?
}

extension CCPAChoiceResponse: Decodable {
    enum CodingKeys: CodingKey {
        case uuid, dateCreated, consentedAll, rejectedAll,
             status, uspstring, rejectedVendors, rejectedCategories,
             gpcEnabled, webConsentPayload, GPPData
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        try self.init(
            uuid: container.decode(String.self, forKey: .uuid),
            dateCreated: container.decode(SPDate.self, forKey: .dateCreated),
            consentedAll: container.decode(Bool.self, forKey: .consentedAll),
            rejectedAll: container.decode(Bool.self, forKey: .rejectedAll),
            status: container.decode(CCPAConsentStatus.self, forKey: .status),
            uspstring: container.decode(String.self, forKey: .uspstring),
            gpcEnabled: container.decodeIfPresent(Bool.self, forKey: .gpcEnabled),
            rejectedVendors: ((container.decodeIfPresent([String?].self, forKey: .rejectedVendors)) ?? []).compactMap { $0 },
            rejectedCategories: ((container.decodeIfPresent([String?].self, forKey: .rejectedCategories)) ?? []).compactMap { $0 },
            webConsentPayload: container.decodeIfPresent(SPWebConsentPayload.self, forKey: .webConsentPayload),
            GPPData: container.decodeIfPresent(SPJson.self, forKey: .GPPData) ?? SPJson()
        )
    }
}

extension GDPRChoiceResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case uuid, euconsent, dateCreated, expirationDate,
             TCData, consentStatus, grants, webConsentPayload
        case acceptedCategories = "categories"
        case acceptedLegIntCategories = "legIntCategories"
        case acceptedVendors = "vendors"
        case acceptedLegIntVendors = "legIntVendors"
        case acceptedSpecialFeatures = "specialFeatures"
    }
}
