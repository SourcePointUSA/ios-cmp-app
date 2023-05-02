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

let prod = (Bundle.framework.object(forInfoDictionaryKey: "SPEnv") as? String) != "preprod"

struct Constants {
    struct Urls {
        static let envParam = prod ? "prod" : "localProd"
        static let additionalData: String = "scriptType=ios&scriptVersion=\(SPConsentManager.VERSION)"
        static let SP_ROOT = URL(string: prod ? "https://cdn.privacy-mgmt.com/" : "https://preprod-cdn.privacy-mgmt.com/")!
        static let WRAPPER_API = URL(string: "./wrapper/?env=\(envParam)", relativeTo: SP_ROOT)!
        static let GDPR_MESSAGE_URL = URL(string: "./v2/message/gdpr?\(additionalData)", relativeTo: WRAPPER_API)!
        static let CCPA_MESSAGE_URL = URL(string: "./v2/message/ccpa?\(additionalData)", relativeTo: WRAPPER_API)!
        static let ERROR_METRIS_URL = URL(string: "./metrics/v1/custom-metrics?\(additionalData)", relativeTo: WRAPPER_API)!
        static let GDPR_CONSENT_URL = URL(string: "./v2/messages/choice/gdpr/?\(additionalData)", relativeTo: WRAPPER_API)!
        static let CCPA_CONSENT_URL = URL(string: "./v2/messages/choice/ccpa/?\(additionalData)", relativeTo: WRAPPER_API)!
        static let IDFA_RERPORT_URL = URL(string: "./metrics/v1/apple-tracking?env=\(envParam)&\(additionalData)", relativeTo: WRAPPER_API)!
        static let DELETE_CUSTOM_CONSENT_URL = URL(string: "./consent/tcfv2/consent/v3/custom?\(additionalData)", relativeTo: SP_ROOT)!
        static let CUSTOM_CONSENT_URL = URL(string: "./tcfv2/v1/gdpr/custom-consent?env=\(envParam)&inApp=true&\(additionalData)", relativeTo: WRAPPER_API)!
        static let GDPR_PRIVACY_MANAGER_VIEW_URL = URL(string: "./consent/tcfv2/privacy-manager/privacy-manager-view?\(additionalData)", relativeTo: SP_ROOT)!
        static let CCPA_PRIVACY_MANAGER_VIEW_URL = URL(string: "./ccpa/privacy-manager/privacy-manager-view?\(additionalData)", relativeTo: SP_ROOT)!
        static let CCPA_PM_URL = URL(string: "./ccpa_pm/index.html", relativeTo: SP_ROOT)!
        static let GDPR_PM_URL = URL(string: "./privacy-manager/index.html", relativeTo: SP_ROOT)!
        static let CONSENT_STATUS_URL = URL(string: "./v2/consent-status?env=\(envParam)&\(additionalData)", relativeTo: WRAPPER_API)!
        static let META_DATA_URL = URL(string: "./v2/meta-data?env=\(envParam)&\(additionalData)", relativeTo: WRAPPER_API)!
        static let GET_MESSAGES_URL = URL(string: "./v2/messages?env=\(envParam)&\(additionalData)", relativeTo: WRAPPER_API)!
        static let PV_DATA_URL = URL(string: "./v2/pv-data?env=\(envParam)&\(additionalData)", relativeTo: WRAPPER_API)!
        static let CHOICE_BASE_URL = URL(string: "./v2/choice/?\(additionalData)", relativeTo: WRAPPER_API)!
        static let CHOICE_GDPR_BASE_URL = URL(string: "./v2/choice/gdpr/?\(additionalData)", relativeTo: WRAPPER_API)!
        static let CHOICE_CCPA_BASE_URL = URL(string: "./v2/choice/ccpa/?\(additionalData)", relativeTo: WRAPPER_API)!
        static let CHOICE_REJECT_ALL_URL = URL(string: "./v2/choice/reject-all/?env=\(envParam)&\(additionalData)", relativeTo: WRAPPER_API)!
        static let CHOICE_CONSENT_ALL_URL = URL(string: "./v2/choice/consent-all/?env=\(envParam)&\(additionalData)", relativeTo: WRAPPER_API)!
    }

    struct UI {
        struct DarkMode: SPUIValues {
            static var defaultFallbackTextColorForDarkMode: UIColor { .black }
        }
    }
}
