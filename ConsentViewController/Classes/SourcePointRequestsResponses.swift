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

protocol WrapperApiRequest: Codable, Equatable {
    var requestUUID: UUID { get }
    var meta: Meta { get }
}

struct MessageResponse: Codable {
    let url: URL?
    let uuid: ConsentUUID
    let userConsent: UserConsent
    var meta: Meta
}

struct ActionResponse: Codable {
    let uuid: ConsentUUID
    let userConsent: UserConsent
    var meta: Meta
}

struct ActionRequest: WrapperApiRequest {
    static func == (lhs: ActionRequest, rhs: ActionRequest) -> Bool {
        lhs.requestUUID == rhs.requestUUID
    }

    let propertyId, accountId: Int
    let privacyManagerId: String
    let uuid: ConsentUUID?
    let requestUUID: UUID
    let consents: GDPRPMConsents
    let meta: Meta
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
