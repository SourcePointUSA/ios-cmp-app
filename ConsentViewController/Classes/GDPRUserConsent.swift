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
    /// The ids of the accepted vendors and categories. These can be found in SourcePoint's dashboard
    ///
    /// - Important: All ids are related to non-iAB vendors/purposes. For iAB related consent refer to `euconsent`
    public let acceptedVendors, acceptedCategories: [String]
    
    /// The iAB consent string.
    public let euconsent: ConsentString
    
    public init(acceptedVendors: [String], acceptedCategories: [String], euconsent: ConsentString) {
        self.acceptedVendors = acceptedVendors
        self.acceptedCategories = acceptedCategories
        self.euconsent = euconsent
    }
    
    open override var description: String { return "acceptedVendors: \(acceptedVendors), acceptedCategories: \(acceptedCategories), euconsent: \(euconsent.consentString)" }
}
