//
//  ChoiceRequests.swift
//  Pods
//
//  Created by Andre Herculano on 17.10.22.
//

import Foundation

struct GDPRChoiceBody: Encodable, Equatable {
    struct PMSaveAndExitPayload: Encodable, Equatable {
        let specialFeatures, categories, vendors: [String?]
        let privacyManagerId, messageId: String
        let lan: SPMessageLanguage
    }

    let authId, uuid, messageId, consentAllRef, vendorListId: String?
    let pubData: SPPublisherData
    let pmSaveAndExitVariables: PMSaveAndExitPayload?
    let sendPVData = true // TODO: ask Sid/Dan what is this
    let propertyId, sampleRate: Int
    let idfaStatus: SPIDFAStatus?
    let granularStatus: ConsentStatus.GranularStatus?
    let includeData = [
        "localState": ["type": "RecordString"],
        "TCData": ["type": "RecordString"]
    ]
}

struct CCPAChoiceBody: Encodable, Equatable {
    struct PMSaveAndExitPayload: Encodable, Equatable {
        let rejectedCategories, rejectedVendors: [String?]
        let privacyManagerId: String
    }

    let authId, uuid, messageId: String?
    let pubData: SPPublisherData
    let pmSaveAndExitVariables: PMSaveAndExitPayload?
    let sendPVData = true // TODO: ask Sid/Dan what is this
    let propertyId, sampleRate: Int
    let includeData = [
        "localState": ["type": "RecordString"]
    ]
}
