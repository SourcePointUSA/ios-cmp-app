//
//  WebsiteDetails+CoreDataProperties.swift
//  
//
//  Created by Vilas on 5/27/19.
//
//

import Foundation
import CoreData


extension WebsiteDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WebsiteDetails> {
        return NSFetchRequest<WebsiteDetails>(entityName: "WebsiteDetails")
    }

    @NSManaged public var accountID: Int64
    @NSManaged public var creationTimestamp: NSDate?
    @NSManaged public var isStaging: Bool
    @NSManaged public var websiteName: String?
    @NSManaged public var manyTargetingParams: NSSet?

}

// MARK: Generated accessors for manyTargetingParams
extension WebsiteDetails {

    @objc(addManyTargetingParamsObject:)
    @NSManaged public func addToManyTargetingParams(_ value: TargetingParams)

    @objc(removeManyTargetingParamsObject:)
    @NSManaged public func removeFromManyTargetingParams(_ value: TargetingParams)

    @objc(addManyTargetingParams:)
    @NSManaged public func addToManyTargetingParams(_ values: NSSet)

    @objc(removeManyTargetingParams:)
    @NSManaged public func removeFromManyTargetingParams(_ values: NSSet)

}
