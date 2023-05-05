//
//  NativePMApp.swift
//  NativePMExampleAppUITests
//
//  Created by Vilas on 27/09/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Nimble
import XCTest
import ConsentViewController

protocol App {
    func launch()
    func terminate()
    func relaunch(clean: Bool, gdpr: Bool, ccpa: Bool, language: SPMessageLanguage)
}

extension XCUIApplication: App {
    func setArgument(_ name: String, _ value: Bool) {
        value ?
            launchArguments.append("-\(name)") :
            launchArguments.removeAll { $0 == "-\(name)" }
    }

    func setArgument(_ name: String, _ value: String) {
        launchArguments.append("-\(name)=\(value)")
    }

    func relaunch(clean: Bool = false, gdpr: Bool = true, ccpa: Bool = true, language: SPMessageLanguage = .BrowserDefault) {
        UserDefaults.standard.synchronize()
        self.terminate()
        setArgument("cleanAppsData", clean)
        setArgument("gdpr", gdpr)
        setArgument("ccpa", ccpa)
        setArgument("lang", language.rawValue)
        launch()
    }
}

class NativePMApp: XCUIApplication {
    class GDPRMessage: XCUIApplication {
        var container: XCUIElement {
            otherElements["GDPR Message"]
        }
        var headerTitle: XCUIElement { container.staticTexts["Header Title"] }
        var acceptAllButton: XCUIElement { container.buttons["Accept"].firstMatch }
        var rejectAllButton: XCUIElement { container.buttons["Reject All"] }
        var categoriesDetailsButton: XCUIElement { container.buttons["Manage Preferences"] }
        var vendorsDetailsButton: XCUIElement { container.buttons["Our Partners"] }
        var privacyPolicyButton: XCUIElement { container.buttons["Privacy Policy"] }
        var categoriesList: XCUIElement { container.tables["Categories List"] }
    }

    class CCPAMessage: XCUIApplication {
        var container: XCUIElement {
            windows.containing(.staticText, identifier: "CCPA Message").firstMatch
        }

        var doNotSellMyInfoButton: XCUIElement {
            container.cells.containing(.staticText, identifier: "Do Not Sell My Personal Data").firstMatch
        }
        var acceptAllButton: XCUIElement { container.buttons["Accept"] }
        var rejectAllButton: XCUIElement { container.buttons["Reject All"] }
        var saveAndExitButton: XCUIElement { container.buttons["Save and Exit"] }
        var categoriesDetailsButton: XCUIElement { container.buttons["Manage Preferences"] }
        var vendorsDetailsButton: XCUIElement { container.buttons["Our Partners"] }
        var privacyPolicyButton: XCUIElement { container.buttons["Privacy Policy"] }
    }

    let gdprMessage = GDPRMessage()
    let ccpaMessage = CCPAMessage()

    var doNotSellMyPersonalInformation: XCUIElement {
        tables.cells.containing(.staticText, identifier: "Do Not Sell My Personal Information").firstMatch
    }

    var category: XCUIElement {
        tables.cells.containing(.staticText, identifier: "Purpose 1").firstMatch
    }

    var category2: XCUIElement {
        tables.cells.containing(.staticText, identifier: "Purpose 2").firstMatch
    }

    var storeAndAccessInformation: XCUIElement {
        tables.cells.containing(.staticText, identifier: "Store and/or access information on a device").firstMatch
    }

    var createPersonalisedAdsProfile: XCUIElement {
        tables.cells.containing(.staticText, identifier: "Create a personalised ads profile").firstMatch
    }

    var seedtag: XCUIElement {
        tables.cells.containing(.staticText, identifier: "Seedtag Advertising S.L").firstMatch
    }

    var freewheel: XCUIElement {
        tables.cells.containing(.staticText, identifier: "Freewheel").firstMatch
    }

    var justpremiumBV: XCUIElement {
        tables.cells.containing(.staticText, identifier: "Justpremium BV").firstMatch
    }

    var loopMe: XCUIElement {
        tables.cells.containing(.staticText, identifier: "LoopMe Limited").firstMatch
    }

    var googleCharts: XCUIElement {
        tables.cells.containing(.staticText, identifier: "Google Charts").firstMatch
    }

