//
//  SPConsents.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 15.02.21.
//

import Foundation

@objcMembers public class SPConsent<ConsentType: Codable & Equatable>: NSObject, Codable {
    let consents: ConsentType?
    let applies: Bool

    public init(consents: ConsentType?, applies: Bool) {
        self.consents = consents
        self.applies = applies
    }

    public override var description: String { "applies: \(applies), consents: \(String(describing: consents))" }
}

extension SPConsent {
    convenience init?(from campaign: Campaign?) {
        guard let campaign = campaign else { return nil }

        switch campaign.userConsent {
        case .ccpa(let consents): self.init(consents: consents as? ConsentType, applies: campaign.applies ?? false)
        case .gdpr(let consents): self.init(consents: consents as? ConsentType, applies: campaign.applies ?? false)
        default: self.init(consents: nil, applies: false)
        }
    }
}

@objcMembers public class SPUserData: NSObject, Codable {
    let gdpr: SPConsent<SPGDPRConsent>?
    let ccpa: SPConsent<SPCCPAConsent>?

    public init(
        gdpr: SPConsent<SPGDPRConsent>? = nil,
        ccpa: SPConsent<SPCCPAConsent>? = nil
    ) {
        self.gdpr = gdpr
        self.ccpa = ccpa
    }

    public override var description: String { "gdpr: \(String(describing: gdpr)), ccpa: \(String(describing: ccpa))" }
}

extension SPUserData {
    convenience init(from messageResponse: MessagesResponse) {
        self.init(
            gdpr: SPConsent<SPGDPRConsent>(from: messageResponse.campaigns.first { campaign in campaign.type == .gdpr }),
            ccpa: SPConsent<SPCCPAConsent>(from: messageResponse.campaigns.first { campaign in campaign.type == .ccpa })
        )
    }
}
