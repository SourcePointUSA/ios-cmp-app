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
    public let id: String?
    public let campaignType: SPCampaignType?
    public let consentLanguage: String?
    public var pmURL: URL?
    public var pmPayload: SPJson = SPJson()
    public var publisherData: [String: SPJson?] = [:]

    public override var description: String {
        """
        SPAction(type: \(type), id: \(id ?? ""), consentLanguage: \(consentLanguage ?? ""), \
        payload: \(pmPayload), publisherData: \(String(describing: publisherData))
        """
    }

    public override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? SPAction else {
            return false
        }
        return other.type == type &&
            other.id == id &&
            other.consentLanguage == consentLanguage &&
            other.pmURL == pmURL &&
            other.pmPayload == pmPayload &&
            other.publisherData == publisherData
    }

    public init(
        type: SPActionType,
        id: String? = nil,
        campaignType: SPCampaignType? = nil,
        consentLanguage: String? = nil,
        pmPayload: SPJson = SPJson(),
        pmurl: URL? = nil) {
        self.type = type
        self.id = id
        self.campaignType = campaignType
        self.consentLanguage = consentLanguage
        self.pmPayload = pmPayload
        self.pmURL = pmurl
    }
}