    var gameAccounts: XCUIElement {
        tables.cells.containing(.staticText, identifier: "Game Accounts").firstMatch
    }

    var acceptButton: XCUIElement {
        buttons["Accept"]
    }

    var acceptAllButton: XCUIElement {
        buttons["Accept All"]
    }

    var managePreferencesButton: XCUIElement {
        buttons["Manage Preferences"]
    }

    var rejectAllButton: XCUIElement {
        buttons["Reject All"]
    }

    var saveAndExitButton: XCUIElement {
        buttons["Save and Exit"]
    }

    var saveAndExitInternalButton: XCUIElement {
        buttons["Save & Exit"]
    }

    var homeButton: XCUIElement {
        buttons["Home"]
    }

    var backButton: XCUIElement {
        buttons["Back"]
    }

    var onButton: XCUIElement {
        buttons["On"]
    }

    var offButton: XCUIElement {
        buttons["Off"]
    }

    var privacyPolicyButton: XCUIElement {
        buttons["Privacy Policy"]
    }

    var consentButton: XCUIElement {
        buttons["CONSENT"]
    }

    var legitimateInterestButton: XCUIElement {
        buttons["LEGITIMATE INTEREST"]
    }

    var ourPartnersButton: XCUIElement {
        buttons["Our Partners"]
    }

    var gdprPrivacyManagerButton: XCUIElement {
        buttons["GDPR Privacy Manager"]
    }

    var ccpaPrivacyManagerButton: XCUIElement {
        buttons["CCPA Privacy Manager"]
    }

    var sdkStatusLabel: XCUIElement {
        staticTexts["sdkStatusLabel"]
    }
}

// MARK: - NativePMApp actions
extension NativePMApp {
    func pressDoNotSellButton() {
        remote.press(.right)
        remote.press(.select)
        remote.press(.left)
    }

    func pressStoreAndAccessInformation() {
        remote.press(.right)
        remote.press(.up)
        storeAndAccessInformation.expectToHaveFocus()
        remote.press(.select)
        remote.press(.down)
        remote.press(.left)
    }

    func pressHomeAndReturnToHomeViewWithFocusOnPrivacyPolicyButton() {
        expect(self.homeButton).toEventually(showUp())
        remote.press(.select)
        privacyPolicyButton.expectToHaveFocus()
    }

    func pressCategory(element: XCUIElement) {
        remote.press(.down)
        if acceptAllButton.hasFocus {
            acceptAllButton.expectToHaveFocus()
            remote.press(.right)
        }
        expectToHaveFocus()
        remote.press(.select)
    }

    func pressOnButtonInCategoryDetails(elementToEnsure: XCUIElement) {
        backButton.expectToHaveFocus()
        remote.press(.down)
        onButton.expectToHaveFocus()
        remote.press(.select)
        elementToEnsure.expectToHaveFocus()
    }

    func pressOffButtonInCategoryDetails(elementToEnsure: XCUIElement) {
        backButton.expectToHaveFocus()
        remote.press(.down)
        onButton.expectToHaveFocus()
        remote.press(.down)
        offButton.expectToHaveFocus()
        remote.press(.select)
        elementToEnsure.expectToHaveFocus()
    }

    func pressSaveAndExitInCategory() {
        remote.press(.left)
        acceptAllButton.expectToHaveFocus()
        remote.press(.down)
        saveAndExitInternalButton.expectToHaveFocus()
        remote.press(.select)
    }

    func switchToLegitInterests() {
        remote.press(.right)
        remote.press(.right)
        legitimateInterestButton.expectToHaveFocus()
    }
}

extension XCUIElement {
    func remotePressUntilFocus(direction: XCUIRemote.Button) {
        var counter = 0
        while !self.hasFocus && counter < 10 {
            remote.press(direction)
            counter += 1
        }
    }

    func expectToHaveFocus() {
        expect(self).toEventually(showUp())
        expect(self.hasFocus) == true
    }

    func remotePress() {
        if waitForExistence(timeout: 5) {
            remotePressUntilFocus(direction: .down)
            remotePressUntilFocus(direction: .up)
            expectToHaveFocus()
            remote.press(.select)
        }
    }
}
