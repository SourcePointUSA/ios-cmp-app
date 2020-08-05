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
@testable import GDPR_MetaApp

class PMAsFirstLayerMessageUITests: QuickSpec {
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
        
        func addTargetingParameter() {
            self.app.targetingParamKeyTextFieldOutlet.tap()
            self.app.targetingParamKeyTextFieldOutlet.typeText(self.properyData.targetingKeyForPMAsFirstLayer)
            self.app.targetingParamValueTextFieldOutlet.tap()
            self.app.targetingParamValueTextFieldOutlet.typeText(self.properyData.targetingValueForPMAsFirstLayer)
            self.app.swipeUp()
            self.app.addTargetingParamButton.tap()
            self.app.savePropertyButton.tap()
        }
        /**
         @Description - User submit valid property details for loading PM as first layer message and tap on Save then expected PM should load
         */
        it("PM as first layer Message") {
            self.app.addPropertyDetails()
            addTargetingParameter()
            expect(self.app.privacyManager).to(showUp())
        }
        
        /**
         @Description - User submit valid property details for loading PM as first layer message and tap on Save then expected PM should load when user select Accept All then consent should get stored when user tap on the property from list screen and click on Cancel then user should navigate back to the info screen
         */
        it("Cancel from PM as first layer Message") {
            self.app.addPropertyDetails()
            addTargetingParameter()
            expect(self.app.privacyManager).to(showUp())
            self.app.acceptAllButton.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
            self.app.backButton.tap()
            expect(self.app.propertyList).to(showUp())
            self.app.propertyItem.tap()
            expect(self.app.privacyManager).to(showUp())
            self.app.cancelButton.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
        }
        
        /**
         @Description - User submit valid property details for loading PM as first layer message and tap on Save then expected PM should load when user select Accept All then consent should get stored when user tap on the Show PM link from the info screen then user should navigate to PM screen showing all toggle as selected
         */
        it("Consents for PM as first layer Message") {
            self.app.addPropertyDetails()
            addTargetingParameter()
            expect(self.app.privacyManager).to(showUp())
            self.app.acceptAllButton.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
            self.app.showPMButton.tap()
            expect(self.app.privacyManager).to(showUp())
            self.app.testPMToggles(value: 1)
        }
        
        /**
         This is currently issue in SDK and need to be fixed from backend, currently PM is not attached with Property in the case of PM as first layer Message.
         @Description - User submit valid property details for loading PM as first layer message with unique AuthID and tap on Save then expected PM should load when user select Accept All then consent should get stored when user tap on the property from list screen then user should see all toggle as true
         */
        //        it("Consents with AuthID for PM as first layer Message") {
        //            self.app.addPropertyDetails()
        //            self.app.authIdTextFieldOutlet.tap()
        //            self.app.authIdTextFieldOutlet.typeText(self.app.dateFormatterForAuthID())
        //            self.app.targetingParamKeyTextFieldOutlet.tap()
        //            self.app.targetingParamKeyTextFieldOutlet.typeText(self.properyData.targetingKeyForPMAsFirstLayer)
        //            self.app.targetingParamValueTextFieldOutlet.tap()
        //            self.app.targetingParamValueTextFieldOutlet.typeText(self.properyData.targetingValueForPMAsFirstLayer)
        //            self.app.swipeUp()
        //            self.app.addTargetingParamButton.tap()
        //            self.app.savePropertyButton.tap()
        //            expect(self.app.privacyManager).to(showUp())
        //            self.app.acceptAllButton.tap()
        //            expect(self.app.propertyDebugInfo).to(showUp())
        //            self.app.backButton.tap()
        //            expect(self.app.propertyList).to(showUp())
        //            self.app.propertyItem.tap()
        //            expect(self.app.privacyManager).to(showUp())
        //            self.app.testPMToggles(value: 1)
        //        }
    }
}
