//
//  ChoiseResponse.swift
//  ConsentViewController-iOS
//
//  Created by Fedko Dmytro on 26/09/2022.
//

import Foundation

struct ChoiceAllResponse: Decodable {
    struct CCPA: Decodable {
        let applies: Bool
        let consentedAll: Bool
        let dateCreated: SPDateCreated
        let rejectedAll: Bool
        let status: CCPAConsentStatus

        // TODO: change to `String` once the API starts returning it
        let uspstring: String?

        let rejectedVendors: [String?]?
        let rejectedCategories: [String?]?
        let gpcEnabled: Bool?
        let newUser: Bool?
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
        let tcData: SPJson?
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
