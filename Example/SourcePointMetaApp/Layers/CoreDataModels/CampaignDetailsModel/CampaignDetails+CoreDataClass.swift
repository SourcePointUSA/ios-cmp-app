//
//  CampaignDetails+CoreDataClass.swift
//  
//
//  Created by Vilas on 17/06/21.
//
//

import Foundation
import CoreData

@objc(CampaignDetails)
public class CampaignDetails: NSManagedObject {
    class var entityName: String {
        return "CampaignDetails"
    }
}
