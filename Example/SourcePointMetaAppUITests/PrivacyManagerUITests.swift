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
@testable import Unified_MetaApp

class PrivacyManagerUITests: QuickSpec {
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
         @Description - User submit valid property details and tap on Save then expected consent message should display when user select MANAGE PREFERENCES then user navigate to PM and should see all toggles as false when user select Save & Exit without any change then user should navigate back to the info screen showing no Vendors and Purposes as selected
         */
        it("Save and Exit without any purposes selected from Privacy Manager via Message") {
            self.app.addPropertyWithCampaignDetails(targetingKey: self.propertyData.targetingKey, targetingValue: self.propertyData.targetingFrenchValue)
            self.app.savePropertyButton.tap()
            expect(self.app.consentMessage).to(showUp())
            self.app.showOptionsButton.tap()
            expect(self.app.privacyManager).to(showUp())
            self.app.saveAndExitButton.tap()
            expect(self.app.ccpaConsentMessage).to(showUp())
            self.app.ccpaAcceptAllButton.tap()
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
         @Description - User submit valid property details and tap on save then the expected consent message should display and when user click on MANAGE PREFERENCES/show options button then user will see Privacy Manager screen when user select reject All then user will navigate to Site Info screen showing ConsentUUID, EUConsent and all Purpose Consents when user navigate back and tap on the site name And click on MANAGE PREFERENCES button from consent message then user should see all purposes are deselected
         */
        ("Reject all from Privacy Manager") {
            self.app.addPropertyWithCampaignDetails(targetingKey: self.propertyData.targetingKey, targetingValue: self.propertyData.targetingFrenchValue)
            self.app.savePropertyButton.tap()
            expect(self.app.consentMessage).to(showUp())
            self.app.showOptionsButton.tap()
            expect(self.app.privacyManager).to(showUp())
            self.app.rejectAllButton.tap()
            expect(self.app.ccpaConsentMessage).to(showUp())
            self.app.ccpaAcceptAllButton.tap()
            expect(self.app.propertyDebugInfo).to(showUp())
            self.app.backButton.tap()
            expect(self.app.propertyList).to(showUp())
            self.app.propertyItem.tap()
            expect(self.app.consentMessage).to(showUp())
            self.app.showOptionsButton.tap()
            expect(self.app.privacyManager).to(showUp())
            self.app.testPMToggles(value: 0)
        }
    }
