//
//  PropertyDetails+CoreDataClass.swift
//  
//
//  Created by Vilas on 11/19/19.
//
//

import Foundation
import CoreData

@objc(PropertyDetails)
public class PropertyDetails: NSManagedObject {
    class var entityName : String {
        return "PropertyDetails"
    }
}
