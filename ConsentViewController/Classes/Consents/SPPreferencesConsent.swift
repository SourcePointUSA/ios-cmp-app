//
//  SPPreferencesConsent.swift
//  Pods
//
//  Created by Fedko Dmytro on 06.05.2025
//

import Foundation

@objcMembers public class SPPreferencesConsent: NSObject, Codable, CampaignConsent, NSCopying {
    var applies: Bool = true
    public var dateCreated: SPDate
    var messageId: String?
    public var uuid: String?
    public var status: [Status] = []
    public var rejectedStatus: [Status] = []

    override open var description: String {
        """
        SPPreferencesConsent(
            - dateCreated: \(dateCreated.originalDateString)
            - messageId: \(messageId ?? "")
            - uuid: \(uuid ?? "")
            - status: \(status)
            - rejectedStatus: \(rejectedStatus)
        )
        """
    }

    init(
        dateCreated: SPDate,
        messageId: String? = nil,
        uuid: String? = nil,
        status: [Status] = [],
        rejectedStatus: [Status] = []
    ) {
        self.uuid = uuid
        self.status = status
        self.messageId = messageId
        self.dateCreated = dateCreated
        self.rejectedStatus = rejectedStatus
    }

    public static func empty() -> SPPreferencesConsent {
        SPPreferencesConsent(dateCreated: .now())
    }

    public func copy(with zone: NSZone? = nil) -> Any {
        SPPreferencesConsent(
            dateCreated: dateCreated,
            messageId: messageId,
            uuid: uuid,
            status: status,
            rejectedStatus: rejectedStatus
        )
    }
}

extension SPPreferencesConsent {
    @objcMembers public class Status: NSObject, Codable {
        public let categoryId: Int
        public let channels: [Channel]
        public let changed: Bool?
        public let dateConsented: SPDate?
        public let subType: SubType?
        public let versionId: String?

        public override var description: String {
            """
            SPPreferencesConsent.Status(
                - categoryId: \(categoryId)
                - channels: \(channels)
                - changed: \(changed as Any)
                - dateConsented: \(dateConsented as Any)
                - subType: \(subType as Any)
                - versionId: \(versionId as Any)
            """
        }

        init(
            categoryId: Int,
            channels: [Channel] = [],
            changed: Bool? = nil,
            dateConsented: SPDate? = nil,
            subType: SubType? = nil,
            versionId: String? = nil
        ) {
            self.categoryId = categoryId
            self.channels = channels
            self.changed = changed
            self.dateConsented = dateConsented
            self.subType = subType
            self.versionId = versionId
        }
    }

    @objcMembers public class Channel: NSObject, Codable {
        public let id: Int
        public let status: Bool

        public override var description: String {
            """
            SPPreferencesConsent.Channel(
                - id: \(id)
                - status: \(status)
            """
        }

        init(id: Int, status: Bool) {
            self.id = id
            self.status = status
        }
    }

    @objc public enum SubType: Int, Codable, CustomStringConvertible {
        case AIPolicy, TermsAndConditions, PrivacyPolicy, LegalPolicy, TermsOfSale, Unknown

        public var description: String {
            return switch self {
            case .AIPolicy: "SPPreferencesConsent.SubType.AIPolicy"
            case .TermsAndConditions: "SPPreferencesConsent.SubType.TermsAndConditions"
            case .PrivacyPolicy: "SPPreferencesConsent.SubType.PrivacyPolicy"
            case .LegalPolicy: "SPPreferencesConsent.SubType.LegalPolicy"
            case .TermsOfSale: "SPPreferencesConsent.SubType.TermsOfSale"
            case .Unknown: "SPPreferencesConsent.SubType.Unknown"
            }
        }

        init(rawString: String) {
            switch rawString.lowercased() {
            case "aipolicy": self = .AIPolicy
            case "termsandconditions": self = .TermsAndConditions
            case "privacypolicy": self = .PrivacyPolicy
            case "legalpolicy": self = .LegalPolicy
            case "termsofsale": self = .TermsOfSale
            case "unknown": self = .Unknown
            default: self = .Unknown
            }
        }
    }
}
