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
@testable import GDPR_MetaApp

class MetaAppValidationUITests: XCTestCase {

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
            
            
            it("Error message with all fields as blank") {
                self.app.addPropertyWithWrongPropertyDetails(accountId: "",propertyId: "",propertyName:"",pmId:"")
                expect(self.app.propertyFieldValidationItem).to(showUp())
            }
            
            it("Error message with account ID as blank") {
                self.app.addPropertyWithWrongPropertyDetails(accountId: "",propertyId: self.properyData.propertyId,propertyName:self.properyData.propertyName,pmId:self.properyData.pmID)
                expect(self.app.propertyFieldValidationItem).to(showUp())
            }
            
            it("Error message with property ID as blank") {
                self.app.addPropertyWithWrongPropertyDetails(accountId: self.properyData.accountId,propertyId: "",propertyName:self.properyData.propertyName,pmId:self.properyData.pmID)
                expect(self.app.propertyFieldValidationItem).to(showUp())
            }
            
            it("Error message with property Name as blank") {
                self.app.addPropertyWithWrongPropertyDetails(accountId: self.properyData.accountId,propertyId:self.properyData.propertyId,propertyName:"",pmId:self.properyData.pmID)
                expect(self.app.propertyFieldValidationItem).to(showUp())
            }
            
            it("Error message with PM ID as blank") {
                self.app.addPropertyWithWrongPropertyDetails(accountId: self.properyData.accountId,propertyId:self.properyData.propertyId,propertyName:self.properyData.propertyName,pmId:"")
                expect(self.app.propertyFieldValidationItem).to(showUp())
            }
            
            it("Error message for blank targeting parameter fields") {
                self.app.deleteProperty()
                expect(self.app.propertyList).to(showUp())
                self.app.addPropertyButton.tap()
                self.app.addTargetingParameterWithWrongDetails(targetingKey: "", targetingValue:"")
                expect(self.app.targetingParameterValidationItem).to(showUp())
            }
            
            it("Error message for blank targeting parameter key fields") {
                self.app.deleteProperty()
                expect(self.app.propertyList).to(showUp())
                self.app.addPropertyButton.tap()
                self.app.addTargetingParameterWithWrongDetails(targetingKey: "", targetingValue:self.properyData.targetingFrenchValue)
                expect(self.app.targetingParameterValidationItem).to(showUp())
            }
            
            it("Error message for blank targeting parameter value fields") {
                self.app.deleteProperty()
                expect(self.app.propertyList).to(showUp())
                self.app.addPropertyButton.tap()
                self.app.addTargetingParameterWithWrongDetails(targetingKey:self.properyData.targetingKey, targetingValue: "")
                expect(self.app.targetingParameterValidationItem).to(showUp())
            }
            
            it("Check no message displayed for wrong Account Id"){
                self.app.addPropertyWithWrongPropertyDetails(accountId: self.properyData.wrongAccountId,propertyId:self.properyData.propertyId,propertyName:self.properyData.propertyName,pmId:self.properyData.pmID)
                expect(self.app.consentMessage).notTo(showUp())
                expect(self.app.propertyDebugInfo).to(showUp())
            }
            
            it("Check no message displayed for wrong Property Id"){
                self.app.addPropertyWithWrongPropertyDetails(accountId: self.properyData.accountId,propertyId:self.properyData.wrongPropertyId,propertyName:self.properyData.propertyName,pmId:self.properyData.pmID)
                expect(self.app.wrongPropertyIdValidationItem).to(showUp())
            }
            
            it("Check no message displayed for wrong Property Name"){
                self.app.addPropertyWithWrongPropertyDetails(accountId: self.properyData.accountId,propertyId:self.properyData.propertyId,propertyName:self.properyData.wrongPropertyName,pmId:self.properyData.pmID)
                expect(self.app.consentMessage).notTo(showUp())
                expect(self.app.propertyDebugInfo).to(showUp())
            }
            
            it("Check message displayed for wrong Privacy Manager"){
                self.app.addPropertyWithWrongPropertyDetails(accountId: self.properyData.accountId,propertyId:self.properyData.propertyId,propertyName:self.properyData.propertyName,pmId:self.properyData.wrongPMId)
                expect(self.app.consentMessage).to(showUp())
            }
            
            it("Check direct PM load for wrong Privacy Manager"){
                self.app.addPropertyWithWrongPropertyDetails(accountId: self.properyData.accountId,propertyId:self.properyData.propertyId,propertyName:self.properyData.propertyName,pmId:self.properyData.wrongPMId)
                expect(self.app.consentMessage).to(showUp())
                self.app.acceptAllButton.tap()
                expect(self.app.propertyDebugInfo).to(showUp())
                self.app.showPMButton.tap()
                expect(self.app.wrongPMValidationItem).to(showUp())
            }
            
        }
    }
