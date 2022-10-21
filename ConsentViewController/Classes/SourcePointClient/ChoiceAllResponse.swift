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
        let dateCreated: String
        let rejectedAll: Bool
        let status: String

        let uspstring: String?             // does not exist in response, Must be NOT NULLABLE

        let rejectedVendors: [String]?
        let rejectedCategories: [String]?
        let gpcEnabled: Bool?
        let newUser: Bool?
        let uuid: String?
    }

    struct GDPR: Decodable {
        struct Grant: Decodable {
            let vendorGrant: Bool?
            let purposeGrants: [String: Bool]?
        }
        struct PostPayload: Decodable {
            let consentAllRef: String?
            let vendorListId: String?
            let granularStatus: ConsentStatus.GranularStatus?
        }

        let addtlConsent: String?
        let applies: Bool?
        let euconsent: String?

        let hasLocalData: Bool?
        let dateCreated: String?
        let childPmId: String?
        let tcData: SPJson?
        let consentStatus: ConsentStatus
        let grants: [String: Grant]?
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
