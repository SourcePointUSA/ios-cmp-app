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
    static var app: AuthExampleApp!

    override class func spec() {
        beforeSuite {
            app = AuthExampleApp()
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

        func acceptGDPRMessage() {
            expect(app.gdprMessage.messageTitle).toEventually(showUp())
            app.gdprMessage.acceptButton.tap()
        }

        func acceptCCPAMessage() {
            expect(app.ccpaMessage.messageTitle).toEventually(showUp())
            app.ccpaMessage.acceptButton.tap()
        }

        func waitForSdkToFinish() {
            expect(app.sdkStatusLabel).toEventually(containText("Finished"))
        }

        func navigateToWebView() {
            app.webViewButton.tap()
        }

        it("Accepting all via native screen should prevent messages from showing on the webview screen") {
            acceptGDPRMessage()
            acceptCCPAMessage()
            waitForSdkToFinish()
            navigateToWebView()
            expect(app.webViewOnConsentReadyCalls.count).toEventually(equal(2))
        }
    }
}
