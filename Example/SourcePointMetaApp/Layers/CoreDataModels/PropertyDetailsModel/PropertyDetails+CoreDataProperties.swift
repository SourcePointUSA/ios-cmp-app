//
//  PropertyDetails+CoreDataProperties.swift
//  
//
//  Created by Vilas on 17/06/21.
//
//

import Foundation
import CoreData


extension PropertyDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PropertyDetails> {
        return NSFetchRequest<PropertyDetails>(entityName: "PropertyDetails")
    }

    @NSManaged public var accountId: Int64
    @NSManaged public var authId: String?
    @NSManaged public var creationTimestamp: Date?
    @NSManaged public var messageLanguage: String?
    @NSManaged public var propertyName: String?
    @NSManaged public var campaignEnv: Int64
    @NSManaged public var manyCampaigns: NSSet?

}

// MARK: Generated accessors for manyCampaigns
extension PropertyDetails {

    @objc(addManyCampaignsObject:)
    @NSManaged public func addToManyCampaigns(_ value: CampaignDetails)

    @objc(removeManyCampaignsObject:)
    @NSManaged public func removeFromManyCampaigns(_ value: CampaignDetails)

    @objc(addManyCampaigns:)
    @NSManaged public func addToManyCampaigns(_ values: NSSet)

    @objc(removeManyCampaigns:)
    @NSManaged public func removeFromManyCampaigns(_ values: NSSet)

}
