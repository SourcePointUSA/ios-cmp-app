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
        if #available(iOS 15.0, *) {
            expect(self.app.attPrePrompt.okButton).to(showUp())
            app.attPrePrompt.okButton.tap()
            expect(self.app.attPrePrompt.attAlertAllowButton).to(showUp(in: 1))
            app.attPrePrompt.attAlertAllowButton.tap()
        } else {
            fail("ATT testing are only available in iOS 15")
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

        it("Accept all through message") {
            self.acceptAtt()
            expect(self.app.gdprMessage.messageTitle).to(showUp())
            self.app.gdprMessage.acceptButton.tap()
            expect(self.app.gdprPrivacyManagerButton).to(showUp())
            self.app.relaunch()
            expect(self.app.gdprMessage.messageTitle).notTo(showUp())
        }

        it("Accept all through 2nd layer") {
            self.acceptAtt()
            expect(self.app.gdprMessage.messageTitle).to(showUp())
            self.app.gdprMessage.showOptionsButton.tap()
            expect(self.app.gdprPM.messageTitle).to(showUp())
            self.app.gdprPM.acceptAllButton.tap()
            expect(self.app.gdprPrivacyManagerButton).to(showUp())
            self.app.relaunch()
            expect(self.app.gdprMessage.messageTitle).notTo(showUp())
        }

        it("Dismissing 2nd layer returns to first layer message") {
            self.acceptAtt()
            expect(self.app.gdprMessage.messageTitle).to(showUp())
            self.app.gdprMessage.showOptionsButton.tap()
            expect(self.app.gdprPM.messageTitle).to(showUp())
            self.app.gdprPM.cancelButton.tap()
            expect(self.app.gdprMessage.messageTitle).to(showUp())
        }
    }
}
