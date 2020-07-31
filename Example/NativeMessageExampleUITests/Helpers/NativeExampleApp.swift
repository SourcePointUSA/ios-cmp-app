//
//  NativeExampleApp.swift
//  NativeMessageExampleUITests
//
//  Created by Vilas on 22/07/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
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

protocol GDPRUI {
    var privacyManager: XCUIElement { get }
}

class NativeExampleApp: XCUIApplication {
    var messageTitle: XCUIElement {
        staticTexts["Personalised Ads"].firstMatch
    }

    var exampleAppLabel: XCUIElement {
        staticTexts["Example App"].firstMatch
    }

    var acceptButton: XCUIElement {
        buttons["Accept"].firstMatch
    }

    var rejectButton: XCUIElement {
        buttons["Reject"].firstMatch
    }

    var showOptionsButton: XCUIElement {
        buttons["Show Options"].firstMatch
    }
    var settingsButton: XCUIElement {
        buttons["Settings"].firstMatch
    }
}

extension NativeExampleApp: GDPRUI {
    var privacyManager: XCUIElement {
        webViews.containing(NSPredicate(format: "label CONTAINS[cd] 'Privacy Settings'")).firstMatch
    }

    var acceptAllButton: XCUIElement {
        privacyManager.buttons["Accept All"].firstMatch
    }

    var rejectAllButton: XCUIElement {
        privacyManager.buttons["Reject All"].firstMatch
    }

    var saveAndExitButton: XCUIElement {
        privacyManager.buttons["Save & Exit"].firstMatch
    }

    var cancelButton: XCUIElement {
        privacyManager.buttons["Cancel"].firstMatch
    }

    var DeviceInformationSwitch: XCUIElement {
        privacyManager.switches["Information storage and access"].firstMatch
    }

    var PersonalisedContentSwitch: XCUIElement {
        privacyManager.switches["Select personalised content"].firstMatch
    }
}
