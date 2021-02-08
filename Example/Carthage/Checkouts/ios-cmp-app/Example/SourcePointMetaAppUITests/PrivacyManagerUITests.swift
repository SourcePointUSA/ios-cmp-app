//
//  PrivacyManagerUITests.swift
//  SourcePointMetaAppUITests
//
//  Created by Vilas on 05/08/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import GDPR_MetaApp

class PrivacyManagerUITests: QuickSpec {
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

        /**
         @Description - User submit valid property details and tap on Save then expected consent message should display when user select MANAGE PREFERENCES then user navigate to PM and should see all toggles as false when user select Save & Exit without any change then user should navigate back to the info screen showing no Vendors and Purposes as selected
         */
        it("Save and Exit without any purposes selected from Privacy Manager via Message") {
            self.app.addPropertyDetails()
            self.app.addTargetingParameter(targetingKey: self.properyData.targetingKey, targetingValue: self.properyData.targetingFrenchValue)
            expect(self.app.consentMessage).to(showUp())
            self.app.showOptionsButton.tap()
            expect(self.app.privacyManager).to(showUp())
            self.app.saveAndExitButton.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
            self.app.backButton.tap()
            expect(self.app.propertyList).to(showUp())
            self.app.propertyItem.tap()
            expect(self.app.consentMessage).to(showUp())
            self.app.showOptionsButton.tap()
            expect(self.app.privacyManager).to(showUp())
            self.app.testPMToggles(value: 0)
        }

        /**
         @Description - User submit valid property details and tap on save then the expected consent message should display and when user click on MANAGE PREFERENCES/show options button then user will see Privacy Manager screen when user select Accept All then user will navigate to Site Info screen showing ConsentUUID, EUConsent and all Purpose Consents when user navigate back and tap on the site name And click on MANAGE PREFERENCES button from consent message then user should see all purposes are selected
         */
        it("Accept all from Privacy Manager via German Message") {
            self.app.addPropertyDetails()
            self.app.addTargetingParameter(targetingKey: self.properyData.messageLanguageTargetingKey, targetingValue: self.properyData.messageLanguageTargetingValue)
            expect(self.app.consentMessageInGerman).to(showUp())
            self.app.showOptionsButtonInGerman.tap()
            expect(self.app.privacyManager).to(showUp())
            self.app.acceptAllButton.tap()
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
