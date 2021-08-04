//
//  MetaAppValidationTests.swift
//  SourcePointMetaAppUITests
//
//  Created by Vrushali Deshpande on 24/08/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import Unified_MetaApp

class MetaAppValidationUITests: QuickSpec {

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

        it("Error message with all fields as blank") {
            self.app.addPropertyWithWrongDetails(accountId: "", propertyName:"")
            expect(self.app.propertyFieldValidationItem).to(showUp())
        }

        it("Error message with account ID as blank") {
            self.app.addPropertyWithWrongDetails(accountId: "", propertyName: self.propertyData.propertyName)
            expect(self.app.propertyFieldValidationItem).to(showUp())
        }

        it("Error message with property Name as blank") {
            self.app.addPropertyWithWrongDetails(accountId: self.propertyData.accountId, propertyName:"")
            expect(self.app.propertyFieldValidationItem).to(showUp())
        }

        it("Error message for blank targeting parameter fields") {
            self.app.setupForMetaAppPropertyValidation()
            self.app.gdprTargetingParamButton.tap()
            expect(self.app.targetingParameterValidationItem).to(showUp())
        }

        it("Error message for blank targeting parameter key fields") {
            self.app.setupForMetaAppPropertyValidation()
            self.app.gdprTargetingKeyTextField.tap()
            self.app.gdprTargetingKeyTextField.typeText(self.propertyData.targetingKey)
            self.app.gdprTargetingParamButton.tap()
            expect(self.app.targetingParameterValidationItem).to(showUp())
        }

        it("Error message for blank targeting parameter value fields") {
            self.app.setupForMetaAppPropertyValidation()
            self.app.gdprTargetingValueTextField.tap()
            self.app.gdprTargetingValueTextField.typeText(self.propertyData.targetingValueShowOnce)
            self.app.gdprTargetingParamButton.tap()
            expect(self.app.targetingParameterValidationItem).to(showUp())
        }

        it("Check no message displayed for wrong Account Id") {
            self.app.addPropertyWithWrongDetails(accountId: self.propertyData.wrongAccountId, propertyName:self.propertyData.propertyName)
            expect(self.app.consentMessage).notTo(showUp())
        }

        it("Check no message displayed for wrong Property Name") {
            self.app.addPropertyWithWrongDetails(accountId: self.propertyData.accountId, propertyName:self.propertyData.wrongPropertyName)
            expect(self.app.consentMessage).notTo(showUp())
        }
    }
}
