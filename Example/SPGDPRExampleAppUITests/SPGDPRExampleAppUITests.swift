//
//  SPGDPRExampleAppUITests.swift
//  SPGDPRExampleAppUITests
//
//  Created by Andre Herculano on 19.06.20.
//  Copyright © 2020 All rights reserved.
//

// swiftlint:disable function_body_length

@testable import ConsentViewController
import Nimble
import Quick
import XCTest

class SPGDPRExampleAppUITests: QuickSpec {
    var app: ExampleApp!

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

    func acceptPreferencesMessage() {
        expect(self.app.preferencesMessage.messageTitle).toEventually(showUp())
        self.app.preferencesMessage.acceptButton.tap()
    }

    func showGDPRPMViaFirstLayerMessage() {
        expect(self.app.gdprMessage.messageTitle).toEventually(showUp())
        self.app.gdprMessage.showOptionsButton.tap()
        expect(self.app.gdprPM.messageTitle).toEventually(showUp())
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
            self.app = ExampleApp()
            Nimble.AsyncDefaults.timeout = .seconds(30)
            Nimble.AsyncDefaults.pollInterval = .milliseconds(300)
        }

        afterSuite {
            Nimble.AsyncDefaults.timeout = .seconds(1)
            Nimble.AsyncDefaults.pollInterval = .milliseconds(10)
        }

        it("Accept all through 1st layer messages") {
            self.app.relaunch(clean: true, resetAtt: true)
            self.runAttScenario()
            self.acceptGDPRMessage()
            self.acceptCCPAMessage()
            //self.acceptPreferencesMessage()
            expect(self.app.gdprPrivacyManagerButton).toEventually(showUp())
            expect(self.app.sdkStatusLabel).toEventually(containText("Finished"))
            self.app.relaunch()
            expect(self.app.sdkStatusLabel).toEventually(containText("Finished"))
        }

        it("Accepting All toggles all toggles on PM") {
            self.app.relaunch(clean: true, resetAtt: false, args: ["ccpa": false, "att": false, "preferences": false])
            self.acceptGDPRMessage()

            expect(self.app.gdprPrivacyManagerButton).toEventually(showUp())
            expect(self.app.sdkStatusLabel).toEventually(containText("Finished"))
            self.app.gdprPrivacyManagerButton.tap()
            expect(self.app.gdprPM).toEventually(showUp())
            expect(self.app.gdprPM.purposeToggles).toEventually(allPass(beToggledOn()))

            self.app.gdprPM.rejectAllButton.tap()
            expect(self.app.gdprPrivacyManagerButton).toEventually(showUp())
            expect(self.app.sdkStatusLabel).toEventually(containText("Finished"))
            self.app.gdprPrivacyManagerButton.tap()
            expect(self.app.gdprPM).toEventually(showUp())
            expect(self.app.gdprPM.purposeToggles).toEventually(allPass(beToggledOff()))
        }

        it("Accept all through 2nd layer") {
            self.app.relaunch(clean: true, resetAtt: true, args: [
                "att": false,
                "ccpa": false,
                "preferences":false
            ])
            self.showGDPRPMViaFirstLayerMessage()
            self.app.gdprPM.acceptAllButton.tap()
            expect(self.app.sdkStatusLabel).toEventually(containText("Finished"))
            self.app.relaunch()
            expect(self.app.sdkStatusLabel).toEventually(containText("Finished"))
        }

        it("Dismissing 2nd layer returns to first layer message") {
            self.app.relaunch(clean: true, resetAtt: true, args: [
                "att": false,
                "ccpa": false,
                "preferences":false
            ])
            self.showGDPRPMViaFirstLayerMessage()
            self.app.gdprPM.cancelButton.tap()
            expect(self.app.gdprMessage.messageTitle).toEventually(showUp())
        }

        it("Consenting and Deleting custom vendor persist after relaunch") {
            self.app.relaunch(clean: true, resetAtt: true, args: [
                "att": true,
                "ccpa": false,
                "preferences":false
            ])
            self.runAttScenario()
            self.acceptGDPRMessage()

            expect(self.app.sdkStatusLabel).toEventually(containText("Finished"))
            expect(self.app.deleteCustomVendorsButton).toEventually(beEnabled())
            expect(self.app.customVendorLabel).toEventually(containText("Accepted"))
            self.app.deleteCustomVendorsButton.tap()
            expect(self.app.customVendorLabel).toEventually(containText("Rejected"))

            self.app.relaunch(args: ["att": false, "ccpa": false, "preferences":false])

            expect(self.app.deleteCustomVendorsButton).toEventually(beDisabled())
            expect(self.app.acceptCustomVendorsButton).toEventually(beEnabled())
            expect(self.app.customVendorLabel).toEventually(containText("Rejected"))

            self.app.acceptCustomVendorsButton.tap()
            expect(self.app.customVendorLabel).toEventually(containText("Accepted"))

            self.app.relaunch(args: ["att": false, "ccpa": false, "preferences":false])

            expect(self.app.deleteCustomVendorsButton).toEventually(beEnabled())
            expect(self.app.acceptCustomVendorsButton).toEventually(beDisabled())
            expect(self.app.customVendorLabel).toEventually(containText("Accepted"))
        }

        it("Shows a translated message") {
            self.app.relaunch(clean: true, resetAtt: false, args: [
                "gdpr": true,
                "att": false,
                "ccpa": false,
                "usnat": false,
                "preferences":false,
                "language": SPMessageLanguage.Spanish.rawValue
            ])
            expect(self.app.sdkStatusLabel).toEventually(containText("Running"))
            expect(self.app.gdprMessage.spanishMessageTitle).toEventually(showUp())
        }
    }
}
