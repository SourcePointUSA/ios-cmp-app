//
//  GDPRUserConsent.swift
//  GDPRConsentViewController
//
//  Created by Andre Herculano on 19.12.19.
//

import Foundation

/**
    GDPRUserConsent encapsulates all consent data from a user.
 */
@objcMembers public class GDPRUserConsent: NSObject, Codable {
    static func empty() -> GDPRUserConsent {
        return GDPRUserConsent(
            acceptedVendors: [],
            acceptedCategories: [],
            legitimateInterestCategories: [],
            specialFeatures: [],
            euconsent: "",
            tcfData: SPGDPRArbitraryJson())
    }

    /// The ids of the accepted vendors and categories. These can be found in SourcePoint's dashboard
    ///
    /// - Important: All ids are related to non-iAB vendors/purposes. For iAB related consent refer to `euconsent`
    public let acceptedVendors,
        acceptedCategories,
        legitimateInterestCategories,
        specialFeatures: [String]

    /// The iAB consent string.
    public let euconsent: String

    /// A dictionary with all TCFv2 related data
    public let tcfData: SPGDPRArbitraryJson

    public init(
        acceptedVendors: [String],
        acceptedCategories: [String],
        legitimateInterestCategories: [String],
        specialFeatures: [String],
        euconsent: String,
        tcfData: SPGDPRArbitraryJson) {
        self.acceptedVendors = acceptedVendors
        self.acceptedCategories = acceptedCategories
        self.legitimateInterestCategories = legitimateInterestCategories
        self.specialFeatures = specialFeatures
        self.euconsent = euconsent
        self.tcfData = tcfData
    }

    public override func isEqual(_ object: Any?) -> Bool {
        if let other = object as? GDPRUserConsent {
            return other.acceptedCategories.elementsEqual(acceptedVendors) &&
                other.acceptedVendors.elementsEqual(acceptedVendors) &&
                other.legitimateInterestCategories.elementsEqual(legitimateInterestCategories) &&
                other.specialFeatures.elementsEqual(specialFeatures) &&
                other.euconsent.elementsEqual(euconsent)
        } else {
            return false
        }
    }

    open override var description: String {
        return """
        UserConsents(
            acceptedVendors: \(acceptedVendors),
            acceptedCategories: \(acceptedCategories),
            legitimateInterests: \(legitimateInterestCategories),
            specialFeatures: \(specialFeatures),
            euconsent: \(euconsent)
        )
        """
    }

    enum CodingKeys: String, CodingKey {
        case acceptedVendors, acceptedCategories, euconsent, specialFeatures
        case legitimateInterestCategories = "legIntCategories"
        case tcfData = "TCData"
    }
}
