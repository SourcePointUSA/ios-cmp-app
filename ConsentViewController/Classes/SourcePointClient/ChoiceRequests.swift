//
//  ChoiceRequests.swift
//  Pods
//
//  Created by Andre Herculano on 17.10.22.
//

import Foundation

struct GDPRChoiceBody: Encodable, Equatable {
    let authId, uuid, messageId, consentAllRef, vendorListId: String?
    let pubData: SPPublisherData
    let pmSaveAndExitVariables: SPJson?
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
    let authId, uuid, messageId: String?
    let pubData: SPPublisherData
    let pmSaveAndExitVariables: SPJson?
    let sendPVData = true // TODO: ask Sid/Dan what is this
    let propertyId, sampleRate: Int
    let includeData = [
        "localState": ["type": "RecordString"]
    ]
}
