//
//  WebsiteDetailsStorageCoordinatorTest.swift
//  SourcePointMetaAppTests
//
//  Created by Vilas on 4/29/19.
//  Copyright © 2019 Cybage. All rights reserved.
//

import XCTest
import CoreData
@testable import SourcePointMetaApp

class WebsiteDetailsStorageCoordinatorTest: XCTestCase {
    
    var siteDetailsStorageCoordinator = WebsiteDetailsStorageCoordinator()
    // Will add all the targeting params to this array
    var targetingParamsArray = [TargetingParamModel]()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // This method is used to test whether all site data can be fetched from database or not.
    func testFetchAllWebsites() {
        siteDetailsStorageCoordinator.fetchAllSites(executionCompletionHandler: { (_allSites) in
            XCTAssertNotNil(_allSites, "unable to fetch the site data")
        })
    }
    
    // This method is used to test whether site data can be fetched from database or not.
    func testfetchSiteData() {
        siteDetailsStorageCoordinator.managedObjectID(completionHandler: {(managedObjectID) in
            if (managedObjectID.entity.name != nil) {
                self.siteDetailsStorageCoordinator.fetch(site: managedObjectID, completionHandler: { ( siteDataDetailsModel) in
                    XCTAssertNotNil(siteDataDetailsModel, "unable to find out stored data")
                })
            }
        })
    }
    
    // This method is used to test whether managed object ID can be fetched from database or not.
    func testfetchManagedObjectID() {
        siteDetailsStorageCoordinator.managedObjectID(completionHandler: {(managedObjectID) in
            XCTAssertNotNil(managedObjectID, "unable to find out stored managedObjectID data")
        })
    }
    
    
    // This test method is used to test whether the website data added or not to database.
    func testAddWebsite() {
        let siteDataModel = SiteDetailsModel(accountId: 22, siteId: 2372, siteName: "mobile.demo", campaign: "stage", privacyManagerId: "5c0e81b7d74b3c30c6852301", showPM: false, creationTimestamp: Date(), authId: nil)
        siteDetailsStorageCoordinator.add(siteDetails: siteDataModel, targetingParams: targetingParamsArray, completionHandler: { (siteManagedObjectID, siteStoredStatus) in
            
            if siteStoredStatus {
                XCTAssert(true, "successfully stored data to database")
            } else {
                XCTAssert(false, "failed to store data to database")
            }
        })
    }
    
    // This test method is used to test whether the website data updated or not to database.
    func testUpdateSiteData() {
        let siteDataModel = SiteDetailsModel(accountId: 22, siteId: 2372, siteName: "mobile.demo", campaign: "stage", privacyManagerId: "5c0e81b7d74b3c30c6852301", showPM: false, creationTimestamp: Date(), authId: nil)
        siteDetailsStorageCoordinator.add(siteDetails: siteDataModel, targetingParams: targetingParamsArray, completionHandler: { (siteManagedObjectID, siteStoredStatus) in
            if let managedObjectID = siteManagedObjectID {
                self.targetingParamsArray.removeAll()
                let targetingParamModel = TargetingParamModel(targetingParamKey: "MyPrivacyManager", targetingParamValue: "true")
                self.targetingParamsArray.append(targetingParamModel)
                self.siteDetailsStorageCoordinator.update(siteDetails: siteDataModel, targetingParams: self.targetingParamsArray, whereManagedObjectID: managedObjectID, completionHandler: {(managedObject, updateStatus) in
                    if updateStatus {
                        XCTAssert(true, "successfully updated the site data to database")
                    } else {
                        XCTAssert(false, "failed to update the site data to database")
                    }
                })
            }
        })
    }
    
    // This test method is used to test whether the website data deleted from database or not.
    func testDeleteSiteData() {
        siteDetailsStorageCoordinator.delete(site: NSManagedObject.init(), completionHandler: {(deleteStatus) in
            if deleteStatus {
                XCTAssert(true, "successfully deleted the site data from database")
            } else {
                XCTAssert(false, "failed to delete the site data from database")
            }
        })
    }
    
    // This method is used to test whether the site data already exist in database or not
    func testcheckExitanceOfData() {
        let siteDataModel = SiteDetailsModel(accountId: 22, siteId: 2372, siteName: "mobile.demo", campaign: "stage", privacyManagerId: "5c0e81b7d74b3c30c6852301", showPM: false, creationTimestamp: Date(), authId: nil)
        siteDetailsStorageCoordinator.add(siteDetails: siteDataModel, targetingParams: targetingParamsArray, completionHandler: { (siteManagedObjectID, siteStoredStatus) in
            
            self.siteDetailsStorageCoordinator.checkExitanceOfData(siteDetails: siteDataModel, targetingParams: self.targetingParamsArray , completionHandler: { (isStored) in
                print(isStored)
                if isStored {
                    XCTAssert(true, "Site data present in database")
                } else {
                    XCTAssert(false, "Site data is not present in database")
                }
            })
        })
    }
}
