//
//  ConsentsProfile.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 11.02.21.
//

import Foundation

/// Represent all the data related to a single legislation when communicating with the API or storing it in the local storage
struct ConsentProfile<LegislationConsent: Codable & Equatable>: Codable, Equatable {
    let uuid: SPConsentUUID?
    let authId: String?
    let applies: Bool?
    let meta: String
    let consents: LegislationConsent
}

/// Represent the collection of legislation and user data we support at SourcePoint
struct ConsentsProfile: Codable, Equatable {
    let gdpr: ConsentProfile<SPGDPRConsent>?
    let ccpa: ConsentProfile<SPCCPAConsent>?

    init(gdpr: ConsentProfile<SPGDPRConsent>? = nil, ccpa: ConsentProfile<SPCCPAConsent>? = nil) {
        self.gdpr = gdpr
        self.ccpa = ccpa
    }
}
