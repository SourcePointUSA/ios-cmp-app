//
//  SPGDPRExampleAppUITests.swift
//  SPGDPRExampleAppUITests
//
//  Created by Andre Herculano on 19.06.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import ConsentViewController

class SPGDPRExampleAppUITests: QuickSpec {
    var app: ExampleApp!

    override func spec() {
        beforeSuite {
            self.continueAfterFailure = false
            self.app = ExampleApp(XCUIApplication())
            self.app.launch()
            self.app.clearConsentButton.tap()
            Nimble.AsyncDefaults.Timeout = 10
            Nimble.AsyncDefaults.PollInterval = 1
        }

        afterSuite {
            self.app.clearConsentButton.tap()
            /// This is a side effect. We need to "force" the UserDefaults to synchronise otherwise
            /// it won't store its in-memory values on the file system in time before closing the app.
            UserDefaults.standard.synchronize()
            Nimble.AsyncDefaults.Timeout = 1
            Nimble.AsyncDefaults.PollInterval = 0.01
        }

        describe("SPGDPRExampleAppUITests") {
            context("when launching the app for the first time") {
                it("1. should see the consent message") {
                    expect(self.app.consentMessage).to(showUp())
                }

                it("2. have the message disappear after rejecting all") {
                    self.app.rejectAllButton.tap()
                    expect(self.app.consentMessage).to(disappear())
                }

                it("3. vendor x should be 'Rejected'") {
                    expect(self.app.vendorXConsentStatus).toEventually(equal("Rejected"))
                }

                it("4. have the vendor x 'Accepted' after tapping on Accept Vendor X button") {
                    self.app.acceptVendorXButton.tap()
                    expect(self.app.vendorXConsentStatus).toEventually(equal("Accepted"))
                }

                it("5. not see the consent message after relaunching") {
                    self.app.relaunch()
                    expect(self.app.consentMessage).notTo(showUp())
                }

                it("6. the vendor x 'Rejected' after tapping on Clear Consents button") {
                    self.app.clearConsentButton.tap()
                    expect(self.app.vendorXConsentStatus).toEventually(equal("Rejected"))
                }

                it("7. the Privacy Manager should open when taping on Privacy Settings button") {
                    self.app.privacySettingsButton.tap()
                    expect(self.app.privacyManager).to(showUp())
                }

                it("8. the Privacy Manager should close after tapping on Accept All") {
                    self.app.acceptAllButton.tap()
                    expect(self.app.privacyManager).to(disappear())
                }

                it("9. have the vendor x 'Accepted'") {
                    expect(self.app.vendorXConsentStatus).toEventually(equal("Accepted"))
                }
            }
        }
    }
}
