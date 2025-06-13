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
    public var status: [PreferencesStatus] = []
    public var rejectedStatus: [PreferencesStatus] = []

    init(
        dateCreated: SPDate,
        messageId: String? = nil,
        uuid: String? = nil,
        status: [PreferencesStatus] = [],
        rejectedStatus: [PreferencesStatus] = []
    ) {
        self.uuid = uuid
        self.status = status
        self.messageId = messageId
        self.dateCreated = dateCreated
        self.rejectedStatus = rejectedStatus
    }
}

extension SPPreferencesConsent {
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

    public static func empty() -> SPPreferencesConsent { SPPreferencesConsent(
        dateCreated: .now()
    )}

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
    @objcMembers public class PreferencesStatus: NSObject, Codable {
        public let categoryId: Int
        public let channels: [PreferencesChannels]
        public let changed: Bool?
        public let dateConsented: SPDate?
        public let subType: PreferencesSubType?

        init(categoryId: Int, channels: [PreferencesChannels] = [], changed: Bool? = nil, dateConsented: SPDate? = nil, subType: PreferencesSubType? = nil) {
            self.categoryId = categoryId
            self.channels = channels
            self.changed = changed
            self.dateConsented = dateConsented
            self.subType = subType
        }
    }

    @objcMembers public class PreferencesChannels: NSObject, Codable {
        public let channelId: Int
        public let status: Bool

        init(channelId: Int, status: Bool) {
            self.channelId = channelId
            self.status = status
        }
    }

    @objc public enum PreferencesSubType: Int, Codable, CustomStringConvertible {
        case AIPolicy, TermsAndConditions, PrivacyPolicy, LegalPolicy, TermsOfSale, Unknown

        public var description: String {
            return switch self {
            case .AIPolicy: "AIPolicy"
            case .TermsAndConditions: "TermsAndConditions"
            case .PrivacyPolicy: "PrivacyPolicy"
            case .LegalPolicy: "LegalPolicy"
            case .TermsOfSale: "TermsOfSale"
            case .Unknown: "Unknown"
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
