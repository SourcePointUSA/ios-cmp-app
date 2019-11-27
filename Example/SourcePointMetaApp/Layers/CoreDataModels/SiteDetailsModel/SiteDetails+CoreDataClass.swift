//
//  SiteDetails+CoreDataClass.swift
//  
//
//  Created by Vilas on 10/19/19.
//
//

import Foundation
import CoreData

@objc(SiteDetails)
public class SiteDetails: NSManagedObject {
    class var entityName : String {
        return "SiteDetails"
    }
}
