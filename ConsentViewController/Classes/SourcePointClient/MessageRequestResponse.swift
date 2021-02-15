//
//  MessageRequest.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 03.07.20.
//

import Foundation

extension SPTargetingParams {
    func stringified() throws -> String? { String(
        data: try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted),
        encoding: .utf8
    )}
}

struct CampaignRequest: Equatable {
    let uuid: SPConsentUUID?
    let accountId, propertyId: Int
    let propertyHref: SPPropertyName
    let campaignEnv: SPCampaignEnv
    let meta: Meta?
    let targetingParams: SPTargetingParams
}

extension CampaignRequest: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(accountId, forKey: .accountId)
        try container.encode(propertyId, forKey: .propertyId)
        try container.encode(propertyHref, forKey: .propertyHref)
        try container.encodeIfPresent(meta, forKey: .meta)
        try container.encodeIfPresent(uuid, forKey: .uuid)
        if !targetingParams.isEmpty {
            try container.encode(targetingParams.stringified(), forKey: .targetingParams)
        }
        if #available(iOS 11, *) {
            try container.encode(campaignEnv, forKey: .campaignEnv)
        } else {
            try container.encode(campaignEnv.stringValue, forKey: .campaignEnv)
        }
    }

    enum CodingKeys: String, CodingKey {
        case uuid, accountId,
             propertyId, propertyHref, campaignEnv,
             targetingParams, meta
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

typealias CCPAMessageResponse<MessageType: Decodable & Equatable> = MessageResponse<SPCCPAConsent, MessageType>
typealias GDPRMessageResponse<MessageType: Decodable & Equatable> = MessageResponse<SPGDPRConsent, MessageType>
struct MessagesResponse<MessageType: Decodable & Equatable>: Decodable, Equatable {
    let gdpr: GDPRMessageResponse<MessageType>?
    let ccpa: CCPAMessageResponse<MessageType>?
}

struct MessageResponse<ConsentType: Decodable & Equatable, MessageType: Decodable & Equatable>: Equatable, Decodable {
    let message: MessageType?
    let applies: Bool
    let uuid: SPConsentUUID
    let userConsent: ConsentType
    var meta: Meta
}
