//
//  CampaignConsent.swift
//  Pods
//
//  Created by Andre Herculano on 06.11.23.
//

import Foundation

protocol CampaignConsent {
    var uuid: String? { get set }
    var applies: Bool { get set }
    var dateCreated: SPDate { get set }
}
