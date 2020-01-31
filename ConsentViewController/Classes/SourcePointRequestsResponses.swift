//
//  SourcePointRequestsResponses.swift
//  GDPRConsentViewController
//
//  Created by Andre Herculano on 15.12.19.
//

import Foundation

typealias Meta = String
public typealias GDPRUUID = String

struct GdprStatus: Codable {
    let gdprApplies: Bool
}

struct MessageRequest: Encodable {
    let uuid: GDPRUUID?
    let euconsent: ConsentString?
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
    let consents: GDPRPMConsents
    let meta: Meta
}

struct ActionResponse: Decodable {
    let uuid: GDPRUUID
    let userConsent: GDPRUserConsent
    var meta: Meta
}

@objc public class PMConsents: NSObject, Codable {
    let vendors, categories: PMConsent
    
    public init(vendors: PMConsent, categories: PMConsent) {
        self.vendors = vendors
        self.categories = categories
    }
}

@objc public class PMConsent: NSObject, Codable {
    let accepted, rejected: [String]
    
    public init(accepted: [String], rejected: [String]) {
        self.accepted = accepted
        self.rejected = rejected
    }
}

struct GDPRPMConsents: Codable {
    let acceptedVendors, acceptedCategories: [String]
}
