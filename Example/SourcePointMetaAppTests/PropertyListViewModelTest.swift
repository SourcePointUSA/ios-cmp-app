//
//  PropertyListViewModelTest.swift
//  SourcePointMetaAppTests
//
//  Created by Vilas on 4/25/19.
//  Copyright © 2019 Cybage. All rights reserved.
//

import XCTest
@testable import SourcePointMetaApp

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
                XCTAssertNotNil(_properties[0].property, "Error property name is not available")
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
    
    // This test method checks whether the property will be deleted or not.
    func testDeleteProperty() {
        let propertyDeletionExpectation = expectation(description: "successfully deleted property data from database")
        propertyListViewModel?.importAllproperties(executionCompletionHandler: { (properties) in
            if properties?.count ?? 0 > 0 {
                self.propertyListViewModel?.delete(atIndex: 0, completionHandler: { (deleteStatus, error) in
                    if error != nil {
                        XCTAssert(false, "failed to delete property data from database")
                    } else {
                        XCTAssert(true, "successfully deleted property data from database")
                    }
                })
            }else{
                XCTAssert(false, "failed to delete property data from database")
                propertyDeletionExpectation.fulfill()
            }
        })
        waitForExpectations(timeout: 1, handler: nil)
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
    
    func testPropertyDetails() {
        let propertyDetailsExpectation = expectation(description: "property details are present")
        propertyListViewModel?.importAllproperties(executionCompletionHandler: { (properties) in
            if properties?.count ?? 0 > 0 {
            let propertyDetails = self.propertyListViewModel?.propertyDetails(atIndex: 0)
            if ((propertyDetails?.0?.accountId) != nil) {
                XCTAssert(true, "property details are present")
            }else {
                 XCTAssert(false, "property details are not present")
            }
            }else {
                XCTAssert(false, "property details are not present")
                propertyDetailsExpectation.fulfill()
            }
        })
        waitForExpectations(timeout: 1, handler: nil)
    }
}
