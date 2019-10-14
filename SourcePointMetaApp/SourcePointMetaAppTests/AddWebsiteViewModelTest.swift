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
    
    // This test method is used to test whether the website data added or not to database.
    func testAddWebsite() {
        let websiteDataModel = WebsiteDetailsModel(websiteName: "mobile.demo", accountID: 22, creationTimestamp: NSDate(), isStaging: false)
        let targetingParamModel = TargetingParamModel(targetingParamKey: "MyPrivacyManager", targetingParamValue: "false")
        targetingParamsArray.append(targetingParamModel)
        addSiteViewModel?.addWebsite(websiteDetails: websiteDataModel, targetingParams: targetingParamsArray, completionHandler: { (error, _,websiteManagedObjectID) in
            
            if error != nil {
                XCTAssert(false, "failed to store data to database")
            } else {
                XCTAssert(true, "successfully stored data to database")
            }
        })
    }
    
    // This method is used to test whether the site data already exist in database or not
    func testcheckExitanceOfData() {
        let websiteDataModel = WebsiteDetailsModel(websiteName: "mobile.demo", accountID: 22, creationTimestamp: NSDate(), isStaging: false)
        let targetingParamModel = TargetingParamModel(targetingParamKey: "MyPrivacyManager", targetingParamValue: "false")
        targetingParamsArray.append(targetingParamModel)
        addSiteViewModel?.checkExitanceOfData(websiteDetails: websiteDataModel, targetingParams: targetingParamsArray , completionHandler: { (isStored) in
            if isStored {
                XCTAssert(true, "Site data present in database")
            }else {
                XCTAssert(false, "Site data is not present in database")
            }
        })
    }
    
    // This method is used to test whether the webview is loaded or not
    func testBuildConsentViewController() {
        let websiteDataModel = WebsiteDetailsModel(websiteName: "mobile.demo", accountID: 22, creationTimestamp: NSDate(), isStaging: false)
        let targetingParamModel = TargetingParamModel(targetingParamKey: "MyPrivacyManager", targetingParamValue: "false")
        targetingParamsArray.append(targetingParamModel)
        
        addSiteViewModel?.buildConsentViewController(websiteDetails: websiteDataModel, targetingParams: targetingParamsArray, completionHandler: {(error, consentViewController, dismissControllerStatus, vendorConsent, purposeConsents)  in
            
            if error != nil {
                XCTAssert(false, "failed to load webview")
            } else {
                XCTAssert(true, "webview is loaded successfully")
            }
        })
    }
    
    // This method is used to test whether all site data can be fetched from database or not.
    func testfetchSitData() {
        let siteListViewModel = WebsiteListViewModel()
        siteListViewModel.importAllWebsites(executionCompletionHandler: { sites in
            if sites!.count > 0 {
                let managedObjectID = siteListViewModel.websiteManagedObjectID(atIndex: 0)
                if (managedObjectID != nil) {
                    self.addSiteViewModel?.fetch(website: managedObjectID!, completionHandler: { ( siteDataDetailsModel) in
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
        let websiteDataModel = WebsiteDetailsModel(websiteName: "mobile.demo", accountID: 22, creationTimestamp: NSDate(), isStaging: false)
        let targetingParamModel = TargetingParamModel(targetingParamKey: "MyPrivacyManager", targetingParamValue: "true")
        targetingParamsArray.append(targetingParamModel)
        let siteListViewModel = WebsiteListViewModel()
        siteListViewModel.importAllWebsites(executionCompletionHandler: { sites in
            if sites!.count > 0 {
                let managedObjectID = siteListViewModel.websiteManagedObjectID(atIndex: 0)
                if (managedObjectID != nil) {
                    self.addSiteViewModel?.update(websiteDetails: websiteDataModel, targetingParams: self.targetingParamsArray, whereManagedObjectID: managedObjectID!, completionHandler: { (optionalWebsiteManagedObjectID, executionStatus) in
                        if executionStatus {
                            XCTAssert(true, "webview data updated successfully")
                        } else {
                            XCTAssert(false, "failed to update website data")
                        }
                    })
                }
            }
        })
    }
    
    // This method is used to validate the website details
    func testValidateWebsiteDetails() {
        let validationResult = addSiteViewModel?.validateWebsiteDetails(accountID: "22", websiteName: "mobile.demo")
        if validationResult! {
            XCTAssert(true, "website data validated successfully")
        } else {
            XCTAssert(false, "failed to validate website")
        }
    }
    
    // This method is used to validate the empty the site data case
    func testValidatWithEmptyeWebsiteDetails() {
        let validationResult = addSiteViewModel?.validateWebsiteDetails(accountID: "", websiteName: "")
        if validationResult! {
            XCTAssert(false, "failed to validate website")
        } else {
            XCTAssert(true, "website data validated successfully")
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
