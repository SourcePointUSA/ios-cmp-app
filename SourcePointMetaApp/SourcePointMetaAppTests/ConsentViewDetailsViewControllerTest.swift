//
//  ConsentViewDetailsViewControllerTest.swift
//  SourcePointMetaAppTests
//
//  Created by Vilas on 8/21/19.
//  Copyright © 2019 Cybage. All rights reserved.
//

import XCTest
import CoreData
import ConsentViewController
@testable import SourcePointMetaApp

class ConsentViewDetailsViewControllerTest: XCTestCase {
    
    var consentDetailsViewController: ConsentViewDetailsViewController?
    
    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        consentDetailsViewController = storyboard.instantiateViewController(withIdentifier: "ConsentViewDetailsViewController") as? ConsentViewDetailsViewController
        
        consentDetailsViewController?.loadView()
        consentDetailsViewController?.viewDidLoad()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // This method is used to check controller has tableview or not
    func testControllerHasTableView() {
        consentDetailsViewController?.loadViewIfNeeded()
        XCTAssertNotNil(consentDetailsViewController?.consentTableView ,
                        "Controller should have a tableview")
    }
    
    // This method is used to check numberOfRows method is implemented or not for tablview.
    func testNumberOfRows() {
        if let consentTableView = consentDetailsViewController?.consentTableView {
            let numberOfRows = consentDetailsViewController?.tableView(consentTableView, numberOfRowsInSection: 0)
            XCTAssertEqual(numberOfRows, 0,
                           "Number of rows in table should match number of property name")
        }
    }
    
    // This method is used to check delegate of tableview method is implemented or not.
    func testTableViewHasDelegate() {
        XCTAssertNotNil(consentDetailsViewController?.consentTableView.delegate)
    }
    
    // This method is used to check wheteher the list controller confroms the delegate method.
    func testTableViewConfromsToTableViewDelegateProtocol() {
        XCTAssertTrue((consentDetailsViewController?.conforms(to: UITableViewDelegate.self))!)
        XCTAssertTrue((consentDetailsViewController?.responds(to: #selector(consentDetailsViewController?.tableView(_:didSelectRowAt:))))!)
    }
    
    // This method is used to check tableview datasource is implemented or not.
    func testTableViewHasDataSource() {
        XCTAssertNotNil(consentDetailsViewController?.consentTableView.dataSource)
    }
    
    // This method is used to check wheteher the list controller confroms the datasource method.
    func testTableViewConformsToTableViewDataSourceProtocol() {
        XCTAssertTrue((consentDetailsViewController?.conforms(to: UITableViewDataSource.self))!)
        XCTAssertTrue((consentDetailsViewController?.responds(to: #selector(consentDetailsViewController?.tableView(_:numberOfRowsInSection:))))!)
        XCTAssertTrue((consentDetailsViewController?.responds(to: #selector(consentDetailsViewController?.tableView(_:cellForRowAt:))))!)
    }
}
