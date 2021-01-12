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

    override func spec() {
        beforeSuite {
            self.continueAfterFailure = false
            self.app = NativeExampleApp()
            Nimble.AsyncDefaults.Timeout = 20
            Nimble.AsyncDefaults.PollInterval = 0.5
        }

        afterSuite {
            Nimble.AsyncDefaults.Timeout = 1
            Nimble.AsyncDefaults.PollInterval = 0.01
        }

        beforeEach {
            self.app.relaunch(clean: true)
        }

        it("Accept all through message") {
            expect(self.app.messageTitle).to(showUp())
            self.app.acceptButton.tap()
            expect(self.app.messageTitle).to(disappear())
            expect(self.app.exampleAppLabel).to(showUp())
            self.app.relaunch()
            expect(self.app.messageTitle).notTo(showUp())
        }

        it("Reject all through message") {
            expect(self.app.messageTitle).to(showUp())
            self.app.rejectButton.tap()
            expect(self.app.messageTitle).to(disappear())
            expect(self.app.exampleAppLabel).to(showUp())
            self.app.relaunch()
            expect(self.app.messageTitle).notTo(showUp())
        }

        it("Save and Exit through privacy manager via message") {
            expect(self.app.messageTitle).to(showUp())
            self.app.showOptionsButton.tap()
            expect(self.app.privacyManager).to(showUp())
            self.app.purposesTab.tap()
            self.app.PersonalisedContentSwitch.tap()
            self.app.DeviceInformationSwitch.tap()
            self.app.saveAndExitButton.tap()
            expect(self.app.privacyManager).to(disappear())
            self.app.relaunch()
            expect(self.app.messageTitle).notTo(showUp())
        }

        it("Accept all through privacy manager directly") {
            expect(self.app.messageTitle).to(showUp())
            self.app.rejectButton.tap()
            expect(self.app.exampleAppLabel).to(showUp())
            self.app.settingsButton.tap()
            expect(self.app.privacyManager).to(showUp())
            self.app.acceptAllButton.tap()
            expect(self.app.privacyManager).to(disappear())
            self.app.relaunch()
            expect(self.app.messageTitle).notTo(showUp())
        }

        it("Reject all through privacy manager directly") {
            expect(self.app.messageTitle).to(showUp())
            self.app.acceptButton.tap()
            expect(self.app.exampleAppLabel).to(showUp())
            self.app.settingsButton.tap()
            expect(self.app.privacyManager).to(showUp())
            self.app.rejectAllButton.tap()
            expect(self.app.privacyManager).to(disappear())
            self.app.relaunch()
            expect(self.app.messageTitle).notTo(showUp())
        }

        it("Save and Exit through privacy manager directly") {
            expect(self.app.messageTitle).to(showUp())
            self.app.acceptButton.tap()
            expect(self.app.exampleAppLabel).to(showUp())
            self.app.settingsButton.tap()
            expect(self.app.privacyManager).to(showUp())
            self.app.saveAndExitButton.tap()
            expect(self.app.privacyManager).to(disappear())
            self.app.relaunch()
            expect(self.app.messageTitle).notTo(showUp())
        }

        it("Save and Exit with few purposes through privacy manager directly") {
            expect(self.app.messageTitle).to(showUp())
            self.app.acceptButton.tap()
            expect(self.app.exampleAppLabel).to(showUp())
            self.app.settingsButton.tap()
            expect(self.app.privacyManager).to(showUp())
            self.app.purposesTab.tap()
            self.app.PersonalisedContentSwitch.tap()
            self.app.DeviceInformationSwitch.tap()
            self.app.saveAndExitButton.tap()
            expect(self.app.privacyManager).to(disappear())
            self.app.relaunch()
            expect(self.app.messageTitle).notTo(showUp())
        }

        it("Cancel with few purposes through privacy manager directly") {
            expect(self.app.messageTitle).to(showUp())
            self.app.acceptButton.tap()
            expect(self.app.exampleAppLabel).to(showUp())
            self.app.settingsButton.tap()
            expect(self.app.privacyManager).to(showUp())
            self.app.purposesTab.tap()
            self.app.PersonalisedContentSwitch.tap()
            self.app.DeviceInformationSwitch.tap()
            self.app.cancelButton.tap()
            expect(self.app.privacyManager).to(disappear())
            self.app.relaunch()
            expect(self.app.messageTitle).notTo(showUp())
        }
    }
}
