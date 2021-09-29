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

    var doNotSellMyPersonalInformation: XCUIElement {
        tables.cells.containing(.staticText, identifier:"Do Not Sell My Personal Information").firstMatch
    }

    var category: XCUIElement {
        tables.cells.containing(.staticText, identifier:"Category 1").firstMatch
    }

    var storeAndaccessInformation: XCUIElement {
        tables.cells.containing(.staticText, identifier:"Store and/or access information on a device").firstMatch
    }

    var freewheel: XCUIElement {
        tables.cells.containing(.staticText, identifier:"Freewheel").firstMatch
    }

    var justpremiumBV: XCUIElement {
        tables.cells.containing(.staticText, identifier:"Justpremium BV").firstMatch
    }

    var gameAccounts: XCUIElement {
        tables.cells.containing(.staticText, identifier:"Game Accounts").firstMatch
    }

    var acceptButton: XCUIElement {
        buttons["Accept"].firstMatch
    }

    var acceptAllButton: XCUIElement {
        buttons["Accept All"].firstMatch
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

    var ManagePreferencesButton: XCUIElement {
        buttons["Manage Preferences"].firstMatch
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

    func expectedMessageShowUP(element: XCUIElement) {
        expect(element).to(showUp())
        expect(element.hasFocus).to(beTrue())
    }
}
