//
//  DidomiUserStatusExt.swift
//  Pods
//
//  Created by Andre Herculano on 26/08/2026.
//

import Didomi
import Foundation

typealias DidomiUserStatus = CurrentUserStatus

extension DidomiUserStatus {
    /// With SP, developers get an object `SPUserData` with all legislation consents, regardless if they apply to the current geolocation or not.
    /// We might have to implement a way on DDM to get that for all legislations, not only the "current".
    func toSourcepoint() -> SPUserData {
        var gdpr: SPConsent<SPGDPRConsent>?
        var ccpa: SPConsent<SPCCPAConsent>?

        switch regulation {
            case .gdpr:
                gdpr = SPConsent(consents: buildGDPRConsent(), applies: true)
            case .cpra:
                ccpa = SPConsent(consents: buildCCPAConsent(), applies: true)
            default: break
        }

        // TODO: implement usnat / globalcmp mapping
        return SPUserData(gdpr: gdpr, ccpa: ccpa, usnat: nil, globalcmp: nil, preferences: nil)
    }

    private func buildGDPRConsent() -> SPGDPRConsent {
        let dateCreated = SPDate(string: created)

        let vendorMap = Dictionary(uniqueKeysWithValues: Didomi.shared.getRequiredVendors().map { ($0.id, $0) })
        let purposeMap = Dictionary(uniqueKeysWithValues: Didomi.shared.getRequiredPurposes().map { ($0.id, $0) })

        let vendorGrants = buildVendorGrants(
            vendors: vendors,
            purposes: purposes,
            vendorMap: vendorMap,
            purposeMap: purposeMap
        )

        let acceptedVendorsSP = buildAcceptedVendors(vendors: vendors, vendorMap: vendorMap)
        let acceptedLegIntVendorsSP = buildAcceptedLegIntVendors(vendors: vendors, vendorMap: vendorMap)

        let legIntPurposeIds = Set(vendorMap.values.flatMap { $0.legIntPurposeIDs })

        return SPGDPRConsent(
            uuid: userID.isEmpty ? nil : userID,
            vendorGrants: vendorGrants,
            euconsent: consentString,
            tcfData: buildTCFData(),
            dateCreated: dateCreated,
            expirationDate: SPDate.anYearFrom(dateCreated),
            applies: true,
            consentStatus: buildConsentStatus(
                vendors: vendors,
                purposes: purposes,
                acceptedVendorsSP: acceptedVendorsSP,
                acceptedLegIntVendorsSP: acceptedLegIntVendorsSP,
                vendorMap: vendorMap,
                purposeMap: purposeMap
            ),
            acceptedLegIntCategories: purposes
                .filter { $0.value.enabled && legIntPurposeIds.contains($0.key) }
                .compactMap { purposeMap[$0.key]?.namespaces?.sp },
            acceptedLegIntVendors: acceptedLegIntVendorsSP,
            acceptedVendors: acceptedVendorsSP,
            acceptedCategories: purposes
                .filter { $0.value.enabled }
                .compactMap { purposeMap[$0.key]?.namespaces?.sp },
            acceptedSpecialFeatures: []
        )
    }

    // builds VendorGrants based on Didomi's vendors and purposes and their namespaces.sp property
    private func buildVendorGrants(
        vendors: [String: VendorStatus],
        purposes: [String: PurposeStatus],
        vendorMap: [String: Vendor],
        purposeMap: [String: Purpose]
    ) -> SPGDPRVendorGrants {
        var vendorGrants: SPGDPRVendorGrants = [:]

        for (didomiVendorId, vendorStatus) in vendors {
            guard let vendor = vendorMap[didomiVendorId],
                  let spVendorId = vendor.namespaces?.sp else { continue }

            // Build purpose grants for this vendor
            let allPurposeIds = Array(vendor.purposeIDs) + Array(vendor.legIntPurposeIDs)
            let purposeGrants: SPGDPRPurposeGrants = Dictionary(
                uniqueKeysWithValues: allPurposeIds.compactMap { purposeId -> (String, Bool)? in
                    guard let purpose = purposeMap[purposeId],
                          let spPurposeId = purpose.namespaces?.sp,
                          let purposeStatus = purposes[purposeId] else { return nil }
                    return (spPurposeId, purposeStatus.enabled)
                }
            )

            vendorGrants[spVendorId] = SPGDPRVendorGrant(granted: vendorStatus.enabled, purposeGrants: purposeGrants)
        }

        return vendorGrants
    }

    private func buildAcceptedVendors(
        vendors: [String: VendorStatus],
        vendorMap: [String: Vendor]
    ) -> [String] {
        return vendors.compactMap { didomiVendorId, vendorStatus in
            guard vendorStatus.enabled,
                  let vendor = vendorMap[didomiVendorId],
                  !vendor.purposeIDs.isEmpty,
                  let spVendorId = vendor.namespaces?.sp else { return nil }
            return spVendorId
        }
    }

