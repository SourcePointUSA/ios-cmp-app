//
//  SPUSNatConsent.swift
//  Pods
//
//  Created by Andre Herculano on 02.11.23.
//

import Foundation

@objcMembers public class SPUSNatConsent: NSObject, Codable, CampaignConsent, NSCopying {
    public struct ConsentString: Codable, Equatable {
        public let sectionId: Int
        public let sectionName, consentString: String
    }

    public var uuid: String?

    public var applies: Bool

    public let consentStrings: [ConsentString]

    /// A dictionary with all GPP related data
    public var GPPData: SPJson?

    let categories: [String]

    var dateCreated, expirationDate: SPDate

    /// Required by SP endpoints
    var lastMessage: LastMessageData?

    /// Used by the rendering app
    let webConsentPayload: SPWebConsentPayload?

    var consentStatus: ConsentStatus

    override open var description: String {
        """
        SPUSNatConsent(
            - uuid: \(uuid ?? "")
            - applies: \(applies)
            - consentStrings: \(consentStrings)
            - categories: \(categories)
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
        categories: [String],
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
        self.categories = []
        self.consentStatus = consentStatus
        self.GPPData = GPPData
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
        categories = try container.decode([String].self, forKey: .categories)
        consentStatus = try container.decode(ConsentStatus.self, forKey: .consentStatus)
        GPPData = try container.decodeIfPresent(SPJson.self, forKey: .GPPData)
    }

    public static func empty() -> SPUSNatConsent { SPUSNatConsent(
        applies: false,
        dateCreated: .now(),
        expirationDate: .distantFuture(),
        consentStrings: [],
        categories: [],
        consentStatus: ConsentStatus()
    )}

    override public func isEqual(_ object: Any?) -> Bool {
        if let other = object as? SPUSNatConsent {
            return other.uuid == uuid &&
                other.applies == applies &&
                other.consentStrings.count == consentStrings.count &&
                other.consentStrings.sorted(by: { $0.sectionId > $1.sectionId }) ==
                    other.consentStrings.sorted(by: { $0.sectionId > $1.sectionId }) &&
                other.categories == categories
        } else {
            return false
        }
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
        consentStatus: consentStatus,
        GPPData: GPPData
    )}
}
