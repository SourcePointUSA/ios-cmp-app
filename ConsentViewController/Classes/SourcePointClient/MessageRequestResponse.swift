//
//  MessageRequest.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 03.07.20.
//

import Foundation

struct MessageRequest: Equatable {
    let uuid: SPConsentUUID?
    let euconsent: String
    let authId: String?
    let accountId: Int
    let propertyId: Int
    let propertyHref: SPPropertyName
    let campaignEnv: GDPRCampaignEnv
    let targetingParams: String?
    let requestUUID: UUID
    let meta: Meta
}

extension MessageRequest: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try? container.decode(SPConsentUUID.self, forKey: .uuid)
        euconsent = try container.decode(String.self, forKey: .euconsent)
        authId = try? container.decode(String.self, forKey: .authId)
        accountId = try container.decode(Int.self, forKey: .accountId)
        propertyId = try container.decode(Int.self, forKey: .propertyId)
        propertyHref = try container.decode(SPPropertyName.self, forKey: .propertyHref)
        targetingParams = try? container.decode(String.self, forKey: .targetingParams)
        requestUUID = try container.decode(UUID.self, forKey: .requestUUID)
        meta = try container.decode(String.self, forKey: .meta)
        if #available(iOS 11, *) {
            campaignEnv = try container.decode(GDPRCampaignEnv.self, forKey: .campaignEnv)
        } else {
            guard let env = GDPRCampaignEnv(stringValue: try container.decode(String.self, forKey: .campaignEnv)) else {
                throw DecodingError.dataCorrupted(DecodingError.Context(
                   codingPath: [],
                   debugDescription: "Unknown GDPRCampaignEnv"
                ))
            }
            campaignEnv = env
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(euconsent, forKey: .euconsent)
        try container.encode(accountId, forKey: .accountId)
        try container.encode(propertyId, forKey: .propertyId)
        try container.encode(propertyHref, forKey: .propertyHref)
        try container.encode(requestUUID, forKey: .requestUUID)
        try container.encode(meta, forKey: .meta)
        if uuid != nil { try container.encode(uuid, forKey: .uuid) }
        if authId != nil { try container.encode(authId, forKey: .authId) }
        if targetingParams != nil { try container.encode(targetingParams, forKey: .targetingParams) }
        if #available(iOS 11, *) {
            try container.encode(campaignEnv, forKey: .campaignEnv)
        } else {
            try container.encode(campaignEnv.stringValue, forKey: .campaignEnv)
        }
    }

    enum CodingKeys: String, CodingKey {
        case uuid, euconsent, authId, accountId, propertyId, propertyHref, campaignEnv, targetingParams, requestUUID, meta
    }
}

struct MessageResponse: Codable {
    let url: URL?
    let msgJSON: GDPRMessage?
    let uuid: SPConsentUUID
    let userConsent: GDPRUserConsent
    var meta: Meta
}
