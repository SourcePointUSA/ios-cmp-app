//
//  Exampleswift
//  SPGDPRExampleAppUITests
//
//  Created by Andre Herculano on 22.06.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
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

protocol GDPRUI {
    var consentUI: XCUIElement { get }
    var privacyManager: XCUIElement { get }
    var consentMessage: XCUIElement { get }
}

class ExampleApp: XCUIApplication {
    var privacySettingsButton: XCUIElement {
        buttons["privacySettingsButton"].firstMatch
    }

    var clearConsentButton: XCUIElement {
        buttons["clearConsentButton"].firstMatch
    }

    var acceptVendorXButton: XCUIElement {
        buttons["acceptVendorXButton"].firstMatch
    }

    var vendorXConsentStatus: String {
        staticTexts["vendorXConsentStatus"].label
    }
}

extension ExampleApp: GDPRUI {
    var consentUI: XCUIElement {
        webViews.containing(NSPredicate(format: "(label CONTAINS[cd] 'GDPR Message') OR (label CONTAINS[cd] 'Privacy Center')")).firstMatch
    }

    var privacyManager: XCUIElement {
        webViews.containing(NSPredicate(format: "label CONTAINS[cd] 'Privacy Center'")).firstMatch
    }

    var consentMessage: XCUIElement {
        webViews.containing(NSPredicate(format: "label CONTAINS[cd] 'GDPR Message'")).firstMatch
    }

    var termsAndConditionsWebPageTitle: XCUIElement {
        webViews.containing(NSPredicate(format: "label CONTAINS[cd] 'Address'")).firstMatch
    }

    var acceptAllButton: XCUIElement {
        consentUI.buttons.containing(NSPredicate(format: "label CONTAINS[cd] 'Accept'")).firstMatch
    }

    var rejectAllButton: XCUIElement {
        consentUI.buttons.containing(NSPredicate(format: "label CONTAINS[cd] 'Reject'")).firstMatch
    }

    var showOptionsButton: XCUIElement {
        consentUI.buttons["Show Options"].firstMatch
    }

    var saveAndExitButton: XCUIElement {
        consentUI.buttons["Save & Exit"].firstMatch
    }

    var purposesButton: XCUIElement {
        staticTexts["PURPOSES"].firstMatch
    }

    var featuresTab: XCUIElement {
        staticTexts["Features are a use of the data that you have already agreed to share with us"].firstMatch
    }

    var termsAndConditionsLink: XCUIElement {
        consentUI.links["Privacy Policy"].firstMatch
    }

    var DeviceInformationSwitch: XCUIElement {
        consentUI.switches["Store and/or access information on a device"].firstMatch
    }

    var PersonalisedAdsSwitch: XCUIElement {
        consentUI.switches["Create a personalised ads profile"].firstMatch
    }
}
