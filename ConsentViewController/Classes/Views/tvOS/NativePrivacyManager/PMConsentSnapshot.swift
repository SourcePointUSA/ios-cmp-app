//
//  PMConsentSnapshot.swift
//  ConsentViewController-tvOS
//
//  Created by Andre Herculano on 13.07.21.
//

import Foundation

protocol PMCategoryManager: AnyObject {
    var onConsentsChange: () -> Void { get set }
    var categories: Set<VendorListCategory> { get }
    var specialPurposes: Set<VendorListCategory> { get }
    var features: Set<VendorListCategory> { get }
    var specialFeatures: Set<VendorListCategory> { get }
    var acceptedCategoriesIds: Set<String> { get set }

    func onCategoryOn(_ category: VendorListCategory)
    func onCategoryOff(_ category: VendorListCategory)
}

protocol PMVendorManager: AnyObject {
    var onConsentsChange: () -> Void { get set }
    var vendors: Set<VendorListVendor> { get }
    var acceptedVendorsIds: Set<String> { get set }

    func onVendorOn(_ vendor: VendorListVendor)
    func onVendorOff(_ vendor: VendorListVendor)
}

struct PMPayload: Codable {
    struct Category: Codable {
        let _id: String
        let iabId: Int?
        let consent, legInt: Bool
        let type: SPCategoryType?
    }
    struct Vendor: Codable {
        let _id: String
        let iabId: Int?
        let consent, legInt: Bool
        let vendorType: SPVendorType?
    }
    struct Feature: Codable {
        let _id: String
        let iabId: Int?
    }
    let lan: SPMessageLanguage
    let privacyManagerId: String
    let categories: [Category]
    let vendors: [Vendor]
    var specialFeatures: [Feature] = []

    func json() -> SPJson? {
        guard
            let data = try? JSONEncoder().encode(self),
            let object = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
            let json = try? SPJson(object) else {
            return nil
        }
        return json
    }
}

class PMConsentSnaptshot: NSObject, PMVendorManager, PMCategoryManager {
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
