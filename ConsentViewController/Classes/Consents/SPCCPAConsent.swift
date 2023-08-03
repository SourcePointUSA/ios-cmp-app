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

struct SPUSPString {
    let version = 1
    let hadChanceToOptOut = true
    let signedLspa: Bool
    let status: CCPAConsentStatus
    let applies: Bool

    var string: String {
        applies ?
            "\(version)" +
            (hadChanceToOptOut ? "Y" : "N") +
            (status == .RejectedAll || status == .RejectedSome ? "Y" : "N") +
            (signedLspa ? "Y" : "N")
        : "\(version)---"
    }
}

extension SPUSPString {
    init(from consents: SPCCPAConsent?) {
        self.init(
            signedLspa: consents?.signedLspa ?? false,
            status: consents?.status ?? .RejectedNone,
            applies: consents?.applies ?? false
        )
    }
}

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
    enum CodingKeys: String, CodingKey {
        case status, rejectedVendors, rejectedCategories,
             uuid, childPmId, consentStatus,
             webConsentPayload, signedLspa, applies,
             GPPData
    }

    /// Indicates if the user has rejected `.All`, `.Some` or `.None` of the vendors **and** categories.
    public var status: CCPAConsentStatus

    /// The ids of the rejected vendors and categories. These can be found in SourcePoint's dashboard
    public var rejectedVendors, rejectedCategories: [String]

    /// the US Privacy String as described by the IAB
    public var uspstring: String { ccpaString.string }

    /// that's the internal Sourcepoint id we give to this consent profile
    public var uuid: String?

    /// Determines if the GDPR legislation applies for this user
    public var applies = false

    /// The date in which the consent profile was created or updated
    public var dateCreated = SPDateCreated.now()

    /// A dictionary with all GPP related data
    public var GPPData: SPJson

    /// In case `/getMessages` request was done with `groupPmId`, `childPmId` will be returned
    var childPmId: String?

    /// Required by SP endpoints
    var lastMessage: LastMessageData?

    /// Required by SP endpoints
    var consentStatus: ConsentStatus

    /// Used by the rendering app
    var webConsentPayload: SPWebConsentPayload?

    var signedLspa: Bool = false

    var ccpaString: SPUSPString {
        SPUSPString(from: self)
    }

    override open var description: String {
        """
        UserConsent(
            - uuid: \(uuid ?? "")
            - status: \(status.rawValue)
            - rejectedVendors: \(rejectedVendors)
            - rejectedCategories: \(rejectedCategories)
            - uspstring: \(uspstring)
            - signedLspa: \(signedLspa)
            - GPPData: \(GPPData)
        )
        """
    }

    init(
        uuid: String? = nil,
        status: CCPAConsentStatus,
        rejectedVendors: [String],
        rejectedCategories: [String],
        signedLspa: Bool,
        childPmId: String? = nil,
        consentStatus: ConsentStatus = ConsentStatus(),
        webConsentPayload: SPWebConsentPayload? = nil,
        GPPData: SPJson = SPJson()
    ) {
        self.uuid = uuid
        self.status = status
        self.rejectedVendors = rejectedVendors
        self.rejectedCategories = rejectedCategories
        self.signedLspa = signedLspa
        self.childPmId = childPmId
        self.consentStatus = consentStatus
        self.webConsentPayload = webConsentPayload
        self.GPPData = GPPData
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decode(CCPAConsentStatus.self, forKey: .status)
        rejectedVendors = try container.decode([String].self, forKey: .rejectedVendors)
        rejectedCategories = try container.decode([String].self, forKey: .rejectedCategories)
        signedLspa = try container.decode(Bool.self, forKey: .signedLspa)
        uuid = try container.decodeIfPresent(String.self, forKey: .uuid)
        childPmId = try container.decodeIfPresent(String.self, forKey: .childPmId)
        consentStatus = try (try? container.decode(ConsentStatus.self, forKey: .consentStatus)) ?? ConsentStatus(from: decoder)
        webConsentPayload = try container.decodeIfPresent(SPWebConsentPayload.self, forKey: .webConsentPayload)
        applies = try container.decodeIfPresent(Bool.self, forKey: .applies) ?? false
        GPPData = try container.decodeIfPresent(SPJson.self, forKey: .GPPData) ?? SPJson()
    }

    public static func empty() -> SPCCPAConsent { SPCCPAConsent(
        status: .RejectedNone,
        rejectedVendors: [],
        rejectedCategories: [],
        signedLspa: false
    )}

    override public func isEqual(_ object: Any?) -> Bool {
        if let other = object as? SPCCPAConsent {
            return other.uuid == uuid &&
            other.rejectedCategories.elementsEqual(rejectedCategories) &&
            other.rejectedVendors.elementsEqual(rejectedVendors) &&
            other.status == status &&
            other.signedLspa == signedLspa
        } else {
            return false
        }
    }
}
