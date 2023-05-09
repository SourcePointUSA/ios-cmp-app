//
//  MessagesRequest.swift
//  Pods
//
//  Created by Andre Herculano on 13.09.22.
//

import Foundation

struct MessagesRequest: QueryParamEncodable {
    struct Body: QueryParamEncodable {
        struct Campaigns: QueryParamEncodable {
            struct CCPA: QueryParamEncodable {
                let targetingParams: SPTargetingParams?
                let hasLocalData: Bool
                let status: CCPAConsentStatus?
            }

            struct GDPR: QueryParamEncodable {
                let targetingParams: SPTargetingParams?
                let hasLocalData: Bool
                let consentStatus: ConsentStatus?
            }

            struct IOS14: QueryParamEncodable {
                let targetingParams: SPTargetingParams?
                let idfaSstatus: SPIDFAStatus
            }

            let ccpa: CCPA?
            let gdpr: GDPR?
            let ios14: IOS14?
        }

        let propertyHref: SPPropertyName
        let accountId: Int
        let campaigns: Campaigns
        let consentLanguage: SPMessageLanguage
        let hasCSP = true
        let campaignEnv: SPCampaignEnv?
        let idfaStatus: SPIDFAStatus?
        let includeData = IncludeData()
    }

    struct MetaData: QueryParamEncodable {
        struct Campaign: QueryParamEncodable {
            let applies: Bool
        }

        let ccpa, gdpr: Campaign?
    }

    struct LocalState: QueryParamEncodable {
        let ccpa: SPJson?
        let gdpr: SPJson?
        let ios14: SPJson?
    }

    struct NonKeyedLocalState: QueryParamEncodable {
        let ccpa: SPJson?
        let gdpr: SPJson?
        let ios14: SPJson?
    }

    let body: Body
    let metadata: MetaData
    let localState: LocalState
    let nonKeyedLocalState: NonKeyedLocalState
}

extension MessagesRequest.NonKeyedLocalState {
    init(nonKeyedLocalState: SPJson?) {
        ccpa = nonKeyedLocalState?["ccpa"]
        gdpr = nonKeyedLocalState?["gdpr"]
        ios14 = nonKeyedLocalState?["ios14"]
    }
}

extension MessagesRequest.LocalState {
    init(localState: SPJson?) {
        ccpa = localState?["ccpa"]
        gdpr = localState?["gdpr"]
        ios14 = localState?["ios14"]
    }
}

extension MessagesRequest.Body.Campaigns {
    init() {
        ccpa = nil
        gdpr = nil
        ios14 = nil
    }
}

extension MessagesRequest.MetaData.Campaign {
    init?(applies: Bool?) {
        guard let applies = applies else { return nil }
        self.applies = applies
    }
}

extension MessagesRequest.Body.Campaigns.GDPR {
    init?(_ campaign: SPCampaign?, hasLocalData: Bool, consentStatus: ConsentStatus) {
        guard let campaign = campaign else { return nil }

        self.targetingParams = campaign.targetingParams
        self.hasLocalData = hasLocalData
        self.consentStatus = consentStatus
    }
}

extension MessagesRequest.Body.Campaigns.CCPA {
    init?(_ campaign: SPCampaign?, hasLocalData: Bool, status: CCPAConsentStatus) {
        guard let campaign = campaign else { return nil }

        self.targetingParams = campaign.targetingParams
        self.hasLocalData = hasLocalData
        self.status = status
    }
}

extension MessagesRequest.Body.Campaigns.IOS14 {
    init?(_ campaign: SPCampaign?, idfaStatus: SPIDFAStatus) {
        guard let campaign = campaign else { return nil }

        self.targetingParams = campaign.targetingParams
        self.idfaSstatus = idfaStatus
    }
}
