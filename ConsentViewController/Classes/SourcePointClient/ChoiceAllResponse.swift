//
//  ChoiseResponse.swift
//  ConsentViewController-iOS
//
//  Created by Fedko Dmytro on 26/09/2022.
//

import Foundation

struct ChoiceAllResponse: Decodable {
    struct CCPA {
        let consentedAll: Bool
        let dateCreated: SPDateCreated
        let rejectedAll: Bool
        let status: CCPAConsentStatus
        let uspstring: String
        let rejectedVendors: [String]
        let rejectedCategories: [String]
        let gpcEnabled: Bool?
        let webConsentPayload: SPWebConsentPayload?
    }

    struct GDPR: Decodable {
        struct PostPayload: Decodable {
            let consentAllRef: String?
            let vendorListId: String
            let granularStatus: ConsentStatus.GranularStatus?
        }

        let addtlConsent, childPmId: String?
        let euconsent: String
        let hasLocalData: Bool?
        let dateCreated: SPDateCreated
        let TCData: SPJson
        let consentStatus: ConsentStatus
        let grants: SPGDPRVendorGrants
        let postPayload: PostPayload?
        let webConsentPayload: SPWebConsentPayload?
    }

    let gdpr: GDPR?
    let ccpa: CCPA?
}

struct ChoiceAllBodyRequest: QueryParamEncodable {
    struct Campaign: Encodable {
        let applies: Bool
    }

    let gdpr, ccpa: Campaign?
}

extension ChoiceAllResponse.CCPA: Decodable {
    enum CodingKeys: String, CodingKey {
        case dateCreated, consentedAll, rejectedAll,
             status, rejectedVendors, rejectedCategories,
             gpcEnabled, webConsentPayload
        case uspstring = "uspString"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        try self.init(
            consentedAll: container.decode(Bool.self, forKey: .consentedAll),
            dateCreated: container.decode(SPDateCreated.self, forKey: .dateCreated),
            rejectedAll: container.decode(Bool.self, forKey: .rejectedAll),
            status: container.decode(CCPAConsentStatus.self, forKey: .status),
            uspstring: container.decode(String.self, forKey: .uspstring),
            rejectedVendors: ((container.decodeIfPresent([String?].self, forKey: .rejectedVendors)) ?? []).compactMap { $0 },
            rejectedCategories: ((container.decodeIfPresent([String?].self, forKey: .rejectedCategories)) ?? []).compactMap { $0 },
            gpcEnabled: container.decodeIfPresent(Bool.self, forKey: .gpcEnabled),
            webConsentPayload: container.decodeIfPresent(SPWebConsentPayload.self, forKey: .webConsentPayload)
        )
    }
}
