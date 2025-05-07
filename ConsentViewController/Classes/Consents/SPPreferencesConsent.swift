//
//  SPPreferencesConsent.swift
//  Pods
//
//  Created by Fedko Dmytro on 06.05.2025
//

import Foundation

@objcMembers public class SPPreferencesConsent: NSObject, Codable, CampaignConsent, NSCopying {
    var applies: Bool = true
    public var uuid: String?
    public var status, rejectedStatus: [PreferencesStatus]?
    var dateCreated: SPDate
    var messageId: String?

    init(
        uuid: String? = nil,
        dateCreated: SPDate,
        status: [PreferencesStatus]?,
        rejectedStatus: [PreferencesStatus]?,
        messageId: String? = nil
    ) {
        self.uuid = uuid
        self.dateCreated = dateCreated
        self.status = status
        self.rejectedStatus = rejectedStatus
        self.messageId = messageId
    }
}

extension SPPreferencesConsent {
    override open var description: String {
        """
        SPPreferencesConsent(
            - uuid: \(uuid ?? "")
            - status: \(status ?? [])
            - rejectedStatus: \(rejectedStatus ?? [])
            - dateCreated: \(dateCreated)
        )
        """
    }

    public static func empty() -> SPPreferencesConsent { SPPreferencesConsent(
        dateCreated: .now(),
        status: [],
        rejectedStatus: []
    )}

    public func copy(with zone: NSZone? = nil) -> Any {
        SPPreferencesConsent(
            uuid: uuid,
            dateCreated: dateCreated,
            status: status,
            rejectedStatus: rejectedStatus,
            messageId: messageId
        )
    }
}

extension SPPreferencesConsent {
    public struct PreferencesStatus: Codable {
        var categoryId: Int
        var channels: [PreferencesChannels]?
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
