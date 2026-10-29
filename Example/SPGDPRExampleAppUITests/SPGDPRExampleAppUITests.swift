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
    static var app: ExampleApp!

    static func acceptAtt() {
        expect(app.attPrePrompt.okButton).toEventually(showUp())
        app.attPrePrompt.okButton.tap()
        expect(app.attPrePrompt.attAlertAllowButton).toEventually(showUp())
        app.attPrePrompt.attAlertAllowButton.tap()
    }

    static func acceptAll(onMessage message: FirstLayerMessage) {
        expect(message.messageTitle).toEventually(showUp())
        message.acceptButton.tap()
    }

    static func showGDPRPMViaFirstLayerMessage() {
        expect(app.gdprMessage.messageTitle).toEventually(showUp())
        app.gdprMessage.showOptionsButton.tap()
        expect(app.gdprPM.messageTitle).toEventually(showUp())
    }

    // We are unable to reset ATT permissions on iOS < 15 so we need to make sure
    // the ATT expectations run only once per test suite.
    static func runAttScenario() {
        if app.shouldRunAttScenario {
            acceptAtt()
        }
    }

    override class func spec() {
        beforeSuite {
            app = ExampleApp()
            Nimble.PollingDefaults.timeout = .seconds(30)
            Nimble.PollingDefaults.pollInterval = .milliseconds(300)
        }

        afterSuite {
            Nimble.PollingDefaults.timeout = .seconds(1)
            Nimble.PollingDefaults.pollInterval = .milliseconds(10)
        }

        it("Accept all through 1st layer messages") {
            app.relaunch(clean: true, resetAtt: true, args: ["ccpa": false])
            runAttScenario()
            acceptAll(onMessage: app.gdprMessage)
//            acceptAll(onMessage: app.ccpaMessage)
            acceptAll(onMessage: app.usnatMessage)
            acceptAll(onMessage: app.globalCmpMessage)
            acceptAll(onMessage: app.preferencesMessage)
            expect(app.gdprPrivacyManagerButton).toEventually(showUp())
            expect(app.sdkStatusLabel).toEventually(containText("Finished"))
            app.relaunch()
            expect(app.sdkStatusLabel).toEventually(containText("Finished"))
        }

        it("Accepting All toggles all toggles on PM") {
            app.relaunch(clean: true, resetAtt: false, args: ["ccpa": false, "att": false, "usnat": false, "preferences": false, "globalcmp": false])
            acceptAll(onMessage: app.gdprMessage)

            expect(app.gdprPrivacyManagerButton).toEventually(showUp())
            expect(app.sdkStatusLabel).toEventually(containText("Finished"))
            app.gdprPrivacyManagerButton.tap()
            expect(app.gdprPM).toEventually(showUp())
            expect(app.gdprPM.purposeToggles).toEventually(allPass(beToggledOn()))

            app.gdprPM.rejectAllButton.tap()
            expect(app.gdprPrivacyManagerButton).toEventually(showUp())
            expect(app.sdkStatusLabel).toEventually(containText("Finished"))
            app.gdprPrivacyManagerButton.tap()
            expect(app.gdprPM).toEventually(showUp())
            expect(app.gdprPM.purposeToggles).toEventually(allPass(beToggledOff()))
        }

        it("Accept all through 2nd layer") {
            app.relaunch(clean: true, resetAtt: true, args: ["att": false, "ccpa": false, "usnat": false, "preferences": false, "globalcmp": false])
            showGDPRPMViaFirstLayerMessage()
            app.gdprPM.acceptAllButton.tap()
            expect(app.sdkStatusLabel).toEventually(containText("Finished"))
            app.relaunch()
            expect(app.sdkStatusLabel).toEventually(containText("Finished"))
        }

        it("Dismissing 2nd layer returns to first layer message") {
            app.relaunch(clean: true, resetAtt: true, args: ["att": false, "ccpa": false, "usnat": false, "preferences": false, "globalcmp": false])
            showGDPRPMViaFirstLayerMessage()
            app.gdprPM.cancelButton.tap()
            expect(app.gdprMessage.messageTitle).toEventually(showUp())
        }

        it("Consenting and Deleting custom vendor persist after relaunch") {
            app.relaunch(clean: true, resetAtt: true, args: ["att": true, "ccpa": false, "usnat": false, "preferences": false, "globalcmp": false])
            runAttScenario()
            acceptAll(onMessage: app.gdprMessage)

            expect(app.sdkStatusLabel).toEventually(containText("Finished"))
            expect(app.deleteCustomVendorsButton).toEventually(beEnabled())
            expect(app.customVendorLabel).toEventually(containText("Accepted"))
            app.deleteCustomVendorsButton.tap()
            expect(app.customVendorLabel).toEventually(containText("Rejected"))

            app.relaunch(args: ["att": false, "ccpa": false, "usnat": false, "preferences": false, "globalcmp": false])

            expect(app.deleteCustomVendorsButton).toEventually(beDisabled())
            expect(app.acceptCustomVendorsButton).toEventually(beEnabled())
            expect(app.customVendorLabel).toEventually(containText("Rejected"))

            app.acceptCustomVendorsButton.tap()
            expect(app.customVendorLabel).toEventually(containText("Accepted"))

            app.relaunch(args: ["att": false, "ccpa": false, "usnat": false, "preferences": false, "globalcmp": false])

            expect(app.deleteCustomVendorsButton).toEventually(beEnabled())
            expect(app.acceptCustomVendorsButton).toEventually(beDisabled())
            expect(app.customVendorLabel).toEventually(containText("Accepted"))
        }

        it("Shows a translated message") {
            app.relaunch(clean: true, resetAtt: false, args: [
                "gdpr": true,
                "att": false,
                "ccpa": false,
                "usnat": false,
                "preferences": false,
                "globalcmp": false,
                "language": SPMessageLanguage.Spanish.rawValue
            ])
            expect(app.sdkStatusLabel).toEventually(containText("Running"))
            expect(app.gdprMessage.spanishMessageTitle).toEventually(showUp())
        }
    }
}
