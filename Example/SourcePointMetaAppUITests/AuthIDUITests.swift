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
@testable import Unified_MetaApp

class AuthIDUITests: QuickSpec {
    var app: MetaApp!
    var propertyData = PropertyData()
    
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

        func addAuthID() {
            self.app.authIdTextFieldOutlet.tap()
            self.app.authIdTextFieldOutlet.typeText(self.app.dateFormatterForAuthID())
            self.app.doneButton.tap()
        }
        
        /**
         @Description - User submit valid property details to show message once with AuthID and tap on Save Then expected message should load When user select Accept All then consent information should get stored when user reset the property then user should not see the message again
         */
        it("No Message shown with show once criteria when consent already saved with AuthID") {
            self.app.addPropertyWithCampaignDetails(targetingKey: self.propertyData.targetingKey, targetingValue: self.propertyData.targetingEnglishValue)
            addAuthID()
            self.app.savePropertyButton.tap()
            expect(self.app.consentMessage).to(showUp())
            self.app.acceptAllButton.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
            if self.app.backButton.exists {
                self.app.backButton.forceTapElement()
            }
            expect(self.app.propertyList).to(showUp())
            if self.app.propertyItem.exists {
                self.app.propertyItem.swipeLeft()
                self.app.resetPropertyButton.tap()
                if self.app.alertOKButton.exists {
                    self.app.alertOKButton.tap()
                }
            }
            expect(self.app.consentMessage).notTo(showUp())
        }
        
        /**
         @Description - User submit valid property details with unique AuthID and tap on Save then expected message should load when user navigate to PM and tap on Accept All then all consent data should be stored when user try to create new property with same details but another unique authId and navigate to PM then user should not see already saved consent
         */
        it("Changing AuthID will change the consents too") {
            self.app.addPropertyWithCampaignDetails(targetingKey: self.propertyData.targetingKey, targetingValue: self.propertyData.targetingFrenchValue)
            addAuthID()
            self.app.savePropertyButton.tap()
            expect(self.app.consentMessage).to(showUp())
            self.app.acceptAllButton.forceTapElement()
            expect(self.app.propertyDebugInfo).to(showUp())
            if self.app.backButton.exists {
                self.app.backButton.forceTapElement()
            }
            expect(self.app.propertyList).to(showUp())
            self.app.addPropertyButton.tap()
            expect(self.app.newProperty).to(showUp())
            self.app.addPropertyDetailsForAuthID(targetingKey:self.propertyData.targetingKey, targetingValue: self.propertyData.targetingFrenchValue)
            addAuthID()
            self.app.savePropertyButton.tap()
            expect(self.app.consentMessage).to(showUp())
            self.app.showOptionsButton.forceTapElement()
            expect(self.app.privacyManager).to(showUp())
            self.app.testPMToggles(value: 0)
        }

        // Test case is failing with Unified SDK
        /**
         @Description - User submit valid property details with unique AuthID and tap on Save then expected Message should load when user navigate to PM and tap on Accept All then all consent data will get stored when user delete this property and create property with same details and navigate to PM then user should see already saved consents
         */
        //        it("Check consents with same AuthID after deleting and recreating property") {
        //            self.app.addPropertyWithCampaignDetails(targetingKey: self.propertyData.targetingKey, targetingValue: self.propertyData.targetingFrenchValue)
        //            let authID = self.app.dateFormatterForAuthID()
        //            self.app.authIdTextFieldOutlet.tap()
        //            self.app.authIdTextFieldOutlet.typeText(authID)
        //            self.app.doneButton.tap()
        //            self.app.savePropertyButton.tap()
        //            expect(self.app.consentMessage).to(showUp())
        //            self.app.acceptAllButton.tap()
        //            expect(self.app.ccpaConsentMessage).to(showUp())
        //            self.app.ccpaAcceptAllButton.tap()
        //            expect(self.app.propertyDebugInfo).to(showUp())
        //            self.app.backButton.tap()
        //            self.app.addPropertyWithCampaignDetails(targetingKey: self.propertyData.targetingKey, targetingValue: self.propertyData.targetingFrenchValue)
        //            self.app.authIdTextFieldOutlet.tap()
        //            self.app.authIdTextFieldOutlet.typeText(authID)
        //            self.app.doneButton.tap()
        //            self.app.savePropertyButton.tap()
        //            expect(self.app.consentMessage).to(showUp())
        //            self.app.showOptionsButton.tap()
        //            expect(self.app.privacyManager).to(showUp())
        //            self.app.testPMToggles(value: 1)
        //        }
    }
}
