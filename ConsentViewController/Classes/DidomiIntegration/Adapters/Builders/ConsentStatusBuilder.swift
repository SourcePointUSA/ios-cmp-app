//
//  ConsentStatusBuilder.swift
//  ConsentViewController
//
//  Created by Claude on 27/08/2026.
//

import Didomi
import Foundation

enum ConsentStatusBuilder {
    static func buildGDPR(
        from status: CurrentUserStatus,
        vendorMap: [String: Vendor],
        purposeMap: [String: Purpose],
        acceptedLegIntVendors: [String]
    ) -> ConsentStatus {
        let totalVendorsCount = status.vendors.count
        let totalPurposesCount = status.purposes.count

        let enabledVendorsCount = status.vendors.values.filter { $0.enabled }.count
        let enabledPurposesCount = status.purposes.values.filter { $0.enabled }.count

        let consentedAll = (totalVendorsCount > 0 && enabledVendorsCount == totalVendorsCount) &&
                          (totalPurposesCount > 0 && enabledPurposesCount == totalPurposesCount)
        let rejectedAll = (totalVendorsCount > 0 && enabledVendorsCount == 0) &&
                         (totalPurposesCount > 0 && enabledPurposesCount == 0)
        let consentedToAny = enabledVendorsCount > 0 || enabledPurposesCount > 0
        let rejectedAny = enabledVendorsCount < totalVendorsCount || enabledPurposesCount < totalPurposesCount

        let totalLegIntVendorsCount = vendorMap.values.filter { !$0.legIntPurposeIDs.isEmpty }.count
        let rejectedLI = acceptedLegIntVendors.count < totalLegIntVendorsCount

        let rejectedVendors = status.vendors
            .filter { !$0.value.enabled }
            .compactMap { vendorMap[$0.key]?.namespaces?.sp }

        let rejectedCategories = status.purposes
            .filter { !$0.value.enabled }
            .compactMap { purposeMap[$0.key]?.namespaces?.sp }

        return ConsentStatus(
            rejectedAny: rejectedAny,
            rejectedLI: rejectedLI,
            consentedAll: consentedAll,
            consentedToAll: consentedAll,
            consentedToAny: consentedToAny,
            rejectedAll: rejectedAll,
            vendorListAdditions: nil,
            legalBasisChanges: nil,
            hasConsentData: !status.vendors.isEmpty || !status.purposes.isEmpty,
            rejectedVendors: rejectedVendors,
            rejectedCategories: rejectedCategories
        )
    }

    static func buildCCPA(
        rejectedVendorsCount: Int,
        rejectedCategoriesCount: Int,
        totalVendorsCount: Int,
        totalPurposesCount: Int
    ) -> CCPAConsentStatus {
        if rejectedVendorsCount == 0 && rejectedCategoriesCount == 0 {
            return .RejectedNone
        } else if rejectedVendorsCount == totalVendorsCount && rejectedCategoriesCount == totalPurposesCount {
            return .RejectedAll
        } else {
            return .RejectedSome
        }
    }
}
