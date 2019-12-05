//
//  AddPropertyViewModelTest.swift
//  SourcePointMetaAppTests
//
//  Created by Vilas on 25/04/19.
//  Copyright © 2019 Cybage. All rights reserved.
//

import XCTest
import CoreData
import ConsentViewController
@testable import SourcePointMetaApp

class AddPropertyViewModelTest: XCTestCase {
    
    
    // Will add all the targeting params to this array
    var targetingParamsArray = [TargetingParamModel]()
    var addPropertyViewModel: AddPropertyViewModel?
    var accountId: Int = 0
    var propertyId: Int = 0
    var property: String = ""
    var campaign: String = ""
    var pmId: String = ""
    var showPM: Bool = false
    var authId: String = ""
    
    override func setUp() {
        addPropertyViewModel = AddPropertyViewModel()
        readDataFromPlist()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    /// this method is used to read the data from plist
    func readDataFromPlist() {
        if let path = Bundle(for: type(of: self)).path(forResource: "TestData", ofType: "plist") {
            let testData = NSDictionary(contentsOfFile: path)
            accountId = testData?.value(forKey: "AccountId") as! Int
            propertyId = testData?.value(forKey: "PropertyId") as! Int
            property = testData?.value(forKey: "Property") as! String
            campaign = testData?.value(forKey: "Campaign") as! String
            pmId = testData?.value(forKey: "PMId") as! String
            showPM = testData?.value(forKey: "ShowPM") as! Bool
            authId = testData?.value(forKey: "AuthId") as! String
        }
    }
    
    // This test method is used to test whether the property data added or not to database.
    func testAddproperty() {
        let propertyDataModel = PropertyDetailsModel(accountId: Int64(accountId), propertyId: Int64(propertyId), property: property, campaign: campaign, privacyManagerId: pmId, showPM: showPM, creationTimestamp: Date(), authId: nil)
        addPropertyViewModel?.addproperty(propertyDetails: propertyDataModel, targetingParams: targetingParamsArray, completionHandler: { (error, _,propertyManagedObjectID) in
            if error != nil {
                XCTAssert(false, "failed to store data to database")
            } else {
                XCTAssert(true, "successfully stored data to database")
            }
        })
    }
    
    // This method is used to test whether the property data already exist in database or not
    func testCheckExitanceOfData() {
        let propertyDataModel = PropertyDetailsModel(accountId: Int64(accountId), propertyId: Int64(propertyId), property: property, campaign: campaign, privacyManagerId: pmId, showPM: showPM, creationTimestamp: Date(), authId: nil)
        addPropertyViewModel?.checkExitanceOfData(propertyDetails: propertyDataModel, targetingParams: targetingParamsArray , completionHandler: { (isStored) in
            if isStored {
                XCTAssert(true, "property data present in database")
            }else {
                XCTAssert(false, "property data is not present in database")
            }
        })
    }
    
    // This method is used to test whether all property data can be fetched from database or not.
    func testfetchSitData() {
        let propertyListViewModel = PropertyListViewModel()
        propertyListViewModel.importAllproperties(executionCompletionHandler: { properties in
            if properties!.count > 0 {
                let managedObjectID = propertyListViewModel.propertyManagedObjectID(atIndex: 0)
                if (managedObjectID != nil) {
                    self.addPropertyViewModel?.fetch(property: managedObjectID!, completionHandler: { ( propertyDataDetailsModel) in
                        XCTAssertNotNil(propertyDataDetailsModel, "unable to find out stored data")
                    })
                }else {
                    XCTAssert(false, "failed to load property details")
                }
            }
        })
        
    }
    
    // This method is used to test whether the property data updated or not in database
    func testUpdatepropertyData() {
        let propertyDataModel = PropertyDetailsModel(accountId: Int64(accountId), propertyId: Int64(propertyId), property: property, campaign: campaign, privacyManagerId: pmId, showPM: showPM, creationTimestamp: Date(), authId: nil)
        let propertyListViewModel = PropertyListViewModel()
        propertyListViewModel.importAllproperties(executionCompletionHandler: { properties in
            if properties!.count > 0 {
                let managedObjectID = propertyListViewModel.propertyManagedObjectID(atIndex: 0)
                if (managedObjectID != nil) {
                    self.addPropertyViewModel?.update(propertyDetails: propertyDataModel, targetingParams: self.targetingParamsArray, whereManagedObjectID: managedObjectID!, completionHandler: { (optionalpropertyManagedObjectID, executionStatus) in
                        if executionStatus {
                            XCTAssert(true, "webview data updated successfully")
                        } else {
                            XCTAssert(false, "failed to update property data")
                        }
                    })
                }
            }
        })
    }
    
    // This method is used to validate the property details
    func testValidatepropertyDetails() {
        let validationResult = addPropertyViewModel?.validatepropertyDetails(accountID: "\(accountId)", propertyId: "\(propertyId)", property: property, privacyManagerId: pmId)
        if validationResult! {
            XCTAssert(true, "property data validated successfully")
        } else {
            XCTAssert(false, "failed to validate property")
        }
    }
    
    // This method is used to validate the empty the property data case
    func testValidatWithEmptyepropertyDetails() {
        let validationResult = addPropertyViewModel?.validatepropertyDetails(accountID: "", propertyId: "", property: "", privacyManagerId: "")
        if validationResult! {
            XCTAssert(false, "failed to validate property")
        } else {
            XCTAssert(true, "property data validated successfully")
        }
    }
    
    func testClearUserDefaultsData() {
        addPropertyViewModel?.clearUserDefaultsData()
        let consentUUID = UserDefaults.standard.string(forKey: "consentUUID")
        
        if (consentUUID == nil ) {
            XCTAssert(true, "UserDefaultData is cleared successfully")
        } else {
            XCTAssert(false, "UserDefaultData is not cleared successfully")
        }
    }
}
