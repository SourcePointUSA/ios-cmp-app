//
//  CCPAPMConsentSnapshot.swift
//  ConsentViewController-tvOS
//
//  Created by Andre Herculano on 13.07.21.
//

import Foundation

class CCPAPMConsentSnaptshot: NSObject, PMVendorManager, PMCategoryManager {
    var specialPurposes: Set<CCPACategory> = Set<CCPACategory>()
    var features: Set<CCPACategory> = Set<CCPACategory>()
    var specialFeatures: Set<CCPACategory> = Set<CCPACategory>()

    typealias VendorType = CCPAVendor
    typealias CategoryType = CCPACategory

    var onConsentsChange: () -> Void = {}

    var vendors: Set<VendorType>
    var acceptedVendorsIds: Set<String> = Set<String>()
    var categories: Set<CategoryType>
    var acceptedCategoriesIds: Set<String> = Set<String>()

    init(
        vendors: Set<VendorType>,
        categories: Set<CategoryType>
    ) {
        self.vendors = vendors
        self.categories = categories
    }

    override init() {
        acceptedCategoriesIds = []
        acceptedVendorsIds = []
        vendors = []
        categories = []
    }

    func toPayload(language: SPMessageLanguage, pmId: String) -> PMPayload {
        PMPayload(
            lan: language,
            privacyManagerId: pmId,
            categories: acceptedCategoriesIds.compactMap { id in
                return PMPayload.Category(
                    _id: id,
                    iabId: 0,
                    consent: true,
                    legInt: false,
                    type: .none
                )
            },
            vendors: acceptedVendorsIds.compactMap { id in
                return PMPayload.Vendor(
                    _id: id,
                    iabId: 0,
                    consent: true,
                    legInt: false,
                    vendorType: .none
                )
            }
        )
    }

    func onCategoryOn(_ category: CCPACategory) {
//        acceptedCategoriesIds.insert(category._id)
        onConsentsChange()
    }

    func onCategoryOff(_ category: CCPACategory) {
//        acceptedCategoriesIds.remove(category._id)
        onConsentsChange()
    }

    func onVendorOn(_ vendor: CCPAVendor) {
//        acceptedVendorsIds.insert(vendor.vendorId)
        onConsentsChange()
    }

    func onVendorOff(_ vendor: CCPAVendor) {
//        acceptedVendorsIds.remove(vendor.vendorId)
        onConsentsChange()
    }
}
