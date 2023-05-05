//
//  NativePMUITests.swift
//  NativePMExampleAppUITests
//
//  Created by Vilas on 27/09/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

// swiftlint:disable function_body_length

@testable import NativePMExampleApp
import Nimble
import Quick
import XCTest

extension QuickSpec {
    var remote: XCUIRemote { XCUIRemote.shared }
}

extension XCUIElement {
    var remote: XCUIRemote { XCUIRemote.shared }
}

class NativePMUITests: QuickSpec {
    var app: NativePMApp!
    var timeout = 20
    var gdprCategoriesCount = 10
    var ccpaCategoriesCount = 3
    var gdprCategoriePlusSpecialFeatures = 11

    override func setUp() {
        continueAfterFailure = false
    }

    func waitFor(_ element: XCUIElement) {
        _ = element.waitForExistence(timeout: TimeInterval(timeout))
    }

    func checkForAllCategories(on element: XCUIElement, shouldBe onOrOf: String, totalCategories: Int) {
        waitFor(element.staticTexts["Manage Preferences"].firstMatch)
        expect(element.tables.cells.staticTexts.containing(NSPredicate(format: "label MATCHES[c] %@", onOrOf)).count).toEventually(equal(totalCategories))
    }

    override func spec() {
        beforeSuite {
            self.continueAfterFailure = false
            self.app = NativePMApp()
            Nimble.AsyncDefaults.timeout = .seconds(self.timeout)
            Nimble.AsyncDefaults.pollInterval = .milliseconds(500)
        }

        afterSuite {
            Nimble.AsyncDefaults.timeout = .seconds(1)
            Nimble.AsyncDefaults.pollInterval = .milliseconds(100)
        }

        it("Accept all through CCPA & GDPR Privacy Manager") {
            self.app.relaunch(clean: true)

            // Accept all GDPR Message
            self.waitFor(self.app.gdprMessage)
            self.app.gdprMessage.acceptAllButton.remotePress()

            // Accept All CCPA Message
            self.waitFor(self.app.ccpaMessage)
            self.app.ccpaMessage.acceptAllButton.remotePress()

            // Wait for the messages to close and PM buttons to show
            expect(self.app.sdkStatusLabel).toEventually(containText("(SDK done)"))

            self.app.relaunch()

            // Assert sure no message shows up
            expect(self.app.sdkStatusLabel).toEventually(containText("(SDK done)"))

            // Assert all GDPR categories are on
            self.app.gdprPrivacyManagerButton.remotePress()
            self.waitFor(self.app.gdprMessage)
            self.app.gdprMessage.categoriesDetailsButton.remotePress()
            self.checkForAllCategories(on: self.app.gdprMessage, shouldBe: "On", totalCategories: self.gdprCategoriesCount)

            self.app.relaunch()

            // Assert all CCPA categories are on
            self.app.ccpaPrivacyManagerButton.remotePress()
            self.waitFor(self.app.ccpaMessage)
            self.app.ccpaMessage.categoriesDetailsButton.remotePress()
            self.checkForAllCategories(on: self.app.ccpaMessage, shouldBe: "On", totalCategories: self.ccpaCategoriesCount)
        }

        it("Reject all through CCPA & GDPR Privacy Manager") {
            self.app.relaunch(clean: true)

            // Accept all GDPR Message
            self.waitFor(self.app.gdprMessage)
            self.app.gdprMessage.rejectAllButton.remotePress()

            // Accept All CCPA Message
            self.waitFor(self.app.ccpaMessage)
            self.app.ccpaMessage.rejectAllButton.remotePress()

            // Wait for the messages to close and PM buttons to show
            expect(self.app.sdkStatusLabel).toEventually(containText("(SDK done)"))

            self.app.relaunch()

            // Assert sure no message shows up
            expect(self.app.sdkStatusLabel).toEventually(containText("(SDK done)"))

            // Assert all GDPR categories are on
            self.app.gdprPrivacyManagerButton.remotePress()
            self.waitFor(self.app.gdprMessage)
            self.app.gdprMessage.categoriesDetailsButton.remotePress()
            self.checkForAllCategories(on: self.app.gdprMessage, shouldBe: "Off", totalCategories: self.gdprCategoriePlusSpecialFeatures)

            self.app.relaunch()

            // Assert all CCPA categories are on
            self.app.ccpaPrivacyManagerButton.remotePress()
            self.waitFor(self.app.ccpaMessage)
            self.app.ccpaMessage.categoriesDetailsButton.remotePress()
            self.checkForAllCategories(on: self.app.ccpaMessage, shouldBe: "Off", totalCategories: self.ccpaCategoriesCount)
        }

        it("Do not sell button toggles on/off when rejecting / accepting all") {
            self.app.relaunch(clean: true, gdpr: false, ccpa: true)

            expect(self.app.ccpaMessage).toEventually(showUp())
            self.app.remote.press(.right)
            expect(self.app.ccpaMessage.doNotSellMyInfoButton.staticTexts["OFF"]).toEventually(showUp())
            self.app.ccpaMessage.doNotSellMyInfoButton.remotePress()
            expect(self.app.ccpaMessage.doNotSellMyInfoButton.staticTexts["ON"]).toEventually(showUp())
            self.app.remote.press(.left)
            self.app.ccpaMessage.saveAndExitButton.remotePress()
            expect(self.app.sdkStatusLabel).toEventually(containText("(SDK done)"))

            self.app.relaunch(clean: false, gdpr: false, ccpa: true)

            self.app.ccpaPrivacyManagerButton.remotePress()
            expect(self.app.ccpaMessage).toEventually(showUp())
            expect(self.app.ccpaMessage.doNotSellMyInfoButton.staticTexts["ON"]).toEventually(showUp())
            self.app.remote.press(.right)
            self.app.ccpaMessage.doNotSellMyInfoButton.remotePress()
            expect(self.app.ccpaMessage.doNotSellMyInfoButton.staticTexts["OFF"]).toEventually(showUp())
            self.app.remote.press(.left)
            self.app.ccpaMessage.saveAndExitButton.remotePress()
            expect(self.app.sdkStatusLabel).toEventually(containText("(SDK done)"))

            self.app.relaunch(clean: false, gdpr: false, ccpa: true)

            self.app.ccpaPrivacyManagerButton.remotePress()
            expect(self.app.ccpaMessage.doNotSellMyInfoButton.staticTexts["OFF"]).toEventually(showUp())
        }

        fit("Handles message translation") {
            self.app.relaunch(clean: true, language: .Spanish)

            // Message content is translated
            expect(self.app.gdprMessage.headerTitle).toEventually(containText("Mensage GDPR"))

            // as well as categories
            expect(self.app.gdprMessage.categoriesList.staticTexts["Almacenar o acceder a información en un dispositivo"].exists).toEventually(beTrue())
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
