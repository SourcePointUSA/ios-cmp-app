//
//  SPUSNatConsent.swift
//  Pods
//
//  Created by Andre Herculano on 02.11.23.
//

import Foundation

@objcMembers public class SPUSNatConsent: NSObject, Codable, CampaignConsent, NSCopying {
    var uuid: String?

    var applies: Bool

    var dateCreated: SPDate

    /// Used by the rendering app
    var webConsentPayload: SPWebConsentPayload?

    override open var description: String {
        """
        SPUSNatConsent(
            - uuid: \(uuid ?? "")
            - applies: \(applies)
            - dateCreated: \(dateCreated)
        )
        """
    }

    init(
        uuid: String? = nil,
        applies: Bool,
        dateCreated: SPDate,
        webConsentPayload: SPWebConsentPayload? = nil
    ) {
        self.uuid = uuid
        self.applies = applies
        self.dateCreated = dateCreated
    }

    public static func empty() -> SPUSNatConsent { SPUSNatConsent(
        applies: false,
        dateCreated: .now()
    )}

    override public func isEqual(_ object: Any?) -> Bool {
        if let other = object as? SPUSNatConsent {
            return other.uuid == uuid &&
                other.applies == applies
        } else {
            return false
        }
    }

    public func copy(with zone: NSZone? = nil) -> Any { SPUSNatConsent(
        uuid: uuid,
        applies: applies,
        dateCreated: dateCreated,
        webConsentPayload: webConsentPayload
    )}
}
