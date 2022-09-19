//
//  PvdataResponse.swift
//  ConsentViewController-iOS
//
//  Created by Fedko Dmytro on 14/09/2022.
//

import Foundation

struct PvDataResponse: Decodable, Equatable {
    struct GDPR: Decodable, Equatable {
        struct Cookie: Decodable, Equatable {
            let key: String
            let value: String
            let maxAge: Int
            let shareRootDomain: Bool
            let session: Bool
        }

        let uuid: String
        let cookies: [Cookie]
    }

    let gdpr: GDPR?
}

struct PvDataRequestBody: Codable, Equatable {
    struct GDPR: Codable, Equatable {
        struct ConsentStatus: Codable, Equatable {
            let hasConsentData: Bool
            let consentedToAny: Bool
            let rejectAny: Bool
        }

        let applies: Bool
        let accountId: Int
        let siteId: Int
        let msgId: Int
        let categoryId: Int
        let subCategoryId: Int
        let fromTest: Bool
        let prtnUUID: Int

        let consentStatus: ConsentStatus
    }

    let gdpr: GDPR?
}
