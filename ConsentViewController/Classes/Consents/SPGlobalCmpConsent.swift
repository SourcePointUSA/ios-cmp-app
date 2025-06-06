//
//  SPGlobalCmpConsent.swift
//  Pods
//
//  Created by Dmytro Fedko on 06.06.25.
//

import Foundation

@objcMembers public class SPGlobalCmpConsent: NSObject, Codable, CampaignConsent, NSCopying {
    /// A collection of accepted/rejected vendors and their ids
    public var vendors: [SPConsentable] { userConsents.vendors }

    /// A collection of accepted/rejected categories (aka. purposes) and their ids
    public var categories: [SPConsentable] { userConsents.categories }

    /// Identifies this globalcmp consent profile
    public var uuid: String?

    /// Whether GlobalCmp applies according to user's location (inferred from IP lookup) and your Vendor List applies scope setting
    public var applies: Bool

    var dateCreated, expirationDate: SPDate

    /// Used by SP endpoints and to derive the data inside `statuses`
    var consentStatus: ConsentStatus

    /// Only here to make it easier encoding/decoding data from SP endpoints.
    /// Used to derive the data in `vendors` and `categories`
    var userConsents: UserConsents

    init(
        uuid: String? = nil,
        applies: Bool,
        dateCreated: SPDate,
        expirationDate: SPDate,
        categories: [SPConsentable],
        vendors: [SPConsentable],
        consentStatus: ConsentStatus
    ) {
        self.uuid = uuid
        self.applies = applies
        self.dateCreated = dateCreated
        self.expirationDate = expirationDate
        self.consentStatus = consentStatus
        self.userConsents = UserConsents(vendors: vendors, categories: categories)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try container.decodeIfPresent(String.self, forKey: .uuid)
        applies = try container.decodeIfPresent(Bool.self, forKey: .applies) ?? false
        dateCreated = try container.decode(SPDate.self, forKey: .dateCreated)
        expirationDate = try container.decode(SPDate.self, forKey: .expirationDate)
        consentStatus = try container.decode(ConsentStatus.self, forKey: .consentStatus)
        userConsents = try container.decodeIfPresent(UserConsents.self, forKey: .userConsents) ?? UserConsents(vendors: [], categories: [])
    }
}

extension SPGlobalCmpConsent {
    override open var description: String {
        """
        SPGlobalCmpConsent(
            - uuid: \(uuid ?? "")
            - applies: \(applies)
            - categories: \(categories)
            - vendors: \(vendors)
            - dateCreated: \(dateCreated)
            - expirationDate: \(expirationDate)
        )
        """
    }

    public static func empty() -> SPGlobalCmpConsent { SPGlobalCmpConsent(
        applies: false,
        dateCreated: .now(),
        expirationDate: .distantFuture(),
        categories: [],
        vendors: [],
        consentStatus: ConsentStatus()
    )}

    override public func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? SPGlobalCmpConsent else { return false }

        return other.uuid == uuid &&
            other.applies == applies &&
            other.categories == categories &&
            other.vendors == vendors
    }

    public func copy(with zone: NSZone? = nil) -> Any { SPGlobalCmpConsent(
        uuid: uuid,
        applies: applies,
        dateCreated: dateCreated,
        expirationDate: expirationDate,
        categories: categories,
        vendors: vendors,
        consentStatus: consentStatus
    )}
}

extension SPGlobalCmpConsent {
    struct UserConsents: Codable, Equatable {
        var vendors, categories: [SPConsentable]
    }
}
