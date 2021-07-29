//
//  CCPAPMConsentSnapshot.swift
//  ConsentViewController-tvOS
//
//  Created by Andre Herculano on 13.07.21.
//

import Foundation

class CCPAPMConsentSnaptshot: NSObject, PMVendorManager, PMCategoryManager {
    typealias VendorType = VendorListVendor
    typealias CategoryType = VendorListCategory

    var onConsentsChange: () -> Void = {}

    var grants: SPGDPRVendorGrants
    var vendors: Set<VendorListVendor>
    var acceptedVendorsIds: Set<String>
    var categories, specialPurposes, features, specialFeatures: Set<VendorListCategory>
    var acceptedCategoriesIds: Set<String>

    var vendorsWhosePurposesAreOff: [String] {
        acceptedVendorsIds
            .compactMap { id in vendors.first { $0.vendorId == id } }
            .filter { vendor in
                let vendorCategoriesIds = (grants[vendor.vendorId] ?? SPGDPRVendorGrant()).purposeGrants.keys
                return acceptedCategoriesIds.isDisjoint(with: vendorCategoriesIds)
            }
            .map { $0.vendorId }
    }

    init(
        grants: SPGDPRVendorGrants,
        vendors: Set<VendorListVendor>,
        categories: Set<VendorListCategory>,
        specialPurposes: Set<VendorListCategory>,
        features: Set<VendorListCategory>,
        specialFeatures: Set<VendorListCategory>
    ) {
        self.grants = grants
        self.vendors = vendors
        self.categories = categories
        self.specialPurposes = specialPurposes
        self.features = features
        self.specialFeatures = specialFeatures
        acceptedVendorsIds = Set<String>(
            grants.filter { $0.value.softGranted }.map { $0.key }
        )
        acceptedCategoriesIds = Set<String>(
            grants.flatMap { vendors in vendors.value.purposeGrants.filter { $0.value }.keys }
        )
    }

    override init() {
        grants = SPGDPRVendorGrants()
        acceptedCategoriesIds = []
        acceptedVendorsIds = []
        vendors = []
        categories = []
        specialPurposes = []
        features = []
        specialFeatures = []
    }

    func toPayload(language: SPMessageLanguage, pmId: String) -> PMPayload {
        PMPayload(
            lan: language,
            privacyManagerId: pmId,
            categories: acceptedCategoriesIds.compactMap { id in
                guard let category = categories.first(where: { c in c._id == id }) else { return nil }
                return PMPayload.Category(
                    _id: id,
                    iabId: category.iabId,
                    consent: true,
                    legInt: false,
                    type: category.type
                )
            },
            vendors: acceptedVendorsIds.compactMap { id in
                guard let vendor = vendors.first(where: { v in v.vendorId == id }) else { return nil }
                return PMPayload.Vendor(
                    _id: id,
                    iabId: vendor.iabId,
                    consent: true,
                    legInt: false,
                    vendorType: vendor.vendorType
                )
            }
        )
    }

    func onCategoryOn(_ category: VendorListCategory) {
        acceptedCategoriesIds.insert(category._id)
        acceptedVendorsIds.formUnion(category.uniqueVendorIds)
        onConsentsChange()
    }

    func onCategoryOff(_ category: VendorListCategory) {
        acceptedCategoriesIds.remove(category._id)
        acceptedVendorsIds.subtract(vendorsWhosePurposesAreOff)
        onConsentsChange()
    }

    func onVendorOn(_ vendor: VendorListVendor) {
        acceptedVendorsIds.insert(vendor.vendorId)
        onConsentsChange()
    }

    func onVendorOff(_ vendor: VendorListVendor) {
        acceptedVendorsIds.remove(vendor.vendorId)
        onConsentsChange()
    }
}
