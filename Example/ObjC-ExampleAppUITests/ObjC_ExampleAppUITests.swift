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
    static var app: ExampleApp!

    override class func spec() {
        beforeSuite {
            app = ExampleApp()
            Nimble.PollingDefaults.timeout = .seconds(30)
            Nimble.PollingDefaults.pollInterval = .milliseconds(100)
        }

        afterSuite {
            Nimble.PollingDefaults.timeout = .seconds(1)
            Nimble.PollingDefaults.pollInterval = .milliseconds(10)
        }

        beforeEach {
            app.relaunch(clean: true, resetAtt: true)
        }

        func acceptAtt() {
            expect(app.attPrePrompt.okButton).toEventually(showUp())
            app.attPrePrompt.okButton.tap()
            expect(app.attPrePrompt.attAlertAllowButton).toEventually(showUp())
            app.attPrePrompt.attAlertAllowButton.tap()
        }

        // We are unable to reset ATT permissions on iOS < 15 so we need to make sure
        // the ATT expectations run only once per test suite.
        func runAttScenario() {
            if app.shouldRunAttScenario {
                acceptAtt()
            }
        }

        it("Accept all through message") {
            runAttScenario()
            expect(app.gdprMessage).toEventually(showUp())
            app.acceptAllButton.tap()
            expect(app.gdprMessage).to(disappear())

            expect(app.usnatMessage).toEventually(showUp())
            app.acceptAllButton.tap()
            expect(app.usnatMessage).to(disappear())

            expect(app.preferencesMessage).toEventually(showUp())
            app.acceptAllButton.tap()
            expect(app.preferencesMessage).to(disappear())

            expect(app.sdkStatus).toEventually(containText("Finished"))

            app.relaunch()
            expect(app.sdkStatus).toEventually(containText("Finished"))
        }
    }
}
