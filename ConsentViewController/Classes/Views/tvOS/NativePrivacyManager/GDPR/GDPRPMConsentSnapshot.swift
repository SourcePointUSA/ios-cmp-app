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

public enum CategoryContentType {
    case consent
    case legitimate
    case specialFeatures
}

class GDPRPMConsentSnaptshot: NSObject, ConsentSnapshot, PMVendorManager, PMCategoryManager {
    typealias VendorType = GDPRVendor
    typealias CategoryType = GDPRCategory

    var onConsentsChange: () -> Void = {}

    var grants: SPGDPRVendorGrants
    var vendors: Set<GDPRVendor>
    var toggledVendorsIds: Set<String>
    var toggledConsentVendorsIds: Set<String>
    var toggledLIVendorsIds: Set<String>
    var categories, specialPurposes, features, specialFeatures: Set<GDPRCategory>
    var toggledCategoriesIds: Set<String>
    var toggledConsentCategoriesIds: Set<String>
    var toggledLICategoriesIds: Set<String>
    var toggledSpecialFeatures: Set<String>

    var consentVendorsWhosePurposesAreOff: [String] {
        toggledConsentVendorsIds
            .compactMap { id in vendors.first { $0.vendorId == id } }
            .filter { vendor in
                let vendorCategoriesIds = (grants[vendor.vendorId] ?? SPGDPRVendorGrant()).purposeGrants.keys
                return toggledConsentCategoriesIds.isDisjoint(with: vendorCategoriesIds)
            }
            .map { $0.vendorId }
    }
    var liVendorsWhosePurposesAreOff: [String] {
        toggledLIVendorsIds
            .compactMap { id in vendors.first { $0.vendorId == id } }
            .filter { vendor in
                let vendorCategoriesIds = (grants[vendor.vendorId] ?? SPGDPRVendorGrant()).purposeGrants.keys
                return toggledLICategoriesIds.isDisjoint(with: vendorCategoriesIds)
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
                    GDPRCategory(name: category.name, description: category.description, disclosureOnly: true, disclosureOnlyVendors: category.disclosureOnlyVendors)
                )
            }
        }
        toggledVendorsIds = Set<String>(
            grants.filter { $0.value.softGranted }.map { $0.key }
        )
        toggledCategoriesIds = Set<String>(
            grants.flatMap { vendors in vendors.value.purposeGrants.filter { $0.value }.keys }
        )
        toggledConsentVendorsIds = Set<String>([])
        toggledLIVendorsIds = Set<String>([])
        toggledConsentCategoriesIds = Set<String>([])
        toggledLICategoriesIds = Set<String>([])
        toggledSpecialFeatures = Set<String>([])
    }

    convenience init(
        grants: SPGDPRVendorGrants,
        legIntCategories: [String]?,
        legIntVendors: [String]?,
        acceptedVendors: [String]?,
        acceptedCategories: [String]?,
        acceptedSpecialFeatures: [String]?,
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
        toggledVendorsIds.formUnion(acceptedVendors ?? [])
        toggledCategoriesIds.formUnion(acceptedCategories ?? [])
        toggledSpecialFeatures.formUnion(acceptedSpecialFeatures ?? [])
        if hasConsentData {
            toggledConsentVendorsIds = Set<String>(acceptedVendors ?? [])
            toggledLIVendorsIds = Set<String>(legIntVendors ?? [])
            toggledConsentCategoriesIds = Set<String>(acceptedCategories ?? [])
            toggledLICategoriesIds = Set<String>(legIntCategories ?? [])
        } else {
            toggledLIVendorsIds = toggledVendorsIds
            toggledConsentVendorsIds = []
            toggledLICategoriesIds = Set<String>(toggledCategoriesIds)
            toggledConsentCategoriesIds = []
        }
    }

    override init() {
        grants = SPGDPRVendorGrants()
        toggledVendorsIds = []
        toggledConsentVendorsIds = []
        toggledLIVendorsIds = []
        toggledCategoriesIds = []
        toggledConsentCategoriesIds = []
        toggledLICategoriesIds = []
        toggledSpecialFeatures = []
        vendors = []
        categories = []
        specialPurposes = []
        features = []
        specialFeatures = []
    }

    func toPayload(language: SPMessageLanguage, pmId: String) -> JSONAble {
        return GDPRPMPayload(
            lan: language,
            privacyManagerId: pmId,
            categories: toggledCategoriesIds.compactMap { id in
                guard let category = categories.first(where: { $0._id == id }) else { return nil }
                return GDPRPMPayload.Category(
                    _id: id,
                    iabId: category.iabId,
                    consent: toggledConsentCategoriesIds.contains(id),
                    legInt: toggledLICategoriesIds.contains(id),
                    type: category.type
                )
            },
            vendors: toggledVendorsIds.compactMap { id in
                guard let vendor = vendors.first(where: { $0.vendorId == id }) else { return nil }
                return GDPRPMPayload.Vendor(
                    _id: id,
                    iabId: vendor.iabId,
                    consent: toggledConsentVendorsIds.contains(id),
                    legInt: toggledLIVendorsIds.contains(id),
                    vendorType: vendor.vendorType
                )
            },
            specialFeatures: toggledSpecialFeatures.compactMap { id in
                guard let feature = specialFeatures.first(where: { $0._id == id }) else { return nil }
                return GDPRPMPayload.Feature(
                    _id: id,
                    iabId: feature.iabId
                )
            }
        )
    }

    func onCategoryOn(_ category: GDPRCategory) {}

    func onCategoryOff(_ category: GDPRCategory) {}

    func onVendorOn(_ vendor: GDPRVendor) {}

    func onVendorOff(_ vendor: GDPRVendor) {}

    func onCategoryOn(category: GDPRCategory, type: CategoryContentType?) {
        switch type {
        case .consent:
            toggledConsentCategoriesIds.insert(category._id)
            toggledConsentVendorsIds.formUnion(category.uniqueConsentVendorIds)

        case .legitimate:
            toggledLICategoriesIds.insert(category._id)
            toggledLIVendorsIds.formUnion(category.uniqueLIVendorIds)

        case .specialFeatures:
            toggledSpecialFeatures.insert(category._id)

        case .none:
            break
        }
        if type != .specialFeatures {
            toggledCategoriesIds.insert(category._id)
            toggledVendorsIds.formUnion(category.uniqueVendorIds)
        }
        onConsentsChange()
    }

    func onCategoryOff(category: GDPRCategory, type: CategoryContentType?) {
        switch type {
        case .consent:
            toggledConsentCategoriesIds.remove(category._id)
            toggledConsentVendorsIds.subtract(consentVendorsWhosePurposesAreOff)

        case .legitimate:
            toggledLICategoriesIds.remove(category._id)
            toggledLIVendorsIds.subtract(liVendorsWhosePurposesAreOff)

        case .specialFeatures:
            toggledSpecialFeatures.remove(category._id)

        case .none:
            break
        }
        onConsentsChange()
    }

    func onVendorOn(vendor: GDPRVendor, legInt: Bool) {
        if legInt {
            toggledLIVendorsIds.insert(vendor.vendorId)
        } else {
            toggledConsentVendorsIds.insert(vendor.vendorId)
        }
        toggledVendorsIds.insert(vendor.vendorId)
        onConsentsChange()
    }

    func onVendorOff(vendor: GDPRVendor, legInt: Bool) {
        if legInt {
            toggledLIVendorsIds.remove(vendor.vendorId)
        } else {
            toggledConsentVendorsIds.remove(vendor.vendorId)
        }
        onConsentsChange()
    }
}
