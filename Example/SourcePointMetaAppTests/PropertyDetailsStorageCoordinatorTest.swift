//
//  PropertyDetailsStorageCoordinatorTest.swift
//  SourcePointMetaAppTests
//
//  Created by Vilas on 4/29/19.
//  Copyright © 2019 Cybage. All rights reserved.
//

import XCTest
import CoreData
@testable import GDPR_MetaApp

class PropertyDetailsStorageCoordinatorTest: XCTestCase {

    var propertyDetailsStorageCoordinator = PropertyDetailsStorageCoordinator()
    // Will add all the targeting params to this array
    var targetingParamsArray = [TargetingParamModel]()

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    // This method is used to test whether all property data can be fetched from database or not.
    func testFetchAllWebproperties() {
        propertyDetailsStorageCoordinator.fetchAllproperties(executionCompletionHandler: { (_allproperties) in
            XCTAssertNotNil(_allproperties, "unable to fetch the property data")
        })
    }

    // This method is used to test whether property data can be fetched from database or not.
    func testfetchpropertyData() {
        propertyDetailsStorageCoordinator.managedObjectID(completionHandler: {(managedObjectID) in
            if managedObjectID.entity.name != nil {
                self.propertyDetailsStorageCoordinator.fetch(property: managedObjectID, completionHandler: { ( propertyDataDetailsModel) in
                    XCTAssertNotNil(propertyDataDetailsModel, "unable to find out stored data")
                })
            }
        })
    }

    // This method is used to test whether managed object ID can be fetched from database or not.
    func testfetchManagedObjectID() {
        propertyDetailsStorageCoordinator.managedObjectID(completionHandler: {(managedObjectID) in
            XCTAssertNotNil(managedObjectID, "unable to find out stored managedObjectID data")
        })
    }

    // This test method is used to test whether the property data added or not to database.
    func testAddWebproperty() {
        let propertyDataModel = PropertyDetailsModel(accountId: 22, propertyId: 2372, propertyName: "mobile.demo", campaign: 0, privacyManagerId: "5c0e81b7d74b3c30c6852301", creationTimestamp: Date(), authId: nil)
        propertyDetailsStorageCoordinator.add(propertyDetails: propertyDataModel, targetingParams: targetingParamsArray, completionHandler: { (_, propertiestoredStatus) in

            if propertiestoredStatus {
                XCTAssert(true, "successfully stored data to database")
            } else {
                XCTAssert(false, "failed to store data to database")
            }
        })
    }

    // This test method is used to test whether the property data updated or not to database.
    func testUpdatepropertyData() {
        let propertyDataModel = PropertyDetailsModel(accountId: 22, propertyId: 2372, propertyName: "mobile.demo", campaign: 0, privacyManagerId: "5c0e81b7d74b3c30c6852301", creationTimestamp: Date(), authId: nil)
        propertyDetailsStorageCoordinator.add(propertyDetails: propertyDataModel, targetingParams: targetingParamsArray, completionHandler: { (propertyManagedObjectID, _) in
            if let managedObjectID = propertyManagedObjectID {
                self.targetingParamsArray.removeAll()
                let targetingParamModel = TargetingParamModel(targetingParamKey: "MyPrivacyManager", targetingParamValue: "true")
                self.targetingParamsArray.append(targetingParamModel)
                self.propertyDetailsStorageCoordinator.update(propertyDetails: propertyDataModel, targetingParams: self.targetingParamsArray, whereManagedObjectID: managedObjectID, completionHandler: {(_, updateStatus) in
                    if updateStatus {
                        XCTAssert(true, "successfully updated the property data to database")
                    } else {
                        XCTAssert(false, "failed to update the property data to database")
                    }
                })
            }
        })
    }

    // This test method is used to test whether the webproperty data deleted from database or not.
//    func testDeletepropertyData() {
//        propertyDetailsStorageCoordinator.delete(property: NSManagedObject.init(), completionHandler: {(deleteStatus) in
//            if deleteStatus {
//                XCTAssert(true, "successfully deleted the property data from database")
//            } else {
//                XCTAssert(false, "failed to delete the property data from database")
//            }
//        })
//    }

/// TODO - update for quick/nimble frameworks
//    // This method is used to test whether the property data already exist in database or not
//    func testcheckExitanceOfData() {
//        let propertyDataModel = PropertyDetailsModel(accountId: 22, propertyId: 2372, propertyName: "mobile.demo", campaign: 0, privacyManagerId: "5c0e81b7d74b3c30c6852301", creationTimestamp: Date(), authId: nil)
//        propertyDetailsStorageCoordinator.add(propertyDetails: propertyDataModel, targetingParams: targetingParamsArray, completionHandler: { (propertyManagedObjectID, propertiestoredStatus) in
//
//            self.propertyDetailsStorageCoordinator.checkExitanceOfData(propertyDetails: propertyDataModel, targetingParams: self.targetingParamsArray , completionHandler: { (isStored) in
//                print(isStored)
//                if isStored {
//                    XCTAssert(true, "property data present in database")
//                } else {
//                    XCTAssert(false, "property data is not present in database")
//                }
//            })
//        })
//    }
}
