//
//  SPUSNatConsent.swift
//  Pods
//
//  Created by Andre Herculano on 02.11.23.
//

import Foundation

@objcMembers public class SPUSNatConsent: NSObject, Codable, CampaignConsent, NSCopying {
    struct UserConsents: Codable, Equatable {
        let vendors, categories: [SPConsentable]
    }

    public struct ConsentString: Codable, Equatable {
        public let sectionId: Int
        public let sectionName, consentString: String
    }

    public var vendors: [SPConsentable] { userConsents.vendors }

    public var categories: [SPConsentable] { userConsents.categories }

    public var uuid: String?

    public var applies: Bool

    public let consentStrings: [ConsentString]

    /// A dictionary with all GPP related data
    public var GPPData: SPJson?

    var dateCreated, expirationDate: SPDate

    /// Required by SP endpoints
    var lastMessage: LastMessageData?

    /// Used by the rendering app
    let webConsentPayload: SPWebConsentPayload?

    var consentStatus: ConsentStatus

    var userConsents: UserConsents

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
