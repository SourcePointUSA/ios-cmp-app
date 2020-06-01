//
//  PropertyListViewControllerTest.swift
//  SourcePointMetaAppTests
//
//  Created by Vilas on 4/25/19.
//  Copyright © 2019 Cybage. All rights reserved.
//

import XCTest
import WebKit
@testable import GDPR_MetaApp

class PropertyListViewControllerTest: XCTestCase {
    
    var propertyListViewController: PropertyListViewController?
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        propertyListViewController = storyboard.instantiateViewController(withIdentifier: "PropertyListViewController") as? PropertyListViewController
        
        propertyListViewController?.loadView()
        propertyListViewController?.viewDidLoad()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // This method is used to check controller has tableview or not
    func testControllerHasTableView() {
        propertyListViewController?.loadViewIfNeeded()
        XCTAssertNotNil(propertyListViewController?.propertyTableView ,
                        "Controller should have a tableview")
    }
    
    // This method is used to check numberOfRows method is implemented or not for tablview.
    func testNumberOfRows() {
        if let propertyTableView = propertyListViewController?.propertyTableView {
            let numberOfRows = propertyListViewController?.tableView(propertyTableView, numberOfRowsInSection: 0)
            XCTAssertEqual(numberOfRows, 0,
                           "Number of rows in table should match number of propertyName")
        }
    }
    
    // This method is used to check CellForRowAtIndexPath method is implemented or not for tableview.
    func testTableViewCellForRowAtIndexPath() {
        let indexPath = NSIndexPath(row: 0, section: 0)
        if let propertyTableView = propertyListViewController?.propertyTableView {
            let cell = propertyListViewController?.tableView(propertyTableView, cellForRowAt: indexPath as IndexPath) as! PropertyCell
            XCTAssertNotNil(cell.propertyLabel.text)
        }
    }
    
    // This method is used to check delegate of tableview method is implemented or not.
    func testTableViewHasDelegate() {
        XCTAssertNotNil(propertyListViewController?.propertyTableView.delegate)
    }
    
    // This method is used to check wheteher the list controller confroms the delegate method.
    func testTableViewConfromsToTableViewDelegateProtocol() {
        XCTAssertTrue((propertyListViewController?.conforms(to: UITableViewDelegate.self))!)
        XCTAssertTrue((propertyListViewController?.responds(to: #selector(propertyListViewController?.tableView(_:didSelectRowAt:))))!)
    }
    
    // This method is used to check tableview datasource is implemented or not.
    func testTableViewHasDataSource() {
        XCTAssertNotNil(propertyListViewController?.propertyTableView.dataSource)
    }
    
    // This method is used to check wheteher the list controller confroms the datasource method.
    func testTableViewConformsToTableViewDataSourceProtocol() {
        XCTAssertTrue((propertyListViewController?.conforms(to: UITableViewDataSource.self))!)
        XCTAssertTrue((propertyListViewController?.responds(to: #selector(propertyListViewController?.tableView(_:numberOfRowsInSection:))))!)
        XCTAssertTrue((propertyListViewController?.responds(to: #selector(propertyListViewController?.tableView(_:cellForRowAt:))))!)
    }
    
    // To check the reuse identifier of the tableview cell
    func testTableViewCellHasReuseIdentifier() {
        let indexPath = NSIndexPath(row: 0, section: 0)
        if let propertyTableView = propertyListViewController?.propertyTableView {
            let cell = propertyListViewController?.tableView(propertyTableView, cellForRowAt: indexPath as IndexPath) as! PropertyCell
            let actualReuseIdentifer = cell.reuseIdentifier
            let expectedReuseIdentifier = "propertyCell"
            XCTAssertEqual(actualReuseIdentifer, expectedReuseIdentifier)
        }
    }
    
    // to check the tableview cell has correct label text or not.
    func testTableCellHasCorrectLabelText() {
        let indexPath = NSIndexPath(row: 0, section: 0)
        if let propertyTableView = propertyListViewController?.propertyTableView {
            let cell = propertyListViewController?.tableView(propertyTableView, cellForRowAt: indexPath as IndexPath) as! PropertyCell
            
            XCTAssertEqual(cell.propertyLabel.text, "Cybage.sp-demo.com")
        }
    }
    
    func testEditActions() {
        let indexPath = NSIndexPath(row: 0, section: 0)
        if let propertyTableView = propertyListViewController?.propertyTableView {
            let actions = propertyListViewController?.tableView(propertyTableView, editActionsForRowAt: indexPath as IndexPath)
            
            if actions?.count ?? 0 > 0 {
                XCTAssert(true, "TrailingSwipeActionsConfiguration is implemented")
            } else {
                XCTAssert(false, "TrailingSwipeActionsConfiguration is not implemented")
            }
        }
    }
}
