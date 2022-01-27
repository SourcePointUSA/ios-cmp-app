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

class NativeExampleApp: XCUIApplication {
    class CCPAPrivacyManager:XCUIApplication {
        private var container: XCUIElement {
            webViews.containing(NSPredicate(format: "label CONTAINS[cd] 'GDPR Privacy Manager'")).firstMatch     //somehow ccpas' pm is the same as gdprs'
        }

        var messageTitle: XCUIElement {
            container
        }
        
        var acceptAllButton: XCUIElement {
            container.buttons["Accept All"].firstMatch
        }
    }
    
    class GDPRPrivacyManager: XCUIApplication {
        private var container: XCUIElement {
            webViews.containing(NSPredicate(format: "label CONTAINS[cd] 'GDPR Privacy Manager'")).firstMatch
        }

        var messageTitle: XCUIElement {
            container
        }

        var purposesTab: XCUIElement {
            staticTexts.containing(NSPredicate(format: "label CONTAINS[cd] 'PURPOSES'")).firstMatch
        }

        var acceptAllButton: XCUIElement {
            container.buttons["Accept All"].firstMatch
        }

        var rejectAllButton: XCUIElement {
            container.buttons["Reject All"].firstMatch
        }

        var saveAndExitButton: XCUIElement {
            container.buttons["Save & Exit"].firstMatch
        }

        var cancelButton: XCUIElement {
            container.buttons["Cancel"].firstMatch
        }
    }

    class GDPRMessage: FirstLayerMessage {
        override var messageTitle: XCUIElement {
            staticTexts["GDPR Native Message"].firstMatch
        }
    }

    class CCPAMessage: FirstLayerMessage {
        override var messageTitle: XCUIElement {
            staticTexts["CCPA Native Message"].firstMatch
        }
    }

    class ATTPrePrompt: XCUIApplication {
        private let system = XCUIApplication(bundleIdentifier: "com.apple.springboard")

        private var container: XCUIElement {
            webViews.containing(NSPredicate(format: "label CONTAINS[cd] 'ATT Pre Prompt'")).firstMatch
        }

        var okButton: XCUIElement {
            container.buttons["OK"].firstMatch
        }

        private var attAlert: XCUIElement {
            system.alerts.containing(NSPredicate(format: "label CONTAINS[cd] 'track your activity'")).firstMatch
        }

        var attAlertAllowButton: XCUIElement {
            attAlert.buttons["Allow"].firstMatch
        }
    }

    let gdprMessage = GDPRMessage()
    let ccpaMessage = CCPAMessage()
    let gdprPM = GDPRPrivacyManager()
    let ccpaPM = CCPAPrivacyManager()
    let attPrePrompt = ATTPrePrompt()

    var gdprPrivacyManagerButton: XCUIElement {
        buttons["GDPR Privacy Manager"].firstMatch
    }

    var ccpaPrivacyManagerButton: XCUIElement {
        buttons["CCPA Privacy Manager"].firstMatch
    }
    
    var shouldRunAttScenario: Bool {
        /// Unfortunately querying for `ATTrackingManager.trackingAuthorizationStatus` during tests is not reliable.
        /// So we rely on the app's IDFA status label in order to decide if the ATT scenario should be tested or not.
        staticTexts["unknown"].exists
    }
}