    private func buildAcceptedLegIntVendors(
        vendors: [String: VendorStatus],
        vendorMap: [String: Vendor]
    ) -> [String] {
        return vendors.compactMap { didomiVendorId, vendorStatus in
            guard vendorStatus.enabled,
                  let vendor = vendorMap[didomiVendorId],
                  !vendor.legIntPurposeIDs.isEmpty,
                  let spVendorId = vendor.namespaces?.sp else { return nil }
            return spVendorId
        }
    }

    private func buildConsentStatus(
        vendors: [String: VendorStatus],
        purposes: [String: PurposeStatus],
        acceptedVendorsSP: [String],
        acceptedLegIntVendorsSP: [String],
        vendorMap: [String: Vendor],
        purposeMap: [String: Purpose]
    ) -> ConsentStatus {
        let totalVendorsCount = vendors.count
        let totalPurposesCount = purposes.count

        let enabledVendorsCount = vendors.values.filter { $0.enabled }.count
        let enabledPurposesCount = purposes.values.filter { $0.enabled }.count

        let consentedAll = (totalVendorsCount > 0 && enabledVendorsCount == totalVendorsCount) &&
                          (totalPurposesCount > 0 && enabledPurposesCount == totalPurposesCount)
        let rejectedAll = (totalVendorsCount > 0 && enabledVendorsCount == 0) &&
                         (totalPurposesCount > 0 && enabledPurposesCount == 0)
        let consentedToAny = enabledVendorsCount > 0 || enabledPurposesCount > 0
        let rejectedAny = enabledVendorsCount < totalVendorsCount || enabledPurposesCount < totalPurposesCount

        // Check if any legitimate interest vendor/purpose was rejected
        let totalLegIntVendorsCount = vendorMap.values.filter { !$0.legIntPurposeIDs.isEmpty }.count
        let rejectedLI = acceptedLegIntVendorsSP.count < totalLegIntVendorsCount

        // Build rejected lists (SP IDs)
        let rejectedVendorsSP = vendors
            .filter { !$0.value.enabled }
            .compactMap { vendorMap[$0.key]?.namespaces?.sp }

        let rejectedCategoriesSP = purposes
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
            hasConsentData: !vendors.isEmpty || !purposes.isEmpty,
            rejectedVendors: rejectedVendorsSP,
            rejectedCategories: rejectedCategoriesSP
        )
    }

    private func buildTCFData() -> SPJson {
        return buildIABData(prefix: "IABTCF_")
    }

    private func buildGPPData() -> SPJson {
        return buildIABData(prefix: "IABGPP_")
    }

    /// get all values with keys prefixed by `prefix` and return a `SPJson` from it
    private func buildIABData(prefix: String) -> SPJson {
        return .object(
            Dictionary(
                uniqueKeysWithValues: UserDefaults.standard.dictionaryRepresentation()
                    .filter { $0.key.hasPrefix(prefix) }
                    .compactMap { key, value -> (SPJson.Key, SPJson)? in
                        guard let json = try? SPJson(value) else { return nil }
                        return (SPJson.Key(key), json)
                    }
                )
            )
    }

    private func buildCCPAConsent() -> SPCCPAConsent {
        let dateCreated = SPDate(string: created)

        // Get all vendors and purposes upfront
        let allVendors = Didomi.shared.getRequiredVendors()
        let allPurposes = Didomi.shared.getRequiredPurposes()

        // Build lookup maps by Didomi ID
        let vendorMap = Dictionary(uniqueKeysWithValues: allVendors.map { ($0.id, $0) })
        let purposeMap = Dictionary(uniqueKeysWithValues: allPurposes.map { ($0.id, $0) })

        let rejectedVendorsSP = vendors
            .filter { !$0.value.enabled }
            .compactMap { vendorMap[$0.key]?.namespaces?.sp }

        let rejectedCategoriesSP = purposes
            .filter { !$0.value.enabled }
            .compactMap { purposeMap[$0.key]?.namespaces?.sp }

        let status: CCPAConsentStatus = if rejectedVendorsSP.isEmpty && rejectedCategoriesSP.isEmpty {
            .RejectedNone
        } else if rejectedVendorsSP.count == vendors.count && rejectedCategoriesSP.count == purposes.count {
            .RejectedAll
        } else {
            .RejectedSome
        }

        return SPCCPAConsent(
            uuid: userID.isEmpty ? nil : userID,
            status: status,
            rejectedVendors: rejectedVendorsSP,
            rejectedCategories: rejectedCategoriesSP,
            signedLspa: false,
            applies: true,
            dateCreated: dateCreated,
            expirationDate: SPDate.anYearFrom(dateCreated),
            GPPData: buildGPPData()
        )
    }
}
