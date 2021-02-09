//
//  AuthExampleUITests.swift
//  AuthExampleUITests
//
//  Created by Vilas on 09/02/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import ConsentViewController

class ExampleApp: XCUIApplication {

    var consentMessage: XCUIElement {
        webViews.containing(NSPredicate(format: "label CONTAINS[cd] 'Privacy Notice'")).firstMatch
    }

    var acceptAllButton: XCUIElement {
        webViews.buttons.containing(NSPredicate(format: "label CONTAINS[cd] 'Accept'")).firstMatch
    }

    func relaunch() {
        launch()
    }

    func swipeUpMessage() {
        swipeUp()
    }
}

class AuthExampleUITests: QuickSpec {
    var app: ExampleApp!

    override func spec() {
        beforeSuite {
            self.continueAfterFailure = false
            self.app = ExampleApp()
        }

        beforeEach {
            self.app.relaunch()
        }

        it("Accept all through message") {
            expect(self.app.consentMessage).to(showUp())
            if self.app.consentMessage.exists {
                self.app.swipeUpMessage()
            }
            self.app.acceptAllButton.tap()
            expect(self.app.consentMessage).to(disappear())
        }
    }
}
