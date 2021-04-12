//
//  ActionRequestResponse.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 03.07.20.
//

import Foundation

struct GDPRActionRequest: Codable, Equatable {
    let propertyHref: SPPropertyName
    let accountId: Int
    let actionType: Int
    let choiceId: String?
    let privacyManagerId: String
    let requestFromPM: Bool
    let requestUUID: UUID
    let pmSaveAndExitVariables: SPJson
    let localState: String
    let publisherData: [String: SPJson?]?
    let consentLanguage: String?

    enum CodingKeys: String, CodingKey {
        case accountId, propertyHref, actionType, choiceId, privacyManagerId, requestFromPM, requestUUID, pmSaveAndExitVariables, localState, consentLanguage
        case publisherData = "pubData"
    }
}

struct CCPAActionRequest: Encodable, Equatable {
    let accountId: Int
    let consents: SPCCPAConsent
    let localState: String
    let privacyManagerId: String
    let propertyHref: SPPropertyName
    let requestUUID: UUID

    enum CodingKeys: String, CodingKey {
        case accountId, consents, localState, privacyManagerId, propertyHref, requestUUID
    }
}

struct ActionResponse<ConsentType: Decodable & Equatable>: Decodable & Equatable {
    let uuid: SPConsentUUID
    let userConsent: ConsentType
    var meta: SPMeta
}
