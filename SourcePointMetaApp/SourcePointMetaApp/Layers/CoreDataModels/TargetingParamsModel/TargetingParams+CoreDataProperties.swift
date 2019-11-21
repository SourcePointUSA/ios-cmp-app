//
//  TargetingParams+CoreDataProperties.swift
//  
//
//  Created by Vilas on 11/19/19.
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
    @NSManaged public var propertyDetails: PropertyDetails?

}
