//
//  SPGDPRExampleAppUITests.swift
//  SPGDPRExampleAppUITests
//
//  Created by Andre Herculano on 19.06.20.
//  Copyright © 2020 All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import ConsentViewController

class SPGDPRExampleAppUITests: QuickSpec {
    var app: ExampleApp!

    func acceptAtt() {
        expect(self.app.attPrePrompt.okButton).toEventually(showUp())
        app.attPrePrompt.okButton.tap()
        expect(self.app.attPrePrompt.attAlertAllowButton).toEventually(showUp())
        app.attPrePrompt.attAlertAllowButton.tap()
    }

    func acceptGDPRMessage() {
        expect(self.app.gdprMessage.messageTitle).toEventually(showUp())
        self.app.gdprMessage.acceptButton.tap()
    }

    func acceptCCPAMessage() {
        expect(self.app.ccpaMessage.messageTitle).toEventually(showUp())
        self.app.ccpaMessage.acceptButton.tap()
    }

    func showGDPRPMViaFirstLayerMessage() {
        expect(self.app.gdprMessage.messageTitle).toEventually(showUp())
        self.app.gdprMessage.showOptionsButton.tap()
        expect(self.app.gdprPM.messageTitle).toEventually(showUp())
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

    /// The SDK stores data in the UserDefaults and it takes a while until it persists its in-memory data
    func waitForUserDefaultsToPersist(_ delay: Int = 3, execute: @escaping () -> Void) {
        waitUntil(timeout: .seconds(delay * 2)) { done in
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
                execute()
                done()
            }
        }
    }

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

        it("Accept all through 1st layer messages") {
            self.app.relaunch(clean: true, resetAtt: true)
            self.runAttScenario()
            self.acceptGDPRMessage()
            self.acceptCCPAMessage()
            expect(self.app.gdprPrivacyManagerButton).toEventually(showUp())
            expect(self.app.sdkStatusLabel).toEventually(containText("Finished"))
            self.app.relaunch()
            expect(self.app.sdkStatusLabel).toEventually(containText("Finished"))
        }

        it("Accept all through 2nd layer") {
            self.app.relaunch(clean: true, resetAtt: true, args: ["att": false])
            self.showGDPRPMViaFirstLayerMessage()
            self.app.gdprPM.acceptAllButton.tap()
            self.acceptCCPAMessage()
            expect(self.app.gdprPrivacyManagerButton).toEventually(showUp())
            expect(self.app.sdkStatusLabel).toEventually(containText("Finished"))
            self.app.relaunch()
            expect(self.app.sdkStatusLabel).toEventually(containText("Finished"))
        }

        it("Dismissing 2nd layer returns to first layer message") {
            self.app.relaunch(clean: true, resetAtt: true, args: [
                "att": false,
                "ccpa": false
            ])
            self.showGDPRPMViaFirstLayerMessage()
            self.app.gdprPM.cancelButton.tap()
            expect(self.app.gdprMessage.messageTitle).toEventually(showUp())
        }

        it("Consenting and Deleting custom vendor persist after relaunch") {
            self.app.relaunch(clean: true, resetAtt: true, args: [
                "att": false,
                "ccpa": false
            ])
            self.acceptGDPRMessage()

            self.app.deleteCustomVendorsButton.tap()

            self.waitForUserDefaultsToPersist {
                self.app.relaunch(args: ["att": false, "ccpa": false])
            }

            expect(self.app.deleteCustomVendorsButton).toEventually(beDisabled())
            expect(self.app.acceptCustomVendorsButton).toEventually(beEnabled())
            expect(self.app.customVendorLabel).toEventually(containText("Rejected"))

            self.app.acceptCustomVendorsButton.tap()

            self.waitForUserDefaultsToPersist {
                self.app.relaunch(args: ["att": false, "ccpa": false])
            }

            expect(self.app.deleteCustomVendorsButton).toEventually(beEnabled())
            expect(self.app.acceptCustomVendorsButton).toEventually(beDisabled())
            expect(self.app.customVendorLabel).toEventually(containText("Accepted"))
        }
    }
}

