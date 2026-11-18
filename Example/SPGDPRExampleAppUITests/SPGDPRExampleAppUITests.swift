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

/// The example app loads a single campaign per launch (Didomi shows one notice per `loadMessage`).
/// The campaign is chosen with the `-campaign=<gdpr|ccpa|usnat>` launch argument.
class SPGDPRExampleAppUITests: QuickSpec {
    static var app: ExampleApp!

    static func launchClean(_ campaign: Campaign, args: [String: Any] = [:]) {
        app.relaunch(clean: true, args: ["campaign": campaign.rawValue].merging(args) { _, new in new })
    }

    static func showNotice(for campaign: Campaign) {
        expect(app.notice.title).toEventually(showUp())
        expect(app.notice.title).toEventually(containText(campaign.noticeTitle))
    }

    static func showPreferencesViaNotice(for campaign: Campaign) {
        showNotice(for: campaign)
        app.notice.showOptionsButton.tap()
        expect(app.preferences.view).toEventually(showUp())
        expect(app.preferences.firstToggle).toEventually(showUp())
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

        Campaign.allCases.forEach { campaign in
            describe("\(campaign.rawValue) campaign") {
                it("Accept all through the notice") {
                    launchClean(campaign)
                    showNotice(for: campaign)
                    app.notice.acceptButton.tap()
                    expect(app.privacyManagerButton(for: campaign)).toEventually(beEnabled())
                    expect(app.sdkStatusLabel).toEventually(containText("Finished"))
                    app.relaunch()
                    expect(app.sdkStatusLabel).toEventually(containText("Finished"))
                    expect(app.notice.view.exists).to(beFalse())
                }

                it("Reject all through the notice") {
                    launchClean(campaign)
                    showNotice(for: campaign)
                    if campaign == .ccpa {
                        // Didomi never renders a "disagree" action on CCPA notices, only "Show Options".
                        app.notice.showOptionsButton.tap()
                        expect(app.preferences.rejectAllButton).toEventually(showUp())
                        app.preferences.rejectAllButton.tap()
                    } else {
                        app.notice.rejectButton.tap()
                    }
                    expect(app.sdkStatusLabel).toEventually(containText("Finished"))
                    app.relaunch()
                    expect(app.sdkStatusLabel).toEventually(containText("Finished"))
                    expect(app.notice.view.exists).to(beFalse())
                }

                it("Shows a translated message") {
                    launchClean(campaign, args: ["language": SPMessageLanguage.Spanish.rawValue])
                    expect(app.notice.title).toEventually(showUp())
                    expect(app.notice.title).toEventually(containText(campaign.spanishNoticeTitle))
                }
            }
        }

        describe("gdpr campaign preferences") {
            it("Accepting All toggles all toggles on PM") {
                launchClean(.gdpr)
                showNotice(for: .gdpr)
                app.notice.acceptButton.tap()

                expect(app.sdkStatusLabel).toEventually(containText("Finished"))
                app.privacyManagerButton(for: .gdpr).tap()
                expect(app.preferences.firstToggle).toEventually(showUp())
                expect(app.preferences.purposeToggles).toEventually(allPass(beToggledOn()))

                // With consent already given, Didomi replaces "agree/disagree to all" by a bulk toggle.
                app.preferences.bulkActionToggle.tap()
                expect(app.preferences.purposeToggles).toEventually(allPass(beToggledOff()))
                app.preferences.saveButton.tap()
                expect(app.privacyManagerButton(for: .gdpr)).toEventually(beEnabled())
                expect(app.sdkStatusLabel).toEventually(containText("Finished"))
                app.privacyManagerButton(for: .gdpr).tap()
                expect(app.preferences.firstToggle).toEventually(showUp())
                expect(app.preferences.purposeToggles).toEventually(allPass(beToggledOff()))
            }

            it("Accept all through 2nd layer") {
                launchClean(.gdpr)
                showPreferencesViaNotice(for: .gdpr)
                app.preferences.acceptAllButton.tap()
                expect(app.sdkStatusLabel).toEventually(containText("Finished"))
                app.relaunch()
                expect(app.sdkStatusLabel).toEventually(containText("Finished"))
                expect(app.notice.view.exists).to(beFalse())
            }

            it("Dismissing 2nd layer returns to first layer message") {
                launchClean(.gdpr)
                showPreferencesViaNotice(for: .gdpr)
                app.preferences.closeButton.tap()
                expect(app.preferences.view).toEventually(disappear())
                showNotice(for: .gdpr)
                // The notice is still on screen, so the SDK is not finished
                expect(app.sdkStatusLabel).toNever(containText("Finished"), until: .seconds(2))
            }
        }

        it("Consenting and Deleting custom vendor persist after relaunch") {
            launchClean(.gdpr)
            showNotice(for: .gdpr)
            app.notice.acceptButton.tap()

            expect(app.sdkStatusLabel).toEventually(containText("Finished"))
            expect(app.deleteCustomVendorsButton).toEventually(beEnabled())
            expect(app.customVendorLabel).toEventually(containText("Accepted"))
            app.deleteCustomVendorsButton.tap()
            expect(app.customVendorLabel).toEventually(containText("Rejected"))

            app.relaunch()

            expect(app.deleteCustomVendorsButton).toEventually(beDisabled())
            expect(app.acceptCustomVendorsButton).toEventually(beEnabled())
            expect(app.customVendorLabel).toEventually(containText("Rejected"))

            app.acceptCustomVendorsButton.tap()
            expect(app.customVendorLabel).toEventually(containText("Accepted"))

            app.relaunch()

            expect(app.deleteCustomVendorsButton).toEventually(beEnabled())
            expect(app.acceptCustomVendorsButton).toEventually(beDisabled())
            expect(app.customVendorLabel).toEventually(containText("Accepted"))
        }
    }
}
