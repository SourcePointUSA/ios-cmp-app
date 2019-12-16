//
//  SourcePointRequestsResponses.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 15.12.19.
//

import Foundation

struct ConsentsResponse: Codable {
    let consentedVendors: [VendorConsent]
    let consentedPurposes: [PurposeConsent]
}

class GdprStatus: Codable {
    let gdprApplies: Bool
}

protocol WrapperApiRequest: Codable, Equatable {
    var requestUUID: UUID { get }
}

struct MessageResponse: WrapperApiRequest {
    let url: URL?
    let euconsent: ConsentString?
    let uuid, requestUUID: UUID
}

struct ActionResponse: WrapperApiRequest {
    let euconsent: ConsentString
    let uuid, requestUUID: UUID
}

struct ActionRequest: WrapperApiRequest {
    let propertyId, accountId, actionType: Int
    let privacyManagerId: String
    let uuid: UUID?
    let requestUUID: UUID
}
