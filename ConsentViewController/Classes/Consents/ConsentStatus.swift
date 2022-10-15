//
//  ConsentStatus.swift
//  Pods
//
//  Created by Andre Herculano on 31.08.22.
//

import Foundation

struct ConsentStatus: Codable, Equatable {
    struct GranularStatus: Codable, Equatable {
        enum Status: String, Codable, Equatable {
            case ALL, SOME, NONE
        }

        var vendorConsent, vendorLegInt, purposeConsent, purposeLegInt: Status?
        var previousOptInAll, defaultConsent: Bool?
    }

    var granularStatus: GranularStatus?
    var rejectedAny, rejectedLI, consentedAll, hasConsentData, consentedToAny, rejectedAll: Bool?
    var rejectedVendors, rejectedCategories: [String?]?
}
