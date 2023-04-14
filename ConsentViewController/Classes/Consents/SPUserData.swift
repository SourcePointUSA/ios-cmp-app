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
        let webConsentPayload: SPJson

        public init(uuid: String, webConsentPayload: SPJson) {
            self.uuid = uuid
            self.webConsentPayload = webConsentPayload
        }
    }

    let gdpr: SPWebConsent?
    let ccpa: SPWebConsent?

    public init(gdpr: SPWebConsent? = nil, ccpa: SPWebConsent? = nil) {
        self.gdpr = gdpr
        self.ccpa = ccpa
    }
}

public class SPConsent<ConsentType: Codable & Equatable>: NSObject, Codable {
    /// The consents data. See: `SPGDPRConsent`, `SPCCPAConsent`
    public let consents: ConsentType?

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
}

@objcMembers public class SPUserData: NSObject, Codable {
    /// Consent data for GDPR. This attribute will be nil if your setup doesn't include a GDPR campaign
    /// - SeeAlso: `SPGDPRConsent`
    public let gdpr: SPConsent<SPGDPRConsent>?

    /// Consent data for CCPA. This attribute will be nil if your setup doesn't include a CCPA campaign
    /// - SeeAlso: `SPCCPAConsent`
    public let ccpa: SPConsent<SPCCPAConsent>?

    let webConsents: SPWebConsents

    override public var description: String {
        "gdpr: \(String(describing: gdpr)), ccpa: \(String(describing: ccpa))"
    }

    public init(
        gdpr: SPConsent<SPGDPRConsent>? = nil,
        ccpa: SPConsent<SPCCPAConsent>? = nil,
        webConsents: SPWebConsents = SPWebConsents()
    ) {
        self.gdpr = gdpr
        self.ccpa = ccpa
        self.webConsents = webConsents
    }

    override open func isEqual(_ object: Any?) -> Bool {
        if let object = object as? SPUserData {
            return  self.gdpr?.applies == object.gdpr?.applies &&
                    self.gdpr?.consents?.uuid == object.gdpr?.consents?.uuid &&
                    self.gdpr?.consents?.euconsent == object.gdpr?.consents?.euconsent &&
                    self.gdpr?.consents?.childPmId == object.gdpr?.consents?.childPmId &&
                    self.gdpr?.consents?.tcfData == object.gdpr?.consents?.tcfData &&
                    self.gdpr?.consents?.vendorGrants == object.gdpr?.consents?.vendorGrants &&
                    self.ccpa?.applies == object.ccpa?.applies &&
                    self.ccpa?.consents?.uuid == object.ccpa?.consents?.uuid &&
                    self.ccpa?.consents?.childPmId == object.ccpa?.consents?.childPmId &&
                    self.ccpa?.consents?.status == object.ccpa?.consents?.status &&
                    self.ccpa?.consents?.uspstring == object.ccpa?.consents?.uspstring &&
                    self.ccpa?.consents?.rejectedVendors == object.ccpa?.consents?.rejectedVendors
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
