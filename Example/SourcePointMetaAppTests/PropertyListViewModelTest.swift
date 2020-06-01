//
//  PropertyListViewModelTest.swift
//  SourcePointMetaAppTests
//
//  Created by Vilas on 4/25/19.
//  Copyright © 2019 Cybage. All rights reserved.
//

import XCTest
@testable import GDPR_MetaApp

class PropertyListViewModelTest: XCTestCase {
    
    var propertyListViewModel: PropertyListViewModel?
    
    override func setUp() {
        propertyListViewModel = PropertyListViewModel()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // This method is used to test whether all property data can be fetched from database or not.
    func testFetchAllSitData() {
        propertyListViewModel?.importAllproperties(executionCompletionHandler: {(properties) in
            XCTAssertNotNil(properties, "unable to fetch the property data")
        })
    }
    
    // This method checks how many property data is stored in database
    func testNumberOfPropertyDataStored() {
        propertyListViewModel?.importAllproperties(executionCompletionHandler: { (properties) in
            let propertyCount = self.propertyListViewModel?.numberOfproperties()
            XCTAssertNotNil(propertyCount, "unable to find out stored data")
        })
    }
    
    // This method check the property name
    func testPropertyName() {
        propertyListViewModel?.importAllproperties(executionCompletionHandler: { (properties) in
            if let _properties = properties, _properties.count > 0 {
                XCTAssertNotNil(_properties[0].propertyName, "Error property name is not available")
            }
        })
    }
    
    // This method checks whether the managedObject ID is available or not.
    func testPropertyManagedObjectID() {
        propertyListViewModel?.importAllproperties(executionCompletionHandler: { (properties) in
            if let _properties = properties, _properties.count > 0 {
                XCTAssertNotNil(_properties[0].objectID, "Error managedObject ID is not available")
            }
        })
    }
    
    func testClearUserDefaultsData() {
        propertyListViewModel?.clearUserDefaultsData()
        let consentUUID = UserDefaults.standard.string(forKey: "consentUUID")
        
        if (consentUUID?.count ?? 0 == 0) {
            XCTAssert(true, "UserDefaultData is cleared successfully")
        } else {
            XCTAssert(false, "UserDefaultData is not cleared successfully")
        }
    }
}
