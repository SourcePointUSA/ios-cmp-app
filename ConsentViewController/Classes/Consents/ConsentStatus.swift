//
//  ConsentStatus.swift
//  Pods
//
//  Created by Andre Herculano on 31.08.22.
//

import Foundation

public struct ConsentStatus: Codable, Equatable {
    struct GranularStatus: Codable, Equatable {
        enum Status: String, Codable, Equatable {
            case ALL, SOME, NONE
        }

        var vendorConsent, vendorLegInt, purposeConsent, purposeLegInt: Status?
        var previousOptInAll, defaultConsent: Bool?
    }

    var granularStatus: GranularStatus? = GranularStatus()
    var rejectedAny, rejectedLI, consentedAll, consentedToAny, rejectedAll, vendorListAdditions, legalBasisChanges: Bool?
    var hasConsentData: Bool? = false
    var rejectedVendors, rejectedCategories: [String?]?
}
