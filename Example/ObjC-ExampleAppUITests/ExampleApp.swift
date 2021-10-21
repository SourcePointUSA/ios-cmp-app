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

class ExampleApp: XCUIApplication {
    var consentMessage: XCUIElement {
        webViews.containing(NSPredicate(format: "label CONTAINS[cd] 'GDPR Message'")).firstMatch
    }

    var acceptAllButton: XCUIElement {
        webViews.buttons.containing(NSPredicate(format: "label CONTAINS[cd] 'Accept'")).firstMatch
    }
}
