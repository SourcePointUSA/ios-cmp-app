//
//  ExampleApp.swift
//  ObjC-ExampleAppUITests
//
//  Created by Andre Herculano on 21.10.21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import XCTest
import Quick
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

extension XCUIElementQuery {
    func first(withLabel label: String) -> XCUIElement {
        containing(NSPredicate(format: "label CONTAINS[cd] '\(label)'")).firstMatch
    }
}

class ExampleApp: XCUIApplication {
    var attNativePrompt: XCUIElement {
        alerts.first(withLabel: "track your activity")
    }

    var attNativePromptAllowButton: XCUIElement {
        attNativePrompt.buttons.first(withLabel: "Allow")
    }

    var consentMessage: XCUIElement {
        webViews.first(withLabel: "GDPR Message")
    }

    var attPrePromptMessage: XCUIElement {
        webViews.first(withLabel: "ATT pre-prompt")
    }

    var acceptAllButton: XCUIElement {
        consentMessage.buttons.first(withLabel: "Accept")
    }

    var acceptATTButton: XCUIElement {
        attPrePromptMessage.buttons.first(withLabel: "Bring it on")
    }
}
