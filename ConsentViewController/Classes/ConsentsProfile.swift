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
    let applies: Bool?
    let meta: String
    let consents: LegislationConsent
}

/// Represent the collection of legislation and user data we support at SourcePoint
struct ConsentsProfile: Codable, Equatable {
    let authId: String?
    var gdpr: ConsentProfile<SPGDPRConsent>?
    var ccpa: ConsentProfile<SPCCPAConsent>?

    init(
        authId: String? = nil,
        gdpr: ConsentProfile<SPGDPRConsent>? = nil,
        ccpa: ConsentProfile<SPCCPAConsent>? = nil
    ) {
        self.authId = authId
        self.gdpr = gdpr
        self.ccpa = ccpa
    }
}
