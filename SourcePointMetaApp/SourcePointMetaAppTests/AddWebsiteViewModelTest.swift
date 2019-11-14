//
//  AddWebsiteViewModelTest.swift
//  SourcePointMetaAppTests
//
//  Created by Vilas on 25/04/19.
//  Copyright © 2019 Cybage. All rights reserved.
//

import XCTest
import CoreData
import ConsentViewController
@testable import SourcePointMetaApp

class AddWebsiteViewModelTest: XCTestCase {
    
    
    // Will add all the targeting params to this array
    var targetingParamsArray = [TargetingParamModel]()
    var addSiteViewModel: AddWebsiteViewModel?
    
    override func setUp() {
        addSiteViewModel = AddWebsiteViewModel()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // This test method is used to test whether the site data added or not to database.
    func testAddSite() {
        let siteDataModel = SiteDetailsModel(accountId: 22, siteId: 2372, siteName: "mobile.demo", campaign: "stage", privacyManagerId: "5c0e81b7d74b3c30c6852301", showPM: false, creationTimestamp: Date(), authId: nil)
        addSiteViewModel?.addSite(siteDetails: siteDataModel, targetingParams: targetingParamsArray, completionHandler: { (error, _,siteManagedObjectID) in
            if error != nil {
                XCTAssert(false, "failed to store data to database")
            } else {
                XCTAssert(true, "successfully stored data to database")
            }
        })
    }
    
    // This method is used to test whether the site data already exist in database or not
    func testcheckExitanceOfData() {
        let siteDataModel = SiteDetailsModel(accountId: 22, siteId: 2372, siteName: "mobile.demo", campaign: "stage", privacyManagerId: "5c0e81b7d74b3c30c6852301", showPM: false, creationTimestamp: Date(), authId: nil)
        addSiteViewModel?.checkExitanceOfData(siteDetails: siteDataModel, targetingParams: targetingParamsArray , completionHandler: { (isStored) in
            if isStored {
                XCTAssert(true, "Site data present in database")
            }else {
                XCTAssert(false, "Site data is not present in database")
            }
        })
    }
    
//    // This method is used to test whether the webview is loaded or not
//    func testBuildConsentViewController() {
//        let siteDataModel = SiteDetailsModel(accountId: 22, siteId: 2372, siteName: "mobile.demo", campaign: "stage", privacyManagerId: "5c0e81b7d74b3c30c6852301", showPM: false, creationTimestamp: Date(), authId: nil)
//        addSiteViewModel?.buildConsentViewController(websiteDetails: siteDataModel, targetingParams: targetingParamsArray, completionHandler: {(error, consentViewController, dismissControllerStatus, vendorConsent, purposeConsents)  in
//
//            if error != nil {
//                XCTAssert(false, "failed to load webview")
//            } else {
//                XCTAssert(true, "webview is loaded successfully")
//            }
//        })
//    }
    
    // This method is used to test whether all site data can be fetched from database or not.
    func testfetchSitData() {
        let siteListViewModel = WebsiteListViewModel()
        siteListViewModel.importAllSites(executionCompletionHandler: { sites in
            if sites!.count > 0 {
                let managedObjectID = siteListViewModel.siteManagedObjectID(atIndex: 0)
                if (managedObjectID != nil) {
                    self.addSiteViewModel?.fetch(site: managedObjectID!, completionHandler: { ( siteDataDetailsModel) in
                        XCTAssertNotNil(siteDataDetailsModel, "unable to find out stored data")
                    })
                }else {
                    XCTAssert(false, "failed to load site details")
                }
            }
        })
        
    }
    
    // This method is used to test whether the site data updated or not in database
    func testUpdateSiteData() {
        let siteDataModel = SiteDetailsModel(accountId: 22, siteId: 2372, siteName: "mobile.demo", campaign: "stage", privacyManagerId: "5c0e81b7d74b3c30c6852301", showPM: false, creationTimestamp: Date(), authId: nil)
        let siteListViewModel = WebsiteListViewModel()
        siteListViewModel.importAllSites(executionCompletionHandler: { sites in
            if sites!.count > 0 {
                let managedObjectID = siteListViewModel.siteManagedObjectID(atIndex: 0)
                if (managedObjectID != nil) {
                    self.addSiteViewModel?.update(siteDetails: siteDataModel, targetingParams: self.targetingParamsArray, whereManagedObjectID: managedObjectID!, completionHandler: { (optionalSiteManagedObjectID, executionStatus) in
                        if executionStatus {
                            XCTAssert(true, "webview data updated successfully")
                        } else {
                            XCTAssert(false, "failed to update site data")
                        }
                    })
                }
            }
        })
    }
    
    // This method is used to validate the site details
    func testValidateSiteDetails() {
        let validationResult = addSiteViewModel?.validateSiteDetails(accountID: "22", siteId: "2372", siteName: "mobile.demo", privacyManagerId: "5c0e81b7d74b3c30c6852301")
        if validationResult! {
            XCTAssert(true, "site data validated successfully")
        } else {
            XCTAssert(false, "failed to validate site")
        }
    }
    
    // This method is used to validate the empty the site data case
    func testValidatWithEmptyeSiteDetails() {
        let validationResult = addSiteViewModel?.validateSiteDetails(accountID: "", siteId: "", siteName: "", privacyManagerId: "")
        if validationResult! {
            XCTAssert(false, "failed to validate site")
        } else {
            XCTAssert(true, "site data validated successfully")
        }
    }
    
    func testClearUserDefaultsData() {
        addSiteViewModel?.clearUserDefaultsData()
        let consentUUID = UserDefaults.standard.string(forKey: "consentUUID")
        
        if (consentUUID?.count ?? 0 == 0) {
            XCTAssert(true, "UserDefaultData is cleared successfully")
        } else {
            XCTAssert(false, "UserDefaultData is not cleared successfully")
        }
    }
}
