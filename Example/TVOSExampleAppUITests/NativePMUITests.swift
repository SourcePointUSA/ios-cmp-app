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
    static var remote: XCUIRemote { XCUIRemote.shared }
}

extension XCUIElement {
    var remote: XCUIRemote { XCUIRemote.shared }
}

class NativePMUITests: QuickSpec {
    static var app: NativePMApp!
    static var timeout = 20
    static var gdprCategoriesCount = 12
    static var ccpaCategoriesCount = 3
    static var gdprCategoriePlusSpecialFeatures = 12
    static var gdprDefaultOnCategories = 3
    static var gdprVendors = 4

    override func setUp() {
        continueAfterFailure = false
    }

    static func waitFor(_ element: XCUIElement) {
        _ = element.waitForExistence(timeout: TimeInterval(NativePMUITests.timeout))
    }

    static func checkForAllCategories(on element: XCUIElement, shouldBe onOrOf: String, totalCategories: Int) {
        waitFor(element.staticTexts["Manage Preferences"].firstMatch)
        expect(element.tables.cells.staticTexts.containing(NSPredicate(format: "label MATCHES[c] %@", onOrOf)).count).toEventually(equal(totalCategories))
    }

    static func checkForAllVendors(on element: XCUIElement, shouldBe onOrOf: String, totalVendors: Int) {
        waitFor(element.staticTexts["Our Partners"].firstMatch)
        expect(element.tables.cells.staticTexts.containing(NSPredicate(format: "label MATCHES[c] %@", onOrOf)).count).toEventually(equal(totalVendors))
    }

