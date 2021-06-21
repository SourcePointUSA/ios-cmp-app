//
//  CampaignDetails+CoreDataProperties.swift
//  
//
//  Created by Vilas on 17/06/21.
//
//

import Foundation
import CoreData


extension CampaignDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CampaignDetails> {
        return NSFetchRequest<CampaignDetails>(entityName: "CampaignDetails")
    }

    @NSManaged public var campaignName: String?
    @NSManaged public var campaignEnv: Int64
    @NSManaged public var pmID: String?
    @NSManaged public var pmTab: String?
    @NSManaged public var propertyDetails: PropertyDetails?
    @NSManaged public var manyTargetingParams: NSSet?

}

// MARK: Generated accessors for manyTargetingParams
extension CampaignDetails {

    @objc(addManyTargetingParamsObject:)
    @NSManaged public func addToManyTargetingParams(_ value: TargetingParams)

    @objc(removeManyTargetingParamsObject:)
    @NSManaged public func removeFromManyTargetingParams(_ value: TargetingParams)

    @objc(addManyTargetingParams:)
    @NSManaged public func addToManyTargetingParams(_ values: NSSet)

    @objc(removeManyTargetingParams:)
    @NSManaged public func removeFromManyTargetingParams(_ values: NSSet)

}
