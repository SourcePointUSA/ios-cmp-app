//
//  SiteDetails+CoreDataProperties.swift
//  
//
//  Created by Vilas on 10/19/19.
//
//

import Foundation
import CoreData


extension SiteDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SiteDetails> {
        return NSFetchRequest<SiteDetails>(entityName: "SiteDetails")
    }

    @NSManaged public var siteName: String?
    @NSManaged public var accountId: Int64
    @NSManaged public var siteId: Int64
    @NSManaged public var campaign: String?
    @NSManaged public var privacyManagerId: String?
    @NSManaged public var showPM: Bool
    @NSManaged public var creationTimestamp: Date?
    @NSManaged public var authId: String?
    @NSManaged public var manyTargetingParams: NSSet?

}

// MARK: Generated accessors for manyTargetingParams
extension SiteDetails {

    @objc(addManyTargetingParamsObject:)
    @NSManaged public func addToManyTargetingParams(_ value: TargetingParams)

    @objc(removeManyTargetingParamsObject:)
    @NSManaged public func removeFromManyTargetingParams(_ value: TargetingParams)

    @objc(addManyTargetingParams:)
    @NSManaged public func addToManyTargetingParams(_ values: NSSet)

    @objc(removeManyTargetingParams:)
    @NSManaged public func removeFromManyTargetingParams(_ values: NSSet)

}
