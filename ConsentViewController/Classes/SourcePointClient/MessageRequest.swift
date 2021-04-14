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

struct CampaignRequest: Encodable, Equatable {
    let campaignEnv: SPCampaignEnv
    let targetingParams: SPTargetingParams
}

struct CampaignsRequest: Equatable, Encodable {
    let gdpr, ccpa, ios14: CampaignRequest?
}

struct MessageRequest: Equatable, Encodable {
    let authId: String?
    let requestUUID: UUID
    let propertyHref: SPPropertyName
    let accountId: Int
    let idfaStatus: SPIDFAStatus
    let localState: String
    let campaigns: CampaignsRequest
    let includeData = [
        "localState": ["type": "RecordString"],
        "TCData": ["type": "RecordString"],
        "messageMetaData": ["type": "RecordString"]
    ]
}
