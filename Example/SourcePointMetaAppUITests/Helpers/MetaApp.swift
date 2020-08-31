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
    var properyData = PropertyData()

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

    var propertyFieldValidationItem: XCUIElement {
        staticTexts.containing(NSPredicate(format: "label CONTAINS[cd] 'Please enter property details'")).firstMatch
    }

    var targetingParameterValidationItem: XCUIElement {
           staticTexts.containing(NSPredicate(format: "label CONTAINS[cd] 'Please enter targeting parameter key and value'")).firstMatch
    }
    
    var wrongPropertyIdValidationItem: XCUIElement {
           staticTexts.containing(NSPredicate(format: "label CONTAINS[cd] 'Error parsing response from'")).firstMatch
    }
    
    var wrongPMValidationItem: XCUIElement {
              staticTexts.containing(NSPredicate(format: "label CONTAINS[cd] 'Could not load PM with id'")).firstMatch
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
    
    var alertOkButton: XCUIElement {
           alerts["alertView"].buttons["OK"].firstMatch
       }

    func addPropertyDetails() {
        deleteProperty()
        expect(self.propertyList).to(showUp())
        self.addPropertyButton.tap()
        expect(self.newProperty).to(showUp())
        self.accountIDTextFieldOutlet.tap()
        self.accountIDTextFieldOutlet.typeText(self.properyData.accountId)
        self.propertyIdTextFieldOutlet.tap()
        self.propertyIdTextFieldOutlet.typeText(self.properyData.propertyId)
        self.propertyTextFieldOutlet.tap()
        self.propertyTextFieldOutlet.typeText(self.properyData.propertyName)
        self.pmTextFieldOutlet.tap()
        self.pmTextFieldOutlet.typeText(self.properyData.pmID)
    }

    func addPropertyWithWrongPropertyDetails(accountId : String, propertyId : String, propertyName : String, pmId : String) {
        deleteProperty()
        expect(self.propertyList).to(showUp())
        self.addPropertyButton.tap()
        self.accountIDTextFieldOutlet.tap()
        self.accountIDTextFieldOutlet.typeText(accountId)
        self.propertyIdTextFieldOutlet.tap()
        self.propertyIdTextFieldOutlet.typeText(propertyId)
        self.propertyTextFieldOutlet.tap()
        self.propertyTextFieldOutlet.typeText(propertyName)
        self.pmTextFieldOutlet.tap()
        self.pmTextFieldOutlet.typeText(pmId)
        self.savePropertyButton.tap()
    }
    
    func addTargetingParameter(targetingKey : String, targetingValue : String) {
        swipeUp()
        self.targetingParamKeyTextFieldOutlet.tap()
        self.targetingParamKeyTextFieldOutlet.typeText(targetingKey)
        self.targetingParamValueTextFieldOutlet.tap()
        self.targetingParamValueTextFieldOutlet.typeText(targetingValue)
        swipeUp()
        self.addTargetingParamButton.tap()
        self.savePropertyButton.tap()
    }

    func addTargetingParameterWithWrongDetails(targetingKey : String, targetingValue : String) {
        swipeUp()
        self.targetingParamKeyTextFieldOutlet.tap()
        self.targetingParamKeyTextFieldOutlet.typeText(targetingKey)
        self.targetingParamValueTextFieldOutlet.tap()
        self.targetingParamValueTextFieldOutlet.typeText(targetingValue)
        swipeUp()
        self.addTargetingParamButton.tap()
    }
    
    func deleteProperty() {
        expect(self.propertyList).to(showUp())
        if self.propertyItem.exists {
            self.propertyItem.swipeLeft()
            self.deletePropertyButton.tap()
            if self.alertYesButton.exists {
                self.alertYesButton.tap()
            }
        }
    }

    func dateFormatterForAuthID() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d yyyy, h:mm:ss"
        let formattedDateInString = formatter.string(from: date)
        return formattedDateInString
    }

    func testPMToggles(value : Int) {
        if self.PersonalisationSwitch.value != nil {
            expect(Int(self.PersonalisationSwitch.value as! String) == value).to(beTrue())
            expect(Int(self.PersonalisedAdsSwitch.value as! String) == value).to(beTrue())
            expect(Int(self.DeviceInformationSwitch.value as! String) == value).to(beTrue())
        }else {
            expect(self.privacyManager).to(showUp())
        }
    }
}

extension MetaApp: GDPRUI {
    var consentUI: XCUIElement {
        webViews.containing(NSPredicate(format: "(label CONTAINS[cd] 'TCFv2 Message Title') OR (label CONTAINS[cd] 'My Cookie Notice') OR (label CONTAINS[cd] 'ShowOnce')")).firstMatch
    }

    var privacyManager: XCUIElement {
        webViews.containing(NSPredicate(format: "label CONTAINS[cd] 'My Cookie Notice'")).firstMatch
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
