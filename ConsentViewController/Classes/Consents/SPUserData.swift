//
//  SPConsents.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 15.02.21.
//

import Foundation

public class SPConsent<ConsentType: Codable & Equatable>: NSObject, Codable {
    /// The consents data. See: `SPGDPRConsent`, `SPCCPAConsent`
    public let consents: ConsentType?

    /// Indicates whether the legislation applies to the current session or not.
    /// This is based on your Vendor List configuration (scope of the vendor list) and will be determined
    /// based on the user's IP. **SP does not store the user's IP.**
    public let applies: Bool

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
    /// Consent data for GDPR. This attribute will be nil if your setup doesn't include a GDPR campaign
    /// - SeeAlso: `SPGDPRConsent`
    public let gdpr: SPConsent<SPGDPRConsent>?

    /// Consent data for CCPA. This attribute will be nil if your setup doesn't include a CCPA campaign
    /// - SeeAlso: `SPCCPAConsent`
    public let ccpa: SPConsent<SPCCPAConsent>?

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

public protocol SPObjcUserData {
    func objcGDPRConsents() -> SPGDPRConsent?
    func objcGDPRApplies() -> Bool
    func objcCCPAConsents() -> SPCCPAConsent?
    func objcCCPAApplies() -> Bool
}

@objc extension SPUserData: SPObjcUserData {
    /// Returns GDPR consent data if any available.
    /// - SeeAlso: `SPGDPRConsent`
    public func objcGDPRConsents() -> SPGDPRConsent? {
        gdpr?.consents
    }

    /// Indicates whether GDPR applies based on the VendorList configuration.
    public func objcGDPRApplies() -> Bool {
        gdpr?.applies ?? false
    }

    /// Returns GDPR consent data if any available.
    /// - SeeAlso: `SPCCPAConsent`
    public func objcCCPAConsents() -> SPCCPAConsent? {
        ccpa?.consents
    }

    /// Indicates whether GDPR applies based on the VendorList configuration.
    public func objcCCPAApplies() -> Bool {
        ccpa?.applies ?? false
    }
}
