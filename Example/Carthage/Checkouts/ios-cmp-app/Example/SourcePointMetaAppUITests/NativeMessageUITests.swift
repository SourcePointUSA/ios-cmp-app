//
//  NativeMessageUITests.swift
//  SourcePointMetaAppUITests
//
//  Created by Vilas on 23/09/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import GDPR_MetaApp

class NativeMessageUITests: QuickSpec {
    var app: MetaApp!
    var properyData = PropertyData()

    override func spec() {
        beforeSuite {
            self.continueAfterFailure = false
            self.app = MetaApp()
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

        it("Accept all through native message") {
            self.app.addPropertyDetailsForNativeMessage()
            self.app.savePropertyButton.tap()
            expect(self.app.messageTitle).to(showUp())
            self.app.acceptButton.tap()
            expect(self.app.messageTitle).to(disappear())
            expect(self.app.propertyDebugInfo).to(showUp())
            self.app.backButton.tap()
            expect(self.app.propertyList).to(showUp())
            self.app.propertyItem.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
        }

        it("Reject all through native message") {
            self.app.addPropertyDetailsForNativeMessage()
            self.app.savePropertyButton.tap()
            expect(self.app.messageTitle).to(showUp())
            self.app.rejectButton.tap()
            expect(self.app.messageTitle).to(disappear())
            expect(self.app.propertyDebugInfo).to(showUp())
            self.app.backButton.tap()
            expect(self.app.propertyList).to(showUp())
            self.app.propertyItem.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
        }

        it("Accept all through privacy manager directly") {
            self.app.addPropertyDetailsForNativeMessage()
            self.app.savePropertyButton.tap()
            expect(self.app.messageTitle).to(showUp())
            self.app.rejectButton.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
            self.app.showPMButton.tap()
            expect(self.app.privacyManager).to(showUp())
            self.app.purposesTab.tap()
            self.app.testNativeMessagePMToggles(value: 0)
            self.app.acceptAllButton.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
            self.app.showPMButton.tap()
            expect(self.app.privacyManager).to(showUp())
            self.app.purposesTab.tap()
            self.app.testNativeMessagePMToggles(value: 1)
        }

        it("Reject all through privacy manager directly") {
            self.app.addPropertyDetailsForNativeMessage()
            self.app.savePropertyButton.tap()
            expect(self.app.messageTitle).to(showUp())
            self.app.acceptButton.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
            self.app.showPMButton.tap()
            expect(self.app.privacyManager).to(showUp())
            self.app.purposesTab.tap()
            self.app.testNativeMessagePMToggles(value: 1)
            self.app.rejectAllButton.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
            self.app.showPMButton.tap()
            expect(self.app.privacyManager).to(showUp())
            self.app.purposesTab.tap()
            self.app.testNativeMessagePMToggles(value: 0)
        }

        it("Save and Exit through privacy manager directly") {
            self.app.addPropertyDetailsForNativeMessage()
            self.app.savePropertyButton.tap()
            expect(self.app.messageTitle).to(showUp())
            self.app.acceptButton.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
            self.app.showPMButton.tap()
            expect(self.app.privacyManager).to(showUp())
            self.app.saveAndExitButton.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
            self.app.backButton.tap()
            expect(self.app.propertyList).to(showUp())
            self.app.propertyItem.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
        }
    }
}
