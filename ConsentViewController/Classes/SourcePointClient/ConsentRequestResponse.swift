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

struct ConsentResponse<ConsentType: Decodable & Equatable>: Decodable & Equatable {
    let localState: SPJson
    let userConsent: ConsentType
}
