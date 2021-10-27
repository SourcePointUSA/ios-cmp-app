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
        expect(self.app.attPrePrompt.okButton).to(showUp())
        app.attPrePrompt.okButton.tap()
        expect(self.app.attPrePrompt.attAlertAllowButton).to(showUp(in: 1))
        app.attPrePrompt.attAlertAllowButton.tap()
    }

    func acceptGDPRMessage() {
        expect(self.app.gdprMessage.messageTitle).to(showUp())
        self.app.gdprMessage.acceptButton.tap()
    }

    func acceptCCPAMessage() {
        expect(self.app.ccpaMessage.messageTitle).to(showUp())
        self.app.ccpaMessage.acceptButton.tap()
    }

    func showGDPRPMViaFirstLayerMessage() {
        expect(self.app.gdprMessage.messageTitle).to(showUp())
        self.app.gdprMessage.showOptionsButton.tap()
        expect(self.app.gdprPM.messageTitle).to(showUp())
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
            self.continueAfterFailure = false
            self.app = NativeExampleApp()
            Nimble.AsyncDefaults.timeout = .seconds(20)
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
            self.acceptGDPRMessage()
            self.acceptCCPAMessage()
            expect(self.app.gdprPrivacyManagerButton).to(showUp())
            self.app.relaunch()
            expect(self.app.gdprMessage.messageTitle).notTo(showUp())
        }

        it("Accept all through 2nd layer") {
            self.runAttScenario()
            self.showGDPRPMViaFirstLayerMessage()
            self.app.gdprPM.acceptAllButton.tap()
            self.acceptCCPAMessage()
            expect(self.app.gdprPrivacyManagerButton).to(showUp())
            self.app.relaunch()
            expect(self.app.gdprMessage.messageTitle).notTo(showUp())
        }

        it("Dismissing 2nd layer returns to first layer message") {
            self.runAttScenario()
            self.showGDPRPMViaFirstLayerMessage()
            self.app.gdprPM.cancelButton.tap()
            expect(self.app.gdprMessage.messageTitle).to(showUp())
        }
    }
}
