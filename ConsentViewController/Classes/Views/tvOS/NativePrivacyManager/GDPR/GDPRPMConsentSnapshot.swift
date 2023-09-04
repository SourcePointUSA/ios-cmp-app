//
//  PMConsentSnapshot.swift
//  ConsentViewController-tvOS
//
//  Created by Andre Herculano on 13.07.21.
//

import Foundation

protocol ConsentSnapshot {
    func toPayload(language: SPMessageLanguage, pmId: String) -> JSONAble
}

class GDPRPMConsentSnaptshot: NSObject, ConsentSnapshot, PMVendorManager, PMCategoryManager {
    typealias VendorType = GDPRVendor
    typealias CategoryType = GDPRCategory

    var onConsentsChange: () -> Void = {}

    var grants: SPGDPRVendorGrants
    var vendors: Set<GDPRVendor>
    var legIntVendors: Set<String>
    var toggledVendorsIds: Set<String>
    var categories, specialPurposes, features, specialFeatures: Set<GDPRCategory>
    var toggledCategoriesIds: Set<String>
    var toggledLICategoriesIds: Set<String>

    var vendorsWhosePurposesAreOff: [String] {
        toggledVendorsIds
            .compactMap { id in vendors.first { $0.vendorId == id } }
            .filter { vendor in
                let vendorCategoriesIds = (grants[vendor.vendorId] ?? SPGDPRVendorGrant()).purposeGrants.keys
                return toggledCategoriesIds.isDisjoint(with: vendorCategoriesIds)
            }
            .map { $0.vendorId }
    }

    init(
        grants: SPGDPRVendorGrants,
        vendors: Set<GDPRVendor>,
        categories: Set<GDPRCategory>,
        specialPurposes: Set<GDPRCategory>,
        features: Set<GDPRCategory>,
        specialFeatures: Set<GDPRCategory>
    ) {
        self.grants = grants
        self.vendors = vendors
        self.categories = categories
        self.specialPurposes = specialPurposes
        self.features = features
        self.specialFeatures = specialFeatures
        let disclosureCategories = categories.filter { $0.disclosureOnly == true }
        if disclosureCategories.isNotEmpty() {
            for category in disclosureCategories {
                self.specialPurposes.insert(
                    GDPRCategory(name: category.name, description: category.description, disclosureOnly: true, legIntVendors: category.disclosureOnlyVendors)
                )
            }
        }
        toggledVendorsIds = Set<String>(
            grants.filter { $0.value.softGranted }.map { $0.key }
        )
        toggledCategoriesIds = Set<String>(
            grants.flatMap { vendors in vendors.value.purposeGrants.filter { $0.value }.keys }
        )
        legIntVendors = Set<String>([String()])
        toggledLICategoriesIds = Set<String>([String()])
    }

    convenience init(
        grants: SPGDPRVendorGrants,
        legIntCategories: [String]?,
        legIntVendors: [String]?,
        hasConsentData: Bool,
        vendors: Set<GDPRVendor>,
        categories: Set<GDPRCategory>,
        specialPurposes: Set<GDPRCategory>,
        features: Set<GDPRCategory>,
        specialFeatures: Set<GDPRCategory>
    ) {
        self.init(
            grants: grants,
            vendors: vendors,
            categories: categories,
            specialPurposes: specialPurposes,
            features: features,
            specialFeatures: specialFeatures
        )
        self.legIntVendors = Set<String>(legIntVendors ?? [String()])
        if hasConsentData {
            toggledLICategoriesIds = Set<String>(legIntCategories ?? [String()])
        } else {
            toggledLICategoriesIds = Set<String>(toggledCategoriesIds)
            toggledCategoriesIds = []
        }
    }

    override init() {
        grants = SPGDPRVendorGrants()
        legIntVendors = []
        toggledCategoriesIds = []
        toggledLICategoriesIds = []
        toggledVendorsIds = []
        vendors = []
        categories = []
        specialPurposes = []
        features = []
        specialFeatures = []
    }

    func toPayload(language: SPMessageLanguage, pmId: String) -> JSONAble {
        GDPRPMPayload(
            lan: language,
            privacyManagerId: pmId,
            categories: toggledCategoriesIds.compactMap { id in
                guard let category = categories.first(where: { c in c._id == id }) else { return nil }
                return GDPRPMPayload.Category(
                    _id: id,
                    iabId: category.iabId,
                    consent: toggledCategoriesIds.contains(id),
                    legInt: toggledLICategoriesIds.contains(id),
                    type: category.type
                )
            },
            vendors: toggledVendorsIds.compactMap { id in
                guard let vendor = vendors.first(where: { v in v.vendorId == id }) else { return nil }
                return GDPRPMPayload.Vendor(
                    _id: id,
                    iabId: vendor.iabId,
                    consent: toggledVendorsIds.contains(id),
                    legInt: legIntVendors.contains(id),
                    vendorType: vendor.vendorType
                )
            }
        )
    }

    func onCategoryOn(_ category: GDPRCategory) {}

    func onCategoryOff(_ category: GDPRCategory) {}

    func onCategoryOn(category: GDPRCategory, legInt: Bool) {
        if legInt {
            toggledLICategoriesIds.insert(category._id)
        } else {
            toggledCategoriesIds.insert(category._id)
        }
        toggledVendorsIds.formUnion(category.uniqueVendorIds)
        onConsentsChange()
    }

    func onCategoryOff(category: GDPRCategory, legInt: Bool) {
        if legInt {
            toggledLICategoriesIds.remove(category._id)
        } else {
            toggledCategoriesIds.remove(category._id)
        }
        toggledVendorsIds.subtract(vendorsWhosePurposesAreOff)
        onConsentsChange()
    }

    func onVendorOn(_ vendor: GDPRVendor) {
        toggledVendorsIds.insert(vendor.vendorId)
        onConsentsChange()
    }

    func onVendorOff(_ vendor: GDPRVendor) {
        toggledVendorsIds.remove(vendor.vendorId)
        onConsentsChange()
    }
}
