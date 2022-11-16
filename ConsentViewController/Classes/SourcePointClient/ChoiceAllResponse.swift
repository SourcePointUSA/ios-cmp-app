//
//  ChoiseResponse.swift
//  ConsentViewController-iOS
//
//  Created by Fedko Dmytro on 26/09/2022.
//

import Foundation

struct ChoiceAllResponse: Decodable {
    struct CCPA {
        let applies: Bool
        let consentedAll: Bool
        let dateCreated: SPDateCreated
        let rejectedAll: Bool
        let status: CCPAConsentStatus
        let uspstring: String? // TODO: this should be returned by the API
        let rejectedVendors: [String]
        let rejectedCategories: [String]
        let gpcEnabled: Bool? // TODO: check with Sid if this not be optional (it's missing for property 16893)
    }

    struct GDPR: Decodable {
        struct PostPayload: Decodable {
            let consentAllRef: String?
            let vendorListId: String
            let granularStatus: ConsentStatus.GranularStatus?
        }

        let addtlConsent, childPmId: String?
        let applies: Bool
        let euconsent: String
        let hasLocalData: Bool?
        let dateCreated: SPDateCreated?
        let TCData: SPJson? // TODO: this should be not empty
        let consentStatus: ConsentStatus
        let grants: SPGDPRVendorGrants
        let postPayload: PostPayload?
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
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        try self.init(
            applies: container.decode(Bool.self, forKey: .applies),
            consentedAll: container.decode(Bool.self, forKey: .consentedAll),
            dateCreated: container.decode(SPDateCreated.self, forKey: .dateCreated),
            rejectedAll: container.decode(Bool.self, forKey: .rejectedAll),
            status: container.decode(CCPAConsentStatus.self, forKey: .status),
            uspstring: container.decodeIfPresent(String.self, forKey: .uspstring),
            rejectedVendors: ((container.decodeIfPresent([String?].self, forKey: .rejectedVendors)) ?? []).compactMap { $0 },
            rejectedCategories: ((container.decodeIfPresent([String?].self, forKey: .rejectedCategories)) ?? []).compactMap { $0 },
            gpcEnabled: container.decodeIfPresent(Bool.self, forKey: .gpcEnabled)
        )
    }

    enum CodingKeys: CodingKey {
        case applies, dateCreated, consentedAll, rejectedAll, status, uspstring, rejectedVendors, rejectedCategories, gpcEnabled
    }
}
