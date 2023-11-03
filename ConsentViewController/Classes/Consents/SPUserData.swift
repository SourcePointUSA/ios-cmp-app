//
//  SPConsents.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 15.02.21.
//

import Foundation

public struct SPWebConsents: Codable, Equatable {
    public struct SPWebConsent: Codable, Equatable {
        let uuid: String
        let webConsentPayload: SPWebConsentPayload?

        public init?(uuid: String?, webConsentPayload: SPWebConsentPayload?) {
            guard let uuid = uuid else { return nil }

            self.uuid = uuid
            self.webConsentPayload = webConsentPayload
        }
    }

    let gdpr, ccpa, usnat: SPWebConsent?

    public init(gdpr: SPWebConsent? = nil, ccpa: SPWebConsent? = nil, usnat: SPWebConsent? = nil) {
        self.gdpr = gdpr
        self.ccpa = ccpa
        self.usnat = usnat
    }
}

public class SPConsent<ConsentType: Codable & Equatable & NSCopying>: NSObject, Codable, NSCopying {
    /// The consents data. See: `SPGDPRConsent`, `SPCCPAConsent`, `SPUSNatConsent`
    public let consents: ConsentType?

    // swiftlint:disable:next todo
    // TODO: deprecate this attribute in favour of ConsentType.applies
    /// Indicates whether the legislation applies to the current session or not.
    /// This is based on your Vendor List configuration (scope of the vendor list) and will be determined
    /// based on the user's IP. **SP does not store the user's IP.**
    public let applies: Bool

    override public var description: String { "applies: \(applies), consents: \(String(describing: consents))" }

    public init(consents: ConsentType?, applies: Bool) {
        self.consents = consents
        self.applies = applies
    }

    override public func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? Self else { return false }
        return other.applies == applies && other.consents == consents
    }

    public func copy(with zone: NSZone? = nil) -> Any {
        SPConsent(consents: consents?.copy() as? ConsentType, applies: applies)
    }
}

@objcMembers public class SPUserData: NSObject, Codable, NSCopying {
    /// Consent data for GDPR. This attribute will be nil if your setup doesn't include a GDPR campaign
    /// - SeeAlso: `SPGDPRConsent`
    public let gdpr: SPConsent<SPGDPRConsent>?

    /// Consent data for CCPA. This attribute will be nil if your setup doesn't include a CCPA campaign
    /// - SeeAlso: `SPCCPAConsent`
    public let ccpa: SPConsent<SPCCPAConsent>?

    /// Consent data for USNat. This attribute will be nil if your setup doesn't include a CCPA campaign
    /// - SeeAlso: `SPUSNatConsent`
    public let usnat: SPConsent<SPUSNatConsent>?

    var webConsents: SPWebConsents { SPWebConsents(
        gdpr: .init(uuid: gdpr?.consents?.uuid, webConsentPayload: gdpr?.consents?.webConsentPayload),
        ccpa: .init(uuid: ccpa?.consents?.uuid, webConsentPayload: ccpa?.consents?.webConsentPayload),
        usnat: .init(uuid: usnat?.consents?.uuid, webConsentPayload: usnat?.consents?.webConsentPayload)
    )}

    override public var description: String {
        "gdpr: \(String(describing: gdpr)), ccpa: \(String(describing: ccpa)), usnat: \(String(describing: usnat))"
    }

    public init(
        gdpr: SPConsent<SPGDPRConsent>? = nil,
        ccpa: SPConsent<SPCCPAConsent>? = nil,
        usnat: SPConsent<SPUSNatConsent>? = nil
    ) {
        self.gdpr = gdpr
        self.ccpa = ccpa
        self.usnat = usnat
    }

    public func copy(with zone: NSZone? = nil) -> Any {
        SPUserData(
            gdpr: gdpr?.copy() as? SPConsent<SPGDPRConsent>,
            ccpa: ccpa?.copy() as? SPConsent<SPCCPAConsent>,
            usnat: usnat?.copy() as? SPConsent<SPUSNatConsent>
        )
    }

    override open func isEqual(_ object: Any?) -> Bool {
        if let object = object as? SPUserData {
            return  gdpr?.applies == object.gdpr?.applies &&
                    gdpr?.consents == object.gdpr?.consents &&
                    ccpa?.applies == object.ccpa?.applies &&
                    ccpa?.consents == object.ccpa?.consents &&
                    usnat?.applies == object.usnat?.applies &&
                    usnat?.consents == object.usnat?.consents
        } else {
            return false
        }
    }
}

public protocol SPObjcUserData {
    func objcGDPRConsents() -> SPGDPRConsent?
    func objcGDPRApplies() -> Bool
    func objcCCPAConsents() -> SPCCPAConsent?
    func objcCCPAApplies() -> Bool
    func objcUSNatConsents() -> SPUSNatConsent?
    func objcUSNatApplies() -> Bool
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

    /// Returns CCPA consent data if any available.
    /// - SeeAlso: `SPCCPAConsent`
    public func objcCCPAConsents() -> SPCCPAConsent? {
        ccpa?.consents
    }

    /// Indicates whether CCPA applies based on the VendorList configuration.
    public func objcCCPAApplies() -> Bool {
        ccpa?.applies ?? false
    }

    /// Returns USNat consent data if any available.
    /// - SeeAlso: `SPUSNatConsent`
    public func objcUSNatConsents() -> SPUSNatConsent? {
        usnat?.consents
    }

    /// Indicates whether USNat applies based on the VendorList configuration.
    public func objcUSNatApplies() -> Bool {
        usnat?.applies ?? false
    }
}
