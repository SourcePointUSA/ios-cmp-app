//
//  CCPAPMConsentSnapshot.swift
//  ConsentViewController-tvOS
//
//  Created by Andre Herculano on 13.07.21.
//

import Foundation

class CCPAPMConsentSnaptshot: NSObject, ConsentSnapshot, PMVendorManager, PMCategoryManager {
    typealias VendorType = CCPAVendor
    typealias CategoryType = CCPACategory

    var onConsentsChange: () -> Void = {}

    var vendors: Set<VendorType>
    var categories: Set<CategoryType>
    var toggledVendorsIds: Set<String> = Set<String>()
    var toggledCategoriesIds: Set<String> = Set<String>()

    init(
        vendors: Set<VendorType>,
        categories: Set<CategoryType>,
        rejectedVendors: [String]?,
        rejectedCategories: [String]?
    ) {
        self.vendors = vendors
        self.categories = categories
        toggledVendorsIds = Set<String>(rejectedVendors ?? [])
        toggledCategoriesIds = Set<String>(rejectedCategories ?? [])
    }

    override init() {
        toggledCategoriesIds = []
        toggledVendorsIds = []
        vendors = []
        categories = []
    }

    func toPayload(language: SPMessageLanguage, pmId: String) -> JSONAble {
        CCPAPMPayload(
            lan: language,
            privacyManagerId: pmId,
            rejectedCategories: Array(toggledCategoriesIds),
            rejectedVendors: Array(toggledVendorsIds)
        )
    }

    func onCategoryOn(_ category: CCPACategory) {
        toggledCategoriesIds.remove(category._id)
        onConsentsChange()
    }

    func onCategoryOff(_ category: CCPACategory) {
        toggledCategoriesIds.insert(category._id)
        onConsentsChange()
    }

    func onVendorOn(_ vendor: CCPAVendor) {
        toggledVendorsIds.remove(vendor._id)
        onConsentsChange()
    }

    func onVendorOff(_ vendor: CCPAVendor) {
        toggledVendorsIds.insert(vendor._id)
        onConsentsChange()
    }
}
