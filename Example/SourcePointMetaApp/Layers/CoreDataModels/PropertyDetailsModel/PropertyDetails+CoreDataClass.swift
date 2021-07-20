//
//  PropertyDetails+CoreDataClass.swift
//  
//
//  Created by Vilas on 17/06/21.
//
//

import Foundation
import CoreData

@objc(PropertyDetails)
public class PropertyDetails: NSManagedObject {
    class var entityName: String {
        return "PropertyDetails"
    }
}
