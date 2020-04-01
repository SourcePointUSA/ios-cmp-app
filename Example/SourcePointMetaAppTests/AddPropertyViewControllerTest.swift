//
//  AddPropertyViewControllerTest.swift
//  SourcePointMetaAppTests
//
//  Created by Vilas on 8/21/19.
//  Copyright © 2019 Cybage. All rights reserved.
//

import XCTest
import CoreData
import ConsentViewController
@testable import GDPR_MetaApp

class AddPropertyViewControllerTest: XCTestCase {

    var addpropertyViewController: AddPropertyViewController?

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        addpropertyViewController = storyboard.instantiateViewController(withIdentifier: "AddPropertyViewController") as? AddPropertyViewController

        addpropertyViewController?.loadView()
        addpropertyViewController?.viewDidLoad()
    }

    override func tearDown() {
        super.tearDown()
    }

    // This method is used to check controller has tableview or not
    func testControllerHasTableView() {
        addpropertyViewController?.loadViewIfNeeded()
        XCTAssertNotNil(addpropertyViewController?.targetingParamTableview ,
                        "Controller should have a tableview")
    }

    // This method is used to check numberOfRows method is implemented or not for tablview.
    func testNumberOfRows() {
        if let propertyTableView = addpropertyViewController?.targetingParamTableview {
            let numberOfRows = addpropertyViewController?.tableView(propertyTableView, numberOfRowsInSection: 0)
            XCTAssertEqual(numberOfRows, 0,
                           "Number of rows in table should match number of propertyName")
        }
    }

    // This method is used to check delegate of tableview method is implemented or not.
    func testTableViewHasDelegate() {
        XCTAssertNotNil(addpropertyViewController?.targetingParamTableview.delegate)
    }

    // This method is used to check wheteher the list controller confroms the delegate method.
    func testTableViewConfromsToTableViewDelegateProtocol() {
        XCTAssertTrue((addpropertyViewController?.conforms(to: UITableViewDelegate.self))!)
        XCTAssertTrue((addpropertyViewController?.responds(to: #selector(addpropertyViewController?.tableView(_:didSelectRowAt:))))!)
    }

    // This method is used to check tableview datasource is implemented or not.
    func testTableViewHasDataSource() {
        XCTAssertNotNil(addpropertyViewController?.targetingParamTableview.dataSource)
    }

    // This method is used to check wheteher the list controller confroms the datasource method.
    func testTableViewConformsToTableViewDataSourceProtocol() {
        XCTAssertTrue((addpropertyViewController?.conforms(to: UITableViewDataSource.self))!)
        XCTAssertTrue((addpropertyViewController?.responds(to: #selector(addpropertyViewController?.tableView(_:numberOfRowsInSection:))))!)
        XCTAssertTrue((addpropertyViewController?.responds(to: #selector(addpropertyViewController?.tableView(_:cellForRowAt:))))!)
    }
}
