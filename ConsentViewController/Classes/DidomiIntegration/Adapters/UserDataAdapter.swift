//
//  UserDataAdapter.swift
//  ConsentViewController
//
//  Created by Claude on 27/08/2026.
//

import Didomi
import Foundation

final class UserDataAdapter: ConsentAdapter {
    private let gdprAdapter: GDPRConsentAdapter
    private let ccpaAdapter: CCPAConsentAdapter

    init(
        gdprAdapter: GDPRConsentAdapter = GDPRConsentAdapter(),
        ccpaAdapter: CCPAConsentAdapter = CCPAConsentAdapter()
    ) {
        self.gdprAdapter = gdprAdapter
        self.ccpaAdapter = ccpaAdapter
    }

    func adapt(from status: CurrentUserStatus) -> SPUserData {
        let gdpr: SPConsent<SPGDPRConsent>?
        let ccpa: SPConsent<SPCCPAConsent>?

        switch status.regulation {
        case .gdpr:
            gdpr = SPConsent(consents: gdprAdapter.adapt(from: status), applies: true)
            ccpa = nil
        case .cpra:
            gdpr = nil
            ccpa = SPConsent(consents: ccpaAdapter.adapt(from: status), applies: true)
        default:
            gdpr = nil
            ccpa = nil
        }

        return SPUserData(
            gdpr: gdpr,
            ccpa: ccpa,
            usnat: nil,
            globalcmp: nil,
            preferences: nil
        )
    }
}
