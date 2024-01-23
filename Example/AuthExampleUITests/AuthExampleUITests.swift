//
//  AuthExampleUITests.swift
//  AuthExampleUITests
//
//  Created by Vilas on 10/02/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

@testable import ConsentViewController
import Nimble
import Quick
import XCTest

class AuthExampleUITests: QuickSpec {
    var app: AuthExampleApp!

    override func spec() {
        beforeSuite {
            self.app = AuthExampleApp()
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

        func acceptGDPRMessage() {
            expect(self.app.gdprMessage.messageTitle).toEventually(showUp())
            self.app.gdprMessage.acceptButton.tap()
        }

        func acceptCCPAMessage() {
            expect(self.app.ccpaMessage.messageTitle).toEventually(showUp())
            self.app.ccpaMessage.acceptButton.tap()
        }

        func waitForSdkToFinish() {
            expect(self.app.sdkStatusLabel).toEventually(containText("Finished"))
        }

        func navigateToWebView() {
            self.app.webViewButton.tap()
        }

        it("Accepting all via native screen should prevent messages from showing on the webview screen") {
            acceptGDPRMessage()
            acceptCCPAMessage()
            waitForSdkToFinish()
            navigateToWebView()
            expect(self.app.webViewOnConsentReadyCalls.count).toEventually(equal(2))
        }
    }
}
