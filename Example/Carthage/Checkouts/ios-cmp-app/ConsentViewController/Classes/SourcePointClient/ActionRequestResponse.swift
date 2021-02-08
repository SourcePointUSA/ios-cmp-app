//
//  ActionRequestResponse.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 03.07.20.
//

import Foundation

struct ActionRequest: Codable, Equatable {
    let propertyId: Int
    let propertyHref: GDPRPropertyName
    let accountId: Int
    let actionType: Int
    let choiceId: String?
    let privacyManagerId: String
    let requestFromPM: Bool
    let uuid: GDPRUUID
    let requestUUID: UUID
    let pmSaveAndExitVariables: SPGDPRArbitraryJson
    let meta: Meta
    let publisherData: [String: SPGDPRArbitraryJson?]?
    let consentLanguage: String?

    enum CodingKeys: String, CodingKey {
        case propertyId, propertyHref, accountId, actionType, choiceId, privacyManagerId, requestFromPM, uuid, requestUUID, pmSaveAndExitVariables, meta, consentLanguage
        case publisherData = "pubData"
    }
}

struct ActionResponse: Codable {
    let uuid: GDPRUUID
    let userConsent: GDPRUserConsent
    var meta: Meta
}
