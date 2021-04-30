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
    public let granted: Bool
    public let purposeGrants: SPGDPRPurposeGrants

    public override var description: String {
        return "VendorGrant(granted: \(granted), purposeGrants: \(purposeGrants))"
    }

    public override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? SPGDPRVendorGrant else {
            return false
        }
        return other.granted == granted && other.purposeGrants == purposeGrants
    }

    public init(granted: Bool, purposeGrants: SPGDPRPurposeGrants) {
        self.granted = granted
        self.purposeGrants = purposeGrants
    }

    enum CodingKeys: String, CodingKey {
        case purposeGrants
        case granted = "vendorGrant"
    }
}

/**
    SPGDPRConsent encapsulates all consent data from a user.
 */
@objcMembers public class SPGDPRConsent: NSObject, Codable {
    public static func empty() -> SPGDPRConsent {
        return SPGDPRConsent(
            vendorGrants: SPGDPRVendorGrants(),
            euconsent: "",
            tcfData: SPJson())
    }

    public let vendorGrants: SPGDPRVendorGrants

    /// The iAB consent string.
    public let euconsent: String

    /// A dictionary with all TCFv2 related data
    public let tcfData: SPJson

    public init(
        vendorGrants: SPGDPRVendorGrants,
        euconsent: String,
        tcfData: SPJson) {
        self.vendorGrants = vendorGrants
        self.euconsent = euconsent
        self.tcfData = tcfData
    }

    public override func isEqual(_ object: Any?) -> Bool {
        if let other = object as? SPGDPRConsent {
            return other.euconsent.elementsEqual(euconsent) &&
                other.vendorGrants.allSatisfy { key, value in vendorGrants[key]?.isEqual(value) ?? false }
        } else {
            return false
        }
    }

    open override var description: String {
        return """
        UserConsents(
            vendorGrants: \(vendorGrants),
            euconsent: \(euconsent)
        )
        """
    }

    enum CodingKeys: String, CodingKey {
        case euconsent
        case tcfData = "TCData"
        case vendorGrants = "grants"
    }
}
