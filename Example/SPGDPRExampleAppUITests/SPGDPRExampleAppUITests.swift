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

        afterEach {
            self.app.clearConsentButton.tap()
            /// This is a side effect. We need to "force" the UserDefaults to synchronise otherwise
            /// it won't store its in-memory values on the file system in time before closing the app.
            UserDefaults.standard.synchronize()
            Nimble.AsyncDefaults.Timeout = 1
            Nimble.AsyncDefaults.PollInterval = 0.01
        }

        describe("SPGDPRExampleAppUITests") {
            it("1. Accept all through message") {
                expect(self.app.consentMessage).to(showUp())
                if self.app.consentMessage.exists {
                    self.app.consentMessage.swipeUp()
                }
                self.app.acceptAllButton.tap()
                expect(self.app.consentMessage).to(disappear())
                expect(self.app.vendorXConsentStatus).to(equal("Accepted"))
                self.app.relaunch()
                expect(self.app.consentMessage).notTo(showUp())
            }

            it("2. Reject all through message") {
                expect(self.app.consentMessage).to(showUp())
                if self.app.consentMessage.exists {
                    self.app.consentMessage.swipeUp()
                }
                self.app.rejectAllButton.tap()
                expect(self.app.consentMessage).to(disappear())
                expect(self.app.vendorXConsentStatus).to(equal("Rejected"))
                self.app.relaunch()
                expect(self.app.consentMessage).notTo(showUp())
            }

            it("3. Accept all through privacy manager via message") {
                expect(self.app.consentMessage).to(showUp())
                if self.app.consentMessage.exists {
                    self.app.consentMessage.swipeUp()
                }
                self.app.showOptionsButton.tap()
                expect(self.app.privacyManager).to(showUp())
                if self.app.privacyManager.exists {
                    self.app.privacyManager.swipeUp()
                }
                self.app.acceptAllButton.tap()
                expect(self.app.consentMessage).to(disappear())
                expect(self.app.vendorXConsentStatus).to(equal("Accepted"))
                self.app.relaunch()
                expect(self.app.consentMessage).notTo(showUp())
            }

            it("4. Reject all through privacy manager via message") {
                expect(self.app.consentMessage).to(showUp())
                if self.app.consentMessage.exists {
                    self.app.consentMessage.swipeUp()
                }
                self.app.showOptionsButton.tap()
                expect(self.app.privacyManager).to(showUp())
                if self.app.privacyManager.exists {
                    self.app.privacyManager.swipeUp()
                }
                self.app.rejectAllButton.tap()
                expect(self.app.consentMessage).to(disappear())
                expect(self.app.vendorXConsentStatus).to(equal("Rejected"))
                self.app.relaunch()
                expect(self.app.consentMessage).notTo(showUp())
            }

            it("5. Save and Exit through privacy manager via message") {
                expect(self.app.consentMessage).to(showUp())
                if self.app.consentMessage.exists {
                    self.app.consentMessage.swipeUp()
                }
                self.app.showOptionsButton.tap()
                expect(self.app.privacyManager).to(showUp())
                if self.app.privacyManager.exists {
                    self.app.privacyManager.swipeUp()
                }
                self.app.saveAndExitButton.tap()
                expect(self.app.consentMessage).to(disappear())
                self.app.relaunch()
                expect(self.app.consentMessage).notTo(showUp())
            }

            it("6. the vendor x 'Rejected' after tapping on Clear Consents button") {
                self.app.clearConsentButton.tap()
                expect(self.app.vendorXConsentStatus).to(equal("Rejected"))
            }

            it("7. have the vendor x 'Accepted' after tapping on Accept Vendor X button") {
                expect(self.app.consentMessage).to(showUp())
                if self.app.consentMessage.exists {
                    self.app.consentMessage.swipeUp()
                }
                self.app.rejectAllButton.tap()
                expect(self.app.consentMessage).to(disappear())
                expect(self.app.vendorXConsentStatus).to(equal("Rejected"))
                self.app.acceptVendorXButton.tap()
                expect(self.app.vendorXConsentStatus).to(equal("Accepted"))
            }

            it("8. Accept all through the Privacy Manager directly") {
                self.app.privacySettingsButton.tap()
                expect(self.app.privacyManager).to(showUp())
                if self.app.privacyManager.exists {
                    self.app.privacyManager.swipeUp()
                }
                self.app.acceptAllButton.tap()
                expect(self.app.privacyManager).to(disappear())
                expect(self.app.vendorXConsentStatus).to(equal("Accepted"))
            }

            it("9. Reject all through the Privacy Manager directly") {
                self.app.privacySettingsButton.tap()
                expect(self.app.privacyManager).to(showUp())
                if self.app.privacyManager.exists {
                    self.app.privacyManager.swipeUp()
                }
                self.app.rejectAllButton.tap()
                expect(self.app.privacyManager).to(disappear())
                expect(self.app.vendorXConsentStatus).to(equal("Rejected"))
            }

            it("10. Save And Exit through the Privacy Manager directly") {
                self.app.privacySettingsButton.tap()
                expect(self.app.privacyManager).to(showUp())
                if self.app.privacyManager.exists {
                    self.app.privacyManager.swipeUp()
                }
                self.app.saveAndExitButton.tap()
                expect(self.app.privacyManager).to(disappear())
            }
        }
    }
}

