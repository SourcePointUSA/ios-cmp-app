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


        it("Error message with all fields as blank") {
            self.app.addPropertyWithWrongPropertyDetails(accountId: "", propertyName:"")
            expect(self.app.propertyFieldValidationItem).to(showUp())
        }

        it("Error message with account ID as blank") {
            self.app.addPropertyWithWrongPropertyDetails(accountId: "", propertyName: self.properyData.propertyName)
            expect(self.app.propertyFieldValidationItem).to(showUp())
        }

        it("Error message with property Name as blank") {
            self.app.addPropertyWithWrongPropertyDetails(accountId: self.properyData.accountId, propertyName:"")
            expect(self.app.propertyFieldValidationItem).to(showUp())
        }

        it("Error message for blank targeting parameter fields") {
            self.app.deleteProperty()
            expect(self.app.propertyList).to(showUp())
            self.app.addPropertyButton.tap()
            self.app.tables.children(matching: .other)["Add GDPR Campaign"].tap()
            self.app.swipeUp()
            let campaigntableviewcellCell = self.app.tables.children(matching: .cell).matching(identifier: "campaignTableViewCell").element(boundBy: 0)
            campaigntableviewcellCell.staticTexts["Targeting Param"].tap()
            expect(self.app.targetingParameterValidationItem).to(showUp())
        }

        it("Error message for blank targeting parameter key fields") {
            self.app.deleteProperty()
            expect(self.app.propertyList).to(showUp())
            self.app.addPropertyButton.tap()
            self.app.tables.children(matching: .other)["Add GDPR Campaign"].tap()
            self.app.swipeUp()
            let campaigntableviewcellCell = self.app.tables.children(matching: .cell).matching(identifier: "campaignTableViewCell").element(boundBy: 0)
            campaigntableviewcellCell.textFields["targetingKeyTextFieldOutlet"].tap()
            campaigntableviewcellCell.textFields["targetingKeyTextFieldOutlet"].typeText("abc")
            campaigntableviewcellCell.staticTexts["Targeting Param"].tap()
            expect(self.app.targetingParameterValidationItem).to(showUp())
        }

        it("Error message for blank targeting parameter value fields") {
            self.app.deleteProperty()
            expect(self.app.propertyList).to(showUp())
            self.app.addPropertyButton.tap()
            self.app.tables.children(matching: .other)["Add GDPR Campaign"].tap()
            self.app.swipeUp()
            let campaigntableviewcellCell = self.app.tables.children(matching: .cell).matching(identifier: "campaignTableViewCell").element(boundBy: 0)
            campaigntableviewcellCell.textFields["targetingValueTextFieldOutlet"].tap()
            campaigntableviewcellCell.textFields["targetingValueTextFieldOutlet"].typeText("abc")
            campaigntableviewcellCell.staticTexts["Targeting Param"].tap()
            expect(self.app.targetingParameterValidationItem).to(showUp())
        }

        it("Check no message displayed for wrong Account Id") {
            self.app.addPropertyWithWrongPropertyDetails(accountId: self.properyData.wrongAccountId, propertyName:self.properyData.propertyName)
            expect(self.app.consentMessage).notTo(showUp())
        }

        it("Check no message displayed for wrong Property Name") {
            self.app.addPropertyWithWrongPropertyDetails(accountId: self.properyData.accountId, propertyName:self.properyData.wrongPropertyName)
            expect(self.app.consentMessage).notTo(showUp())
        }
    }
}
