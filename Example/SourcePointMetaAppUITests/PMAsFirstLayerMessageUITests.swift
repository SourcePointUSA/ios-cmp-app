//
//  PMAsFirstLayerMessage.swift
//  SourcePointMetaAppUITests
//
//  Created by Vilas on 05/08/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import Unified_MetaApp

class PMAsFirstLayerMessageUITests: QuickSpec {
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

        /**
         @Description - User submit valid property details for loading PM as first layer message and tap on Save then expected PM should load
         */
        it("PM as first layer Message") {
            self.app.addPropertyWithCampaignDetails(targetingKey: self.propertyData.targetingKeyForPMAsFirstLayer, targetingValue: self.propertyData.targetingValueForPMAsFirstLayer)
            self.app.savePropertyButton.tap()
            expect(self.app.privacyManager).to(showUp())
        }
        
        /**
         @Description - User submit valid property details for loading PM as first layer message and tap on Save then expected PM should load when user click on Cancel then user should navigate  to the CCPA consent message screen
         */
        it("Cancel from PM as first layer Message") {
            self.app.addPropertyWithCampaignDetails(targetingKey: self.propertyData.targetingKeyForPMAsFirstLayer, targetingValue: self.propertyData.targetingValueForPMAsFirstLayer)
            self.app.savePropertyButton.tap()
            expect(self.app.privacyManager).to(showUp())
            self.app.cancelButton.tap()
            expect(self.app.ccpaConsentMessage).to(showUp())
        }

        /**
         @Description - User submit valid property details for loading PM as first layer message and tap on Save then expected PM should load when user select Accept All then consent should get stored when user tap on the Show PM link from the info screen then user should navigate to PM screen showing all toggle as selected
         */
        it("Consents for PM as first layer Message") {
            self.app.addPropertyWithCampaignDetails(targetingKey: self.propertyData.targetingKeyForPMAsFirstLayer, targetingValue: self.propertyData.targetingValueForPMAsFirstLayer)
            self.app.savePropertyButton.tap()
            expect(self.app.privacyManager).to(showUp())
            self.app.acceptAllButton.forceTapElement()
            expect(self.app.ccpaConsentMessage).to(showUp())
            self.app.ccpaAcceptAllButton.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
            self.app.menuButton.tap()
            self.app.loadGDPRPM.tap()
            expect(self.app.privacyManager).to(showUp())
            self.app.testPMToggles(value: 1)
        }

        /**
         @Description - User submit valid property details for loading PM as first layer message with unique AuthID and tap on Save then expected PM should load when user select Accept All then consent should get stored when user tap on the property from list screen then user should see all toggle as true
         */
        it("Consents with AuthID for PM as first layer Message") {
            self.app.addPropertyWithCampaignDetails(targetingKey: self.propertyData.targetingKeyForPMAsFirstLayer, targetingValue: self.propertyData.targetingValueForPMAsFirstLayer)
            self.app.authIdTextFieldOutlet.tap()
            self.app.authIdTextFieldOutlet.typeText(self.app.dateFormatterForAuthID())
            self.app.doneButton.tap()
            self.app.savePropertyButton.tap()
            expect(self.app.privacyManager).to(showUp())
            self.app.swipeDown()
            self.app.acceptAllButton.forceTapElement()
            expect(self.app.propertyDebugInfo).to(showUp())
            if self.app.backButton.exists {
                self.app.backButton.forceTapElement()
            }
            expect(self.app.propertyList).to(showUp())
            self.app.propertyItem.tap()
            expect(self.app.privacyManager).to(showUp())
            self.app.testPMToggles(value: 1)
        }
    }
}
