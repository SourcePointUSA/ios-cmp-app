//
//  PropertyDetails+CoreDataProperties.swift
//  
//
//  Created by Vilas on 2/10/20.
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
    @NSManaged public var campaign: Int64
    @NSManaged public var creationTimestamp: Date?
    @NSManaged public var privacyManagerId: String?
    @NSManaged public var propertyName: String?
    @NSManaged public var propertyId: Int64
    @NSManaged public var manyTargetingParams: NSSet?

}

// MARK: Generated accessors for manyTargetingParams
extension PropertyDetails {

    @objc(addManyTargetingParamsObject:)
    @NSManaged public func addToManyTargetingParams(_ value: TargetingParams)

    @objc(removeManyTargetingParamsObject:)
    @NSManaged public func removeFromManyTargetingParams(_ value: TargetingParams)

    @objc(addManyTargetingParams:)
    @NSManaged public func addToManyTargetingParams(_ values: NSSet)

    @objc(removeManyTargetingParams:)
    @NSManaged public func removeFromManyTargetingParams(_ values: NSSet)

}
