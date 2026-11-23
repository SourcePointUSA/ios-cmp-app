//
//  DidomiUserStatus+Framework.swift
//  Pods
//
//  Created by Andre Herculano on 23/11/26.
//

import Foundation
import Didomi

/// Tells apart the notices that have no framework (TCF or GPP) from the ones that do.
/// Consent from notices without a framework can also be reported as Global CMP.
extension DidomiUserStatus {
    /// GDPR notice without TCF or GPP.
    /// Read from what Didomi saved for the user: `IABTCF_gdprApplies` for TCF and `IABGPP_GppSID` for GPP.
    var isGDPROnly: Bool {
        guard DidomiUserStatus.regulationName(regulation) == Regulation.gdpr.description else {
            return false
        }
        let hasTCF = (UserDefaults.standard.object(forKey: "IABTCF_gdprApplies") as? Int) == 1
        return !hasTCF && DidomiUserStatus.gppSectionIds().isEmpty
    }

    /// US states notice without GPP (USNat section, id 7).
    var isUSOnly: Bool {
        let isUS = Didomi.shared.applicableRegulationConfiguration?.mixed ?? regulation.mixed
        return isUS && !DidomiUserStatus.gppSectionIds().contains("7")
    }

    static func regulationName(_ regulation: Regulation) -> String {
        Didomi.shared.applicableRegulationConfiguration?.regulationName.lowercased() ?? regulation.description
    }

    static func gppSectionIds() -> [String] {
        (UserDefaults.standard.string(forKey: "IABGPP_GppSID") ?? "").split(separator: "_").map(String.init)
    }
}
