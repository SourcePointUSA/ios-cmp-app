//
//  SPCCPAConsent.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 08.02.21.
//

import Foundation

/// Indicates the consent status of a given user.
@objc public enum CCPAConsentStatus: Int, Codable {
    /// Indicates the user has rejected none of the vendors or purposes (categories)
    case RejectedNone

    /// Indicates the user has rejected none of the vendors or purposes (categories)
    case RejectedSome

    /// Indicates the user has rejected none of the vendors or purposes (categories)
    case RejectedAll

    /// Indicates the user has **explicitly** acceted all vendors and purposes (categories).
    /// That's slightly different than `RejectNone`. By default in the CCPA users are already
    /// `RejectedNone`, the `ConsentedAll` indicates the user has taken an action to
    /// consent to all vendors and purposes.
    case ConsentedAll

    public typealias RawValue = String

    public var rawValue: RawValue {
        switch self {
        case .ConsentedAll:
            return "consentedAll"
        case .RejectedAll:
            return "rejectedAll"
        case .RejectedSome:
            return "rejectedSome"
        case .RejectedNone:
            return "rejectedNone"
        }
    }

    public init?(rawValue: RawValue) {
        switch rawValue {
        case "consentedAll":
            self = .ConsentedAll
        case "rejectedAll":
            self = .RejectedAll
        case "rejectedSome":
            self = .RejectedSome
        case "rejectedNone":
            self = .RejectedNone
        default:
            return nil
        }
    }
}

public typealias SPUsPrivacyString = String

/**
 The UserConsent class encapsulates the consent status, rejected vendor ids and rejected categories (purposes) ids.
 - Important: The `rejectedVendors` and `rejectedCategories` arrays will only be populated if the `status` is `.Some`.
 That is, if the user has rejected `.All` or `.None` vendors/categories, those arrays will be empty.
 */
@objcMembers public class SPCCPAConsent: NSObject, Codable {
    /// represents the default state of the consumer prior to seeing the consent message
    /// - seealso: https://github.com/InteractiveAdvertisingBureau/USPrivacy/blob/master/CCPA/US%20Privacy%20String.md#us-privacy-string-format
    public static let defaultUsPrivacyString = "1---"

    public static func empty() -> SPCCPAConsent { SPCCPAConsent(
        status: .RejectedNone,
        rejectedVendors: [],
        rejectedCategories: [],
        uspstring: defaultUsPrivacyString
    )}

    /// Indicates if the user has rejected `.All`, `.Some` or `.None` of the vendors **and** categories.
    public let status: CCPAConsentStatus
    /// The ids of the rejected vendors and categories. These can be found in SourcePoint's dashboard
    public let rejectedVendors, rejectedCategories: [String]
    /// the US Privacy String as described by the IAB
    public let uspstring: SPUsPrivacyString
    /// that's the internal Sourcepoint id we give to this consent profile
    public var uuid: String?

    public static func rejectedNone () -> SPCCPAConsent { SPCCPAConsent(
        status: CCPAConsentStatus.RejectedNone,
        rejectedVendors: [],
        rejectedCategories: [],
        uspstring: ""
    )}

    public init(
        uuid: String? = nil,
        status: CCPAConsentStatus,
        rejectedVendors: [String],
        rejectedCategories: [String],
        uspstring: SPUsPrivacyString
    ) {
        self.uuid = uuid
        self.status = status
        self.rejectedVendors = rejectedVendors
        self.rejectedCategories = rejectedCategories
        self.uspstring = uspstring
    }

    open override var description: String {
        "UserConsent(uuid: \(uuid ?? ""), status: \(status.rawValue), rejectedVendors: \(rejectedVendors), rejectedCategories: \(rejectedCategories), uspstring: \(uspstring))"
    }

    enum CodingKeys: CodingKey {
        case status, rejectedVendors, rejectedCategories, uspstring, uuid
    }

    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try values.decodeIfPresent(String.self, forKey: .uuid)
        rejectedVendors = try values.decode([String].self, forKey: .rejectedVendors)
        rejectedCategories = try values.decode([String].self, forKey: .rejectedCategories)
        uspstring = try values.decode(SPUsPrivacyString.self, forKey: .uspstring)
        let statusString = try values.decode(String.self, forKey: .status)
        switch statusString {
        case "rejectedNone": status = .RejectedNone
        case "rejectedSome": status = .RejectedSome
        case "rejectedAll":  status = .RejectedAll
        case "consentedAll": status = .ConsentedAll
        default: throw DecodingError.dataCorruptedError(
            forKey: CodingKeys.status,
            in: values,
            debugDescription: "Unknown Status: \(statusString)")
        }
    }

    public override func isEqual(_ object: Any?) -> Bool {
        if let other = object as? SPCCPAConsent {
            return other.uuid == uuid &&
                other.rejectedCategories.elementsEqual(rejectedCategories) &&
                other.rejectedVendors.elementsEqual(rejectedVendors) &&
                other.status == status &&
                other.uspstring == uspstring
        } else {
            return false
        }
    }
}
