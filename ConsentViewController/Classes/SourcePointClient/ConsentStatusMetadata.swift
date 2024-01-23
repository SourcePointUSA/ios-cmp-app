//
//  ConsentStatusMetadata.swift
//  Pods
//
//  Created by Andre Herculano on 30.08.22.
//

import Foundation

/// Data Transfer Class used to encapsulate the meta data of `/consent-status` network call
struct ConsentStatusMetaData: QueryParamEncodable {
    struct Campaign: Encodable {
        let applies: Bool
        let dateCreated: SPDate?
        let uuid: String?
        let hasLocalData = false
        let idfaStatus: SPIDFAStatus?
    }

    struct USNatCampaign: Encodable {
        let applies: Bool
        let dateCreated: SPDate?
        let uuid: String?
        let hasLocalData = false
        let idfaStatus: SPIDFAStatus?
        let transitionCCPAAuth: Bool?
        let optedOut: Bool?
    }

    let gdpr, ccpa: Campaign?
    let usnat: USNatCampaign?
}

extension ConsentStatusMetaData.Campaign {
    init?(_ consent: CampaignConsent?, campaign: SPCampaign?, idfaStatus: SPIDFAStatus?) {
        guard let consent = consent, campaign != nil else { return nil }
        applies = consent.applies
        dateCreated = consent.dateCreated
        uuid = consent.uuid
        self.idfaStatus = idfaStatus
    }
}

extension ConsentStatusMetaData.USNatCampaign {
    init?(
        _ consent: CampaignConsent?,
        campaign: SPCampaign?,
        idfaStatus: SPIDFAStatus?,
        dateCreated: SPDate?,
        optedOut: Bool?
    ) {
        guard let consent = consent, let campaign = campaign else { return nil }
        applies = consent.applies
        uuid = consent.uuid
        transitionCCPAAuth = campaign.transitionCCPAAuth
        self.dateCreated = dateCreated
        self.optedOut = optedOut
        self.idfaStatus = idfaStatus
    }
}
