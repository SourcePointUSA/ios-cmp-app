//
//  Action.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 11.12.19.
//

import Foundation

/// User actions. Its integer representation matches with what SourcePoint's endpoints expect.
@objc public enum ActionType: Int {
    case SaveAndExit = 1
    case PMCancel = 2
    case AcceptAll = 11
    case ShowPrivacyManager = 12
    case RejectAll = 13
    case Dismiss = 15
}

/// Action consists of `ActionType` and an id. Those come from each action the user can take in the ConsentUI
@objcMembers public class Action: NSObject {
    public let type: ActionType
    public let id: String?
    
    public init(type: ActionType, id: String?) {
        self.type = type
        self.id = id
    }
}
