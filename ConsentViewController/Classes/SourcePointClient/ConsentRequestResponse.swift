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
    let pubData: SPPublisherData
    let requestUUID: UUID
    let includeData = IncludeData()
}

struct CCPAConsentRequest: Encodable, Equatable {
    let authId: String?
    let localState: SPJson
    let pubData: SPPublisherData
    let pmSaveAndExitVariables: SPJson?
    let requestUUID: UUID
    let includeData = IncludeData()
}

struct ConsentResponse: Decodable & Equatable {
    enum Keys: CodingKey {
        case localState, userConsent
    }

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
}
