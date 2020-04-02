//
//  Action.swift
//  GDPRConsentViewController
//
//  Created by Andre Herculano on 11.12.19.
//

import Foundation

/// User actions. Its integer representation matches with what SourcePoint's endpoints expect.
@objc public enum GDPRActionType: Int, Codable {
    case SaveAndExit = 1
    case PMCancel = 2
    case AcceptAll = 11
    case ShowPrivacyManager = 12
    case RejectAll = 13
    case Dismiss = 15
}

/// Action consists of `GDPRActionType` and an id. Those come from each action the user can take in the ConsentUI
@objcMembers public class GDPRAction: NSObject {
    public let type: GDPRActionType
    public let id: String?

    public init(type: GDPRActionType, id: String?) {
        self.type = type
        self.id = id
    }
}
