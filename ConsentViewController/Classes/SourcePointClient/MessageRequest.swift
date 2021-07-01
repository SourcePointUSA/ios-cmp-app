//
//  MessageRequest.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 03.07.20.
//

import Foundation

struct CampaignRequest: Encodable, Equatable {
    let targetingParams: SPTargetingParams
}

struct CampaignsRequest: Equatable, Encodable {
    let gdpr, ccpa, ios14: CampaignRequest?

    static func spCampaignToRequest(_ campaign: SPCampaign?) -> CampaignRequest? {
        guard let campaign = campaign else { return nil }
        return CampaignRequest(
            targetingParams: campaign.targetingParams
        )
    }
}

extension CampaignsRequest {
    init(from campaigns: SPCampaigns) {
        gdpr = CampaignsRequest.spCampaignToRequest(campaigns.gdpr)
        ccpa = CampaignsRequest.spCampaignToRequest(campaigns.ccpa)
        ios14 = CampaignsRequest.spCampaignToRequest(campaigns.ios14)
    }
}

struct MessageRequest: Equatable, Encodable {
    let authId: String?
    let requestUUID: UUID
    let propertyHref: SPPropertyName
    let accountId: Int
    let campaignEnv: SPCampaignEnv
    let idfaStatus: SPIDFAStatus
    let localState: SPJson
    let consentLanguage: SPMessageLanguage
    let campaigns: CampaignsRequest
    let includeData = [
        "localState": ["type": "RecordString"],
        "TCData": ["type": "RecordString"],
        "messageMetaData": ["type": "RecordString"]
    ]
}
