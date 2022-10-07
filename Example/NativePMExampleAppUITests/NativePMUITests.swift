//
//  NativePMUITests.swift
//  NativePMExampleAppUITests
//
//  Created by Vilas on 27/09/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import NativePMExampleApp

extension QuickSpec {
    var remote: XCUIRemote { XCUIRemote.shared }
}

extension XCUIElement {
    var remote: XCUIRemote { XCUIRemote.shared }
}

class NativePMUITests: QuickSpec {
    var app: NativePMApp!

    override func spec() {
        beforeSuite {
            self.continueAfterFailure = false
            self.app = NativePMApp()
            Nimble.AsyncDefaults.timeout = .seconds(20)
            Nimble.AsyncDefaults.pollInterval = .milliseconds(100)
        }

        afterSuite {
            Nimble.AsyncDefaults.timeout = .seconds(1)
            Nimble.AsyncDefaults.pollInterval = .milliseconds(100)
        }

        beforeEach {
            self.app.relaunch(clean: true)
        }

        it("Accept all through CCPA & GDPR Privacy Manager") {
            // Accept all GDPR Message
            expect(self.app.gdprMessage).toEventually(showUp())
            self.app.gdprMessage.acceptAllButton.remotePress()

            // Accept All CCPA Message
            expect(self.app.ccpaMessage).toEventually(showUp())
            self.app.ccpaMessage.acceptAllButton.remotePress()

            // Wait for the messages to close and PM buttons to show
            expect(self.app.gdprPrivacyManagerButton).toEventually(showUp())
            expect(self.app.ccpaPrivacyManagerButton).toEventually(showUp())

            self.app.relaunch()

            // Assert sure no message shows up
            expect(self.app.gdprMessage.container.exists).toEventually(beFalse())
            expect(self.app.ccpaMessage.container.exists).toEventually(beFalse())

            // Assert all GDPR categories are on
            self.app.gdprPrivacyManagerButton.remotePress()
            expect(self.app.gdprMessage).toEventually(showUp())
            self.app.gdprMessage.categoriesDetailsButton.remotePress()
            expect(self.app.gdprMessage.staticTexts["Manage Preferences"].firstMatch).toEventually(showUp())
            expect(self.app.gdprMessage.tables.cells.staticTexts.containing(NSPredicate(format: "label MATCHES[c] %@", "On")).count).toEventually(equal(10))

            self.app.relaunch()

            // Assert all CCPA categories are on
            self.app.ccpaPrivacyManagerButton.remotePress()
            expect(self.app.ccpaMessage).toEventually(showUp())
            self.app.ccpaMessage.categoriesDetailsButton.remotePress()
            expect(self.app.gdprMessage.staticTexts["Manage Preferences"].firstMatch).toEventually(showUp())
            expect(self.app.gdprMessage.tables.cells.staticTexts.containing(NSPredicate(format: "label MATCHES[c] %@", "On")).count).toEventually(equal(3))
        }

        fit("Reject all through CCPA & GDPR Privacy Manager") {
            // Reject all GDPR Message
            expect(self.app.gdprMessage).toEventually(showUp())
            self.app.gdprMessage.rejectAllButton.remotePress()

            // Reject All CCPA Message
            expect(self.app.ccpaMessage).toEventually(showUp())
            self.app.ccpaMessage.rejectAllButton.remotePress()

            // Wait for the messages to close and PM buttons to show
            expect(self.app.gdprPrivacyManagerButton).toEventually(showUp())
            expect(self.app.ccpaPrivacyManagerButton).toEventually(showUp())

            self.app.relaunch()

            // Assert sure no message shows up
            expect(self.app.gdprMessage.container.exists).toEventually(beFalse())
            expect(self.app.ccpaMessage.container.exists).toEventually(beFalse())

            // Assert all GDPR categories are on
            self.app.gdprPrivacyManagerButton.remotePress()
            expect(self.app.gdprMessage).toEventually(showUp())
            self.app.gdprMessage.categoriesDetailsButton.remotePress()
            expect(self.app.gdprMessage.staticTexts["Manage Preferences"].firstMatch).toEventually(showUp())
            expect(self.app.gdprMessage.tables.cells.staticTexts.containing(NSPredicate(format: "label MATCHES[c] %@", "On")).count).toEventually(equal(0))

            self.app.relaunch()

            // Assert all CCPA categories are on
            self.app.ccpaPrivacyManagerButton.remotePress()
            expect(self.app.ccpaMessage).toEventually(showUp())
            self.app.ccpaMessage.categoriesDetailsButton.remotePress()
            expect(self.app.gdprMessage.staticTexts["Manage Preferences"].firstMatch).toEventually(showUp())
            expect(self.app.gdprMessage.tables.cells.staticTexts.containing(NSPredicate(format: "label MATCHES[c] %@", "On")).count).toEventually(equal(0))
        }

//        it("Save and Exit through CCPA & GDPR Privacy Manager") {
//            self.app.gdprPrivacyManagerButton.remotePress()
//            self.app.acceptButton.expectToHaveFocus()
//            self.app.managePreferencesButton.remotePress()
//            self.app.homeButton.expectToHaveFocus()
//            self.app.saveAndExitInternalButton.remotePress()
//            self.app.ccpaPrivacyManagerButton.remotePress()
//            self.app.acceptButton.expectToHaveFocus()
//            self.app.managePreferencesButton.remotePress()
//            self.app.homeButton.expectToHaveFocus()
//            self.app.saveAndExitInternalButton.remotePress()
//        }
//
//        it("Privacy policy of CCPA & GDPR Privacy Manager") {
//            self.app.ccpaPrivacyManagerButton.remotePress()
//            self.app.acceptButton.expectToHaveFocus()
//            self.app.privacyPolicyButton.remotePress()
//            self.app.pressHomeAndReturnToHomeViewWithFocusOnPrivacyPolicyButton()
//            self.app.acceptButton.remotePress()
//            self.app.gdprPrivacyManagerButton.remotePress()
//            self.app.acceptButton.expectToHaveFocus()
//            self.app.privacyPolicyButton.remotePress()
//            self.app.pressHomeAndReturnToHomeViewWithFocusOnPrivacyPolicyButton()
//            self.app.acceptButton.remotePress()
//        }
//
//        it("Manage Preferences through CCPA & GDPR Privacy Manager with few purposes ON") {
//            self.app.gdprPrivacyManagerButton.remotePress()
//            self.app.acceptButton.expectToHaveFocus()
//            self.app.managePreferencesButton.remotePress()
//            expect(self.app.homeButton).toEventually(showUp())
//            self.app.pressCategory(element: self.app.storeAndAccessInformation)
//            self.app.pressOnButtonInCategoryDetails(elementToEnsure: self.app.storeAndAccessInformation)
//            self.app.pressSaveAndExitInCategory()
//            self.app.ccpaPrivacyManagerButton.remotePress()
//            self.app.acceptButton.expectToHaveFocus()
//            self.app.managePreferencesButton.remotePress()
//            expect(self.app.homeButton).toEventually(showUp())
//            self.app.pressCategory(element: self.app.category)
//            self.app.pressOnButtonInCategoryDetails(elementToEnsure: self.app.category2)
//            self.app.pressSaveAndExitInCategory()
//        }
//
//        it("Manage Preferences through CCPA & GDPR Privacy Manager with few purposes OFF") {
//            self.app.gdprPrivacyManagerButton.remotePress()
//            self.app.acceptButton.expectToHaveFocus()
//            self.app.managePreferencesButton.remotePress()
//            expect(self.app.homeButton).toEventually(showUp())
//            self.app.pressCategory(element: self.app.storeAndAccessInformation)
//            self.app.pressOffButtonInCategoryDetails(elementToEnsure: self.app.storeAndAccessInformation)
//            self.app.pressSaveAndExitInCategory()
//            self.app.ccpaPrivacyManagerButton.remotePress()
//            self.app.acceptButton.expectToHaveFocus()
//            self.app.managePreferencesButton.remotePress()
//            expect(self.app.homeButton).toEventually(showUp())
//            self.app.pressCategory(element: self.app.category)
//            self.app.pressOffButtonInCategoryDetails(elementToEnsure: self.app.category2)
//            self.app.pressSaveAndExitInCategory()
//        }
//
//        it("Our Partners through CCPA & GDPR Privacy Manager with few purposes On") {
//            self.app.gdprPrivacyManagerButton.remotePress()
//            self.app.acceptButton.expectToHaveFocus()
//            self.app.ourPartnersButton.remotePress()
//            expect(self.app.homeButton).toEventually(showUp())
//            self.app.pressCategory(element: self.app.loopMe)
//            self.app.pressOnButtonInCategoryDetails(elementToEnsure: self.app.googleCharts)
//            self.app.pressSaveAndExitInCategory()
//            self.app.ccpaPrivacyManagerButton.remotePress()
//            self.app.acceptButton.expectToHaveFocus()
//            self.app.ourPartnersButton.remotePress()
//            expect(self.app.homeButton).toEventually(showUp())
//            self.app.pressCategory(element: self.app.freewheel)
//            self.app.pressOnButtonInCategoryDetails(elementToEnsure: self.app.seedtag)
//            self.app.pressSaveAndExitInCategory()
//        }
//
//        it("Our Partners through CCPA & GDPR Privacy Manager with few purposes OFF") {
//            self.app.gdprPrivacyManagerButton.remotePress()
//            self.app.acceptButton.expectToHaveFocus()
//            self.app.ourPartnersButton.remotePress()
//            expect(self.app.homeButton).toEventually(showUp())
//            self.app.pressCategory(element: self.app.loopMe)
//            self.app.pressOffButtonInCategoryDetails(elementToEnsure: self.app.googleCharts)
//            self.app.pressSaveAndExitInCategory()
//            self.app.ccpaPrivacyManagerButton.remotePress()
//            self.app.acceptButton.expectToHaveFocus()
//            self.app.ourPartnersButton.remotePress()
//            expect(self.app.homeButton).toEventually(showUp())
//            self.app.pressCategory(element: self.app.freewheel)
//            self.app.pressOffButtonInCategoryDetails(elementToEnsure: self.app.seedtag)
//            self.app.pressSaveAndExitInCategory()
//        }
//
//        it("Manage Preferences through GDPR Privacy Manager with few Legitimate interest purposes ON") {
//            self.app.gdprPrivacyManagerButton.remotePress()
//            self.app.acceptButton.expectToHaveFocus()
//            self.app.managePreferencesButton.remotePress()
//            expect(self.app.homeButton).toEventually(showUp())
//            self.app.switchToLegitInterests()
//            self.app.pressCategory(element: self.app.createPersonalisedAdsProfile)
//            self.app.pressOnButtonInCategoryDetails(elementToEnsure: self.app.createPersonalisedAdsProfile)
//            self.app.pressSaveAndExitInCategory()
//        }
//
//        it("Manage Preferences through GDPR Privacy Manager with few Legitimate interest purposes OFF") {
//            self.app.gdprPrivacyManagerButton.remotePress()
//            self.app.acceptButton.expectToHaveFocus()
//            self.app.managePreferencesButton.remotePress()
//            expect(self.app.homeButton).toEventually(showUp())
//            self.app.switchToLegitInterests()
//            self.app.pressCategory(element: self.app.createPersonalisedAdsProfile)
//            self.app.pressOffButtonInCategoryDetails(elementToEnsure: self.app.createPersonalisedAdsProfile)
//            self.app.pressSaveAndExitInCategory()
//        }
//
//        it("Our Partners through GDPR Privacy Manager with few Legitimate interest purposes ON") {
//            self.app.gdprPrivacyManagerButton.remotePress()
//            self.app.acceptButton.expectToHaveFocus()
//            self.app.ourPartnersButton.remotePress()
//            expect(self.app.homeButton).toEventually(showUp())
//            self.app.switchToLegitInterests()
//            self.app.pressCategory(element: self.app.loopMe)
//            self.app.backButton.expectToHaveFocus()
//            self.app.pressOnButtonInCategoryDetails(elementToEnsure: self.app.loopMe)
//            self.app.pressSaveAndExitInCategory()
//        }
//
//        it("Our Partners through GDPR Privacy Manager with few Legitimate interest purposes Off") {
//            self.app.gdprPrivacyManagerButton.remotePress()
//            self.app.acceptButton.expectToHaveFocus()
//            self.app.ourPartnersButton.remotePress()
//            expect(self.app.homeButton).toEventually(showUp())
//            self.app.switchToLegitInterests()
//            self.app.pressCategory(element: self.app.loopMe)
//            self.app.backButton.expectToHaveFocus()
//            self.app.pressOffButtonInCategoryDetails(elementToEnsure: self.app.loopMe)
//            self.app.pressSaveAndExitInCategory()
//        }
    }
}
