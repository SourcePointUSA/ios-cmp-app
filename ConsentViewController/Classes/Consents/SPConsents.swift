//
//  SPConsents.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 15.02.21.
//

import Foundation

@objcMembers public class SPConsent<ConsentType>: NSObject {
    let consents: ConsentType
    let applies: Bool

    public init(consents: ConsentType, applies: Bool) {
        self.consents = consents
        self.applies = applies
    }
}

@objcMembers public class SPConsents: NSObject {
    let gdpr: SPConsent<SPGDPRConsent>?
    let ccpa: SPConsent<SPCCPAConsent>?

    public init(
        gdpr: SPConsent<SPGDPRConsent>? = nil,
        ccpa: SPConsent<SPCCPAConsent>? = nil
    ) {
        self.gdpr = gdpr
        self.ccpa = ccpa
    }
}