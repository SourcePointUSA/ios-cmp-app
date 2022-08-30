//
//  ConsentStatusResponse.swift
//  Pods
//
//  Created by Andre Herculano on 29.08.22.
//

import Foundation

struct SPDateCreated: Codable, Equatable {
    static let format: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return formatter
    }()

    let originalDateString: String
    let date: Date

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        originalDateString = try container.decode(String.self)
        date = SPDateCreated.format.date(from: originalDateString)!
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(originalDateString)
    }
}

struct SPConsentStatus: Decodable, Equatable {
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

struct ConsentStatusResponse: Decodable, Equatable {
    struct Data: Decodable, Equatable {
        struct GDPR: Decodable, Equatable {
            let gdprApplies, localDataCurrent: Bool
            let dateCreated: SPDateCreated
            let uuid, vendorListId, euconsent, addtlConsent: String
            let grants: SPGDPRVendorGrants
            let consentStatus: SPConsentStatus
        }

        struct CCPA: Decodable, Equatable {
            let ccpaApplies, rejectedAll, newUser: Bool
            let dateCreated: SPDateCreated
            let uuid, uspstring: String
            let rejectedCategories, rejectedVendors: [String]
            let status: CCPAConsentStatus
        }

        let gdpr: GDPR?
        let ccpa: CCPA?
    }

    let consentStatusData: Data
}
