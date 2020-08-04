//
//  MetaApp.swift
//  SourcePointMetaAppUITests
//
//  Created by Vilas on 28/07/20.
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
    var consentUI: XCUIElement { get }
    var privacyManager: XCUIElement { get }
    var consentMessage: XCUIElement { get }
}

class MetaApp: XCUIApplication {
    var propertyList: XCUIElement {
        staticTexts["Property List"].firstMatch
    }

    var newProperty: XCUIElement {
        staticTexts["New Property"].firstMatch
    }

    var editProperty: XCUIElement {
        staticTexts["Edit Property"].firstMatch
    }

    var noPropertyData: XCUIElement {
        staticTexts["Please tap on + button to add new property"].firstMatch
    }

    var propertyDebugInfo: XCUIElement {
        staticTexts["Property Debug Info"].firstMatch
    }

    var propertyItem: XCUIElement {
        staticTexts.containing(NSPredicate(format: "label CONTAINS[cd] 'tcfv2.automation.testing'")).firstMatch
    }

    var deletePropertyButton: XCUIElement {
        propertyItem.buttons["trailing2"].firstMatch
    }

    var editPropertyButton: XCUIElement {
        propertyItem.buttons["trailing1"].firstMatch
    }

    var resetPropertyButton: XCUIElement {
        propertyItem.buttons["trailing0"].firstMatch
    }

    var addPropertyButton: XCUIElement {
        buttons["Add"].firstMatch
    }

    var addTargetingParamButton: XCUIElement {
        buttons["addButton"].firstMatch
    }

    var savePropertyButton: XCUIElement {
        navigationBars.buttons["Save"].firstMatch
    }

    var backButton: XCUIElement {
        navigationBars.buttons["Back"].firstMatch
    }

    var showPMButton: XCUIElement {
        navigationBars.buttons["Show PM"].firstMatch
    }

    var accountIDTextFieldOutlet: XCUIElement {
        textFields["accountIDTextFieldOutlet"].firstMatch
    }

    var propertyIdTextFieldOutlet: XCUIElement {
        textFields["propertyIdTextFieldOutlet"].firstMatch
    }

    var propertyTextFieldOutlet: XCUIElement {
        textFields["propertyTextFieldOutlet"].firstMatch
    }

    var authIdTextFieldOutlet: XCUIElement {
        textFields["authIdTextFieldOutlet"].firstMatch
    }

    var pmTextFieldOutlet: XCUIElement {
        textFields["pmTextFieldOutlet"].firstMatch
    }

    var targetingParamKeyTextFieldOutlet: XCUIElement {
        textFields["targetingParamKeyTextFieldOutlet"].firstMatch
    }

    var targetingParamValueTextFieldOutlet: XCUIElement {
        textFields["targetingParamValueTextFieldOutlet"].firstMatch
    }

    var stagingSwitchOutlet: XCUIElement {
        switches["isStagingSwitchOutlet"].firstMatch
    }

    var alertYesButton: XCUIElement {
        alerts["alertView"].buttons["YES"].firstMatch
    }

    var alertNoButton: XCUIElement {
        alerts["alertView"].buttons["NO"].firstMatch
    }
}

extension MetaApp: GDPRUI {
    var consentUI: XCUIElement {
        webViews.containing(NSPredicate(format: "(label CONTAINS[cd] 'TCFv2 Message Title') OR (label CONTAINS[cd] 'Cookie Notice') OR (label CONTAINS[cd] 'ShowOnce')")).firstMatch
    }

    var privacyManager: XCUIElement {
        webViews.containing(NSPredicate(format: "label CONTAINS[cd] 'Cookie Notice'")).firstMatch
    }

    var consentMessage: XCUIElement {
        webViews.containing(NSPredicate(format: "(label CONTAINS[cd] 'TCFv2 Message Title') OR (label CONTAINS[cd] 'ShowOnce')")).firstMatch
    }

    var termsAndConditionsWebPageTitle: XCUIElement {
        webViews.containing(NSPredicate(format: "label CONTAINS[cd] 'Address'")).firstMatch
    }

    var acceptAllButton: XCUIElement {
        consentUI.buttons.containing(NSPredicate(format: "label CONTAINS[cd] 'Accept'")).firstMatch
    }

    var rejectAllButton: XCUIElement {
        consentUI.buttons.containing(NSPredicate(format: "label CONTAINS[cd] 'Reject'")).firstMatch
    }

    var showOptionsButton: XCUIElement {
        consentUI.buttons["MANAGE PREFERENCES"].firstMatch
    }

    var saveAndExitButton: XCUIElement {
        consentUI.buttons["Save & Exit"].firstMatch
    }

    var cancelButton: XCUIElement {
        privacyManager.buttons["Cancel"].firstMatch
    }

    var dismissMessageButton: XCUIElement {
        webViews.containing(NSPredicate(format: "label CONTAINS[cd] 'X'")).firstMatch
    }

    var termsAndConditionsLink: XCUIElement {
        consentUI.links["Terms & Conditions"].firstMatch
    }

    var PersonalisedAdsSwitch: XCUIElement {
        consentUI.switches["Select personalised content"].firstMatch
    }

    var DeviceInformationSwitch: XCUIElement {
        consentUI.switches["Information storage and access"].firstMatch
    }

    var PersonalisationSwitch: XCUIElement {
        consentUI.switches["Personalisation"].firstMatch
    }
}


