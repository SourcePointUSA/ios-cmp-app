//
//  WebsiteDetails.swift
//  SourcepointMetaApp
//
//  Created by Vilas on 23/03/19.
//  Copyright © 2019 Cybage. All rights reserved.
//

import Foundation

struct SiteDetailsModel {
    
    //// MARK: - Instance properties
    
    /// It holds site name
    let siteName : String?
    
    /// It holds account Id.
    let accountId: Int64
    
    /// It holds siteId Id.
    let siteId: Int64
    
    /// It holds campaign value
    let campaign : String
    
    /// It holds privacy manager Id
    let privacyManagerId : String?
    
    /// It holds show PM value
    let showPM : Bool
    
    /// It holds site addded timestamp
    let creationTimestamp : Date
    
    /// It holds site name
    let authId : String?
    
    //// MARK: - Initializers
    
    /// Data Model creation.
    ///
    /// - Parameters:
    ///   - accountId : Customer accountId
    ///   - siteId : siteId
    ///   - siteName: site name.
    ///   - campaign: stage/public.
    ///   - privacyManagerId: privacyManagerId which is associated with the site
    ///   - creationTimestamp: site added in database time
    ///   - showPM: whether we have to show message or PM
    init(accountId:Int64, siteId: Int64, siteName: String?, campaign: String, privacyManagerId:String?, showPM: Bool, creationTimestamp: Date, authId: String? ) {
        self.accountId = accountId
        self.siteId = siteId
        self.siteName = siteName
        self.campaign = campaign
        self.privacyManagerId = privacyManagerId
        self.showPM = showPM
        self.creationTimestamp = creationTimestamp
        self.authId = authId
    }
}
