//
//  Action.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 11.12.19.
//

import Foundation

/// User actions. Its integer representation matches with what SourcePoint's endpoints expect.
@objc public enum Action: Int {
    case SaveAndExit = 1
    case AcceptAll = 11
    case ShowPrivacyManager = 12
    case RejectAll = 13
    case Dismiss = 15
}
