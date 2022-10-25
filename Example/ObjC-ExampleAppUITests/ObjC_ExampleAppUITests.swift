//
//  ObjC_ExampleAppUITests.swift
//  ObjC-ExampleAppUITests
//
//  Created by Vilas on 08/02/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import ConsentViewController

class ObjC_ExampleAppUITests: QuickSpec {
    var app: ExampleApp!

    override func spec() {
        beforeSuite {
            self.continueAfterFailure = false
            self.app = ExampleApp()
            Nimble.AsyncDefaults.timeout = .seconds(20)
            Nimble.AsyncDefaults.pollInterval = .milliseconds(100)
        }

        afterSuite {
            Nimble.AsyncDefaults.timeout = .seconds(1)
            Nimble.AsyncDefaults.pollInterval = .milliseconds(10)
        }

        beforeEach {
            self.app.relaunch(clean: true)
        }

        func acceptAtt() {
            expect(self.app.attPrePrompt.okButton).toEventually(showUp())
            app.attPrePrompt.okButton.tap()
            expect(self.app.attPrePrompt.attAlertAllowButton).toEventually(showUp(in: 1))
            app.attPrePrompt.attAlertAllowButton.tap()
        }

        // We are unable to reset ATT permissions on iOS < 15 so we need to make sure
        // the ATT expectations run only once per test suite.
        func runAttScenario() {
            if #available(iOS 15.0, *) {
                acceptAtt()
            } else if app.shouldRunAttScenario {
                if #available(iOS 14, *) {
                    acceptAtt()
                }
            }
        }

        it("Accept all through message") {
            runAttScenario()
            expect(self.app.consentMessage).toEventually(showUp())
            self.app.acceptAllButton.tap()
            expect(self.app.consentMessage).to(disappear())
        }
    }
}
