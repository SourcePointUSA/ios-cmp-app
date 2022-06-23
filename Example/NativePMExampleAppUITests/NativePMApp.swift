//
//  NativePMApp.swift
//  NativePMExampleAppUITests
//
//  Created by Vilas on 27/09/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
import Nimble

protocol App {
    func launch()
    func terminate()
    func relaunch(clean: Bool)
}

extension XCUIApplication: App {
    func relaunch(clean: Bool = false) {
        UserDefaults.standard.synchronize()
        self.terminate()
        clean ?
            launchArguments.append("-cleanAppsData") :
            launchArguments.removeAll { $0 == "-cleanAppsData" }
        launch()
    }
}

class NativePMApp: XCUIApplication {

    var doNotSellMyPersonalInformation: XCUIElement {
        tables.cells.containing(.staticText, identifier:"Do Not Sell My Personal Information").firstMatch
    }

    var category: XCUIElement {
        tables.cells.containing(.staticText, identifier:"Purpose 1").firstMatch
    }

    var category2: XCUIElement {
        tables.cells.containing(.staticText, identifier:"Purpose 2").firstMatch
    }
    
    var storeAndAccessInformation: XCUIElement {
        tables.cells.containing(.staticText, identifier:"Store and/or access information on a device").firstMatch
    }

    var createPersonalisedAdsProfile: XCUIElement {
        tables.cells.containing(.staticText, identifier:"Create a personalised ads profile").firstMatch
    }
    
    var seedtag: XCUIElement {
        tables.cells.containing(.staticText, identifier:"Seedtag Advertising S.L").firstMatch
    }

    var freewheel: XCUIElement {
        tables.cells.containing(.staticText, identifier:"Freewheel").firstMatch
    }
    
    var justpremiumBV: XCUIElement {
        tables.cells.containing(.staticText, identifier:"Justpremium BV").firstMatch
    }

    var loopMe: XCUIElement {
        tables.cells.containing(.staticText, identifier:"LoopMe Limited").firstMatch
    }
    
    var googleCharts: XCUIElement {
        tables.cells.containing(.staticText, identifier:"Google Charts").firstMatch
    }
    
    var gameAccounts: XCUIElement {
        tables.cells.containing(.staticText, identifier:"Game Accounts").firstMatch
    }

    var acceptButton: XCUIElement {
        buttons["Accept"].firstMatch
    }

    var acceptAllButton: XCUIElement {
        buttons["Accept All"].firstMatch
    }
    
    var managePreferencesButton: XCUIElement {
        buttons["Manage Preferences"].firstMatch
    }

    var rejectAllButton: XCUIElement {
        buttons["Reject All"].firstMatch
    }

    var saveAndExitButton: XCUIElement {
        buttons["Save and Exit"].firstMatch
    }

    var saveAndExitInternalButton: XCUIElement {
        buttons["Save & Exit"].firstMatch
    }

    var homeButton: XCUIElement {
        buttons["Home"].firstMatch
    }

    var backButton: XCUIElement {
        buttons["Back"].firstMatch
    }

    var onButton: XCUIElement {
        buttons["On"].firstMatch
    }

    var offButton: XCUIElement {
        buttons["Off"].firstMatch
    }

    var privacyPolicyButton: XCUIElement {
        buttons["Privacy Policy"].firstMatch
    }

    var consentButton: XCUIElement {
        buttons["CONSENT"].firstMatch
    }

    var legitimateInterestButton: XCUIElement {
        buttons["LEGITIMATE INTEREST"].firstMatch
    }

    var ourPartnersButton: XCUIElement {
        buttons["Our Partners"].firstMatch
    }
    
    var gdprPrivacyManagerButton: XCUIElement {
        buttons["GDPR Privacy Manager"].firstMatch
    }
    
    var ccpaPrivacyManagerButton: XCUIElement {
        buttons["CCPA Privacy Manager"].firstMatch
    }

    func expectedMessageShowUP(element: XCUIElement) {
        expect(element).to(showUp())
        expect(element.hasFocus).to(beTrue())
    }
}

// MARK: - NativePMApp shenanigans
extension NativePMApp {
    func clickButtonUntilElementHasFocus(directionBtn: XCUIRemote.Button, element: XCUIElement)
    {
        var counter = 0
        while(!element.hasFocus && counter < 10) {
            XCUIRemote.shared.press(directionBtn)
            counter += 1
        }
    }
    
    func findAndPress(element: XCUIElement)
    {
        if element.exists {
            expect(element).to(showUp())
            clickButtonUntilElementHasFocus(directionBtn: .down, element: element)
            clickButtonUntilElementHasFocus(directionBtn: .up, element: element)
            expectedMessageShowUP(element: element)
            XCUIRemote.shared.press(.select)
        }
    }
    
    func pressDoNotSellButton()
    {
        XCUIRemote.shared.press(.right)
//            expectedMessageShowUP(element: doNotSellMyPersonalInformation)
//            previous line is commented since appletv.demo "Do Not Sell" button has blank text
        XCUIRemote.shared.press(.select)
        XCUIRemote.shared.press(.left)
    }
    
    func pressStoreAndAccessInformation()
    {
        XCUIRemote.shared.press(.right)
        XCUIRemote.shared.press(.up)
        expectedMessageShowUP(element: storeAndAccessInformation)
        XCUIRemote.shared.press(.select)
        XCUIRemote.shared.press(.down)
        XCUIRemote.shared.press(.left)
    }
    
    func pressHomeAndReturnToHomeViewWithFocusOnPrivacyPolicyButton()
    {
        expect(self.homeButton).to(showUp())
        XCUIRemote.shared.press(.select)
        expectedMessageShowUP(element: privacyPolicyButton)
    }
    
    func pressCategory(element: XCUIElement)
    {
        XCUIRemote.shared.press(.down)
        if acceptAllButton.hasFocus {
            expectedMessageShowUP(element: acceptAllButton)
            XCUIRemote.shared.press(.right)
        }
        expectedMessageShowUP(element: element)
        XCUIRemote.shared.press(.select)
    }
    
    func pressOnButtonInCategoryDetails(elementToEnsure: XCUIElement)
    {
        expectedMessageShowUP(element: backButton)
        XCUIRemote.shared.press(.down)
        expectedMessageShowUP(element: onButton)
        XCUIRemote.shared.press(.select)
        expectedMessageShowUP(element: elementToEnsure)
    }
    
    func pressOffButtonInCategoryDetails(elementToEnsure: XCUIElement)
    {
        expectedMessageShowUP(element: backButton)
        XCUIRemote.shared.press(.down)
        expectedMessageShowUP(element: onButton)
        XCUIRemote.shared.press(.down)
        expectedMessageShowUP(element: offButton)
        XCUIRemote.shared.press(.select)
        expectedMessageShowUP(element: elementToEnsure)
    }
    
    func pressSaveAndExitInCategory()
    {
        XCUIRemote.shared.press(.left)
        expectedMessageShowUP(element: acceptAllButton)
        XCUIRemote.shared.press(.down)
        expectedMessageShowUP(element: saveAndExitInternalButton)
        XCUIRemote.shared.press(.select)
    }
    
    func switchToLegitInterests()
    {
        XCUIRemote.shared.press(.right)
        XCUIRemote.shared.press(.right)
        expectedMessageShowUP(element: legitimateInterestButton)
    }
}
