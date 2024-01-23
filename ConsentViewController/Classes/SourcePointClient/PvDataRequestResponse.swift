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

    let gdpr, ccpa, usnat: Campaign?
}

struct PvDataRequestBody: Encodable, Equatable {
    struct GDPR: Encodable, Equatable {
        let applies: Bool
        let uuid: String?
        let accountId: Int
        let siteId: Int
        let consentStatus: ConsentStatus
        let pubData: SPPublisherData?
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
        let pubData: SPPublisherData?
        let messageId: Int?
        let sampleRate: Float?
    }

    struct USNat: Encodable, Equatable {
        let applies: Bool
        let uuid: String?
        let accountId: Int
        let siteId: Int
        let consentStatus: ConsentStatus
        let pubData: SPPublisherData?
        let sampleRate: Float?
        let msgId: Int?
        let categoryId: Int?
        let subCategoryId: Int?
        let prtnUUID: String?
    }

    let gdpr: GDPR?
    let ccpa: CCPA?
    let usnat: USNat?

    init(gdpr: GDPR? = nil, ccpa: CCPA? = nil, usnat: USNat? = nil) {
        self.gdpr = gdpr
        self.ccpa = ccpa
        self.usnat = usnat
    }
}
