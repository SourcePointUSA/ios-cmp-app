//
//  CCPAConsentAdapter.swift
//  ConsentViewController
//
//  Created by Claude on 27/08/2026.
//

import Didomi
import Foundation

final class CCPAConsentAdapter: ConsentAdapter {
    private let vendorProvider: VendorProvider
    private let purposeProvider: PurposeProvider

    init(
        vendorProvider: VendorProvider = DidomiVendorProvider(),
        purposeProvider: PurposeProvider = DidomiPurposeProvider()
    ) {
        self.vendorProvider = vendorProvider
        self.purposeProvider = purposeProvider
    }

    func adapt(from status: CurrentUserStatus) -> SPCCPAConsent {
        let vendors = vendorProvider.getVendors()
        let purposes = purposeProvider.getPurposes()

        let vendorMap = vendors.keyedById()
        let purposeMap = purposes.keyedById()

        let rejectedVendors = status.vendors
            .filter { !$0.value.enabled }
            .compactMap { vendorMap[$0.key]?.namespaces?.sp }

        let rejectedCategories = status.purposes
            .filter { !$0.value.enabled }
            .compactMap { purposeMap[$0.key]?.namespaces?.sp }

        let consentStatus = ConsentStatusBuilder.buildCCPA(
            rejectedVendorsCount: rejectedVendors.count,
            rejectedCategoriesCount: rejectedCategories.count,
            totalVendorsCount: status.vendors.count,
            totalPurposesCount: status.purposes.count
        )

        let dateCreated = SPDate(string: status.created)

        return SPCCPAConsent(
            uuid: status.userID.isEmpty ? nil : status.userID,
            status: consentStatus,
            rejectedVendors: rejectedVendors,
            rejectedCategories: rejectedCategories,
            signedLspa: false,
            applies: true,
            dateCreated: dateCreated,
            expirationDate: SPDate.anYearFrom(dateCreated),
            GPPData: IABDataBuilder.buildGPPData()
        )
    }
}

// MARK: - Helper Extensions

private extension Array where Element == Vendor {
    func keyedById() -> [String: Vendor] {
        Dictionary(uniqueKeysWithValues: map { ($0.id, $0) })
    }
}

private extension Array where Element == Purpose {
    func keyedById() -> [String: Purpose] {
        Dictionary(uniqueKeysWithValues: map { ($0.id, $0) })
    }
}
