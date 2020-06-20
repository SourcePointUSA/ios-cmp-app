//
//  Action.swift
//  GDPRConsentViewController
//
//  Created by Andre Herculano on 11.12.19.
//

import Foundation

/// User actions. Its integer representation matches with what SourcePoint's endpoints expect.
@objc public enum GDPRActionType: Int, Codable, CaseIterable, CustomStringConvertible {
    case SaveAndExit = 1
    case PMCancel = 2
    case AcceptAll = 11
    case ShowPrivacyManager = 12
    case RejectAll = 13
    case Dismiss = 15

    public var description: String {
        switch self {
        case .AcceptAll: return "AcceptAll"
        case .RejectAll: return "RejectAll"
        case .ShowPrivacyManager: return "ShowPrivacyManager"
        case .SaveAndExit: return "SaveAndExit"
        case .Dismiss: return "Dismiss"
        case .PMCancel: return "PMCancel"
        default: return "Unknown"
        }
    }
}

/// Action consists of `GDPRActionType` and an id. Those come from each action the user can take in the ConsentUI
@objcMembers public class GDPRAction: NSObject {
    public let type: GDPRActionType
    public let id: String?
    public let payload: Data

    public init(type: GDPRActionType, id: String? = nil, payload: Data = "{}".data(using: .utf8)!) {
        self.type = type
        self.id = id
        self.payload = payload
    }
}
