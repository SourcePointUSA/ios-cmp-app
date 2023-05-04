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
    let sendPVData: Bool
    let propertyId: Int
    let sampleRate: Float?
    let idfaStatus: SPIDFAStatus?
    let granularStatus: ConsentStatus.GranularStatus?
    let includeData = IncludeData()
}

struct CCPAChoiceBody: Encodable, Equatable {
    let authId, uuid, messageId: String?
    let pubData: SPPublisherData
    let pmSaveAndExitVariables: SPJson?
    let sendPVData: Bool
    let propertyId: Int
    let sampleRate: Float?
    let includeData = IncludeData()
}
