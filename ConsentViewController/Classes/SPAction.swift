//
//  Action.swift
//  GDPRConsentViewController
//
//  Created by Andre Herculano on 11.12.19.
//

import Foundation

/// User actions. Its integer representation matches with what SourcePoint's endpoints expect.
@objc public enum SPActionType: Int, Codable, CaseIterable, CustomStringConvertible {
    case SaveAndExit = 1
    case PMCancel = 2
    case Custom = 9
    case AcceptAll = 11
    case ShowPrivacyManager = 12
    case RejectAll = 13
    case Dismiss = 15
    case RequestATTAccess = 16
    case IDFAAccepted = 17
    case IDFADenied = 18
    case Unknown = 0

    public var description: String {
        switch self {
        case .AcceptAll: return "AcceptAll"
        case .RejectAll: return "RejectAll"
        case .Custom: return "Custom"
        case .ShowPrivacyManager: return "ShowPrivacyManager"
        case .SaveAndExit: return "SaveAndExit"
        case .Dismiss: return "Dismiss"
        case .PMCancel: return "PMCancel"
        case .RequestATTAccess: return "RequestATTAccess"
        case .IDFAAccepted: return "IDFAAccepted"
        case .IDFADenied: return "IDFADenied"
        case .Unknown: return "Unkown"
        @unknown default: return "Unknown"
        }
    }
}

/// Action consists of `SPActionType` and an id. Those come from each action the user can take in the ConsentUI
@objcMembers public class SPAction: NSObject {
    public var type: SPActionType
    public let campaignType: SPCampaignType
    public let consentLanguage: String?
    public var pmURL: URL?
    public var pmId: String? {
        if let url = pmURL {
            return URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems?.first(where: {
                $0.name == "message_id"
            })?.value
        }
        return nil
    }
    public var pmPayload: SPJson = SPJson()
    public var publisherData: [String: SPJson?] = [:]
    public var customActionId: String?

    public override var description: String {
        """
        SPAction(type: \(type), consentLanguage: \(consentLanguage ?? ""), \
        payload: \(pmPayload), publisherData: \(String(describing: publisherData)),
        customActionId: \(customActionId ?? ""))
        """
    }

    public override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? SPAction else {
            return false
        }
        return other.type == type &&
            other.consentLanguage == consentLanguage &&
            other.pmURL == pmURL &&
            other.pmPayload == pmPayload &&
            other.publisherData == publisherData
    }

    public init(
        type: SPActionType,
        campaignType: SPCampaignType = .unknown,
        consentLanguage: String? = nil,
        pmPayload: SPJson = SPJson(),
        pmurl: URL? = nil,
        customActionId: String? = nil
    ) {
        self.type = type
        self.campaignType = campaignType
        self.consentLanguage = consentLanguage
        self.pmPayload = pmPayload
        self.pmURL = pmurl
        self.customActionId = customActionId
    }
}
