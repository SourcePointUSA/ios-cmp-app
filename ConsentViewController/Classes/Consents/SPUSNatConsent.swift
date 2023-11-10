//
//  SPUSNatConsent.swift
//  Pods
//
//  Created by Andre Herculano on 02.11.23.
//

import Foundation

@objcMembers public class SPUSNatConsent: NSObject, Codable, CampaignConsent, NSCopying {
    public var uuid: String?

    public var applies: Bool

    public let categories: [String]

    var dateCreated: SPDate

    public let consentString: String

    /// Required by SP endpoints
    var lastMessage: LastMessageData?

    /// Used by the rendering app
    let webConsentPayload: SPWebConsentPayload?

    let consentStatus: ConsentStatus

    override open var description: String {
        """
        SPUSNatConsent(
            - uuid: \(uuid ?? "")
            - applies: \(applies)
            - categories: \(categories)
            - dateCreated: \(dateCreated)
        )
        """
    }

    init(
        uuid: String? = nil,
        applies: Bool,
        dateCreated: SPDate,
        consentString: String,
        webConsentPayload: SPWebConsentPayload? = nil,
        lastMessage: LastMessageData? = nil,
        categories: [String],
        consentStatus: ConsentStatus
    ) {
        self.uuid = uuid
        self.applies = applies
        self.dateCreated = dateCreated
        self.consentString = consentString
        self.webConsentPayload = webConsentPayload
        self.lastMessage = lastMessage
        self.categories = []
        self.consentStatus = consentStatus
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try container.decodeIfPresent(String.self, forKey: .uuid)
        applies = try container.decodeIfPresent(Bool.self, forKey: .applies) ?? false
        dateCreated = try container.decode(SPDate.self, forKey: .dateCreated)
        consentString = try container.decode(String.self, forKey: .consentString)
        webConsentPayload = try container.decodeIfPresent(SPWebConsentPayload.self, forKey: .webConsentPayload)
        lastMessage = try container.decodeIfPresent(LastMessageData.self, forKey: .lastMessage)
        categories = try container.decode([String].self, forKey: .categories)
        consentStatus = try container.decode(ConsentStatus.self, forKey: .consentStatus)
    }

    public static func empty() -> SPUSNatConsent { SPUSNatConsent(
        applies: false,
        dateCreated: .now(),
        consentString: "",
        categories: [],
        consentStatus: ConsentStatus()
    )}

    override public func isEqual(_ object: Any?) -> Bool {
        if let other = object as? SPUSNatConsent {
            return other.uuid == uuid &&
                other.applies == applies &&
                other.consentString == consentString &&
                other.categories == categories
        } else {
            return false
        }
    }

    public func copy(with zone: NSZone? = nil) -> Any { SPUSNatConsent(
        uuid: uuid,
        applies: applies,
        dateCreated: dateCreated,
        consentString: consentString,
        webConsentPayload: webConsentPayload,
        lastMessage: lastMessage,
        categories: categories,
        consentStatus: consentStatus
    )}
}
