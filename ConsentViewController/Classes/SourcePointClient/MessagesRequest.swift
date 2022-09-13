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
                let targetingParams: SPJson?
                let hasLocalData: Bool
                let status: CCPAConsentStatus?
            }

            struct GDPR: QueryParamEncodable {
                let targetingParams: SPJson?
                let hasLocalData: Bool
                let consentStatus: ConsentStatus
            }

            struct IOS14: QueryParamEncodable {
                let idfaSstatus: SPIDFAStatus
                let targetingParams: SPJson?
            }

            let ccpa: CCPA?
            let gdpr: GDPR?
            let ios14: IOS14?
        }

        let propertyHref: SPPropertyName
        let accountId: Int
        let campaigns: Campaigns
        let localState: SPJson?
        let consentLanguage: SPMessageLanguage
        let hasCSP = true
        let campaignEnv: SPCampaignEnv?
        let idfaStatus: SPIDFAStatus?
        let includeData = try? SPJson([
            "localState": ["type": "RecordString"],
            "TCData": ["type": "RecordString"]
        ])
    }

    struct MetaData: QueryParamEncodable {
        struct Campaign: QueryParamEncodable {
            let applies: Bool
        }

        let ccpa, gdpr: Campaign?
    }

    let body: Body
    let metadata: MetaData?
    let nonKeyedLocalState: SPJson?
}

extension MessagesRequest.Body.Campaigns {
    init() {
        ccpa = nil
        gdpr = nil
        ios14 = nil
    }
}
