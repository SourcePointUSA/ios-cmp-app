//
//  ConsentStatus.swift
//  Pods
//
//  Created by Andre Herculano on 31.08.22.
//

import Foundation

public struct ConsentStatus: Codable, Equatable {
    struct GranularStatus: Codable, Equatable {
        var vendorConsent, vendorLegInt, purposeConsent, purposeLegInt: String?
        var previousOptInAll, defaultConsent, sellStatus,
            shareStatus, sensitiveDataStatus, gpcStatus: Bool?
    }

    var granularStatus: GranularStatus? = GranularStatus()
    public var rejectedAny, rejectedLI, consentedAll, consentedToAll,
               consentedToAny, rejectedAll, vendorListAdditions, legalBasisChanges: Bool?
    var hasConsentData: Bool? = false
    var rejectedVendors: [String?]?
    var rejectedCategories: [String?]?
}
