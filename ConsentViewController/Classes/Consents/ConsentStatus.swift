//
//  ConsentStatus.swift
//  Pods
//
//  Created by Andre Herculano on 31.08.22.
//

import Foundation

struct ConsentStatus: Decodable, Equatable {
    struct GranularStatus: Decodable, Equatable {
        enum Status: String, Decodable, Equatable {
            case ALL, SOME, NONE
        }

        let vendorConsent, vendorLegInt, purposeConsent, purposeLegInt: Status
        let previousOptInAll, defaultConsent: Bool
    }

    let granularStatus: GranularStatus
    let rejectedAny, rejectedLI, consentedAll, hasConsentData, consentedToAny: Bool
}
