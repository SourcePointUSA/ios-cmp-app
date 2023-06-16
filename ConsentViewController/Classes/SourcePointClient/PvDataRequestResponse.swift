//
//  PvDataRequestResponse.swift
//  ConsentViewController-iOS
//
//  Created by Fedko Dmytro on 14/09/2022.
//

import Foundation

struct PvDataResponse: Decodable, Equatable {
    struct Campaign: Decodable, Equatable {
        let uuid: String
    }

    let gdpr: Campaign?
    let ccpa: Campaign?
}

struct PvDataRequestBody: Encodable, Equatable {
    struct GDPR: Encodable, Equatable {
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

    struct CCPA: Encodable, Equatable {
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
