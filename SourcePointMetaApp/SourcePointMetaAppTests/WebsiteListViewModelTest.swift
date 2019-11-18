//
//  WebsiteListViewModelTest.swift
//  SourcePointMetaAppTests
//
//  Created by Vilas on 4/25/19.
//  Copyright © 2019 Cybage. All rights reserved.
//

import XCTest
@testable import SourcePointMetaApp

class WebsiteListViewModelTest: XCTestCase {
    
    var siteListViewModel: WebsiteListViewModel?
    
    override func setUp() {
        siteListViewModel = WebsiteListViewModel()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // This method is used to test whether all site data can be fetched from database or not.
    func testFetchAllSitData() {
        siteListViewModel?.importAllSites(executionCompletionHandler: {(sites) in
            XCTAssertNotNil(sites, "unable to fetch the site data")
        })
    }
    
    // This method checks how many site data is stored in database
    func testNumberOfSiteDataStored() {
        siteListViewModel?.importAllSites(executionCompletionHandler: { (sites) in
            let siteCount = self.siteListViewModel?.numberOfSites()
            XCTAssertNotNil(siteCount, "unable to find out stored data")
        })
    }
    
    // This method check the site name
    func testsiteName() {
        siteListViewModel?.importAllSites(executionCompletionHandler: { (sites) in
            if let _sites = sites, _sites.count > 0 {
                XCTAssertNotNil(_sites[0].siteName, "Error site name is not available")
            }
        })
    }
    
    // This method checks whether the managedObject ID is available or not.
    func testsiteManagedObjectID() {
        siteListViewModel?.importAllSites(executionCompletionHandler: { (sites) in
            if let _sites = sites, _sites.count > 0 {
                XCTAssertNotNil(_sites[0].objectID, "Error managedObject ID is not available")
            }
        })
    }
    
    // This test method checks whether the site will be deleted or not.
    func testDeleteSite() {
        let siteDeletionExpectation = expectation(description: "successfully deleted site data from database")
        siteListViewModel?.importAllSites(executionCompletionHandler: { (sites) in
            if sites?.count ?? 0 > 0 {
                self.siteListViewModel?.delete(atIndex: 0, completionHandler: { (deleteStatus, error) in
                    if error != nil {
                        XCTAssert(false, "failed to delete site data from database")
                    } else {
                        XCTAssert(true, "successfully deleted site data from database")
                    }
                })
            }else{
                XCTAssert(false, "failed to delete site data from database")
                siteDeletionExpectation.fulfill()
            }
        })
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testClearUserDefaultsData() {
        siteListViewModel?.clearUserDefaultsData()
        let consentUUID = UserDefaults.standard.string(forKey: "consentUUID")
        
        if (consentUUID?.count ?? 0 == 0) {
            XCTAssert(true, "UserDefaultData is cleared successfully")
        } else {
            XCTAssert(false, "UserDefaultData is not cleared successfully")
        }
    }
    
    func testSiteDetails() {
        let siteDetailsExpectation = expectation(description: "site details are present")
        siteListViewModel?.importAllSites(executionCompletionHandler: { (sites) in
            if sites?.count ?? 0 > 0 {
            let siteDetails = self.siteListViewModel?.siteDetails(atIndex: 0)
            if ((siteDetails?.0?.accountId) != nil) {
                XCTAssert(true, "site details are present")
            }else {
                 XCTAssert(false, "site details are not present")
            }
            }else {
                XCTAssert(false, "site details are not present")
                siteDetailsExpectation.fulfill()
            }
        })
        waitForExpectations(timeout: 1, handler: nil)
    }
}
