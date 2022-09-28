//
//  NativePMApp.swift
//  NativePMExampleAppUITests
//
//  Created by Vilas on 27/09/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
import Nimble

protocol App {
    func launch()
    func terminate()
    func relaunch(clean: Bool)
}

extension XCUIApplication: App {
    func relaunch(clean: Bool = false) {
        UserDefaults.standard.synchronize()
        self.terminate()
        clean ?
            launchArguments.append("-cleanAppsData") :
            launchArguments.removeAll { $0 == "-cleanAppsData" }
        launch()
    }
}

class NativePMApp: XCUIApplication {
    class GDPRMessage: XCUIApplication {
        var container: XCUIElement {
            windows.containing(.staticText, identifier: "GDPR Message").firstMatch
        }

        var acceptAllButton: XCUIElement { container.buttons["Accept"].firstMatch }
        var rejectAllButton: XCUIElement { container.buttons["Reject All"].firstMatch }
        var categoriesDetailsButton: XCUIElement { container.buttons["Manage Preferences"].firstMatch }
        var vendorsDetailsButton: XCUIElement { container.buttons["Our Partners"].firstMatch }
        var privacyPolicyButton: XCUIElement { container.buttons["Privacy Policy"].firstMatch }
    }

    class CCPAMessage: XCUIApplication {
        var container: XCUIElement {
            windows.containing(.staticText, identifier: "CCPA Message").firstMatch
        }

        var doNotSellMyInfoButton: XCUIElement {
            container.buttons["Do not sell my personal information"].firstMatch
        }
        var acceptAllButton: XCUIElement { container.buttons["Accept"].firstMatch }
        var rejectAllButton: XCUIElement { container.buttons["Reject All"].firstMatch }
        var categoriesDetailsButton: XCUIElement { container.buttons["Manage Preferences"].firstMatch }
        var vendorsDetailsButton: XCUIElement { container.buttons["Our Partners"].firstMatch }
        var privacyPolicyButton: XCUIElement { container.buttons["Privacy Policy"].firstMatch }
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
        buttons["Accept"].firstMatch
    }

    var acceptAllButton: XCUIElement {
        buttons["Accept All"].firstMatch
    }

    var managePreferencesButton: XCUIElement {
        buttons["Manage Preferences"].firstMatch
    }

    var rejectAllButton: XCUIElement {
        buttons["Reject All"].firstMatch
    }

    var saveAndExitButton: XCUIElement {
        buttons["Save and Exit"].firstMatch
    }

    var saveAndExitInternalButton: XCUIElement {
        buttons["Save & Exit"].firstMatch
    }

    var homeButton: XCUIElement {
        buttons["Home"].firstMatch
    }

    var backButton: XCUIElement {
        buttons["Back"].firstMatch
    }

    var onButton: XCUIElement {
        buttons["On"].firstMatch
    }

    var offButton: XCUIElement {
        buttons["Off"].firstMatch
    }

    var privacyPolicyButton: XCUIElement {
        buttons["Privacy Policy"].firstMatch
    }

    var consentButton: XCUIElement {
        buttons["CONSENT"].firstMatch
    }

    var legitimateInterestButton: XCUIElement {
        buttons["LEGITIMATE INTEREST"].firstMatch
    }

    var ourPartnersButton: XCUIElement {
        buttons["Our Partners"].firstMatch
    }

    var gdprPrivacyManagerButton: XCUIElement {
        buttons["GDPR Privacy Manager"].firstMatch
    }

    var ccpaPrivacyManagerButton: XCUIElement {
        buttons["CCPA Privacy Manager"].firstMatch
    }
}

// MARK: - NativePMApp actions
extension NativePMApp {
    func pressDoNotSellButton() {
        remote.press(.right)
//            expectedMessageShowUP(element: doNotSellMyPersonalInformation)
//            previous line is commented since appletv.demo "Do Not Sell" button has blank text
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
        while(!self.hasFocus && counter < 10) {
            remote.press(direction)
            counter += 1
        }
    }

    func expectToHaveFocus() {
        expect(self).toEventually(showUp())
        expect(self.hasFocus).to(beTrue())
    }

    func remotePress() {
        if self.exists {
            expect(self).toEventually(showUp())
            remotePressUntilFocus(direction: .down)
            remotePressUntilFocus(direction: .up)
            expectToHaveFocus()
            remote.press(.select)
        }
    }
}
