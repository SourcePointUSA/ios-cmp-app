//
//  PvDataRequestResponse.swift
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
        let applies: Bool
        let uuid: String?
        let accountId: Int
        let siteId: Int
        let consentStatus: ConsentStatus
        let pubData: [String: String]?
        let sampleRate: Float?
        let euconsent: String?
        let msgId: Int?
        let categoryId: Int?
        let subCategoryId: Int?
        let prtnUUID: String?
    }

    struct CCPA: Codable, Equatable {
        let applies: Bool
        let uuid: String?
        let accountId: Int
        let siteId: Int
        let consentStatus: ConsentStatus
        let pubData: [String: String]?
        let messageId: Int?
        let sampleRate: Float?
    }

    let gdpr: GDPR?
    let ccpa: CCPA?

    init(gdpr: GDPR? = nil, ccpa: CCPA? = nil) {
        self.gdpr = gdpr
        self.ccpa = ccpa
    }
}