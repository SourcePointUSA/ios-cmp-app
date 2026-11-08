//
//  GDPRConsentAdapter.swift
//  ConsentViewController
//
//  Created by Claude on 27/08/2026.
//

import Didomi
import Foundation

final class GDPRConsentAdapter: ConsentAdapter {
    private let vendorProvider: VendorProvider
    private let purposeProvider: PurposeProvider

    init(
        vendorProvider: VendorProvider = DidomiVendorProvider(),
        purposeProvider: PurposeProvider = DidomiPurposeProvider()
    ) {
        self.vendorProvider = vendorProvider
        self.purposeProvider = purposeProvider
    }

    func adapt(from status: CurrentUserStatus) -> SPGDPRConsent {
        let vendors = vendorProvider.getVendors()
        let purposes = purposeProvider.getPurposes()

        let vendorMap = vendors.keyedById()
        let purposeMap = purposes.keyedById()

        let vendorGrants = VendorGrantsBuilder.build(
            from: status.vendors,
            purposes: status.purposes,
            vendorMap: vendorMap,
            purposeMap: purposeMap
        )

        let legIntPurposeIds = Set(vendors.flatMap { $0.legIntPurposeIDs })

        let acceptedVendors = AcceptedVendorsBuilder.buildAcceptedVendors(
            from: status.vendors,
            vendorMap: vendorMap
        )

        let acceptedLegIntVendors = AcceptedVendorsBuilder.buildAcceptedLegIntVendors(
            from: status.vendors,
            vendorMap: vendorMap
        )

        let acceptedCategories = AcceptedCategoriesBuilder.buildAcceptedCategories(
            from: status.purposes,
            purposeMap: purposeMap
        )

        let acceptedLegIntCategories = AcceptedCategoriesBuilder.buildAcceptedLegIntCategories(
            from: status.purposes,
            purposeMap: purposeMap,
            legIntPurposeIds: legIntPurposeIds
        )

        let dateCreated = SPDate(string: status.created)

        return SPGDPRConsent(
            uuid: status.userID.isEmpty ? nil : status.userID,
            vendorGrants: vendorGrants,
            euconsent: status.consentString,
            tcfData: IABDataBuilder.buildTCFData(),
            dateCreated: dateCreated,
            expirationDate: SPDate.anYearFrom(dateCreated),
            applies: true,
            consentStatus: ConsentStatusBuilder.buildGDPR(
                from: status,
                vendorMap: vendorMap,
                purposeMap: purposeMap,
                acceptedLegIntVendors: acceptedLegIntVendors
            ),
            acceptedLegIntCategories: acceptedLegIntCategories,
            acceptedLegIntVendors: acceptedLegIntVendors,
            acceptedVendors: acceptedVendors,
            acceptedCategories: acceptedCategories
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
