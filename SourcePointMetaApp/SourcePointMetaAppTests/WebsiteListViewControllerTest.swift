//
//  WebsiteListViewControllerTest.swift
//  SourcePointMetaAppTests
//
//  Created by Vilas on 4/25/19.
//  Copyright © 2019 Cybage. All rights reserved.
//

import XCTest
import WebKit
@testable import SourcePointMetaApp

class WebsiteListViewControllerTest: XCTestCase {
    
    var siteListViewController: WebsiteListViewController?
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        siteListViewController = storyboard.instantiateViewController(withIdentifier: "WebsiteListViewController") as? WebsiteListViewController
        
        siteListViewController?.loadView()
        siteListViewController?.viewDidLoad()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // This method is used to check controller has tableview or not
    func testControllerHasTableView() {
        siteListViewController?.loadViewIfNeeded()
        XCTAssertNotNil(siteListViewController?.websiteTableView ,
                        "Controller should have a tableview")
    }
    
    // This method is used to check numberOfRows method is implemented or not for tablview.
    func testNumberOfRows() {
        if let siteTableView = siteListViewController?.websiteTableView {
            let numberOfRows = siteListViewController?.tableView(siteTableView, numberOfRowsInSection: 0)
            XCTAssertEqual(numberOfRows, 0,
                           "Number of rows in table should match number of siteName")
        }
    }
    
    // This method is used to check CellForRowAtIndexPath method is implemented or not for tableview.
    func testTableViewCellForRowAtIndexPath() {
        let indexPath = NSIndexPath(row: 0, section: 0)
        if let siteTableView = siteListViewController?.websiteTableView {
            let cell = siteListViewController?.tableView(siteTableView, cellForRowAt: indexPath as IndexPath) as! WebsiteCell
            XCTAssertNotNil(cell.websiteNameLabel.text)
        }
    }
    
    // This method is used to check delegate of tableview method is implemented or not.
    func testTableViewHasDelegate() {
        XCTAssertNotNil(siteListViewController?.websiteTableView.delegate)
    }
    
    // This method is used to check wheteher the list controller confroms the delegate method.
    func testTableViewConfromsToTableViewDelegateProtocol() {
        XCTAssertTrue((siteListViewController?.conforms(to: UITableViewDelegate.self))!)
        XCTAssertTrue((siteListViewController?.responds(to: #selector(siteListViewController?.tableView(_:didSelectRowAt:))))!)
    }
    
    // This method is used to check tableview datasource is implemented or not.
    func testTableViewHasDataSource() {
        XCTAssertNotNil(siteListViewController?.websiteTableView.dataSource)
    }
    
    // This method is used to check wheteher the list controller confroms the datasource method.
    func testTableViewConformsToTableViewDataSourceProtocol() {
        XCTAssertTrue((siteListViewController?.conforms(to: UITableViewDataSource.self))!)
        XCTAssertTrue((siteListViewController?.responds(to: #selector(siteListViewController?.tableView(_:numberOfRowsInSection:))))!)
        XCTAssertTrue((siteListViewController?.responds(to: #selector(siteListViewController?.tableView(_:cellForRowAt:))))!)
    }
    
    // To check the reuse identifier of the tableview cell
    func testTableViewCellHasReuseIdentifier() {
        let indexPath = NSIndexPath(row: 0, section: 0)
        if let siteTableView = siteListViewController?.websiteTableView {
            let cell = siteListViewController?.tableView(siteTableView, cellForRowAt: indexPath as IndexPath) as! WebsiteCell
            let actualReuseIdentifer = cell.reuseIdentifier
            let expectedReuseIdentifier = "websiteCell"
            XCTAssertEqual(actualReuseIdentifer, expectedReuseIdentifier)
        }
    }
    
    // to check the tableview cell has correct label text or not.
    func testTableCellHasCorrectLabelText() {
        let indexPath = NSIndexPath(row: 0, section: 0)
        if let siteTableView = siteListViewController?.websiteTableView {
            let cell = siteListViewController?.tableView(siteTableView, cellForRowAt: indexPath as IndexPath) as! WebsiteCell
            
            XCTAssertEqual(cell.websiteNameLabel.text, "Cybage.sp-demo.com")
        }
    }
    
    func testTrailingSwipeActionsConfiguration() {
        let indexPath = NSIndexPath(row: 0, section: 0)
        if let siteTableView = siteListViewController?.websiteTableView {
            let configuration = siteListViewController?.tableView(siteTableView, trailingSwipeActionsConfigurationForRowAt: indexPath as IndexPath)
            if configuration?.actions.count ?? 0 > 0 {
                XCTAssert(true, "TrailingSwipeActionsConfiguration is implemented")
            } else {
                XCTAssert(false, "TrailingSwipeActionsConfiguration is not implemented")
            }
        }
    }
    
    func testEditActions() {
        let indexPath = NSIndexPath(row: 0, section: 0)
        if let siteTableView = siteListViewController?.websiteTableView {
            let actions = siteListViewController?.tableView(siteTableView, editActionsForRowAt: indexPath as IndexPath)
            
            if actions?.count ?? 0 > 0 {
                XCTAssert(true, "TrailingSwipeActionsConfiguration is implemented")
            } else {
                XCTAssert(false, "TrailingSwipeActionsConfiguration is not implemented")
            }
        }
    }
}
