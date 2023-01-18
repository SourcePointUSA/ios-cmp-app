//
//  Constants.swift
//  Pods
//
//  Created by Andre Herculano on 22.09.21.
//

import Foundation
import UIKit

protocol SPUIValues {
    static var defaultFallbackTextColorForDarkMode: UIColor { get }
}

let prod = (Bundle.framework.object(forInfoDictionaryKey: "SPEnv") as? String) != "staging"

struct Constants {
    struct Urls {
        static let envParam = prod ? "prod" : "stage"
        static let SP_ROOT = URL(string: prod ? "https://cdn.privacy-mgmt.com/" : "https://cdn.sp-stage.net/")!
        static let WRAPPER_API = URL(string: "./wrapper/", relativeTo: SP_ROOT)!
        static let GDPR_MESSAGE_URL = URL(string: "./v2/message/gdpr", relativeTo: WRAPPER_API)!
        static let CCPA_MESSAGE_URL = URL(string: "./v2/message/ccpa", relativeTo: WRAPPER_API)!
        static let ERROR_METRIS_URL = URL(string: "./metrics/v1/custom-metrics", relativeTo: WRAPPER_API)!
        static let GET_MESSAGES_URL = URL(string: "./v2/get_messages/?env=\(envParam)", relativeTo: WRAPPER_API)!
        static let GDPR_CONSENT_URL = URL(string: "./v2/messages/choice/gdpr/", relativeTo: WRAPPER_API)!
        static let CCPA_CONSENT_URL = URL(string: "./v2/messages/choice/ccpa/", relativeTo: WRAPPER_API)!
        static let IDFA_RERPORT_URL = URL(string: "./metrics/v1/apple-tracking?env=\(envParam)", relativeTo: WRAPPER_API)!
        static let DELETE_CUSTOM_CONSENT_URL = URL(string: "./consent/tcfv2/consent/v3/custom/", relativeTo: SP_ROOT)!
        static let CUSTOM_CONSENT_URL = URL(string: "./tcfv2/v1/gdpr/custom-consent?env=\(envParam)&inApp=true", relativeTo: WRAPPER_API)!
        static let MMS_MESSAGE_URL = URL(string: "./mms/v2/message", relativeTo: SP_ROOT)!
        static let GDPR_PRIVACY_MANAGER_VIEW_URL = URL(string: "./consent/tcfv2/privacy-manager/privacy-manager-view", relativeTo: SP_ROOT)!
        static let CCPA_PRIVACY_MANAGER_VIEW_URL = URL(string: "./ccpa/privacy-manager/privacy-manager-view", relativeTo: SP_ROOT)!
        static let CCPA_PM_URL = URL(string: "./ccpa_pm/index.html", relativeTo: SP_ROOT)!
        static let GDPR_PM_URL = URL(string: "./privacy-manager/index.html", relativeTo: SP_ROOT)!
    }

    struct UI {
        struct DarkMode: SPUIValues {
            static var defaultFallbackTextColorForDarkMode: UIColor { .black }
        }
    }
}
