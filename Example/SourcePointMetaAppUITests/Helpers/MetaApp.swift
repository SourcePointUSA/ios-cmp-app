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
    var propertyData = PropertyData()
    var gdprCampaigntableviewcellCell: XCUIElement!
    var ccpaCampaigntableviewcellCell: XCUIElement!

    var propertyList: XCUIElement {
        staticTexts.containing(NSPredicate(format: "label CONTAINS[cd] 'Property List'")).firstMatch
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
        staticTexts.containing(NSPredicate(format: "(label CONTAINS[cd] 'unified.meta.com') OR (label CONTAINS[cd] 'tcfv2.mobile.demo')")).firstMatch
    }

    var propertyFieldValidationItem: XCUIElement {
        staticTexts.containing(NSPredicate(format: "label CONTAINS[cd] 'Please enter property details'")).firstMatch
    }

    var targetingParameterValidationItem: XCUIElement {
           staticTexts.containing(NSPredicate(format: "label CONTAINS[cd] 'Please enter targeting parameter key and value'")).firstMatch
    }
    
    var wrongPropertyIdValidationItem: XCUIElement {
           staticTexts.containing(NSPredicate(format: "label CONTAINS[cd] 'The SDK got an unexpected response from /message endpoint'")).firstMatch
    }
    
    var wrongPMValidationItem: XCUIElement {
              staticTexts.containing(NSPredicate(format: "label CONTAINS[cd] 'Something went wrong in the SDK'")).firstMatch
    }

    var addGDPRCampaign: XCUIElement {
        staticTexts["Add GDPR Campaign"].firstMatch
    }

    var deletePropertyButton: XCUIElement {
        propertyItem.buttons.element(boundBy: 2).firstMatch
    }

    var editPropertyButton: XCUIElement {
        propertyItem.buttons.element(boundBy: 1).firstMatch
    }

    var resetPropertyButton: XCUIElement {
        propertyItem.buttons.element(boundBy: 0).firstMatch
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

    var accountIDTextFieldOutlet: XCUIElement {
        textFields["accountIDTextFieldOutlet"].firstMatch
    }

    var propertyTextFieldOutlet: XCUIElement {
        textFields["propertyTextFieldOutlet"].firstMatch
    }

    var authIdTextFieldOutlet: XCUIElement {
        textFields["authIdTextFieldOutlet"].firstMatch
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

    var alertOKButton: XCUIElement {
        alerts["alertView"].buttons["OK"].firstMatch
    }

    var doneButton: XCUIElement {
        toolbars["Toolbar"].buttons["Done"].firstMatch
    }

    var okButton: XCUIElement {
        alerts["alertView"].scrollViews.otherElements.buttons["OK"].firstMatch
    }

    func addPropertyDetails() {
        deleteProperty()
        expect(self.propertyList).toEventually(showUp())
        self.addPropertyButton.tap()
        expect(self.newProperty).toEventually(showUp())
        self.accountIDTextFieldOutlet.tap()
        self.accountIDTextFieldOutlet.typeText(self.propertyData.accountId)
        self.propertyTextFieldOutlet.tap()
        self.propertyTextFieldOutlet.typeText(self.propertyData.propertyName)
    }

    func addPropertyWithWrongPropertyDetails(accountId : String, propertyName : String) {
        deleteProperty()
        expect(self.propertyList).toEventually(showUp())
        self.addPropertyButton.tap()
        self.accountIDTextFieldOutlet.tap()
        self.accountIDTextFieldOutlet.typeText(accountId)
        self.propertyTextFieldOutlet.tap()
        self.propertyTextFieldOutlet.typeText(propertyName)
        self.savePropertyButton.tap()
    }

    func addPropertyWithCampaignDetails(targetingKey: String, targetingValue: String) {
        addPropertyDetails()
        tables.children(matching: .other)[self.propertyData.addGDPRCampaign].tap()
        swipeUp()
        gdprCampaigntableviewcellCell = tables.children(matching: .cell).matching(identifier: self.propertyData.campaignTableViewCell).element(boundBy: 0)
        gdprPMTextField.tap()
        gdprPMTextField.typeText(self.propertyData.gdprPMID)
        doneButton.tap()
        gdprTargetingKeyTextField.tap()
        gdprTargetingKeyTextField.typeText(targetingKey)
        doneButton.tap()
        gdprTargetingValueTextField.tap()
        gdprTargetingValueTextField.typeText(targetingValue)
        doneButton.tap()
        saveGDPRCampaign.tap()
        okButton.tap()
        tables.children(matching: .other)[self.propertyData.addCCPACampaign].forceTapElement()
        ccpaCampaigntableviewcellCell = tables.children(matching: .cell).matching(identifier: self.propertyData.campaignTableViewCell).element(boundBy: 1)
        expect(self.ccpaPMTextField).toEventually(showUp())
        ccpaPMTextField.tap()
        ccpaPMTextField.typeText(self.propertyData.ccpaPMID)
        doneButton.tap()
        ccpaTargetingKeyTextField.tap()
        ccpaTargetingKeyTextField.typeText(self.propertyData.targetingKeyShowOnce)
        doneButton.tap()
        ccpaTargetingValueTextField.tap()
        ccpaTargetingValueTextField.typeText(self.propertyData.targetingValueShowOnce)
        doneButton.tap()
        saveCCPACampaign.tap()
        okButton.tap()
    }

    func addPropertyDetailsForAuthID(targetingKey: String, targetingValue: String) {
        self.accountIDTextFieldOutlet.tap()
        self.accountIDTextFieldOutlet.typeText(self.propertyData.accountId)
        self.propertyTextFieldOutlet.tap()
        self.propertyTextFieldOutlet.typeText(self.propertyData.propertyName)
        tables.children(matching: .other)[self.propertyData.addGDPRCampaign].tap()
        swipeUp()
        gdprCampaigntableviewcellCell = tables.children(matching: .cell).matching(identifier: self.propertyData.campaignTableViewCell).element(boundBy: 0)
        gdprPMTextField.tap()
        gdprPMTextField.typeText(self.propertyData.gdprPMID)
        doneButton.tap()
        gdprTargetingKeyTextField.tap()
        gdprTargetingKeyTextField.typeText(targetingKey)
        doneButton.tap()
        gdprTargetingValueTextField.tap()
        gdprTargetingValueTextField.typeText(targetingValue)
        doneButton.tap()
        saveGDPRCampaign.tap()
        okButton.tap()
        tables.children(matching: .other)[self.propertyData.addCCPACampaign].forceTapElement()
        ccpaCampaigntableviewcellCell = tables.children(matching: .cell).matching(identifier: self.propertyData.campaignTableViewCell).element(boundBy: 1)
        ccpaPMTextField.tap()
        ccpaPMTextField.typeText(self.propertyData.ccpaPMID)
        doneButton.tap()
        ccpaTargetingKeyTextField.tap()
        ccpaTargetingKeyTextField.typeText(self.propertyData.targetingKeyShowOnce)
        doneButton.tap()
        ccpaTargetingValueTextField.tap()
        ccpaTargetingValueTextField.typeText(self.propertyData.targetingValueShowOnce)
        doneButton.tap()
        saveCCPACampaign.tap()
        okButton.tap()
    }


    func addGDPRPropertyDetails(targetingKey: String, targetingValue: String) {
        tables.children(matching: .other)[self.propertyData.addGDPRCampaign].tap()
        swipeUp()
        gdprTargetingKeyTextField.tap()
        gdprTargetingKeyTextField.typeText(targetingKey)
        doneButton.tap()
        gdprTargetingValueTextField.tap()
        gdprTargetingValueTextField.typeText(targetingValue)
        doneButton.tap()
        saveGDPRCampaign.tap()
        okButton.tap()
        savePropertyButton.tap()
    }

    func addPropertyWithCampaignDetailsAndFeaturesTab(targetingKey: String, targetingValue: String) {
        addPropertyDetails()
        tables.children(matching: .other)[self.propertyData.addGDPRCampaign].tap()
        swipeUp()
        gdprCampaigntableviewcellCell = tables.children(matching: .cell).matching(identifier: self.propertyData.campaignTableViewCell).element(boundBy: 0)
        gdprPMTextField.tap()
        gdprPMTextField.typeText(self.propertyData.gdprPMID)
        doneButton.tap()
        dropDownButton.tap()
        defaultPickerWheels.swipeUp()
        featuresPickerWheels.tap()
        doneButton.tap()
        gdprTargetingKeyTextField.tap()
        gdprTargetingKeyTextField.typeText(targetingKey)
        doneButton.tap()
        gdprTargetingValueTextField.tap()
        gdprTargetingValueTextField.typeText(targetingValue)
        doneButton.tap()
        saveGDPRCampaign.tap()
        okButton.tap()
        tables.children(matching: .other)[self.propertyData.addCCPACampaign].forceTapElement()
        ccpaCampaigntableviewcellCell = tables.children(matching: .cell).matching(identifier: self.propertyData.campaignTableViewCell).element(boundBy: 1)
        ccpaPMTextField.tap()
        ccpaPMTextField.typeText(self.propertyData.ccpaPMID)
        doneButton.tap()
        ccpaTargetingKeyTextField.tap()
        ccpaTargetingKeyTextField.typeText(self.propertyData.targetingKeyShowOnce)
        doneButton.tap()
        ccpaTargetingValueTextField.tap()
        ccpaTargetingValueTextField.typeText(self.propertyData.targetingValueShowOnce)
        doneButton.tap()
        saveCCPACampaign.tap()
        okButton.tap()
    }
    
    func deleteProperty() {
        expect(self.propertyList).toEventually(showUp())
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
        if self.PersonalisedAdsSwitch.value != nil {
            expect(Int(self.PersonalisedAdsSwitch.value as! String) == value).to(beTrue())
            expect(Int(self.BasicAdsSwitch.value as! String) == value).to(beTrue())
        }else {
            expect(self.privacyManager).toEventually(showUp())
        }
    }

    func setupForMetaAppPropertyValidation() {
        deleteProperty()
        expect(self.propertyList).toEventually(showUp())
        addPropertyButton.tap()
        tables.children(matching: .other)[self.propertyData.addGDPRCampaign].tap()
        swipeUp()
        gdprCampaigntableviewcellCell = tables.children(matching: .cell).matching(identifier: self.propertyData.campaignTableViewCell).element(boundBy: 0)
    }

}

extension MetaApp: GDPRUI {
    var consentUI: XCUIElement {
        webViews.containing(NSPredicate(format: "(label CONTAINS[cd] 'TCFv2 Message Title') OR (label CONTAINS[cd] 'Cookie Notice') OR (label CONTAINS[cd] 'ShowOnce') OR (label CONTAINS[cd] 'Privacy Settings')")).firstMatch
    }

    var privacyManager: XCUIElement {
        webViews.otherElements["Privacy Manager App"].children(matching: .other).element(boundBy: 0).staticTexts["Cookie Notice"].firstMatch
    }

    var consentMessage: XCUIElement {
        webViews.containing(NSPredicate(format: "(label CONTAINS[cd] 'TCFv2 Message Title') OR (label CONTAINS[cd] 'ShowOnce')")).firstMatch
    }

    var attMessage: XCUIElement {
        webViews.containing(NSPredicate(format: "label CONTAINS[cd] 'ATT pre-prompt'")).firstMatch
    }

    var ccpaConsentMessage: XCUIElement {
        webViews.containing(NSPredicate(format: "label CONTAINS[cd] 'SHOW ONLY ONCE MESSAGE'")).firstMatch
    }

    var consentMessageInGerman: XCUIElement {
        webViews.containing(NSPredicate(format: "label CONTAINS[cd] 'Wir benötigen Ihre Zustimmung'")).firstMatch
    }

    var termsAndConditionsWebPageTitle: XCUIElement {
        webViews.containing(NSPredicate(format: "label CONTAINS[cd] 'Address'")).firstMatch
    }

    var bringItOnButton: XCUIElement {
        attMessage.buttons.containing(NSPredicate(format: "label CONTAINS[cd] 'Bring it on'")).firstMatch
    }

    var acceptAllButton: XCUIElement {
        consentUI.buttons.containing(NSPredicate(format: "label CONTAINS[cd] 'Accept'")).firstMatch
    }

    var ccpaAcceptAllButton: XCUIElement {
        ccpaConsentMessage.buttons.containing(NSPredicate(format: "label CONTAINS[cd] 'Accept All'")).firstMatch
    }

    var acceptAllButtonInGerman: XCUIElement {
        consentMessageInGerman.buttons["Zustimmen"].firstMatch
    }

    var rejectAllButton: XCUIElement {
        consentUI.buttons["Reject All"].firstMatch
    }

    var showOptionsButton: XCUIElement {
        consentUI.buttons["Manage Preferences"].firstMatch
    }

    var showOptionsButtonInGerman: XCUIElement {
        consentMessageInGerman.buttons["Einstellungen"].firstMatch
    }

    var saveAndExitButton: XCUIElement {
        consentUI.buttons["Save & Exit"].firstMatch
    }

    var cancelButton: XCUIElement {
        consentUI.buttons["Cancel"].firstMatch
    }

    var dismissMessageButton: XCUIElement {
        webViews.staticTexts["X"].firstMatch
    }

    var purposesTab: XCUIElement {
        staticTexts.containing(NSPredicate(format: "label CONTAINS[cd] 'PURPOSES'")).firstMatch
    }

    var termsAndConditionsLink: XCUIElement {
        consentUI.links["Terms & Conditions"].firstMatch
    }

    var PersonalisedAdsSwitch: XCUIElement {
        consentUI.switches.element(boundBy: 2) // == "Create a personalised ads profile"
    }

    var BasicAdsSwitch: XCUIElement {
        consentUI.switches.element(boundBy: 1) // == "Select basic ads"
    }

    var featuresTab: XCUIElement {
        staticTexts[
            "Features are a use of the data that you have already agreed to share with us"
        ].firstMatch
    }

    var gdprTargetingParamButton: XCUIElement {
        gdprCampaigntableviewcellCell.staticTexts["Targeting Param"].firstMatch
    }

    var gdprTargetingKeyTextField: XCUIElement {
        gdprCampaigntableviewcellCell.textFields["targetingKeyTextFieldOutlet"].firstMatch
    }

    var gdprTargetingValueTextField: XCUIElement {
        gdprCampaigntableviewcellCell.textFields["targetingValueTextFieldOutlet"].firstMatch
    }

    var ccpaTargetingParamButton: XCUIElement {
        ccpaCampaigntableviewcellCell.staticTexts["Targeting Param"].firstMatch
    }

    var ccpaTargetingKeyTextField: XCUIElement {
        ccpaCampaigntableviewcellCell.textFields["targetingKeyTextFieldOutlet"].firstMatch
    }

    var ccpaTargetingValueTextField: XCUIElement {
        ccpaCampaigntableviewcellCell.textFields["targetingValueTextFieldOutlet"].firstMatch
    }

    var saveCCPACampaign: XCUIElement {
        ccpaCampaigntableviewcellCell.staticTexts["Save Campaign"].firstMatch
    }

    var saveGDPRCampaign: XCUIElement {
        gdprCampaigntableviewcellCell.staticTexts["Save Campaign"].firstMatch
    }

    var gdprPMTextField: XCUIElement {
        gdprCampaigntableviewcellCell.textFields["pmTextFieldOutlet"].firstMatch
    }

    var ccpaPMTextField: XCUIElement {
        ccpaCampaigntableviewcellCell.textFields["pmTextFieldOutlet"].firstMatch
    }

    var dropDownButton: XCUIElement {
        gdprCampaigntableviewcellCell.buttons["dropDown"].firstMatch
    }

    var defaultPickerWheels: XCUIElement {
        pickerWheels["Default"].firstMatch
    }

    var featuresPickerWheels: XCUIElement {
        pickerWheels["Features"].firstMatch
    }

    var menuButton: XCUIElement {
        navigationBars["Property Debug Info"].buttons["Menu"].firstMatch
    }

    var loadGDPRPM: XCUIElement {
        tables.staticTexts["Load GDPR PM"].firstMatch
    }
}
