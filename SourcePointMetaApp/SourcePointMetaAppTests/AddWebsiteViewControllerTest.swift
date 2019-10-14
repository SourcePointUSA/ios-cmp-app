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

    var addWebsiteViewController: AddWebsiteViewController?
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        addWebsiteViewController = storyboard.instantiateViewController(withIdentifier: "AddWebsiteViewController") as? AddWebsiteViewController
        
        addWebsiteViewController?.loadView()
        addWebsiteViewController?.viewDidLoad()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // This method is used to check controller has tableview or not
    func testControllerHasTableView() {
        addWebsiteViewController?.loadViewIfNeeded()
        XCTAssertNotNil(addWebsiteViewController?.targetingParamTableview ,
                        "Controller should have a tableview")
    }
    
    // This method is used to check numberOfRows method is implemented or not for tablview.
    func testNumberOfRows() {
        if let siteTableView = addWebsiteViewController?.targetingParamTableview {
            let numberOfRows = addWebsiteViewController?.tableView(siteTableView, numberOfRowsInSection: 0)
            XCTAssertEqual(numberOfRows, 0,
                           "Number of rows in table should match number of siteName")
        }
    }
    
    // This method is used to check delegate of tableview method is implemented or not.
    func testTableViewHasDelegate() {
        XCTAssertNotNil(addWebsiteViewController?.targetingParamTableview.delegate)
    }
    
    // This method is used to check wheteher the list controller confroms the delegate method.
    func testTableViewConfromsToTableViewDelegateProtocol() {
        XCTAssertTrue((addWebsiteViewController?.conforms(to: UITableViewDelegate.self))!)
        XCTAssertTrue((addWebsiteViewController?.responds(to: #selector(addWebsiteViewController?.tableView(_:didSelectRowAt:))))!)
    }
    
    // This method is used to check tableview datasource is implemented or not.
    func testTableViewHasDataSource() {
        XCTAssertNotNil(addWebsiteViewController?.targetingParamTableview.dataSource)
    }
    
    // This method is used to check wheteher the list controller confroms the datasource method.
    func testTableViewConformsToTableViewDataSourceProtocol() {
        XCTAssertTrue((addWebsiteViewController?.conforms(to: UITableViewDataSource.self))!)
        XCTAssertTrue((addWebsiteViewController?.responds(to: #selector(addWebsiteViewController?.tableView(_:numberOfRowsInSection:))))!)
        XCTAssertTrue((addWebsiteViewController?.responds(to: #selector(addWebsiteViewController?.tableView(_:cellForRowAt:))))!)
    }
}
