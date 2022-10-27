//
//  NativeMessageExampleUITests.swift
//  NativeMessageExampleUITests
//
//  Created by Vilas on 22/07/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import ConsentViewController

class NativeMessageExampleUITests: QuickSpec {
    var app: NativeExampleApp!

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

    func showCCPAPMViaFirstLayerMessage() {
        expect(self.app.ccpaMessage.messageTitle).toEventually(showUp())
        self.app.ccpaMessage.showOptionsButton.tap()
        expect(self.app.ccpaPM.messageTitle).toEventually(showUp())
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

    override func spec() {
        beforeSuite {
            self.app = NativeExampleApp()
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

        it("Accept all through 1st layer messages") {
            self.runAttScenario()

            // assert the PM's cancel button navigates the user back to the 1st layer
            self.showGDPRPMViaFirstLayerMessage()
            self.app.gdprPM.cancelButton.tap()
            self.acceptGDPRMessage()

            self.acceptCCPAMessage()

            self.app.relaunch()
            expect(self.app.sdkStatusLabel).toEventually(containText("Finished"))
        }

        it("Accept all through 2nd layer") {
            self.runAttScenario()
            self.showGDPRPMViaFirstLayerMessage()
            self.app.gdprPM.acceptAllButton.tap()
            self.showCCPAPMViaFirstLayerMessage()
            self.app.ccpaPM.acceptAllButton.tap()
            self.app.relaunch()
            expect(self.app.sdkStatusLabel).toEventually(containText("Finished"))
        }
    }
}
