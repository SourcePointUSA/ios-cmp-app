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

    /// It holds property Id.
    let propertyId: Int64

    /// It holds campaign value
    let campaign: Int64

    /// It holds native message value
    let nativeMessage: Int64

    /// It holds privacy manager Id
    let privacyManagerId: String?

    /// It holds property addded timestamp
    let creationTimestamp: Date

    /// It holds auth Id value
    let authId: String?

    /// It holds message language value
    let messageLanguage: String?

    // MARK: - Initializers

    /// Data Model creation.
    ///
    /// - Parameters:
    ///   - accountId : Customer accountId
    ///   - propertyId : propertyId
    ///   - property: propertyName.
    ///   - campaign: stage/public.
    ///   - privacyManagerId: privacyManagerId which is associated with the property
    ///   - creationTimestamp: property added in database time
    init(accountId: Int64, propertyId: Int64, propertyName: String?, campaign: Int64, privacyManagerId: String?, creationTimestamp: Date, authId: String?, nativeMessage: Int64, messageLanguage: String?) {
        self.accountId = accountId
        self.propertyId = propertyId
        self.propertyName = propertyName
        self.campaign = campaign
        self.privacyManagerId = privacyManagerId
        self.creationTimestamp = creationTimestamp
        self.authId = authId
        self.nativeMessage = nativeMessage
        self.messageLanguage = messageLanguage
    }
}
