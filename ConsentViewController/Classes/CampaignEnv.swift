//
//  CampaignEnv.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 08.01.20.
//

import Foundation

/// Tells the SDK if we should load stage or public campaigns.
@objc public enum CampaignEnv: Int {
    case Stage = 0
    case Public = 1
}
