//
//  PropertyDetailsModel.swift
//  SourcepointMetaApp
//
//  Created by Vilas on 23/03/19.
//  Copyright © 2019 Cybage. All rights reserved.
//

import Foundation

struct PropertyDetailsModel {
    
    //// MARK: - Instance properties
    
    /// It holds property name
    let property : String?
    
    /// It holds account Id.
    let accountId: Int64
    
    /// It holds property Id.
    let propertyId: Int64
    
    /// It holds campaign value
    let campaign : String
    
    /// It holds privacy manager Id
    let privacyManagerId : String?
    
    /// It holds show PM value
    let showPM : Bool
    
    /// It holds property addded timestamp
    let creationTimestamp : Date
    
    /// It holds auth Id value
    let authId : String?
    
    //// MARK: - Initializers
    
    /// Data Model creation.
    ///
    /// - Parameters:
    ///   - accountId : Customer accountId
    ///   - propertyId : propertyId
    ///   - property: property.
    ///   - campaign: stage/public.
    ///   - privacyManagerId: privacyManagerId which is associated with the property
    ///   - creationTimestamp: property added in database time
    ///   - showPM: whether we have to show message or PM
    init(accountId:Int64, propertyId: Int64, property: String?, campaign: String, privacyManagerId:String?, showPM: Bool, creationTimestamp: Date, authId: String? ) {
        self.accountId = accountId
        self.propertyId = propertyId
        self.property = property
        self.campaign = campaign
        self.privacyManagerId = privacyManagerId
        self.showPM = showPM
        self.creationTimestamp = creationTimestamp
        self.authId = authId
    }
}
