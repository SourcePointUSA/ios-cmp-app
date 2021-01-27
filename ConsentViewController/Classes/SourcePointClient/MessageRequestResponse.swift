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
    let targetingParams: String?
}

extension CampaignRequest: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try? container.decode(SPConsentUUID.self, forKey: .uuid)
//        euconsent = try container.decode(String.self, forKey: .euconsent)
        accountId = try container.decode(Int.self, forKey: .accountId)
        propertyId = try container.decode(Int.self, forKey: .propertyId)
        propertyHref = try container.decode(SPPropertyName.self, forKey: .propertyHref)
        targetingParams = try? container.decode(String.self, forKey: .targetingParams)
        meta = try container.decode(String.self, forKey: .meta)
        if #available(iOS 11, *) {
            campaignEnv = try container.decode(SPCampaignEnv.self, forKey: .campaignEnv)
        } else {
            guard let env = SPCampaignEnv(stringValue: try container.decode(String.self, forKey: .campaignEnv)) else {
                throw DecodingError.dataCorrupted(DecodingError.Context(
                   codingPath: [],
                   debugDescription: "Unknown SPCampaignEnv"
                ))
            }
            campaignEnv = env
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(euconsent, forKey: .euconsent)
        try container.encode(accountId, forKey: .accountId)
        try container.encode(propertyId, forKey: .propertyId)
        try container.encode(propertyHref, forKey: .propertyHref)
        try container.encode(meta, forKey: .meta)
        if uuid != nil { try container.encode(uuid, forKey: .uuid) }
        if targetingParams != nil { try container.encode(targetingParams, forKey: .targetingParams) }
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

struct CampaignsRequest: Equatable, Codable {
    let gdpr, ccpa: CampaignRequest?
}

struct MessageRequest: Equatable, Codable {
    let authId: String?
    let requestUUID: UUID
    let campaigns: CampaignsRequest
}

struct MessageResponse: Codable {
    let url: URL?
    let msgJSON: GDPRMessage?
    let uuid: SPConsentUUID
    let userConsent: GDPRUserConsent
    var meta: Meta
}
