//
//  NativeMessageExampleUITests.swift
//  NativeMessageExampleUITests
//
//  Created by Vilas on 22/07/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

@testable import ConsentViewController
import Nimble
import Quick
import XCTest

class NativeMessageExampleUITests: QuickSpec {
    override class func spec() {
        var app: NativeExampleApp!

        func acceptAtt() {
            expect(app.attPrePrompt.okButton).toEventually(showUp())
            app.attPrePrompt.okButton.tap()
            expect(app.attPrePrompt.attAlertAllowButton).toEventually(showUp())
            app.attPrePrompt.attAlertAllowButton.tap()
        }

        func acceptGDPRMessage() {
            expect(app.gdprMessage.messageTitle).toEventually(showUp())
            app.gdprMessage.acceptButton.tap()
        }

        func acceptCCPAMessage() {
            expect(app.ccpaMessage.messageTitle).toEventually(showUp())
            app.ccpaMessage.acceptButton.tap()
        }

        func showGDPRPMViaFirstLayerMessage() {
            expect(app.gdprMessage.messageTitle).toEventually(showUp())
            app.gdprMessage.showOptionsButton.tap()
            expect(app.gdprPM.messageTitle).toEventually(showUp())
        }

        func showCCPAPMViaFirstLayerMessage() {
            expect(app.ccpaMessage.messageTitle).toEventually(showUp())
            app.ccpaMessage.showOptionsButton.tap()
            expect(app.ccpaPM.messageTitle).toEventually(showUp())
        }

        // We are unable to reset ATT permissions on iOS < 15 so we need to make sure
        // the ATT expectations run only once per test suite.
        func runAttScenario() {
            if app.shouldRunAttScenario {
                acceptAtt()
            }
        }

        beforeSuite {
            app = NativeExampleApp()
            Nimble.PollingDefaults.timeout = .seconds(20)
            Nimble.PollingDefaults.pollInterval = .milliseconds(100)
        }

        afterSuite {
            Nimble.PollingDefaults.timeout = .seconds(1)
            Nimble.PollingDefaults.pollInterval = .milliseconds(10)
        }

        beforeEach {
            app.relaunch(clean: true, resetAtt: true)
        }

        it("Accept all through 1st layer messages") {
            runAttScenario()

            // assert the PM's cancel button navigates the user back to the 1st layer
            showGDPRPMViaFirstLayerMessage()
            app.gdprPM.cancelButton.tap()
            acceptGDPRMessage()

            acceptCCPAMessage()
            expect(app.sdkStatusLabel).toEventually(containText("Finished"))

            app.relaunch()
            expect(app.sdkStatusLabel).toEventually(containText("Finished"))
        }

        it("Accept all through 2nd layer") {
            runAttScenario()
            showGDPRPMViaFirstLayerMessage()
            app.gdprPM.acceptAllButton.tap()
            showCCPAPMViaFirstLayerMessage()
            app.ccpaPM.acceptAllButton.tap()
            expect(app.sdkStatusLabel).toEventually(containText("Finished"))
            app.relaunch()
            expect(app.sdkStatusLabel).toEventually(containText("Finished"))
        }
    }
}
