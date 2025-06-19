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

    public var dateCreated, expirationDate: SPDate

    /// Used by SP endpoints and to derive the data inside `statuses`
    var consentStatus: ConsentStatus

    /// Only here to make it easier encoding/decoding data from SP endpoints.
    /// Used to derive the data in `vendors` and `categories`
    var userConsents: UserConsents

    /// Used by the rendering app
    var webConsentPayload: SPWebConsentPayload?

    init(
        uuid: String? = nil,
        applies: Bool,
        dateCreated: SPDate,
        expirationDate: SPDate,
        userConsents: UserConsents = UserConsents(vendors: [], categories: []),
        consentStatus: ConsentStatus,
        webConsentPayload: SPWebConsentPayload? = nil
    ) {
        self.uuid = uuid
        self.applies = applies
        self.dateCreated = dateCreated
        self.expirationDate = expirationDate
        self.consentStatus = consentStatus
        self.userConsents = userConsents
        self.webConsentPayload = webConsentPayload
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try container.decodeIfPresent(String.self, forKey: .uuid)
        applies = try container.decodeIfPresent(Bool.self, forKey: .applies) ?? false
        dateCreated = try container.decode(SPDate.self, forKey: .dateCreated)
        expirationDate = try container.decode(SPDate.self, forKey: .expirationDate)
        consentStatus = try container.decode(ConsentStatus.self, forKey: .consentStatus)
        userConsents = try container.decodeIfPresent(UserConsents.self, forKey: .userConsents) ?? UserConsents(vendors: [], categories: [])
        webConsentPayload = try container.decodeIfPresent(SPWebConsentPayload.self, forKey: .webConsentPayload)
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
        userConsents: userConsents,
        consentStatus: consentStatus,
        webConsentPayload: webConsentPayload
    )}
}

extension SPGlobalCmpConsent {
    struct UserConsents: Codable, Equatable {
        var vendors, categories: [SPConsentable]
    }
}
