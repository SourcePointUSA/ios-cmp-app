//
//  TargetingParams+CoreDataProperties.swift
//  
//
//  Created by Vilas on 17/06/21.
//
//

import Foundation
import CoreData


extension TargetingParams {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TargetingParams> {
        return NSFetchRequest<TargetingParams>(entityName: "TargetingParams")
    }

    @NSManaged public var key: String?
    @NSManaged public var value: String?
    @NSManaged public var campaignDetails: CampaignDetails?

}
