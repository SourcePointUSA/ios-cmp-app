//
//  AuthIDUITests.swift
//  SourcePointMetaAppUITests
//
//  Created by Vilas on 05/08/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import GDPR_MetaApp

class AuthIDUITests: QuickSpec {
    var app: MetaApp!
    var properyData = PropertyData()
    
    override func spec() {
        beforeSuite {
            self.continueAfterFailure = false
            self.app = MetaApp()
            Nimble.AsyncDefaults.Timeout = 20
            Nimble.AsyncDefaults.PollInterval = 0.5
        }
        
        afterSuite {
            Nimble.AsyncDefaults.Timeout = 1
            Nimble.AsyncDefaults.PollInterval = 0.01
        }
        
        beforeEach {
            self.app.relaunch(clean: true)
        }

        func addAuthID() {
            self.app.authIdTextFieldOutlet.tap()
            self.app.authIdTextFieldOutlet.typeText(self.app.dateFormatterForAuthID())
        }
        
        /**
         @Description - User submit valid property details to show message once with AuthID and tap on Save Then expected message should load When user select Accept All then consent information should get stored when user reset the property then user should not see the message again
         */
        it("No Message shown with show once criteria when consent already saved with AuthID") {
            self.app.addPropertyDetails()
            addAuthID()
            self.app.addTargetingParameter(targetingKey: self.properyData.targetingKey, targetingValue: self.properyData.targetingEnglishValue)
            expect(self.app.consentMessage).to(showUp())
            self.app.acceptAllButton.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
            self.app.backButton.tap()
            expect(self.app.propertyList).to(showUp())
            if self.app.propertyItem.exists {
                self.app.propertyItem.swipeLeft()
                self.app.resetPropertyButton.tap()
                if self.app.alertYesButton.exists {
                    self.app.alertYesButton.tap()
                }
            }
            expect(self.app.consentMessage).notTo(showUp())
        }
        
        /**
         @Description - User submit valid property details with unique AuthID and tap on Save then expected message should load when user navigate to PM and tap on Accept All then all consent data should be stored when user try to create new property with same details but another unique authId and navigate to PM then user should not see already saved consent
         */
        it("Changing AuthID will change the consents too") {
            self.app.addPropertyDetails()
            addAuthID()
            self.app.addTargetingParameter(targetingKey: self.properyData.targetingKey, targetingValue: self.properyData.targetingFrenchValue)
            expect(self.app.consentMessage).to(showUp())
            self.app.showOptionsButton.tap()
            expect(self.app.privacyManager).to(showUp())
            self.app.acceptAllButton.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
            self.app.backButton.tap()
            expect(self.app.propertyList).to(showUp())
            self.app.addPropertyButton.tap()
            expect(self.app.newProperty).to(showUp())
            self.app.accountIDTextFieldOutlet.tap()
            self.app.accountIDTextFieldOutlet.typeText(self.properyData.accountId)
            self.app.propertyIdTextFieldOutlet.tap()
            self.app.propertyIdTextFieldOutlet.typeText(self.properyData.propertyId)
            self.app.propertyTextFieldOutlet.tap()
            self.app.propertyTextFieldOutlet.typeText(self.properyData.propertyName)
            addAuthID()
            self.app.pmTextFieldOutlet.tap()
            self.app.pmTextFieldOutlet.typeText(self.properyData.pmID)
            self.app.addTargetingParameter(targetingKey: self.properyData.targetingKey, targetingValue: self.properyData.targetingFrenchValue)
            expect(self.app.consentMessage).to(showUp())
            self.app.showOptionsButton.tap()
            expect(self.app.privacyManager).to(showUp())
            self.app.testPMToggles(value: 0)
        }
        
        /**
         @Description - User submit valid property details with unique AuthID and tap on Save then expected Message should load when user navigate to PM and tap on Accept All then all consent data will get stored when user delete this property and create property with same details and navigate to PM then user should see already saved consents
         */
        it("Check consents with same AuthID after deleting and recreating property") {
            self.app.addPropertyDetails()
            let authID = self.app.dateFormatterForAuthID()
            self.app.authIdTextFieldOutlet.tap()
            self.app.authIdTextFieldOutlet.typeText(authID)
            self.app.addTargetingParameter(targetingKey: self.properyData.targetingKey, targetingValue: self.properyData.targetingFrenchValue)
            expect(self.app.consentMessage).to(showUp())
            self.app.showOptionsButton.tap()
            expect(self.app.privacyManager).to(showUp())
            self.app.acceptAllButton.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
            self.app.backButton.tap()
            self.app.addPropertyDetails()
            self.app.authIdTextFieldOutlet.tap()
            self.app.authIdTextFieldOutlet.typeText(authID)
            self.app.addTargetingParameter(targetingKey: self.properyData.targetingKey, targetingValue: self.properyData.targetingFrenchValue)
            expect(self.app.consentMessage).to(showUp())
            self.app.showOptionsButton.tap()
            expect(self.app.privacyManager).to(showUp())
            self.app.testPMToggles(value: 1)
        }
        
        /**
         @Description - User submit valid property details without AuthID and tap on Save then expected consent message should display when user select Accept all then user will navigate to Site Info screen showing ConsentUUID, EUConsent and all Vendors & Purpose Consents when user navigate back & edit property with unique AuthID then user should not see message again should see given consent information
         */
        it("When consents already given then Message will not appear with AuthID and consents will attach with AuthID") {
            self.app.addPropertyDetails()
            self.app.addTargetingParameter(targetingKey: self.properyData.targetingKeyShowOnce, targetingValue: self.properyData.targetingValueShowOnce)
            expect(self.app.consentMessage).to(showUp())
            self.app.acceptAllButton.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
            self.app.backButton.tap()
            expect(self.app.propertyList).to(showUp())
            if self.app.propertyItem.exists {
                self.app.propertyItem.swipeLeft()
                self.app.editPropertyButton.tap()
                expect(self.app.editProperty).to(showUp())
                addAuthID()
                self.app.savePropertyButton.tap()
                expect(self.app.propertyDebugInfo).to(showUp())
            }
        }
    }
}
