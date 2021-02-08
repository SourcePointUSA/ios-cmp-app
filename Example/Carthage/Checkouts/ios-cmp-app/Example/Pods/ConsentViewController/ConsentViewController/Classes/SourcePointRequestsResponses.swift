//
//  SourcePointRequestsResponses.swift
//  GDPRConsentViewController
//
//  Created by Andre Herculano on 15.12.19.
//

import Foundation

typealias Meta = String
public typealias GDPRUUID = String

struct MessageRequest: Encodable {
    let uuid: GDPRUUID?
    let euconsent: String
    let authId: String?
    let accountId: Int
    let propertyId: Int
    let propertyHref: GDPRPropertyName
    let campaignEnv: GDPRCampaignEnv
    let targetingParams: String?
    let requestUUID: UUID
    let meta: Meta
}

struct MessageResponse: Decodable {
    let url: URL?
    let msgJSON: GDPRMessage?
    let uuid: GDPRUUID
    let userConsent: GDPRUserConsent
    var meta: Meta
}

struct ActionRequest: Encodable {
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
}

struct ActionResponse: Decodable {
    let uuid: GDPRUUID
    let userConsent: GDPRUserConsent
    var meta: Meta
}

typealias PMConsents = SPGDPRArbitraryJson

struct GDPRPMConsents: Codable {
    let acceptedVendors, acceptedCategories: [String]
}

struct CustomConsentResponse: Codable, Equatable {
    let vendors, categories, legIntCategories, specialFeatures: [String]
}
