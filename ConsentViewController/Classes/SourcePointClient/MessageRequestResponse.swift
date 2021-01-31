//
//  MessageRequest.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 03.07.20.
//

import Foundation

struct CampaignRequest: Equatable {
//    let euconsent: String still needed?
    let uuid: SPConsentUUID?
    let accountId, propertyId: Int
    let propertyHref: SPPropertyName
    let campaignEnv: SPCampaignEnv
    let meta: Meta
    let targetingParams: SPTargetingParams /// TODO: check if targetingParams can be an object instead of string
}

extension CampaignRequest: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(euconsent, forKey: .euconsent)
        try container.encode(accountId, forKey: .accountId)
        try container.encode(propertyId, forKey: .propertyId)
        try container.encode(propertyHref, forKey: .propertyHref)
        try container.encode(meta, forKey: .meta)
        if uuid != nil { try container.encode(uuid, forKey: .uuid) }
        try container.encode(targetingParams, forKey: .targetingParams)
        if #available(iOS 11, *) {
            try container.encode(campaignEnv, forKey: .campaignEnv)
        } else {
            try container.encode(campaignEnv.stringValue, forKey: .campaignEnv)
        }
    }

    enum CodingKeys: String, CodingKey {
        case uuid, accountId,
             propertyId, propertyHref, campaignEnv,
             targetingParams, meta //, euconsent
    }
}

struct CampaignsRequest: Equatable, Encodable {
    let gdpr, ccpa: CampaignRequest?
}

struct MessageRequest: Equatable, Encodable {
    let authId: String?
    let requestUUID: UUID
    let campaigns: CampaignsRequest
}

struct MessageResponse: Decodable {
    let url: URL?
    let msgJSON: GDPRMessage?
    let uuid: SPConsentUUID
    let userConsent: GDPRUserConsent
    var meta: Meta
}
