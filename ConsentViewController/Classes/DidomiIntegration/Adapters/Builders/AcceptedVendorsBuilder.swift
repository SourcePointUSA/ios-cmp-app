//
//  AcceptedVendorsBuilder.swift
//  ConsentViewController
//
//  Created by Claude on 27/08/2026.
//

import Didomi
import Foundation

enum AcceptedVendorsBuilder {
    static func buildAcceptedVendors(
        from vendors: [String: CurrentUserStatus.VendorStatus],
        vendorMap: [String: Vendor]
    ) -> [String] {
        build(from: vendors, vendorMap: vendorMap) { !$0.purposeIDs.isEmpty }
    }

    static func buildAcceptedLegIntVendors(
        from vendors: [String: CurrentUserStatus.VendorStatus],
        vendorMap: [String: Vendor]
    ) -> [String] {
        build(from: vendors, vendorMap: vendorMap) { !$0.legIntPurposeIDs.isEmpty }
    }

    private static func build(
        from vendors: [String: CurrentUserStatus.VendorStatus],
        vendorMap: [String: Vendor],
        filteringBy predicate: (Vendor) -> Bool
    ) -> [String] {
        vendors.compactMap { didomiVendorId, vendorStatus in
            guard vendorStatus.enabled,
                  let vendor = vendorMap[didomiVendorId],
                  predicate(vendor),
                  let spVendorId = vendor.namespaces?.sp else { return nil }
            return spVendorId
        }
    }
}
