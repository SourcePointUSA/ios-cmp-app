//
//  SPGDPRConsent.swift
//  GDPRConsentViewController
//
//  Created by Andre Herculano on 19.12.19.
//

import Foundation

/// A dictionary in which the keys represent the Vendor Id
public typealias SPGDPRVendorGrants = [GDPRVendorId: SPGDPRVendorGrant]
public typealias GDPRVendorId = String

/// A dictionary in which the keys represent the Purpose Id and the values indicate if that purpose is granted (`true`) or not (`false`) on a legal basis.
public typealias SPGDPRPurposeGrants = [SPGDPRPurposeId: Bool]
public typealias SPGDPRPurposeId = String

/// Encapuslates data about a particular vendor being "granted" based on its purposes
@objcMembers public class SPGDPRVendorGrant: NSObject, Codable {
    /// if all purposes are granted, the vendorGrant will be set to `true`
    public let vendorGrant: Bool
    public let purposeGrants: SPGDPRPurposeGrants

    public override var description: String {
        return "VendorGrant(vendorGrant: \(vendorGrant), purposeGrants: \(purposeGrants))"
    }

    public override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? SPGDPRVendorGrant else {
            return false
        }
        return other.vendorGrant == vendorGrant && other.purposeGrants == purposeGrants
    }

    public init(vendorGrant: Bool, purposeGrants: SPGDPRPurposeGrants) {
        self.vendorGrant = vendorGrant
        self.purposeGrants = purposeGrants
    }
}

/**
    SPGDPRConsent encapsulates all consent data from a user.
 */
@objcMembers public class SPGDPRConsent: NSObject, Codable {
    public static func empty() -> SPGDPRConsent {
        return SPGDPRConsent(
            acceptedVendors: [],
            acceptedCategories: [],
            legitimateInterestCategories: [],
            specialFeatures: [],
            vendorGrants: SPGDPRVendorGrants(),
            euconsent: "",
            tcfData: SPJson())
    }

    /// The ids of the accepted vendors and categories. These can be found in SourcePoint's dashboard
    ///
    /// - Important: All ids are related to non-iAB vendors/purposes. For iAB related consent refer to `euconsent`
    public let acceptedVendors,
        acceptedCategories,
        legitimateInterestCategories,
        specialFeatures: [String]

    public let vendorGrants: SPGDPRVendorGrants

    /// The iAB consent string.
    public let euconsent: String

    /// A dictionary with all TCFv2 related data
    public let tcfData: SPJson

    public init(
        acceptedVendors: [String],
        acceptedCategories: [String],
        legitimateInterestCategories: [String],
        specialFeatures: [String],
        vendorGrants: SPGDPRVendorGrants,
        euconsent: String,
        tcfData: SPJson) {
        self.acceptedVendors = acceptedVendors
        self.acceptedCategories = acceptedCategories
        self.legitimateInterestCategories = legitimateInterestCategories
        self.specialFeatures = specialFeatures
        self.vendorGrants = vendorGrants
        self.euconsent = euconsent
        self.tcfData = tcfData
    }

    public override func isEqual(_ object: Any?) -> Bool {
        if let other = object as? SPGDPRConsent {
            return other.acceptedCategories.elementsEqual(acceptedCategories) &&
                other.acceptedVendors.elementsEqual(acceptedVendors) &&
                other.legitimateInterestCategories.elementsEqual(legitimateInterestCategories) &&
                other.specialFeatures.elementsEqual(specialFeatures) &&
                other.euconsent.elementsEqual(euconsent) &&
                other.vendorGrants.allSatisfy { key, value in vendorGrants[key]?.isEqual(value) ?? false }
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
            vendorGrants: \(vendorGrants),
            euconsent: \(euconsent)
        )
        """
    }

    enum CodingKeys: String, CodingKey {
        case acceptedVendors, acceptedCategories, euconsent, specialFeatures
        case legitimateInterestCategories = "legIntCategories"
        case tcfData = "TCData"
        case vendorGrants = "grants"
    }
}
