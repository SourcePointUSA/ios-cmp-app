//
//  ExampleApp.swift
//  SPGDPRExampleAppUITests
//
//  Created by Andre Herculano on 22.06.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest

protocol App {
    func launch()
    func terminate()
    func relaunch()
}

protocol GDPRUI {
    var consentUI: XCUIElement { get }
    var privacyManager: XCUIElement { get }
    var consentMessage: XCUIElement { get }
}

class ExampleApp {
    let app: XCUIApplication

    var privacySettingsButton: XCUIElement {
        app.buttons["privacySettingsButton"].firstMatch
    }

    var clearConsentButton: XCUIElement {
        app.buttons["clearConsentButton"].firstMatch
    }

    var acceptVendorXButton: XCUIElement {
        app.buttons["acceptVendorXButton"].firstMatch
    }

    var vendorXConsentStatus: String {
        app.staticTexts["vendorXConsentStatus"].label
    }

    init(_ app: XCUIApplication) {
        self.app = app
    }
}

extension ExampleApp: App {
    func launch() {
        app.launch()
    }

    func terminate() {
        app.terminate()
    }

    func relaunch() {
        terminate()
        launch()
    }
}

extension ExampleApp: GDPRUI {
    var consentUI: XCUIElement {
        consentMessage.exists ?
            consentMessage :
            privacyManager
    }

    var privacyManager: XCUIElement {
        app.webViews.containing(NSPredicate(format: "label CONTAINS[cd] 'Privacy Center'")).firstMatch
    }

    var consentMessage: XCUIElement {
        app.webViews.containing(NSPredicate(format: "label CONTAINS[cd] 'Privacy Notice'")).firstMatch
    }

    var acceptAllButton: XCUIElement {
        consentUI.buttons.containing(NSPredicate(format: "label CONTAINS[cd] 'Accept'")).firstMatch
    }

    var rejectAllButton: XCUIElement {
        consentUI.buttons.containing(NSPredicate(format: "label CONTAINS[cd] 'Reject'")).firstMatch
    }

    var showOptionsButton: XCUIElement {
        consentUI.buttons["Options"].firstMatch
    }

    var saveAndExitButton: XCUIElement {
        consentUI.buttons["Save & Exit"].firstMatch
    }
}
