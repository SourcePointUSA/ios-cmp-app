//
//  SPPreferencesConsent.swift
//  Pods
//
//  Created by Fedko Dmytro on 06.05.2025
//

import Foundation

@objcMembers public class SPPreferencesConsent: NSObject, Codable, CampaignConsent, NSCopying {
    var applies: Bool = true
    var dateCreated: SPDate
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
    public struct PreferencesStatus: Codable {
        var categoryId: Int
        var channels: [PreferencesChannels] = []
        var changed: Bool?
        var dateConsented: SPDate?
        var subType: PreferencesSubType? = PreferencesSubType.Unknown
    }

    struct PreferencesChannels: Codable {
        var channelId: Int
        var status: Bool
    }

    public enum PreferencesSubType: Codable {
        case AIPolicy, TermsAndConditions, PrivacyPolicy, LegalPolicy, TermsOfSale, Unknown
    }
}
