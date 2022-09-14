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
    var rejectedAny, rejectedLI, consentedAll, hasConsentData, consentedToAny: Bool?
}

//extension ConsentStatus.GranularStatus {
//    init() {
//        previousOptInAll = nil
//        defaultConsent = nil
//        vendorConsent = nil
//        vendorLegInt = nil
//        purposeConsent = nil
//        purposeLegInt = nil
//    }
//}
//
//extension ConsentStatus {
//    init() {
//        rejectedAny = nil
//        rejectedLI = nil
//        consentedAll = nil
//        hasConsentData = nil
//        consentedToAny = nil
//        granularStatus = nil
//    }
//}
