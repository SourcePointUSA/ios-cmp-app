//
//  AuthExampleUITests.swift
//  AuthExampleUITests
//
//  Created by Vilas on 10/02/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest

class AuthExampleUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
    }

    func testAcceptAllMessage() throws {
        let webViewsQuery = XCUIApplication().webViews
        let webMessageTitle = webViewsQuery.staticTexts["Privacy Notice"]
        let exists = NSPredicate(format: "exists == 1")
        expectation(for: exists, evaluatedWith: webMessageTitle, handler: nil)
        waitForExpectations(timeout: 30, handler: nil)
        XCTAssert(webMessageTitle.exists)
        webMessageTitle.swipeUp()
        webViewsQuery.buttons["Accept"].tap()
    }
}
