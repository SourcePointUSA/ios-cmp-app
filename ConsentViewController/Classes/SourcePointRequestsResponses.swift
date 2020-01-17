//
//  SourcePointRequestsResponses.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 15.12.19.
//

import Foundation

public typealias Meta = String
public typealias ConsentUUID = String

struct GdprStatus: Codable {
    let gdprApplies: Bool
}

struct MessageRequest: Encodable {
    let uuid: ConsentUUID?
    let euconsent: ConsentString?
    let accountId: Int
    let propertyId: Int
    let propertyHref: PropertyName
    let campaignEnv: CampaignEnv
    let targetingParams: String?
    let requestUUID: UUID
    let meta: Meta
}

struct MessageResponse: Decodable {
    let url: URL?
    let uuid: ConsentUUID
    let userConsent: UserConsent
    var meta: Meta
}

struct ActionRequest: Encodable {
    let propertyId: Int
    let propertyHref: PropertyName
    let accountId: Int
    let actionType: Int
    let choiceId: String?
    let privacyManagerId: String
    let requestFromPM: Bool
    let uuid: ConsentUUID
    let requestUUID: UUID
    let consents: GDPRPMConsents
    let meta: Meta
}

struct ActionResponse: Decodable {
    let uuid: ConsentUUID
    let userConsent: UserConsent
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
