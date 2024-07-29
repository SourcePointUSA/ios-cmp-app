//
//  SPUSNatConsent.swift
//  Pods
//
//  Created by Andre Herculano on 02.11.23.
//

import Foundation

@objcMembers public class SPUSNatConsent: NSObject, Codable, CampaignConsent, NSCopying {
    /// A collection of accepted/rejected vendors and their ids
    public var vendors: [SPConsentable] { userConsents.vendors }

    /// A collection of accepted/rejected categories (aka. purposes) and their ids
    public var categories: [SPConsentable] { userConsents.categories }

    /// Identifies this usnat consent profile
    public var uuid: String?

    /// Whether USNat applies according to user's location (inferred from IP lookup) and your Vendor List applies scope setting
    public var applies: Bool

    /// The consent strings related to this user profile
    public var consentStrings: [ConsentString]

    /// A series of statuses (`Bool?`) regarding GPP and user consent
    /// - SeeAlso: `SPUSNatConsent.Statuses`
    public var statuses: Statuses { .init(from: consentStatus) }

    /// A dictionary with all GPP related data. Only available on Swift implementations.
    /// ObjC projects will have to access this data via `UserDefaults` according to the GPP spec:
    /// - SeeAlso: https://github.com/InteractiveAdvertisingBureau/Global-Privacy-Platform/blob/main/Core/CMP%20API%20Specification.md#in-app-details
    public var GPPData: SPJson?

    var dateCreated, expirationDate: SPDate

    /// Required by SP endpoints
    var lastMessage: LastMessageData?

    /// Used by the rendering app
    let webConsentPayload: SPWebConsentPayload?

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
        consentStrings: [ConsentString],
        webConsentPayload: SPWebConsentPayload? = nil,
        lastMessage: LastMessageData? = nil,
        categories: [SPConsentable],
        vendors: [SPConsentable],
        consentStatus: ConsentStatus,
        GPPData: SPJson? = nil
    ) {
        self.uuid = uuid
        self.applies = applies
        self.dateCreated = dateCreated
        self.expirationDate = expirationDate
        self.consentStrings = consentStrings
        self.webConsentPayload = webConsentPayload
        self.lastMessage = lastMessage
        self.consentStatus = consentStatus
        self.GPPData = GPPData
        self.userConsents = UserConsents(vendors: vendors, categories: categories)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try container.decodeIfPresent(String.self, forKey: .uuid)
        applies = try container.decodeIfPresent(Bool.self, forKey: .applies) ?? false
        dateCreated = try container.decode(SPDate.self, forKey: .dateCreated)
        expirationDate = try container.decode(SPDate.self, forKey: .expirationDate)
        consentStrings = try container.decode([ConsentString].self, forKey: .consentStrings)
        webConsentPayload = try container.decodeIfPresent(SPWebConsentPayload.self, forKey: .webConsentPayload)
        lastMessage = try container.decodeIfPresent(LastMessageData.self, forKey: .lastMessage)
        consentStatus = try container.decode(ConsentStatus.self, forKey: .consentStatus)
        GPPData = try container.decodeIfPresent(SPJson.self, forKey: .GPPData)
        userConsents = try container.decodeIfPresent(UserConsents.self, forKey: .userConsents) ?? UserConsents(vendors: [], categories: [])
    }
}

extension SPUSNatConsent {
    override open var description: String {
        """
        SPUSNatConsent(
            - uuid: \(uuid ?? "")
            - applies: \(applies)
            - consentStrings: \(consentStrings)
            - categories: \(categories)
            - vendors: \(vendors)
            - dateCreated: \(dateCreated)
            - expirationDate: \(expirationDate)
        )
        """
    }

    public static func empty() -> SPUSNatConsent { SPUSNatConsent(
        applies: false,
        dateCreated: .now(),
        expirationDate: .distantFuture(),
        consentStrings: [],
        categories: [],
        vendors: [],
        consentStatus: ConsentStatus()
    )}

    override public func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? SPUSNatConsent else { return false }

