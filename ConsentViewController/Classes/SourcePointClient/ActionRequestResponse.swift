//
//  ActionRequestResponse.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 03.07.20.
//

import Foundation

struct ActionRequest: Codable, Equatable {
    let propertyId: Int
    let propertyHref: SPPropertyName
    let accountId: Int
    let actionType: Int
    let choiceId: String?
    let privacyManagerId: String
    let requestFromPM: Bool
    let uuid: SPConsentUUID
    let requestUUID: UUID
    let pmSaveAndExitVariables: SPJson
    let meta: Meta
    let publisherData: [String: SPJson?]?
    let consentLanguage: String?

    enum CodingKeys: String, CodingKey {
        case propertyId, propertyHref, accountId, actionType, choiceId, privacyManagerId, requestFromPM, uuid, requestUUID, pmSaveAndExitVariables, meta, consentLanguage
        case publisherData = "pubData"
    }
}

struct ActionResponse: Codable {
    let uuid: SPConsentUUID
    let userConsent: SPGDPRConsent
    var meta: Meta
}
