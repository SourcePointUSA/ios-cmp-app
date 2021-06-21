//
//  PropertyDetailsModel.swift
//  SourcepointMetaApp
//
//  Created by Vilas on 23/03/19.
//  Copyright © 2019 Cybage. All rights reserved.
//

import Foundation

struct PropertyDetailsModel {

    // MARK: - Instance properties

    /// It holds property name
    let propertyName: String?

    /// It holds account Id.
    let accountId: Int64

    /// It holds property addded timestamp
    let creationTimestamp: Date

    /// It holds auth Id value
    let authId: String?

    /// It holds message language value
    let messageLanguage: String?

    let campaignDetails: [CampaignModel]?

    // MARK: - Initializers

    /// Data Model creation.
    ///
    /// - Parameters:
    ///   - accountId : Customer accountId
    ///   - property: propertyName.
    ///   - campaign: stage/public.
    ///   - creationTimestamp: property added in database time
    init(accountId: Int64, propertyName: String?, creationTimestamp: Date, authId: String?, messageLanguage: String?, campaignDetails: [CampaignModel]?) {
        self.accountId = accountId
        self.propertyName = propertyName
        self.creationTimestamp = creationTimestamp
        self.authId = authId
        self.messageLanguage = messageLanguage
        self.campaignDetails = campaignDetails
    }
}
