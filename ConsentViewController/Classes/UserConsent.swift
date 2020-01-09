//
//  UserConsent.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 19.12.19.
//

import Foundation

/// Indicates the consent status of a given user.
@objc public enum ConsentStatus: Int, Codable {
    /// Indicates the user has accepted none of the vendors or purposes (categories)
    case AcceptedNone
    
    /// Indicates the user has accepted none of the vendors or purposes (categories)
    case AcceptedSome
    
    /// Indicates the user has accepted none of the vendors or purposes (categories)
    case AcceptedAll
}

/**
    The UserConsent class encapsulates the consent status, accepted vendor ids and accepted categories (purposes) ids.
    - Important: The `acceptedVendors` and `acceptedCategories` arrays will only be populated if the `status` is `.Some`. That is, if the user has accepted `.All` or `.None` vendors/categories, those arrays will be empty.
 */
@objc public class UserConsent: NSObject, Codable {
    /// Indicates if the user has accepted `.All`, `.Some` or `.None` of the vendors **and** categories.
    public let status: ConsentStatus
    /// The ids of the accepted vendors and categories. These can be found in SourcePoint's dashboard
    public let acceptedVendors, acceptedCategories: [String]
    
    public static func acceptedNone () -> UserConsent {
        return UserConsent(status: ConsentStatus.AcceptedNone, acceptedVendors: [], acceptedCategories: [])
    }
    
    public init(status: ConsentStatus, acceptedVendors: [String], acceptedCategories: [String]) {
        self.status = status
        self.acceptedVendors = acceptedVendors
        self.acceptedCategories = acceptedCategories
    }
    
    open override var description: String { return "Status: \(status.rawValue), acceptedVendors: \(acceptedVendors), acceptedCategories: \(acceptedCategories)" }
    
    enum CodingKeys: String, CodingKey {
       case status, acceptedVendors, acceptedCategories
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        acceptedVendors = try values.decode([String].self, forKey: .acceptedVendors)
        acceptedCategories = try values.decode([String].self, forKey: .acceptedCategories)
        let statusString = try values.decode(String.self, forKey: .status)
        switch statusString {
            case "acceptedNone": status = .AcceptedNone
            case "acceptedSome": status = .AcceptedSome
            case "acceptedAll": status = .AcceptedAll
            default: throw MessageEventParsingError(message: "Unknown status string: \(statusString)")
        }
    }
}
