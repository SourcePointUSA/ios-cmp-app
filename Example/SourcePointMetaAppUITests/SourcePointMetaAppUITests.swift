//
//  SourcePointMetaAppUITests.swift
//  SourcePointMetaAppUITests
//
//  Created by Vilas on 28/07/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import Unified_MetaApp

class SourcePointMetaAppUITests: QuickSpec {
    var app: MetaApp!
    var properyData = PropertyData()

    override func spec() {
        beforeSuite {
            self.continueAfterFailure = false
            self.app = MetaApp()
            Nimble.AsyncDefaults.timeout = .seconds(20)
            Nimble.AsyncDefaults.pollInterval = .milliseconds(500)
        }

        afterSuite {
            Nimble.AsyncDefaults.timeout = .seconds(1)
            Nimble.AsyncDefaults.pollInterval = .milliseconds(100)
        }

        beforeEach {
            self.app.relaunch(clean: true)
        }

        /**
         @Description - User submit valid property details and tap on Save then expected consent message should display when user tap on  Accept All button then ccpa consent message should display when user tap on accpet all button then consent data should display on info screen when user navigate back and tap on the Property again then user should not see message again when user delete cookies for the property then user should see consent message again.
         */
        fit("Show purpose consents after reset cookies") {
            self.app.addPropertyDetails()
            self.app.tables.children(matching: .other)["Add GDPR Campaign"].tap()
            self.app.swipeUp()
            let gdprCampaigntableviewcellCell = self.app.tables.children(matching: .cell).matching(identifier: "campaignTableViewCell").element(boundBy: 0)
            gdprCampaigntableviewcellCell.textFields["pmTextFieldOutlet"].tap()
            gdprCampaigntableviewcellCell.textFields["pmTextFieldOutlet"].typeText("528826")
            let doneButton = self.app.toolbars["Toolbar"].buttons["Done"]
            doneButton.tap()
            gdprCampaigntableviewcellCell.textFields["targetingKeyTextFieldOutlet"].tap()
            gdprCampaigntableviewcellCell.textFields["targetingKeyTextFieldOutlet"].typeText("displayMode")
            doneButton.tap()
            gdprCampaigntableviewcellCell.textFields["targetingValueTextFieldOutlet"].tap()
            gdprCampaigntableviewcellCell.textFields["targetingValueTextFieldOutlet"].typeText("appLaunch")
            doneButton.tap()
            gdprCampaigntableviewcellCell.staticTexts["Save Campaign"].tap()
            let alertView = self.app.alerts["alertView"].scrollViews.otherElements
            let okButton = alertView.buttons["OK"]
            okButton.tap()
            self.app.tables.children(matching: .other)["Add CCPA Campaign"].forceTapElement()
            let ccpaCampaigntableviewcellCell = self.app.tables.children(matching: .cell).matching(identifier: "campaignTableViewCell").element(boundBy: 1)
            ccpaCampaigntableviewcellCell.textFields["pmTextFieldOutlet"].tap()
            ccpaCampaigntableviewcellCell.textFields["pmTextFieldOutlet"].typeText("529554")
            doneButton.tap()
            ccpaCampaigntableviewcellCell.textFields["targetingKeyTextFieldOutlet"].tap()
            ccpaCampaigntableviewcellCell.textFields["targetingKeyTextFieldOutlet"].typeText("displayMode")
            doneButton.tap()
            ccpaCampaigntableviewcellCell.textFields["targetingValueTextFieldOutlet"].tap()
            ccpaCampaigntableviewcellCell.textFields["targetingValueTextFieldOutlet"].typeText("appLaunch")
            doneButton.tap()
            ccpaCampaigntableviewcellCell.staticTexts["Save Campaign"].tap()
            okButton.tap()
            self.app.savePropertyButton.tap()
            expect(self.app.consentMessage).to(showUp())
            self.app.acceptAllButton.tap()
            expect(self.app.ccpaConsentMessage).to(showUp())
            self.app.ccpaAcceptAllButton.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
            self.app.backButton.tap()
            expect(self.app.propertyList).to(showUp())
            self.app.propertyItem.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
            self.app.backButton.tap()
            expect(self.app.propertyList).to(showUp())
            if self.app.propertyItem.exists {
                self.app.propertyItem.swipeLeft()
                self.app.resetPropertyButton.tap()
                if self.app.alertOKButton.exists {
                    self.app.alertOKButton.tap()
                }
            }
            expect(self.app.consentMessage).to(showUp())
        }

        /**
         @Description - User submit valid property details and tap on Save then expected messages should load When user select Reject All then consent information should get stored when user swipe on property and choose to delete user should able to delete the property screen
         */
        fit("Delete Property from property list") {
            self.app.addPropertyDetails()
            self.app.tables.children(matching: .other)["Add GDPR Campaign"].tap()
            self.app.swipeUp()
            let gdprCampaigntableviewcellCell = self.app.tables.children(matching: .cell).matching(identifier: "campaignTableViewCell").element(boundBy: 0)
            gdprCampaigntableviewcellCell.textFields["pmTextFieldOutlet"].tap()
            gdprCampaigntableviewcellCell.textFields["pmTextFieldOutlet"].typeText("528826")
            let doneButton = self.app.toolbars["Toolbar"].buttons["Done"]
            doneButton.tap()
            gdprCampaigntableviewcellCell.textFields["targetingKeyTextFieldOutlet"].tap()
            gdprCampaigntableviewcellCell.textFields["targetingKeyTextFieldOutlet"].typeText("language")
            doneButton.tap()
            gdprCampaigntableviewcellCell.textFields["targetingValueTextFieldOutlet"].tap()
            gdprCampaigntableviewcellCell.textFields["targetingValueTextFieldOutlet"].typeText("en")
            doneButton.tap()
            gdprCampaigntableviewcellCell.staticTexts["Save Campaign"].tap()
            let alertView = self.app.alerts["alertView"].scrollViews.otherElements
            let okButton = alertView.buttons["OK"]
            okButton.tap()
            self.app.tables.children(matching: .other)["Add CCPA Campaign"].forceTapElement()
            let ccpaCampaigntableviewcellCell = self.app.tables.children(matching: .cell).matching(identifier: "campaignTableViewCell").element(boundBy: 1)
            ccpaCampaigntableviewcellCell.textFields["pmTextFieldOutlet"].tap()
            ccpaCampaigntableviewcellCell.textFields["pmTextFieldOutlet"].typeText("529554")
            doneButton.tap()
            ccpaCampaigntableviewcellCell.textFields["targetingKeyTextFieldOutlet"].tap()
            ccpaCampaigntableviewcellCell.textFields["targetingKeyTextFieldOutlet"].typeText("displayMode")
            doneButton.tap()
            ccpaCampaigntableviewcellCell.textFields["targetingValueTextFieldOutlet"].tap()
            ccpaCampaigntableviewcellCell.textFields["targetingValueTextFieldOutlet"].typeText("appLaunch")
            doneButton.tap()
            ccpaCampaigntableviewcellCell.staticTexts["Save Campaign"].tap()
            okButton.tap()
            self.app.savePropertyButton.tap()
            expect(self.app.consentMessage).to(showUp())
            self.app.rejectAllButton.tap()
            expect(self.app.ccpaConsentMessage).to(showUp())
            self.app.ccpaAcceptAllButton.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
            self.app.backButton.tap()
            expect(self.app.propertyList).to(showUp())
            self.app.deleteProperty()
            expect(self.app.propertyItem).notTo(showUp())
        }

        /**
         @Description - User submit valid property details and tap on Save then expected messages should load when user select Accept All then consent information should get stored when user swipe on property and edit the key/parameter details then user should see respective message
         */
        fit("Edit Property from property list") {
            self.app.addPropertyDetails()
            self.app.tables.children(matching: .other)["Add GDPR Campaign"].tap()
            self.app.swipeUp()
            let gdprCampaigntableviewcellCell = self.app.tables.children(matching: .cell).matching(identifier: "campaignTableViewCell").element(boundBy: 0)
            gdprCampaigntableviewcellCell.textFields["pmTextFieldOutlet"].tap()
            gdprCampaigntableviewcellCell.textFields["pmTextFieldOutlet"].typeText("528826")
            let doneButton = self.app.toolbars["Toolbar"].buttons["Done"]
            doneButton.tap()
            gdprCampaigntableviewcellCell.textFields["targetingKeyTextFieldOutlet"].tap()
            gdprCampaigntableviewcellCell.textFields["targetingKeyTextFieldOutlet"].typeText("language")
            doneButton.tap()
            gdprCampaigntableviewcellCell.textFields["targetingValueTextFieldOutlet"].tap()
            gdprCampaigntableviewcellCell.textFields["targetingValueTextFieldOutlet"].typeText("en")
            doneButton.tap()
            gdprCampaigntableviewcellCell.staticTexts["Save Campaign"].tap()
            let alertView = self.app.alerts["alertView"].scrollViews.otherElements
            let okButton = alertView.buttons["OK"]
            okButton.tap()
            self.app.tables.children(matching: .other)["Add CCPA Campaign"].forceTapElement()
            let ccpaCampaigntableviewcellCell = self.app.tables.children(matching: .cell).matching(identifier: "campaignTableViewCell").element(boundBy: 1)
            ccpaCampaigntableviewcellCell.textFields["pmTextFieldOutlet"].tap()
            ccpaCampaigntableviewcellCell.textFields["pmTextFieldOutlet"].typeText("529554")
            doneButton.tap()
            ccpaCampaigntableviewcellCell.textFields["targetingKeyTextFieldOutlet"].tap()
            ccpaCampaigntableviewcellCell.textFields["targetingKeyTextFieldOutlet"].typeText("displayMode")
            doneButton.tap()
            ccpaCampaigntableviewcellCell.textFields["targetingValueTextFieldOutlet"].tap()
            ccpaCampaigntableviewcellCell.textFields["targetingValueTextFieldOutlet"].typeText("appLaunch")
            doneButton.tap()
            ccpaCampaigntableviewcellCell.staticTexts["Save Campaign"].tap()
            okButton.tap()
            self.app.savePropertyButton.tap()
            expect(self.app.consentMessage).to(showUp())
            self.app.acceptAllButton.tap()
            expect(self.app.ccpaConsentMessage).to(showUp())
            self.app.ccpaAcceptAllButton.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
            self.app.backButton.tap()
            expect(self.app.propertyList).to(showUp())
            if self.app.propertyItem.exists {
                self.app.propertyItem.swipeLeft()
                self.app.editPropertyButton.tap()
                expect(self.app.editProperty).to(showUp())
                self.app.authIdTextFieldOutlet.tap()
                self.app.authIdTextFieldOutlet.typeText(self.app.dateFormatterForAuthID())
                self.app.tables.children(matching: .other)["Add GDPR Campaign"].tap()
                self.app.swipeUp()
                gdprCampaigntableviewcellCell.textFields["targetingKeyTextFieldOutlet"].tap()
                gdprCampaigntableviewcellCell.textFields["targetingKeyTextFieldOutlet"].typeText("language")
                doneButton.tap()
                gdprCampaigntableviewcellCell.textFields["targetingValueTextFieldOutlet"].tap()
                gdprCampaigntableviewcellCell.textFields["targetingValueTextFieldOutlet"].typeText("fr")
                doneButton.tap()
                gdprCampaigntableviewcellCell.staticTexts["Save Campaign"].tap()
                let alertView = self.app.alerts["alertView"].scrollViews.otherElements
                let okButton = alertView.buttons["OK"]
                okButton.tap()
                self.app.savePropertyButton.tap()
                expect(self.app.consentMessage).to(showUp())
            }
        }

        /**
         @Description - User submit valid property details tap on Save then expected messages should load When user dismiss the message then user should see info screen with ConsentUUID details
         */
        fit("Check ConsentUUID on Message Dismiss") {
            self.app.addPropertyDetails()
            self.app.tables.children(matching: .other)["Add GDPR Campaign"].tap()
            self.app.swipeUp()
            let gdprCampaigntableviewcellCell = self.app.tables.children(matching: .cell).matching(identifier: "campaignTableViewCell").element(boundBy: 0)
            gdprCampaigntableviewcellCell.textFields["pmTextFieldOutlet"].tap()
            gdprCampaigntableviewcellCell.textFields["pmTextFieldOutlet"].typeText("528826")
            let doneButton = self.app.toolbars["Toolbar"].buttons["Done"]
            doneButton.tap()
            gdprCampaigntableviewcellCell.textFields["targetingKeyTextFieldOutlet"].tap()
            gdprCampaigntableviewcellCell.textFields["targetingKeyTextFieldOutlet"].typeText("language")
            doneButton.tap()
            gdprCampaigntableviewcellCell.textFields["targetingValueTextFieldOutlet"].tap()
            gdprCampaigntableviewcellCell.textFields["targetingValueTextFieldOutlet"].typeText("en")
            doneButton.tap()
            gdprCampaigntableviewcellCell.staticTexts["Save Campaign"].tap()
            let alertView = self.app.alerts["alertView"].scrollViews.otherElements
            let okButton = alertView.buttons["OK"]
            okButton.tap()
            self.app.tables.children(matching: .other)["Add CCPA Campaign"].forceTapElement()
            let ccpaCampaigntableviewcellCell = self.app.tables.children(matching: .cell).matching(identifier: "campaignTableViewCell").element(boundBy: 1)
            ccpaCampaigntableviewcellCell.textFields["pmTextFieldOutlet"].tap()
            ccpaCampaigntableviewcellCell.textFields["pmTextFieldOutlet"].typeText("529554")
            doneButton.tap()
            ccpaCampaigntableviewcellCell.textFields["targetingKeyTextFieldOutlet"].tap()
            ccpaCampaigntableviewcellCell.textFields["targetingKeyTextFieldOutlet"].typeText("displayMode")
            doneButton.tap()
            ccpaCampaigntableviewcellCell.textFields["targetingValueTextFieldOutlet"].tap()
            ccpaCampaigntableviewcellCell.textFields["targetingValueTextFieldOutlet"].typeText("appLaunch")
            doneButton.tap()
            ccpaCampaigntableviewcellCell.staticTexts["Save Campaign"].tap()
            okButton.tap()
            self.app.savePropertyButton.tap()
            expect(self.app.consentMessage).to(showUp())
            self.app.dismissMessageButton.tap()
            expect(self.app.ccpaConsentMessage).to(showUp())
            self.app.dismissMessageButton.tap()
            expect(self.app.ccpaConsentMessage).notTo(showUp())
        }

        fit("Check feature tab as default PM tab") {
            self.app.addPropertyDetails()
            self.app.tables.children(matching: .other)["Add GDPR Campaign"].tap()
            self.app.swipeUp()
            let gdprCampaigntableviewcellCell = self.app.tables.children(matching: .cell).matching(identifier: "campaignTableViewCell").element(boundBy: 0)
            gdprCampaigntableviewcellCell.textFields["pmTextFieldOutlet"].tap()
            gdprCampaigntableviewcellCell.textFields["pmTextFieldOutlet"].typeText("528826")
            let doneButton = self.app.toolbars["Toolbar"].buttons["Done"]
            doneButton.tap()
            gdprCampaigntableviewcellCell.buttons["dropDown"].tap()
            self.app.pickerWheels["Default"].swipeUp()
            self.app.pickerWheels["Features"].tap()
            doneButton.tap()
            gdprCampaigntableviewcellCell.textFields["targetingKeyTextFieldOutlet"].tap()
            gdprCampaigntableviewcellCell.textFields["targetingKeyTextFieldOutlet"].typeText("language")
            doneButton.tap()
            gdprCampaigntableviewcellCell.textFields["targetingValueTextFieldOutlet"].tap()
            gdprCampaigntableviewcellCell.textFields["targetingValueTextFieldOutlet"].typeText("en")
            doneButton.tap()
            gdprCampaigntableviewcellCell.staticTexts["Save Campaign"].tap()
            let alertView = self.app.alerts["alertView"].scrollViews.otherElements
            let okButton = alertView.buttons["OK"]
            okButton.tap()
            self.app.tables.children(matching: .other)["Add CCPA Campaign"].forceTapElement()
            let ccpaCampaigntableviewcellCell = self.app.tables.children(matching: .cell).matching(identifier: "campaignTableViewCell").element(boundBy: 1)
            ccpaCampaigntableviewcellCell.textFields["pmTextFieldOutlet"].tap()
            ccpaCampaigntableviewcellCell.textFields["pmTextFieldOutlet"].typeText("529554")
            doneButton.tap()
            ccpaCampaigntableviewcellCell.textFields["targetingKeyTextFieldOutlet"].tap()
            ccpaCampaigntableviewcellCell.textFields["targetingKeyTextFieldOutlet"].typeText("displayMode")
            doneButton.tap()
            ccpaCampaigntableviewcellCell.textFields["targetingValueTextFieldOutlet"].tap()
            ccpaCampaigntableviewcellCell.textFields["targetingValueTextFieldOutlet"].typeText("appLaunch")
            doneButton.tap()
            ccpaCampaigntableviewcellCell.staticTexts["Save Campaign"].tap()
            okButton.tap()
            self.app.savePropertyButton.tap()
            expect(self.app.consentMessage).to(showUp())
            self.app.acceptAllButton.tap()
            expect(self.app.ccpaConsentMessage).to(showUp())
            self.app.ccpaAcceptAllButton.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
            self.app.navigationBars["Property Debug Info"].buttons["Menu"].tap()
            self.app.tables.staticTexts["Load GDPR PM"].tap()
            expect(self.app.featuresTab).to(showUp())
        }

        /**
         @Description - User submit valid property details and tap on Save then expected consent messages should display when user select Accept all then user will navigate to Site Info screen showing ConsentUUID, EUConsent and all Vendors & Purpose Consents when user navigate back & tap on the site name and select MANAGE PREFERENCES button from consent message view then user will see all vendors & purposes as selected")
         */
        fit("Accept all from German Message") {
            self.app.addPropertyDetails()
            self.app.tables.children(matching: .other)["Add GDPR Campaign"].tap()
            self.app.swipeUp()
            let gdprCampaigntableviewcellCell = self.app.tables.children(matching: .cell).matching(identifier: "campaignTableViewCell").element(boundBy: 0)
            gdprCampaigntableviewcellCell.textFields["pmTextFieldOutlet"].tap()
            gdprCampaigntableviewcellCell.textFields["pmTextFieldOutlet"].typeText("528826")
            let doneButton = self.app.toolbars["Toolbar"].buttons["Done"]
            doneButton.tap()
            gdprCampaigntableviewcellCell.textFields["targetingKeyTextFieldOutlet"].tap()
            gdprCampaigntableviewcellCell.textFields["targetingKeyTextFieldOutlet"].typeText("messageLanguage")
            doneButton.tap()
            gdprCampaigntableviewcellCell.textFields["targetingValueTextFieldOutlet"].tap()
            gdprCampaigntableviewcellCell.textFields["targetingValueTextFieldOutlet"].typeText("german")
            doneButton.tap()
            gdprCampaigntableviewcellCell.staticTexts["Save Campaign"].tap()
            let alertView = self.app.alerts["alertView"].scrollViews.otherElements
            let okButton = alertView.buttons["OK"]
            okButton.tap()
            self.app.tables.children(matching: .other)["Add CCPA Campaign"].forceTapElement()
            let ccpaCampaigntableviewcellCell = self.app.tables.children(matching: .cell).matching(identifier: "campaignTableViewCell").element(boundBy: 1)
            ccpaCampaigntableviewcellCell.textFields["pmTextFieldOutlet"].tap()
            ccpaCampaigntableviewcellCell.textFields["pmTextFieldOutlet"].typeText("529554")
            doneButton.tap()
            ccpaCampaigntableviewcellCell.textFields["targetingKeyTextFieldOutlet"].tap()
            ccpaCampaigntableviewcellCell.textFields["targetingKeyTextFieldOutlet"].typeText("displayMode")
            doneButton.tap()
            ccpaCampaigntableviewcellCell.textFields["targetingValueTextFieldOutlet"].tap()
            ccpaCampaigntableviewcellCell.textFields["targetingValueTextFieldOutlet"].typeText("appLaunch")
            doneButton.tap()
            ccpaCampaigntableviewcellCell.staticTexts["Save Campaign"].tap()
            okButton.tap()
            self.app.savePropertyButton.tap()
            expect(self.app.consentMessageInGerman).to(showUp())
            self.app.acceptAllButtonInGerman.tap()
            expect(self.app.ccpaConsentMessage).to(showUp())
            self.app.ccpaAcceptAllButton.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
            self.app.backButton.tap()
            expect(self.app.propertyList).to(showUp())
            self.app.propertyItem.tap()
            expect(self.app.consentMessageInGerman).to(showUp())
            self.app.showOptionsButtonInGerman.tap()
            expect(self.app.privacyManager).to(showUp())
        }
    }
}

extension XCUIElement {
    func forceTapElement() {
        if self.isHittable {
            self.tap()
        }
        else {
            let coordinate: XCUICoordinate = self.coordinate(withNormalizedOffset: CGVector(dx:0.0, dy:0.0))
            coordinate.tap()
        }
    }
}
