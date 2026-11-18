//
//  Exampleswift
//  SPGDPRExampleAppUITests
//
//  Created by Andre Herculano on 22.06.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Nimble
import XCTest

protocol App {
    func launch()
    func terminate()
    func relaunch(clean: Bool, resetAtt: Bool, args: [String: Any])
}

extension XCUIApplication: App {
    func relaunch(
        clean: Bool = false,
        resetAtt: Bool = false,
        args: [String: Any] = [:]
    ) {
        UserDefaults.standard.synchronize()
        self.terminate()
        if #available(iOS 15.0, *), resetAtt {
            resetAuthorizationStatus(for: .userTracking)
        }
        // A clean launch starts from scratch, so arguments of previous launches don't leak into it.
        // Non-clean launches (relaunch to check persistence) keep the previous ones.
        if clean {
            launchArguments = ["-cleanAppsData"]
        } else {
            launchArguments.removeAll { $0 == "-cleanAppsData" }
        }
        args.forEach { key, value in
            launchArguments.append("-\(key)=\(value)")
        }
        launch()
    }
}

extension XCUIApplication {
    /// Didomi's views expose the same accessibility identifier on different element types
    /// depending on the iOS version, so we look the identifier up regardless of the type.
    func element(_ id: String) -> XCUIElement {
        descendants(matching: .any).matching(identifier: id).firstMatch
    }
}

/// The campaign (regulation) the example app loads. Didomi shows one notice per `loadMessage`,
/// so each test picks the campaign it wants to exercise with the `-campaign=<name>` launch argument.
enum Campaign: String, CaseIterable {
    case gdpr, ccpa, usnat

    /// Text of the notice title configured in the example app's local Didomi config.
    var noticeTitle: String {
        switch self {
            case .gdpr: return "GDPR Message"
            case .ccpa: return "CCPA Privacy Notice"
            case .usnat: return "US Privacy Notice"
        }
    }

    var spanishNoticeTitle: String {
        switch self {
            case .gdpr: return "Mensaje GDPR"
            case .ccpa: return "Aviso de privacidad de CCPA"
            case .usnat: return "Aviso de privacidad de EE. UU."
        }
    }
}

class ExampleApp: XCUIApplication {
    class Notice {
        let app: XCUIApplication
        init(app: XCUIApplication) { self.app = app }

        var view: XCUIElement { app.element("notice_view") }
        var title: XCUIElement { app.element("notice_title") }
        var acceptButton: XCUIElement { app.element("notice_agree_button") }
        var rejectButton: XCUIElement { app.element("notice_disagree_button") }
        var showOptionsButton: XCUIElement { app.element("notice_learn_more_button") }
    }

    class Preferences {
        let app: XCUIApplication
        init(app: XCUIApplication) { self.app = app }

        var view: XCUIElement { app.element("purposes_view") }
        var closeButton: XCUIElement { app.element("purposes_close") }
        var saveButton: XCUIElement { app.element("didomi_toolbar_save_button") }
        var acceptAllButton: XCUIElement { app.element("didomi_toolbar_agree_to_all_button") }
        var rejectAllButton: XCUIElement { app.element("didomi_toolbar_disagree_to_all_button") }
        var bulkActionToggle: XCUIElement { app.buttons["purposes_bulk_action_root"].firstMatch }
        var firstToggle: XCUIElement { app.descendants(matching: .any)["purpose_toggle_0"] }

        /// Toggles currently visible on screen (cells scrolled out or covered by the toolbar are not refreshed by Didomi
        /// until they are shown). Their `value` is "Enabled", "Disabled" or "Unspecified".
        var purposeToggles: [XCUIElement] {
            let toggles = app.descendants(matching: .any).matching(
                NSPredicate(format: "identifier BEGINSWITH 'purpose_toggle_'")
            )
            return (0..<toggles.count).map { toggles.element(boundBy: $0) }.filter { $0.isHittable }
        }
    }

    lazy var notice = Notice(app: self)
    lazy var preferences = Preferences(app: self)

    /// The Privacy Manager button of the campaign being tested.
    func privacyManagerButton(for campaign: Campaign) -> XCUIElement {
        switch campaign {
            case .gdpr: return buttons["GDPR Privacy Manager"].firstMatch
            case .ccpa: return buttons["CPPA Privacy Manager"].firstMatch
            case .usnat: return buttons["USNat Privacy Manager"].firstMatch
        }
    }

    var deleteCustomVendorsButton: XCUIElement {
        buttons["Delete My Vendor"].firstMatch
    }

    var acceptCustomVendorsButton: XCUIElement {
        buttons["Accept My Vendor"].firstMatch
    }

    var clearConsentButton: XCUIElement {
        buttons["clearConsentButton"]
    }

    var loadMessagesButton: XCUIElement {
        buttons["Load Messages"].firstMatch
    }

    var sdkStatusLabel: XCUIElement {
        staticTexts["sdkStatusLabel"]
    }

    var customVendorLabel: XCUIElement {
        staticTexts["customVendorLabel"]
    }
}
