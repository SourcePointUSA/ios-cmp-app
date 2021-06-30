//
//  ConsentRequestResponse.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 03.07.20.
//

import Foundation

struct GDPRConsentRequest: Encodable, Equatable {
    let authId: String?
    let idfaStatus: SPIDFAStatus
    let localState: SPJson
    let pmSaveAndExitVariables: SPJson?
    let publisherData: [String: SPJson?]?
    let requestUUID: UUID
    let includeData = [
        "localState": ["type": "RecordString"],
        "TCData": ["type": "RecordString"]
    ]

    enum CodingKeys: String, CodingKey {
        case authId, localState, idfaStatus, pmSaveAndExitVariables, requestUUID, includeData
        case publisherData = "pubData"
    }
}

struct CCPAConsentRequest: Encodable, Equatable {
    let authId: String?
    let localState: SPJson
    let publisherData: [String: SPJson?]?
    let pmSaveAndExitVariables: SPJson?
    let requestUUID: UUID
    let includeData = [
        "localState": ["type": "RecordString"],
        "TCData": ["type": "RecordString"]
    ]

    enum CodingKeys: String, CodingKey {
        case authId, localState, pmSaveAndExitVariables, requestUUID, includeData
        case publisherData = "pubData"
    }
}

struct ConsentResponse: Decodable & Equatable {
    let localState: SPJson
    let userConsent: Consent

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        localState = try container.decode(SPJson.self, forKey: .localState)
        userConsent = try container.decode(Consent.self, forKey: .userConsent)
        switch userConsent {
        case .gdpr(let consents): consents.uuid = localState["gdpr"]?["uuid"]?.stringValue
        case .ccpa(let consents): consents.uuid = localState["ccpa"]?["uuid"]?.stringValue
        default: break
        }
    }

    enum Keys: CodingKey {
        case localState, userConsent
    }
}
