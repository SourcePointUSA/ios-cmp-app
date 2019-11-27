//
//  AddWebsiteViewControllerTest.swift
//  SourcePointMetaAppTests
//
//  Created by Vilas on 8/21/19.
//  Copyright © 2019 Cybage. All rights reserved.
//

import XCTest
import CoreData
import ConsentViewController
@testable import SourcePointMetaApp

class AddWebsiteViewControllerTest: XCTestCase {

    var addSiteViewController: AddWebsiteViewController?
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        addSiteViewController = storyboard.instantiateViewController(withIdentifier: "AddWebsiteViewController") as? AddWebsiteViewController
        
        addSiteViewController?.loadView()
        addSiteViewController?.viewDidLoad()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // This method is used to check controller has tableview or not
    func testControllerHasTableView() {
        addSiteViewController?.loadViewIfNeeded()
        XCTAssertNotNil(addSiteViewController?.targetingParamTableview ,
                        "Controller should have a tableview")
    }
    
    // This method is used to check numberOfRows method is implemented or not for tablview.
    func testNumberOfRows() {
        if let siteTableView = addSiteViewController?.targetingParamTableview {
            let numberOfRows = addSiteViewController?.tableView(siteTableView, numberOfRowsInSection: 0)
            XCTAssertEqual(numberOfRows, 0,
                           "Number of rows in table should match number of siteName")
        }
    }
    
    // This method is used to check delegate of tableview method is implemented or not.
    func testTableViewHasDelegate() {
        XCTAssertNotNil(addSiteViewController?.targetingParamTableview.delegate)
    }
    
    // This method is used to check wheteher the list controller confroms the delegate method.
    func testTableViewConfromsToTableViewDelegateProtocol() {
        XCTAssertTrue((addSiteViewController?.conforms(to: UITableViewDelegate.self))!)
        XCTAssertTrue((addSiteViewController?.responds(to: #selector(addSiteViewController?.tableView(_:didSelectRowAt:))))!)
    }
    
    // This method is used to check tableview datasource is implemented or not.
    func testTableViewHasDataSource() {
        XCTAssertNotNil(addSiteViewController?.targetingParamTableview.dataSource)
    }
    
    // This method is used to check wheteher the list controller confroms the datasource method.
    func testTableViewConformsToTableViewDataSourceProtocol() {
        XCTAssertTrue((addSiteViewController?.conforms(to: UITableViewDataSource.self))!)
        XCTAssertTrue((addSiteViewController?.responds(to: #selector(addSiteViewController?.tableView(_:numberOfRowsInSection:))))!)
        XCTAssertTrue((addSiteViewController?.responds(to: #selector(addSiteViewController?.tableView(_:cellForRowAt:))))!)
    }
}