        return other.uuid == uuid &&
            other.applies == applies &&
            other.consentStrings.count == consentStrings.count &&
            other.consentStrings.sorted(by: { $0.sectionId > $1.sectionId }) ==
            other.consentStrings.sorted(by: { $0.sectionId > $1.sectionId }) &&
            other.categories == categories &&
            other.vendors == vendors
    }

    public func copy(with zone: NSZone? = nil) -> Any { SPUSNatConsent(
        uuid: uuid,
        applies: applies,
        dateCreated: dateCreated,
        expirationDate: expirationDate,
        consentStrings: consentStrings,
        webConsentPayload: webConsentPayload,
        lastMessage: lastMessage,
        categories: categories,
        vendors: vendors,
        consentStatus: consentStatus,
        GPPData: GPPData
    )}
}

extension SPUSNatConsent {
    struct UserConsents: Codable, Equatable {
        var vendors, categories: [SPConsentable]
    }
}

extension SPUSNatConsent {
    @objc(SPUSNatConsent_ConsentString)
    @objcMembers public class ConsentString: NSObject, Codable {
        public let sectionId: Int
        public let sectionName, consentString: String

        override open var description: String {
            """
            SPUSNatConsent.ConsentString(
                - sectionId: \(sectionId)
                - sectionName: \(sectionName)
                - consentString: \(consentString)
            )
            """
        }

        public init(sectionId: Int, sectionName: String, consentString: String) {
            self.sectionId = sectionId
            self.sectionName = sectionName
            self.consentString = consentString
        }

        override public func isEqual(_ object: Any?) -> Bool {
            guard let other = object as? ConsentString else { return false }

            return other.sectionId == sectionId &&
            other.sectionName == sectionName &&
            other.consentString == consentString
        }
    }
}

public extension SPUSNatConsent {
    struct Statuses: CustomStringConvertible, Equatable {
        public var rejectedAny, consentedToAll, consentedToAny,
            hasConsentData, sellStatus, shareStatus,
            sensitiveDataStatus, gpcStatus: Bool?

        public var description: String {
            """
            SPUSNatConsent.Statuses(
                - rejectedAny: \(rejectedAny as Any)
                - consentedToAll: \(consentedToAll as Any)
                - consentedToAny: \(consentedToAny as Any)
                - hasConsentData: \(hasConsentData as Any)
                - sellStatus: \(sellStatus as Any)
                - shareStatus: \(shareStatus as Any)
                - sensitiveDataStatus: \(sensitiveDataStatus as Any)
                - gpcStatus: \(gpcStatus as Any)
            )
            """
        }

        init(from status: ConsentStatus) {
            rejectedAny = status.rejectedAny
            consentedToAll = status.consentedToAll
            consentedToAny = status.consentedToAny
            hasConsentData = status.hasConsentData
            sellStatus = status.granularStatus?.sellStatus
            shareStatus = status.granularStatus?.shareStatus
            sensitiveDataStatus = status.granularStatus?.sensitiveDataStatus
            gpcStatus = status.granularStatus?.gpcStatus
        }
    }
}

@available(swift, obsoleted: 1.0)
public extension SPUSNatConsent {
    @objc(SPUSNatConsent_ObjcStatuses)
    class ObjcStatuses: NSObject {
        let statuses: Statuses

        @objc public var rejectedAny: Bool { statuses.rejectedAny ?? false }
        @objc public var consentedToAll: Bool { statuses.consentedToAll ?? false }
        @objc public var consentedToAny: Bool { statuses.consentedToAny ?? false }
        @objc public var hasConsentData: Bool { statuses.hasConsentData ?? false }
        @objc public var sellStatus: Bool { statuses.sellStatus ?? false }
        @objc public var shareStatus: Bool { statuses.shareStatus ?? false }
        @objc public var sensitiveDataStatus: Bool { statuses.sensitiveDataStatus ?? false }
        @objc public var gpcStatus: Bool { statuses.gpcStatus ?? false }

        override public var description: String {
            """
            SPUSNatConsent_ObjcStatuses(
                - rejectedAny: \(rejectedAny as Any)
                - consentedToAll: \(consentedToAll as Any)
                - consentedToAny: \(consentedToAny as Any)
                - hasConsentData: \(hasConsentData as Any)
                - sellStatus: \(sellStatus as Any)
                - shareStatus: \(shareStatus as Any)
                - sensitiveDataStatus: \(sensitiveDataStatus as Any)
                - gpcStatus: \(gpcStatus as Any)
            )
            """
        }

        public init(from statuses: Statuses) {
            self.statuses = statuses
        }
    }

    var objcStatuses: ObjcStatuses { .init(from: statuses) }
}