    override class func spec() {
        beforeSuite {
            app = NativePMApp()
            Nimble.PollingDefaults.timeout = .seconds(timeout)
            Nimble.PollingDefaults.pollInterval = .milliseconds(500)
        }

        afterSuite {
            Nimble.PollingDefaults.timeout = .seconds(1)
            Nimble.PollingDefaults.pollInterval = .milliseconds(100)
        }

        it("Accept all through CCPA & GDPR Privacy Manager") {
            app.relaunch(clean: true)

            // Accept all GDPR Message
            waitFor(app.gdprMessage)
            app.gdprMessage.acceptAllButton.remotePress()

            // Accept All CCPA Message
            waitFor(app.ccpaMessage)
            app.ccpaMessage.acceptAllButton.remotePress()

            // Wait for the messages to close and PM buttons to show
            expect(app.sdkStatusLabel).toEventually(containText("(SDK done)"))

            app.relaunch()

            // Assert sure no message shows up
            expect(app.sdkStatusLabel).toEventually(containText("(SDK done)"))

            // Assert all GDPR categories are on
            app.gdprPrivacyManagerButton.remotePress()
            waitFor(app.gdprMessage)
            app.gdprMessage.categoriesDetailsButton.remotePress()
            checkForAllCategories(on: app.gdprMessage, shouldBe: "On", totalCategories: gdprCategoriesCount)

            app.relaunch()

            // Assert all CCPA categories are on
            app.ccpaPrivacyManagerButton.remotePress()
            waitFor(app.ccpaMessage)
            app.ccpaMessage.categoriesDetailsButton.remotePress()
            checkForAllCategories(on: app.ccpaMessage, shouldBe: "On", totalCategories: ccpaCategoriesCount)
        }

        it("Reject all through CCPA & GDPR Privacy Manager") {
            app.relaunch(clean: true)

            // Accept all GDPR Message
            waitFor(app.gdprMessage)
            app.gdprMessage.rejectAllButton.remotePress()

            // Accept All CCPA Message
            waitFor(app.ccpaMessage)
            app.ccpaMessage.rejectAllButton.remotePress()

            // Wait for the messages to close and PM buttons to show
            expect(app.sdkStatusLabel).toEventually(containText("(SDK done)"))

            app.relaunch()

            // Assert sure no message shows up
            expect(app.sdkStatusLabel).toEventually(containText("(SDK done)"))

            // Assert all GDPR categories are on
            app.gdprPrivacyManagerButton.remotePress()
            waitFor(app.gdprMessage)
            app.gdprMessage.categoriesDetailsButton.remotePress()
            checkForAllCategories(on: app.gdprMessage, shouldBe: "Off", totalCategories: gdprCategoriePlusSpecialFeatures)

            app.relaunch()

            // Assert all CCPA categories are on
            app.ccpaPrivacyManagerButton.remotePress()
            waitFor(app.ccpaMessage)
            app.ccpaMessage.categoriesDetailsButton.remotePress()
            checkForAllCategories(on: app.ccpaMessage, shouldBe: "Off", totalCategories: ccpaCategoriesCount)
        }

        it("Do not sell button toggles on/off when rejecting / accepting all") {
            app.relaunch(clean: true, gdpr: false, ccpa: true)

            expect(app.ccpaMessage).toEventually(showUp())
            app.remote.press(.right)
            expect(app.ccpaMessage.doNotSellMyInfoButton.staticTexts["OFF"]).toEventually(showUp())
            app.ccpaMessage.doNotSellMyInfoButton.remotePress(extraMove: .right)
            expect(app.ccpaMessage.doNotSellMyInfoButton.staticTexts["ON"]).toEventually(showUp())
            app.remote.press(.left)
            app.ccpaMessage.saveAndExitButton.remotePress()
            expect(app.sdkStatusLabel).toEventually(containText("(SDK done)"))

            app.relaunch(clean: false, gdpr: false, ccpa: true)

            app.ccpaPrivacyManagerButton.remotePress()
            expect(app.ccpaMessage).toEventually(showUp())
            expect(app.ccpaMessage.doNotSellMyInfoButton.staticTexts["ON"]).toEventually(showUp())
            app.remote.press(.right)
            app.ccpaMessage.doNotSellMyInfoButton.remotePress(extraMove: .right)
            expect(app.ccpaMessage.doNotSellMyInfoButton.staticTexts["OFF"]).toEventually(showUp())
            app.remote.press(.left)
            app.ccpaMessage.saveAndExitButton.remotePress()
            expect(app.sdkStatusLabel).toEventually(containText("(SDK done)"))

            app.relaunch(clean: false, gdpr: false, ccpa: true)

            app.ccpaPrivacyManagerButton.remotePress()
            expect(app.ccpaMessage.doNotSellMyInfoButton.staticTexts["OFF"]).toEventually(showUp())
        }

        it("Handles message translation via 1st layer") {
            app.relaunch(clean: true, language: .Spanish)

            // Message content is translated
            expect(app.gdprMessage.headerTitle).toEventually(containText("Mensage GDPR"))

            // as well as categories
            expect(app.gdprMessage.categoriesList.staticTexts["Crear perfiles para publicidad personalizada"].exists).toEventually(beTrue())
        }
        
        it("Handles message translation when loading PM via function") {
            app.relaunch(clean: true, gdpr: true, ccpa: false, language: .Spanish)

            waitFor(app.gdprMessage)
            remote.press(.select)

            app.gdprPrivacyManagerButton.remotePress()
            waitFor(app.gdprMessage)
            
            expect(app.gdprMessage.headerTitle).toEventually(containText("Mensage GDPR"))
            expect(app.gdprMessage.categoriesList.staticTexts["Crear perfiles para publicidad personalizada"].exists).toEventually(beTrue())
        }

        it("Manage Preferences and Our Vendors through GDPR Privacy Manager with few consent purposes ON") {
            app.relaunch(clean: true, gdpr: true, ccpa: false)
            app.gdprPrivacyManagerButton.remotePress()
            app.acceptButton.expectToHaveFocus()

            app.ourPartnersButton.remotePress()
            checkForAllVendors(on: app.gdprMessage, shouldBe: "On", totalVendors: 0)
            app.homeButton.remotePress()

            app.managePreferencesButton.remotePress()
            expect(app.homeButton).toEventually(showUp())
            app.pressCategory(element: app.storeAndAccessInformation)
            app.pressOnButtonInCategoryDetails()
            app.backToHomeButton()
            app.homeButton.remotePress()
            app.ourPartnersButton.remotePress()
            checkForAllVendors(on: app.gdprMessage, shouldBe: "On", totalVendors: 3)
            app.homeButton.remotePress()

            app.managePreferencesButton.remotePress()
            expect(app.homeButton).toEventually(showUp())
            app.pressCategory(element: app.createPersonalisedAdsProfile)
            app.pressOnButtonInCategoryDetails()
            app.backToHomeButton()
            app.homeButton.remotePress()
            app.ourPartnersButton.remotePress()
            checkForAllVendors(on: app.gdprMessage, shouldBe: "On", totalVendors: 3)
            remote.press(.down)
            remote.press(.down)
            app.saveAndExitInternalButton.remotePress()

            app.gdprPrivacyManagerButton.remotePress()
            app.acceptButton.expectToHaveFocus()
            app.managePreferencesButton.remotePress()
            checkForAllCategories(on: app.gdprMessage, shouldBe: "On", totalCategories: 2)
            app.homeButton.remotePress()
            app.ourPartnersButton.remotePress()
            checkForAllVendors(on: app.gdprMessage, shouldBe: "On", totalVendors: 4)
        }

        it("Check default toggles status on Manage Preferences and Our Vendors through GDPR Privacy Manager") {
            app.relaunch(clean: true, gdpr: true, ccpa: false)
            app.acceptButton.expectToHaveFocus()
            app.managePreferencesButton.remotePress()
            checkForAllCategories(on: app.gdprMessage, shouldBe: "On", totalCategories: 0)
            remote.press(.right)
            remote.press(.right)
            checkForAllCategories(on: app.gdprMessage, shouldBe: "On", totalCategories: gdprDefaultOnCategories)
            app.backToHomeButton()
            app.homeButton.remotePress()
            app.ourPartnersButton.remotePress()
            checkForAllVendors(on: app.gdprMessage, shouldBe: "On", totalVendors: 0)
            remote.press(.right)
            remote.press(.right)
            checkForAllVendors(on: app.gdprMessage, shouldBe: "On", totalVendors: gdprDefaultOnCategories)
            app.backToHomeButton()
            remote.press(.down)
            remote.press(.down)
            app.saveAndExitInternalButton.remotePress()
            app.gdprPrivacyManagerButton.remotePress()
            app.acceptButton.expectToHaveFocus()
            app.managePreferencesButton.remotePress()
            checkForAllCategories(on: app.gdprMessage, shouldBe: "On", totalCategories: 0)
            remote.press(.right)
            remote.press(.right)
            checkForAllCategories(on: app.gdprMessage, shouldBe: "On", totalCategories: gdprDefaultOnCategories)
            app.backToHomeButton()
            app.homeButton.remotePress()
            app.ourPartnersButton.remotePress()
            checkForAllVendors(on: app.gdprMessage, shouldBe: "On", totalVendors: 0)
            remote.press(.right)
            remote.press(.right)
            checkForAllVendors(on: app.gdprMessage, shouldBe: "On", totalVendors: gdprDefaultOnCategories)
        }
    }
}
