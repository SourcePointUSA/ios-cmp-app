//
//  Constants.swift
//  Pods
//
//  Created by Andre Herculano on 22.09.21.
//

// swiftlint:disable force_unwrapping

import Foundation
import UIKit

protocol SPUIValues {
    static var defaultFallbackTextColorForDarkMode: UIColor { get }
}

struct Constants {
    struct Urls {
        static let envParam = "prod"
        static let additionalData: String = "scriptType=ios&scriptVersion=\(SPConsentManager.VERSION)"
        static let SP_ROOT = URL(string: prod ? "https://cdn.privacy-mgmt.com/" : "https://preprod-cdn.privacy-mgmt.com/")!
        static let WRAPPER_API = URL(string: "./wrapper/?env=\(envParam)", relativeTo: SP_ROOT)!
        static let GDPR_MESSAGE_URL = URL(string: "./v2/message/v2/gdpr?\(additionalData)", relativeTo: WRAPPER_API)!
        static let CCPA_MESSAGE_URL = URL(string: "./v2/message/v2/ccpa?\(additionalData)", relativeTo: WRAPPER_API)!
        static let ERROR_METRIS_URL = URL(string: "./metrics/v1/custom-metrics?\(additionalData)", relativeTo: WRAPPER_API)!
        static let GDPR_PRIVACY_MANAGER_VIEW_URL = URL(string: "./consent/tcfv2/privacy-manager/privacy-manager-view?\(additionalData)", relativeTo: SP_ROOT)!
        static let CCPA_PRIVACY_MANAGER_VIEW_URL = URL(string: "./ccpa/privacy-manager/privacy-manager-view?\(additionalData)", relativeTo: SP_ROOT)!
        static let CCPA_PM_URL = URL(string: "./ccpa_pm/index.html", relativeTo: SP_ROOT)!
        static let USNAT_PM_URL = URL(string: "./us_pm/index.html", relativeTo: SP_ROOT)!
        static let GLOBALCMP_PM_URL = URL(string: "./us_pm/index.html?is_global_cmp=true", relativeTo: SP_ROOT)!
        static let GDPR_PM_URL = URL(string: "./privacy-manager/index.html", relativeTo: SP_ROOT)!
    }

    struct UI {
        struct DarkMode: SPUIValues {
            static var defaultFallbackTextColorForDarkMode: UIColor { .black }
        }
        struct StandartStyle {
            public var backgroundColor: String = "#575757"
            public var activeBackgroundColor: String = "#707070"
            public var onFocusTextColor: String = "#000000"
            public var onUnfocusTextColor: String = "#ffffff"
            public var onFocusBackgroundColor: String = "#ffffff"
            public var onUnfocusBackgroundColor: String = "#575757"
            public var font: SPNativeFont = SPNativeFont(fontSize: 14, fontWeight: "400", fontFamily: "arial, helvetica, sans-serif", color: "#000000")
            public var activeFont: SPNativeFont = SPNativeFont(fontSize: 14, fontWeight: "400", fontFamily: "arial, helvetica, sans-serif", color: "#ffffff")
        }
    }

    static let prod = false//(Bundle.framework.object(forInfoDictionaryKey: "SPEnv") as? String) != "preprod"
}

// swiftlint:enable force_unwrapping
