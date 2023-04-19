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

    case LinkedNoAction

    /// If there's a new value introduced in the backend and we don't know how to parse it
    case Unknown

    public typealias RawValue = String

    public var rawValue: RawValue {
        switch self {
            case .ConsentedAll: return "consentedAll"
            case .RejectedAll: return "rejectedAll"
            case .RejectedSome: return "rejectedSome"
            case .RejectedNone: return "rejectedNone"
            case .LinkedNoAction: return "linkedNoAction"
            case .Unknown: return "unknown"
            default: return "unknown"
        }
    }

    public init?(rawValue: RawValue) {
        switch rawValue {
            case "consentedAll": self = .ConsentedAll
            case "rejectedAll": self = .RejectedAll
            case "rejectedSome": self = .RejectedSome
            case "rejectedNone": self = .RejectedNone
            case "linkedNoAction": self = .LinkedNoAction
            case "unknown": self = .Unknown
            default: self = .Unknown
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self = .init(rawValue: try container.decode(String.self)) ?? .Unknown
    }
}

public typealias SPUsPrivacyString = String

protocol CampaignConsent {
    var uuid: String? { get set }
    var applies: Bool { get set }
    var dateCreated: SPDateCreated { get set }
}

/**
 The UserConsent class encapsulates the consent status, rejected vendor ids and rejected categories (purposes) ids.
 - Important: The `rejectedVendors` and `rejectedCategories` arrays will only be populated if the `status` is `.Some`.
 That is, if the user has rejected `.All` or `.None` vendors/categories, those arrays will be empty.
 */
@objcMembers public class SPCCPAConsent: NSObject, Codable, CampaignConsent {
    enum CodingKeys: CodingKey {
        case status, rejectedVendors, rejectedCategories,
             uspstring, uuid, childPmId, consentStatus,
             webConsentPayload
    }

    /// represents the default state of the consumer prior to seeing the consent message
    /// - seealso: https://github.com/InteractiveAdvertisingBureau/USPrivacy/blob/master/CCPA/US%20Privacy%20String.md#us-privacy-string-format
    public static let defaultUsPrivacyString = "1---"

    /// Indicates if the user has rejected `.All`, `.Some` or `.None` of the vendors **and** categories.
    public var status: CCPAConsentStatus

    /// The ids of the rejected vendors and categories. These can be found in SourcePoint's dashboard
    public var rejectedVendors, rejectedCategories: [String]

    /// the US Privacy String as described by the IAB
    public var uspstring: SPUsPrivacyString

    /// that's the internal Sourcepoint id we give to this consent profile
    public var uuid: String?

    /// Determines if the GDPR legislation applies for this user
    public var applies = false

    /// The date in which the consent profile was created or updated
    public var dateCreated = SPDateCreated.now()

    /// In case `/getMessages` request was done with `groupPmId`, `childPmId` will be returned
    var childPmId: String?

    /// Required by SP endpoints
    var lastMessage: LastMessageData?

    /// Required by SP endpoints
    var consentStatus: ConsentStatus

    /// Used by the rendering app
    var webConsentPayload: SPWebConsentPayload?

    override open var description: String {
        "UserConsent(uuid: \(uuid ?? ""), status: \(status.rawValue), rejectedVendors: \(rejectedVendors), rejectedCategories: \(rejectedCategories), uspstring: \(uspstring))"
    }

    init(
        uuid: String? = nil,
        status: CCPAConsentStatus,
        rejectedVendors: [String],
        rejectedCategories: [String],
        uspstring: SPUsPrivacyString,
        childPmId: String? = nil,
        consentStatus: ConsentStatus = ConsentStatus(),
        webConsentPayload: SPWebConsentPayload? = nil
    ) {
        self.uuid = uuid
        self.status = status
        self.rejectedVendors = rejectedVendors
        self.rejectedCategories = rejectedCategories
        self.uspstring = uspstring
        self.childPmId = childPmId
        self.consentStatus = consentStatus
        self.webConsentPayload = webConsentPayload
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decode(CCPAConsentStatus.self, forKey: .status)
        rejectedVendors = try container.decode([String].self, forKey: .rejectedVendors)
        rejectedCategories = try container.decode([String].self, forKey: .rejectedCategories)
        uspstring = try container.decode(SPUsPrivacyString.self, forKey: .uspstring)
        uuid = try container.decodeIfPresent(String.self, forKey: .uuid)
        childPmId = try container.decodeIfPresent(String.self, forKey: .childPmId)
        consentStatus = try (try? container.decode(ConsentStatus.self, forKey: .consentStatus)) ?? ConsentStatus(from: decoder)
        webConsentPayload = try container.decodeIfPresent(SPWebConsentPayload.self, forKey: .webConsentPayload)
    }

    public static func rejectedNone () -> SPCCPAConsent { SPCCPAConsent(
        status: CCPAConsentStatus.RejectedNone,
        rejectedVendors: [],
        rejectedCategories: [],
        uspstring: ""
    )}

    public static func empty() -> SPCCPAConsent { SPCCPAConsent(
        status: .RejectedNone,
        rejectedVendors: [],
        rejectedCategories: [],
        uspstring: defaultUsPrivacyString
    )}

    override public func isEqual(_ object: Any?) -> Bool {
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
