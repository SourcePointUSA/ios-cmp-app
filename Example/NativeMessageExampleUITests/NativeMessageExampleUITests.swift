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

            // assert the PM's cancel button navigates the user back to the 1st layer
            self.showGDPRPMViaFirstLayerMessage()
            self.app.gdprPM.cancelButton.tap()
            self.acceptGDPRMessage()

            self.acceptCCPAMessage()
            expect(self.app.sdkStatusLabel).toEventually(containText("Finished"))

            self.app.relaunch()
            expect(self.app.sdkStatusLabel).toEventually(containText("Finished"))
        }

        it("Accept all through 2nd layer") {
            self.runAttScenario()
            self.showGDPRPMViaFirstLayerMessage()
            self.app.gdprPM.acceptAllButton.tap()
            self.showCCPAPMViaFirstLayerMessage()
            self.app.ccpaPM.acceptAllButton.tap()
            expect(self.app.sdkStatusLabel).toEventually(containText("Finished"))
            self.waitForUserDefaultsToPersist(20) {
                self.app.relaunch()
            }
            expect(self.app.sdkStatusLabel).toEventually(containText("Finished"))
        }
    }
}
