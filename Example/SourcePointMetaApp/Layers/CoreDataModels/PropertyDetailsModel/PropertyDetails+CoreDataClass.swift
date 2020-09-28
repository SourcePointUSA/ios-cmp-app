//
//  PropertyDetails+CoreDataClass.swift
//  
//
//  Created by Vilas on 22/09/20.
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
