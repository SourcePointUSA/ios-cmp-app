//
//  WebsiteDetails.swift
//  SourcepointMetaApp
//
//  Created by Vilas on 23/03/19.
//  Copyright © 2019 Cybage. All rights reserved.
//

import Foundation

struct WebsiteDetailsModel {
    
    //// MARK: - Instance properties
    
    /// It holds website name
    let websiteName : String?
    
    /// It holds account ID.
    let accountID: Int64
    
    
    /// It holds website addded timestamp
    let creationTimestamp : NSDate?
    
    
    /// It holds info about staging or not
    let isStaging : Bool
    

    //// MARK: - Initializers
    
    
    /// Data Model creation.
    ///
    /// - Parameters:
    ///   - websiteName: website name.
    ///   - accountId: Custoemr account ID.
    ///   - creationTimestamp: website added in database time
    ///   - isStaging: whether the website is staging or public.
    
    init(websiteName wName : String?, accountID accountAddress : Int64,
         creationTimestamp timestamp : NSDate?, isStaging isstaging: Bool) {
        websiteName = wName
        accountID = accountAddress
        creationTimestamp = timestamp
        isStaging = isstaging
    }
}
