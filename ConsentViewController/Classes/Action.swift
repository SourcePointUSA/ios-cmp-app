//
//  Action.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 11.12.19.
//

import Foundation

@objc public enum Action: Int {
    case AcceptAll = 11
    case ShowPrivacyManager = 12
    case RejectAll = 13
    case Dismiss = 15
    
    // TODO: Change PM actions according to new PM
    case PMCancel = 98
    case PMAction = 99
}
