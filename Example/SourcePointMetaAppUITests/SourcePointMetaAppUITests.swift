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
         @Description - User submit valid property details and tap on Save then expected consent message should display when user select MANAGE PREFERENCES and tap from Accept All button then consent data should display on info screen when user navigate back and tap on the Property again then user should not see message again when user delete cookies for the property then user should see consent message again.
         */
        fit("Show purpose consents after reset cookies") {
            self.app.addPropertyDetails()
            self.app.tables.children(matching: .other)["Add GDPR Campaign"].tap()
            self.app.swipeUp()
            let campaigntableviewcellCell = self.app.tables.children(matching: .cell).matching(identifier: "campaignTableViewCell").element(boundBy: 0)
            campaigntableviewcellCell.textFields["pmTextFieldOutlet"].tap()
            campaigntableviewcellCell.textFields["pmTextFieldOutlet"].typeText("528826")
            let doneButton = self.app.toolbars["Toolbar"].buttons["Done"]
            doneButton.tap()
            campaigntableviewcellCell.textFields["targetingKeyTextFieldOutlet"].tap()
            campaigntableviewcellCell.textFields["targetingKeyTextFieldOutlet"].typeText("displayMode")
            doneButton.tap()
            campaigntableviewcellCell.textFields["targetingValueTextFieldOutlet"].tap()
            campaigntableviewcellCell.textFields["targetingValueTextFieldOutlet"].typeText("appLaunch")
            doneButton.tap()
            campaigntableviewcellCell.staticTexts["Save Campaign"].tap()
            let alertView = self.app.alerts["alertView"].scrollViews.otherElements
            let okButton = alertView.buttons["OK"]
            okButton.tap()
            self.app.tables.children(matching: .other)["Add CCPA Campaign"].forceTapElement()
            let campaigntableviewcellCell1 = self.app.tables.children(matching: .cell).matching(identifier: "campaignTableViewCell").element(boundBy: 1)
            campaigntableviewcellCell1.textFields["pmTextFieldOutlet"].tap()
            campaigntableviewcellCell1.textFields["pmTextFieldOutlet"].typeText("529554")
            doneButton.tap()
            campaigntableviewcellCell1.textFields["targetingKeyTextFieldOutlet"].tap()
            campaigntableviewcellCell1.textFields["targetingKeyTextFieldOutlet"].typeText("displayMode")
            doneButton.tap()
            campaigntableviewcellCell1.textFields["targetingValueTextFieldOutlet"].tap()
            campaigntableviewcellCell1.textFields["targetingValueTextFieldOutlet"].typeText("appLaunch")
            doneButton.tap()
            campaigntableviewcellCell1.staticTexts["Save Campaign"].tap()
            okButton.tap()
            self.app.savePropertyButton.tap()
            expect(self.app.attMessage).to(showUp())
            self.app.bringItOnButton.tap()
            if self.app.alerts["Allow “Unified-MetaApp” to track your activity across other companies’ apps and websites?"].exists {
            self.app.alerts["Allow “Unified-MetaApp” to track your activity across other companies’ apps and websites?"].scrollViews.otherElements.buttons["Allow"].tap()
            }
            expect(self.app.consentMessage).to(showUp())
            self.app.showOptionsButton.tap()
            expect(self.app.privacyManager).to(showUp())
            self.app.acceptAllButton.tap()
            expect(self.app.ccpaConsentMessage).to(showUp())
            self.app.acceptAllButton.tap()
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
         @Description - User submit valid property details and tap on Save then expected message should load When user select Reject All then consent information should get stored when user swipe on property and choose to delete user should able to delete the property screen
         */
        it("Delete Property from property list") {
            self.app.addPropertyDetails()
            self.app.addTargetingParameter(targetingKey: self.properyData.targetingKey, targetingValue: self.properyData.targetingFrenchValue)
            expect(self.app.consentMessage).to(showUp())
            self.app.rejectAllButton.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
            self.app.backButton.tap()
            expect(self.app.propertyList).to(showUp())
            self.app.deleteProperty()
            expect(self.app.propertyItem).notTo(showUp())
        }

        /**
         @Description - User submit valid property details and tap on Save then expected message should load when user select Accept All then consent information should get stored when user swipe on property and edit the key/parameter details then user should see respective message
         */
        it("Edit Property from property list") {
            self.app.addPropertyDetails()
            self.app.addTargetingParameter(targetingKey: self.properyData.targetingKey, targetingValue: self.properyData.targetingEnglishValue)
            expect(self.app.consentMessage).to(showUp())
            self.app.acceptAllButton.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
            self.app.backButton.tap()
            expect(self.app.propertyList).to(showUp())
            if self.app.propertyItem.exists {
                self.app.propertyItem.swipeLeft()
                self.app.editPropertyButton.tap()
                expect(self.app.editProperty).to(showUp())
                self.app.addTargetingParameter(targetingKey: self.properyData.targetingKey, targetingValue: self.properyData.targetingFrenchValue)
                expect(self.app.consentMessage).to(showUp())
            }
        }

        /**
         @Description - User submit valid property details tap on Save then expected message should load When user dismiss the message then user should see info screen with ConsentUUID details
         */
        it("Check ConsentUUID on Message Dismiss") {
            self.app.addPropertyDetails()
            self.app.addTargetingParameter(targetingKey: self.properyData.targetingKey, targetingValue: self.properyData.targetingEnglishValue)
            expect(self.app.consentMessage).to(showUp())
            self.app.dismissMessageButton.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
        }

        it("Check feature tab as default PM tab") {
            self.app.deleteProperty()
            expect(self.app.propertyList).to(showUp())
            self.app.addPropertyButton.tap()
            expect(self.app.newProperty).to(showUp())
            self.app.accountIDTextFieldOutlet.tap()
            self.app.accountIDTextFieldOutlet.typeText(self.properyData.accountIdOfAccount22)
            self.app.propertyTextFieldOutlet.tap()
            self.app.propertyTextFieldOutlet.typeText(self.properyData.propertyNameOfAccount22)
            self.app.savePropertyButton.tap()
            expect(self.app.consentMessageForAccount22).to(showUp())
            self.app.showOptionsButtonForAccount22.tap()
            expect(self.app.privacyManagerForAccount22).to(showUp())
            expect(self.app.featuresTab).to(showUp())
        }

        /**
         @Description - User submit valid property details and tap on Save then expected consent message should display when user select Accept all then user will navigate to Site Info screen showing ConsentUUID, EUConsent and all Vendors & Purpose Consents when user navigate back & tap on the site name and select MANAGE PREFERENCES button from consent message view then user will see all vendors & purposes as selected")
         */
        it("Accept all from German Message") {
            self.app.addPropertyDetails()
            self.app.addTargetingParameter(targetingKey: self.properyData.messageLanguageTargetingKey, targetingValue: self.properyData.messageLanguageTargetingValue)
            expect(self.app.consentMessageInGerman).to(showUp())
            self.app.acceptAllButtonInGerman.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
            self.app.backButton.tap()
            expect(self.app.propertyList).to(showUp())
            self.app.propertyItem.tap()
            expect(self.app.consentMessageInGerman).to(showUp())
            self.app.showOptionsButtonInGerman.tap()
            expect(self.app.privacyManager).to(showUp())
            self.app.testPMToggles(value: 1)
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
