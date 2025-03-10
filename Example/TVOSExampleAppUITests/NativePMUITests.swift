//
//  NativePMUITests.swift
//  TVOSExampleAppUITests
//
//  Created by Vilas on 27/09/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

// swiftlint:disable function_body_length

@testable import TVOSExampleApp
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
    var gdprCategoriesCount = 12
    var ccpaCategoriesCount = 3
    var gdprCategoriePlusSpecialFeatures = 12
    var gdprDefaultOnCategories = 3

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

    func checkForAllVendors(on element: XCUIElement, shouldBe onOrOf: String, totalVendors: Int) {
        waitFor(element.staticTexts["Our Partners"].firstMatch)
        expect(element.tables.cells.staticTexts.containing(NSPredicate(format: "label MATCHES[c] %@", onOrOf)).count).toEventually(equal(totalVendors))
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
            self.app.ccpaMessage.doNotSellMyInfoButton.remotePress(extraMove: .right)
            expect(self.app.ccpaMessage.doNotSellMyInfoButton.staticTexts["ON"]).toEventually(showUp())
            self.app.remote.press(.left)
            self.app.ccpaMessage.saveAndExitButton.remotePress()
            expect(self.app.sdkStatusLabel).toEventually(containText("(SDK done)"))

            self.app.relaunch(clean: false, gdpr: false, ccpa: true)

            self.app.ccpaPrivacyManagerButton.remotePress()
            expect(self.app.ccpaMessage).toEventually(showUp())
            expect(self.app.ccpaMessage.doNotSellMyInfoButton.staticTexts["ON"]).toEventually(showUp())
            self.app.remote.press(.right)
            self.app.ccpaMessage.doNotSellMyInfoButton.remotePress(extraMove: .right)
            expect(self.app.ccpaMessage.doNotSellMyInfoButton.staticTexts["OFF"]).toEventually(showUp())
            self.app.remote.press(.left)
            self.app.ccpaMessage.saveAndExitButton.remotePress()
            expect(self.app.sdkStatusLabel).toEventually(containText("(SDK done)"))

            self.app.relaunch(clean: false, gdpr: false, ccpa: true)

            self.app.ccpaPrivacyManagerButton.remotePress()
            expect(self.app.ccpaMessage.doNotSellMyInfoButton.staticTexts["OFF"]).toEventually(showUp())
        }

        it("Handles message translation via 1st layer") {
            self.app.relaunch(clean: true, language: .Spanish)

            // Message content is translated
            expect(self.app.gdprMessage.headerTitle).toEventually(containText("Mensage GDPR"))

            // as well as categories
            expect(self.app.gdprMessage.categoriesList.staticTexts["Crear perfiles para publicidad personalizada"].exists).toEventually(beTrue())
        }
        
        it("Handles message translation when loading PM via function") {
            self.app.relaunch(clean: true, gdpr: true, ccpa: false, language: .Spanish)

            self.waitFor(self.app.gdprMessage)
            self.remote.press(.select)

            self.app.gdprPrivacyManagerButton.remotePress()
            self.waitFor(self.app.gdprMessage)
            
            expect(self.app.gdprMessage.headerTitle).toEventually(containText("Mensage GDPR"))
            expect(self.app.gdprMessage.categoriesList.staticTexts["Crear perfiles para publicidad personalizada"].exists).toEventually(beTrue())
        }

        it("Manage Preferences and Our Vendors through GDPR Privacy Manager with few consent purposes ON") {
            self.app.relaunch(clean: true, gdpr: true, ccpa: false)
            self.app.gdprPrivacyManagerButton.remotePress()
            self.app.acceptButton.expectToHaveFocus()

            self.app.ourPartnersButton.remotePress()
            self.checkForAllVendors(on: self.app.gdprMessage, shouldBe: "On", totalVendors: 0)
            self.app.homeButton.remotePress()

            self.app.managePreferencesButton.remotePress()
            expect(self.app.homeButton).toEventually(showUp())
            self.app.pressCategory(element: self.app.storeAndAccessInformation)
            self.app.pressOnButtonInCategoryDetails()
            self.app.backToHomeButton()
            self.app.homeButton.remotePress()
            self.app.ourPartnersButton.remotePress()
            self.checkForAllVendors(on: self.app.gdprMessage, shouldBe: "On", totalVendors: 4)
            self.app.homeButton.remotePress()

            self.app.managePreferencesButton.remotePress()
            expect(self.app.homeButton).toEventually(showUp())
            self.app.pressCategory(element: self.app.createPersonalisedAdsProfile)
            self.app.pressOnButtonInCategoryDetails()
            self.app.backToHomeButton()
            self.app.homeButton.remotePress()
            self.app.ourPartnersButton.remotePress()
            self.checkForAllVendors(on: self.app.gdprMessage, shouldBe: "On", totalVendors: 5)
            self.remote.press(.down)
            self.remote.press(.down)
            self.app.saveAndExitInternalButton.remotePress()

            self.app.gdprPrivacyManagerButton.remotePress()
            self.app.acceptButton.expectToHaveFocus()
            self.app.managePreferencesButton.remotePress()
            self.checkForAllCategories(on: self.app.gdprMessage, shouldBe: "On", totalCategories: 2)
            self.app.homeButton.remotePress()
            self.app.ourPartnersButton.remotePress()
            self.checkForAllVendors(on: self.app.gdprMessage, shouldBe: "On", totalVendors: 5)
        }

        it("Check default toggles status on Manage Preferences and Our Vendors through GDPR Privacy Manager") {
            self.app.relaunch(clean: true, gdpr: true, ccpa: false)
            self.app.acceptButton.expectToHaveFocus()
            self.app.managePreferencesButton.remotePress()
            self.checkForAllCategories(on: self.app.gdprMessage, shouldBe: "On", totalCategories: 0)
            self.remote.press(.right)
            self.remote.press(.right)
            self.checkForAllCategories(on: self.app.gdprMessage, shouldBe: "On", totalCategories: self.gdprDefaultOnCategories)
            self.app.backToHomeButton()
            self.app.homeButton.remotePress()
            self.app.ourPartnersButton.remotePress()
            self.checkForAllVendors(on: self.app.gdprMessage, shouldBe: "On", totalVendors: 0)
            self.remote.press(.right)
            self.remote.press(.right)
            self.checkForAllVendors(on: self.app.gdprMessage, shouldBe: "On", totalVendors: self.gdprDefaultOnCategories)
            self.app.backToHomeButton()
            self.remote.press(.down)
            self.remote.press(.down)
            self.app.saveAndExitInternalButton.remotePress()
            self.app.gdprPrivacyManagerButton.remotePress()
            self.app.acceptButton.expectToHaveFocus()
            self.app.managePreferencesButton.remotePress()
            self.checkForAllCategories(on: self.app.gdprMessage, shouldBe: "On", totalCategories: 0)
            self.remote.press(.right)
            self.remote.press(.right)
            self.checkForAllCategories(on: self.app.gdprMessage, shouldBe: "On", totalCategories: self.gdprDefaultOnCategories)
            self.app.backToHomeButton()
            self.app.homeButton.remotePress()
            self.app.ourPartnersButton.remotePress()
            self.checkForAllVendors(on: self.app.gdprMessage, shouldBe: "On", totalVendors: 0)
            self.remote.press(.right)
            self.remote.press(.right)
            self.checkForAllVendors(on: self.app.gdprMessage, shouldBe: "On", totalVendors: self.gdprDefaultOnCategories)
        }
    }
}
