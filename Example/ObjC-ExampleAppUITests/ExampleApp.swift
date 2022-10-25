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
    func relaunch(clean: Bool, resetAtt: Bool)
}

extension XCUIApplication: App {
    func relaunch(clean: Bool = false, resetAtt: Bool = false) {
        UserDefaults.standard.synchronize()
        self.terminate()
        if #available(iOS 15.0, *), resetAtt {
            resetAuthorizationStatus(for: .userTracking)
        }
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
    class ATTPrePrompt: XCUIApplication {
        private let system = XCUIApplication(bundleIdentifier: "com.apple.springboard")

        private var container: XCUIElement {
            webViews.containing(NSPredicate(format: "label CONTAINS[cd] 'ATT pre-prompt'")).firstMatch
        }

        var okButton: XCUIElement {
            container.buttons["Bring it on"].firstMatch
        }

        private var attAlert: XCUIElement {
            system.alerts.containing(NSPredicate(format: "label CONTAINS[cd] 'track you'")).firstMatch
        }

        var attAlertAllowButton: XCUIElement {
            attAlert.buttons["Allow"].firstMatch
        }
    }

    let attPrePrompt = ATTPrePrompt()

    var shouldRunAttScenario: Bool {
        /// Unfortunately querying for `ATTrackingManager.trackingAuthorizationStatus` during tests is not reliable.
        /// So we rely on the app's IDFA status label in order to decide if the ATT scenario should be tested or not.
        staticTexts["unknown"].exists
    }

    var consentMessage: XCUIElement {
        webViews.first(withLabel: "GDPR Message")
    }

    var acceptAllButton: XCUIElement {
        consentMessage.buttons.first(withLabel: "Accept")
    }

    var sdkStatus: XCUIElement {
        staticTexts["sdkStatusLabel"]
    }
}
