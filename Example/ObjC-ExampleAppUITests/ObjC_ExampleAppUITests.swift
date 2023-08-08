//
//  ObjC_ExampleAppUITests.swift
//  ObjC-ExampleAppUITests
//
//  Created by Vilas on 08/02/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

@testable import ConsentViewController
import Nimble
import Quick
import XCTest

class ObjCExampleAppUITests: QuickSpec {
    var app: ExampleApp!

    override func spec() {
        beforeSuite {
            self.continueAfterFailure = false
            self.app = ExampleApp()
            Nimble.AsyncDefaults.timeout = .seconds(30)
            Nimble.AsyncDefaults.pollInterval = .milliseconds(100)
        }

        afterSuite {
            Nimble.AsyncDefaults.timeout = .seconds(1)
            Nimble.AsyncDefaults.pollInterval = .milliseconds(10)
        }

        beforeEach {
            self.app.relaunch(clean: true, resetAtt: true)
        }

        func acceptAtt() {
            expect(self.app.attPrePrompt.okButton).toEventually(showUp())
            app.attPrePrompt.okButton.tap()
            expect(self.app.attPrePrompt.attAlertAllowButton).toEventually(showUp())
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
            expect(self.app.gdprMessage).toEventually(showUp())
            self.app.acceptAllButton.tap()
            expect(self.app.gdprMessage).to(disappear())

            expect(self.app.ccpaMessage).toEventually(showUp())
            self.app.acceptAllButton.tap()
            expect(self.app.ccpaMessage).to(disappear())

            expect(self.app.sdkStatus).toEventually(containText("Finished"))

            self.app.relaunch()
            expect(self.app.sdkStatus).toEventually(containText("Finished"))
        }
    }
}
