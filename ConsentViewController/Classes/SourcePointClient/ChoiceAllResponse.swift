//
//  ChoiseResponse.swift
//  ConsentViewController-iOS
//
//  Created by Fedko Dmytro on 26/09/2022.
//

import Foundation

struct ChoiceAllResponse: Decodable {
    struct USNAT {
        let consentedToAll: Bool
        let dateCreated: SPDate
        let rejectedAny: Bool
        let gpcEnabled: Bool?
        let webConsentPayload: SPWebConsentPayload?
        let GPPData: SPJson
    }

    struct CCPA {
        let consentedAll: Bool
        let dateCreated, expirationDate: SPDate
        let rejectedAll: Bool
        let status: CCPAConsentStatus
        let uspstring: String
        let rejectedVendors: [String]
        let rejectedCategories: [String]
        let gpcEnabled: Bool?
        let webConsentPayload: SPWebConsentPayload?
        let GPPData: SPJson
    }

    struct GDPR {
        struct PostPayload: Decodable {
            let consentAllRef: String?
            let vendorListId: String
            let granularStatus: ConsentStatus.GranularStatus?
        }

        let addtlConsent, childPmId: String?
        let euconsent: String
        let hasLocalData: Bool?
        let dateCreated: SPDate
        let expirationDate: SPDate
        let TCData: SPJson
        let consentStatus: ConsentStatus
        let grants: SPGDPRVendorGrants
        let postPayload: PostPayload?
        let webConsentPayload: SPWebConsentPayload?
        let gcmStatus: SPGCMData?
        let acceptedLegIntCategories: [String]
        let acceptedLegIntVendors: [String]
        let acceptedVendors: [String]
        let acceptedCategories: [String]
        let acceptedSpecialFeatures: [String]
    }

    let gdpr: GDPR?
    let ccpa: CCPA?
    let usnat: USNAT?
}

struct ChoiceAllMetaDataParam: QueryParamEncodable {
    struct Campaign: Encodable {
        let applies: Bool
    }

    let gdpr, ccpa, usnat: Campaign?
}

extension ChoiceAllResponse.USNAT: Decodable {
    enum CodingKeys: String, CodingKey {
        case dateCreated, consentedToAll, rejectedAny,
             gpcEnabled, webConsentPayload, GPPData
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        try self.init(
            consentedToAll: container.decode(Bool.self, forKey: .consentedToAll),
            dateCreated: container.decode(SPDate.self, forKey: .dateCreated),
            rejectedAny: container.decode(Bool.self, forKey: .rejectedAny),
            gpcEnabled: container.decodeIfPresent(Bool.self, forKey: .gpcEnabled),
            webConsentPayload: container.decodeIfPresent(SPWebConsentPayload.self, forKey: .webConsentPayload),
            GPPData: container.decodeIfPresent(SPJson.self, forKey: .GPPData) ?? SPJson()
        )
    }
}

extension ChoiceAllResponse.CCPA: Decodable {
    enum CodingKeys: String, CodingKey {
        case dateCreated, expirationDate, consentedAll, rejectedAll,
             status, rejectedVendors, rejectedCategories,
             gpcEnabled, webConsentPayload, GPPData
        case uspstring = "uspString"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        try self.init(
            consentedAll: container.decode(Bool.self, forKey: .consentedAll),
            dateCreated: container.decode(SPDate.self, forKey: .dateCreated),
            expirationDate: container.decode(SPDate.self, forKey: .expirationDate),
            rejectedAll: container.decode(Bool.self, forKey: .rejectedAll),
            status: container.decode(CCPAConsentStatus.self, forKey: .status),
            uspstring: container.decode(String.self, forKey: .uspstring),
            rejectedVendors: ((container.decodeIfPresent([String?].self, forKey: .rejectedVendors)) ?? []).compactMap { $0 },
            rejectedCategories: ((container.decodeIfPresent([String?].self, forKey: .rejectedCategories)) ?? []).compactMap { $0 },
            gpcEnabled: container.decodeIfPresent(Bool.self, forKey: .gpcEnabled),
            webConsentPayload: container.decodeIfPresent(SPWebConsentPayload.self, forKey: .webConsentPayload),
            GPPData: container.decodeIfPresent(SPJson.self, forKey: .GPPData) ?? SPJson()
        )
    }
}

extension ChoiceAllResponse.GDPR: Decodable {
    enum CodingKeys: String, CodingKey {
        case addtlConsent, childPmId, euconsent, hasLocalData,
             dateCreated, expirationDate, TCData, consentStatus,
             grants, postPayload, webConsentPayload, gcmStatus
        case acceptedCategories = "categories"
        case acceptedLegIntCategories = "legIntCategories"
        case acceptedVendors = "vendors"
        case acceptedLegIntVendors = "legIntVendors"
        case acceptedSpecialFeatures = "specialFeatures"
    }
}
