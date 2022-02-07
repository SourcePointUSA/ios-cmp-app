//
//  NativePMUITests.swift
//  NativePMExampleAppUITests
//
//  Created by Vilas on 27/09/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import NativePMExampleApp

class NativePMUITests: QuickSpec {

    var app: NativePMApp!

    override func spec() {
        beforeSuite {
            self.continueAfterFailure = false
            self.app = NativePMApp()
            Nimble.AsyncDefaults.timeout = .seconds(10)
            Nimble.AsyncDefaults.pollInterval = .milliseconds(500)
        }

        afterSuite {
            Nimble.AsyncDefaults.timeout = .seconds(1)
            Nimble.AsyncDefaults.pollInterval = .milliseconds(100)
        }

        beforeEach {
            self.app.relaunch(clean: true)
        }

        it("Accept all through CCPA & GDPR Privacy Manager") {
            self.app.findAndPress(element: self.app.ccpaPrivacyManagerButton)
            expect(self.app.acceptButton).to(showUp())
            self.app.pressDoNotSellButton()
            self.app.findAndPress(element: self.app.acceptButton)
            self.app.findAndPress(element: self.app.gdprPrivacyManagerButton)
            expect(self.app.acceptButton).to(showUp())
            self.app.pressStoreAndAccessInformation()
            self.app.findAndPress(element: self.app.acceptButton)
        }

        it("Reject all through CCPA & GDPR Privacy Manager") {
            self.app.findAndPress(element: self.app.gdprPrivacyManagerButton)
            self.app.expectedMessageShowUP(element: self.app.acceptButton)
            self.app.findAndPress(element: self.app.rejectAllButton)
            self.app.findAndPress(element: self.app.ccpaPrivacyManagerButton)
            self.app.expectedMessageShowUP(element: self.app.acceptButton)
            self.app.findAndPress(element: self.app.rejectAllButton)
        }

        it("Save and Exit through CCPA & GDPR Privacy Manager") {
            self.app.findAndPress(element: self.app.gdprPrivacyManagerButton)
            self.app.expectedMessageShowUP(element: self.app.acceptButton)
            self.app.findAndPress(element: self.app.managePreferencesButton)
            self.app.expectedMessageShowUP(element: self.app.homeButton)
            self.app.findAndPress(element: self.app.saveAndExitInternalButton)
            self.app.findAndPress(element: self.app.ccpaPrivacyManagerButton)
            self.app.expectedMessageShowUP(element: self.app.acceptButton)
            self.app.findAndPress(element: self.app.managePreferencesButton)
            self.app.expectedMessageShowUP(element: self.app.homeButton)
            self.app.findAndPress(element: self.app.saveAndExitInternalButton)
        }

        it("Privacy policy of CCPA & GDPR Privacy Manager") {
            self.app.findAndPress(element: self.app.ccpaPrivacyManagerButton)
            self.app.expectedMessageShowUP(element: self.app.acceptButton)
            self.app.findAndPress(element: self.app.privacyPolicyButton)
            self.app.pressHomeAndReturnToHomeViewWithFocusOnPrivacyPolicyButton()
            self.app.findAndPress(element: self.app.acceptButton)
            self.app.findAndPress(element: self.app.gdprPrivacyManagerButton)
            self.app.expectedMessageShowUP(element: self.app.acceptButton)
            self.app.findAndPress(element: self.app.privacyPolicyButton)
            self.app.pressHomeAndReturnToHomeViewWithFocusOnPrivacyPolicyButton()
            self.app.findAndPress(element: self.app.acceptButton)
        }

        it("Manage Preferences through CCPA & GDPR Privacy Manager with few purposes ON") {
            self.app.findAndPress(element: self.app.ccpaPrivacyManagerButton)
            self.app.expectedMessageShowUP(element: self.app.acceptButton)
            self.app.findAndPress(element: self.app.managePreferencesButton)
            expect(self.app.homeButton).to(showUp())
            self.app.pressCategory(element: self.app.category)
            self.app.pressOnButtonInCategoryDetails(elementToEnsure: self.app.category2)
            self.app.pressSaveAndExitInCategory()
            self.app.findAndPress(element: self.app.gdprPrivacyManagerButton)
            self.app.expectedMessageShowUP(element: self.app.acceptButton)
            self.app.findAndPress(element: self.app.managePreferencesButton)
            expect(self.app.homeButton).to(showUp())
            self.app.pressCategory(element: self.app.storeAndAccessInformation)
            self.app.pressOnButtonInCategoryDetails(elementToEnsure: self.app.storeAndAccessInformation)
            self.app.pressSaveAndExitInCategory()
        }

        it("Manage Preferences through CCPA & GDPR Privacy Manager with few purposes OFF") {
            self.app.findAndPress(element: self.app.ccpaPrivacyManagerButton)
            self.app.expectedMessageShowUP(element: self.app.acceptButton)
            self.app.findAndPress(element: self.app.managePreferencesButton)
            expect(self.app.homeButton).to(showUp())
            self.app.pressCategory(element: self.app.category)
            self.app.pressOffButtonInCategoryDetails(elementToEnsure: self.app.category2)
            self.app.pressSaveAndExitInCategory()
            self.app.findAndPress(element: self.app.gdprPrivacyManagerButton)
            self.app.expectedMessageShowUP(element: self.app.acceptButton)
            self.app.findAndPress(element: self.app.managePreferencesButton)
            expect(self.app.homeButton).to(showUp())
            self.app.pressCategory(element: self.app.storeAndAccessInformation)
            self.app.pressOffButtonInCategoryDetails(elementToEnsure: self.app.storeAndAccessInformation)
            self.app.pressSaveAndExitInCategory()
        }

        it("Our Partners through CCPA & GDPR Privacy Manager with few purposes On") {
            self.app.findAndPress(element: self.app.ccpaPrivacyManagerButton)
            self.app.expectedMessageShowUP(element: self.app.acceptButton)
            self.app.findAndPress(element: self.app.ourPartnersButton)
            expect(self.app.homeButton).to(showUp())
            self.app.pressCategory(element: self.app.freewheel)
            self.app.pressOnButtonInCategoryDetails(elementToEnsure: self.app.seedtag)
            self.app.pressSaveAndExitInCategory()
            self.app.findAndPress(element: self.app.gdprPrivacyManagerButton)
            self.app.expectedMessageShowUP(element: self.app.acceptButton)
            self.app.findAndPress(element: self.app.ourPartnersButton)
            expect(self.app.homeButton).to(showUp())
            self.app.pressCategory(element: self.app.loopMe)
            self.app.pressOnButtonInCategoryDetails(elementToEnsure: self.app.googleCharts)
            self.app.pressSaveAndExitInCategory()
        }

        it("Our Partners through CCPA & GDPR Privacy Manager with few purposes OFF") {
            self.app.findAndPress(element: self.app.ccpaPrivacyManagerButton)
            self.app.expectedMessageShowUP(element: self.app.acceptButton)
            self.app.findAndPress(element: self.app.ourPartnersButton)
            expect(self.app.homeButton).to(showUp())
            self.app.pressCategory(element: self.app.freewheel)
            self.app.pressOffButtonInCategoryDetails(elementToEnsure: self.app.seedtag)
            self.app.pressSaveAndExitInCategory()
            self.app.findAndPress(element: self.app.gdprPrivacyManagerButton)
            self.app.expectedMessageShowUP(element: self.app.acceptButton)
            self.app.findAndPress(element: self.app.ourPartnersButton)
            expect(self.app.homeButton).to(showUp())
            self.app.pressCategory(element: self.app.loopMe)
            self.app.pressOffButtonInCategoryDetails(elementToEnsure: self.app.googleCharts)
            self.app.pressSaveAndExitInCategory()
        }

        it("Manage Preferences through GDPR Privacy Manager with few Legitimate interest purposes ON") {
            self.app.findAndPress(element: self.app.gdprPrivacyManagerButton)
            self.app.expectedMessageShowUP(element: self.app.acceptButton)
            self.app.findAndPress(element: self.app.managePreferencesButton)
            expect(self.app.homeButton).to(showUp())
            self.app.switchToLegitInterests()
            self.app.pressCategory(element: self.app.createPersonalisedAdsProfile)
            self.app.pressOnButtonInCategoryDetails(elementToEnsure: self.app.createPersonalisedAdsProfile)
            self.app.pressSaveAndExitInCategory()
        }

        it("Manage Preferences through GDPR Privacy Manager with few Legitimate interest purposes OFF") {
            self.app.findAndPress(element: self.app.gdprPrivacyManagerButton)
            self.app.expectedMessageShowUP(element: self.app.acceptButton)
            self.app.findAndPress(element: self.app.managePreferencesButton)
            expect(self.app.homeButton).to(showUp())
            self.app.switchToLegitInterests()
            self.app.pressCategory(element: self.app.createPersonalisedAdsProfile)
            self.app.pressOffButtonInCategoryDetails(elementToEnsure: self.app.createPersonalisedAdsProfile)
            self.app.pressSaveAndExitInCategory()
        }

        it("Our Partners through GDPR Privacy Manager with few Legitimate interest purposes ON") {
            self.app.findAndPress(element: self.app.gdprPrivacyManagerButton)
            self.app.expectedMessageShowUP(element: self.app.acceptButton)
            self.app.findAndPress(element: self.app.ourPartnersButton)
            expect(self.app.homeButton).to(showUp())
            self.app.switchToLegitInterests()
            self.app.pressCategory(element: self.app.loopMe)
            self.app.expectedMessageShowUP(element: self.app.backButton)
            self.app.pressOnButtonInCategoryDetails(elementToEnsure: self.app.loopMe)
            self.app.pressSaveAndExitInCategory()
        }

        it("Our Partners through GDPR Privacy Manager with few Legitimate interest purposes Off") {
            self.app.findAndPress(element: self.app.gdprPrivacyManagerButton)
            self.app.expectedMessageShowUP(element: self.app.acceptButton)
            self.app.findAndPress(element: self.app.ourPartnersButton)
            expect(self.app.homeButton).to(showUp())
            self.app.switchToLegitInterests()
            self.app.pressCategory(element: self.app.loopMe)
            self.app.expectedMessageShowUP(element: self.app.backButton)
            self.app.pressOffButtonInCategoryDetails(elementToEnsure: self.app.loopMe)
            self.app.pressSaveAndExitInCategory()
        }
    }
}
