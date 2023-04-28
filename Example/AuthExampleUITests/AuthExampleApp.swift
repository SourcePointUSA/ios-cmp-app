//
//  AuthExampleApp.swift
//  AuthExampleUITests
//
//  Created by Andre Herculano on 27.04.23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import Nimble
import XCTest

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

class FirstLayerMessage: XCUIApplication {
    var messageTitle: XCUIElement { staticTexts["Message Title"].firstMatch }
    var acceptButton: XCUIElement { buttons["Accept All"].firstMatch }
    var rejectButton: XCUIElement { buttons["Reject All"].firstMatch }
    var showOptionsButton: XCUIElement { buttons["Show Options"].firstMatch }
}

class AuthExampleApp: XCUIApplication {
    class GDPRMessage: FirstLayerMessage {
        override var messageTitle: XCUIElement {
            staticTexts["GDPR Message"].firstMatch
        }
    }

    class CCPAMessage: FirstLayerMessage {
        override var messageTitle: XCUIElement {
            staticTexts["CCPA Message"].firstMatch
        }
    }

    let gdprMessage = GDPRMessage()
    let ccpaMessage = CCPAMessage()


    var webViewButton: XCUIElement {
        buttons["WebView"]
    }

    var webViewOnConsentReadyCalls: XCUIElementQuery {
        staticTexts
            .containing(NSPredicate(format: "label CONTAINS[c] %@", "onConsentReady"))
    }

    var sdkStatusLabel: XCUIElement {
        staticTexts["sdkStatusLabel"]
    }
}

