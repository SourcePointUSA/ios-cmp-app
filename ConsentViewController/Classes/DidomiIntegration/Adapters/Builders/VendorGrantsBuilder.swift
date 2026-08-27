//
//  VendorGrantsBuilder.swift
//  ConsentViewController
//
//  Created by Claude on 27/08/2026.
//

import Didomi
import Foundation

enum VendorGrantsBuilder {
    static func build(
        from vendors: [String: CurrentUserStatus.VendorStatus],
        purposes: [String: CurrentUserStatus.PurposeStatus],
        vendorMap: [String: Vendor],
        purposeMap: [String: Purpose]
    ) -> SPGDPRVendorGrants {
        vendors.reduce(into: [:]) { result, entry in
            let (didomiVendorId, vendorStatus) = entry

            guard let vendor = vendorMap[didomiVendorId],
                  let spVendorId = vendor.namespaces?.sp else { return }

            let purposeGrants = buildPurposeGrants(
                for: vendor,
                purposes: purposes,
                purposeMap: purposeMap
            )

            result[spVendorId] = SPGDPRVendorGrant(
                granted: vendorStatus.enabled,
                purposeGrants: purposeGrants
            )
        }
    }

    private static func buildPurposeGrants(
        for vendor: Vendor,
        purposes: [String: CurrentUserStatus.PurposeStatus],
        purposeMap: [String: Purpose]
    ) -> SPGDPRPurposeGrants {
        let allPurposeIds = Array(vendor.purposeIDs) + Array(vendor.legIntPurposeIDs)

        return allPurposeIds
            .compactMap { purposeId -> (String, Bool)? in
                guard let purpose = purposeMap[purposeId],
                      let spPurposeId = purpose.namespaces?.sp,
                      let purposeStatus = purposes[purposeId] else { return nil }
                return (spPurposeId, purposeStatus.enabled)
            }
            .reduce(into: [:]) { $0[$1.0] = $1.1 }
    }
}
