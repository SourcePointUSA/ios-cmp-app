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
    var consentStatus: CCPAConsentStatus = .RejectedNone

    init(
        vendors: Set<VendorType>,
        categories: Set<CategoryType>,
        rejectedVendors: [String]?,
        rejectedCategories: [String]?,
        consentStatus: CCPAConsentStatus?
    ) {
        self.vendors = vendors
        self.categories = categories
        toggledVendorsIds = Set<String>(rejectedVendors ?? [])
        toggledCategoriesIds = Set<String>(rejectedCategories ?? [])
        self.consentStatus = consentStatus ?? .RejectedNone
    }

    override init() {
        toggledCategoriesIds = []
        toggledVendorsIds = []
        vendors = []
        categories = []
        consentStatus = .RejectedNone
    }

    convenience init(withStatus status: CCPAConsentStatus?) {
        self.init()
        consentStatus = status ?? .RejectedNone
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
        updateConsentStatus()
        onConsentsChange()
    }

    func onCategoryOff(_ category: CCPACategory) {
        toggledCategoriesIds.insert(category._id)
        updateConsentStatus()
        onConsentsChange()
    }

    func onVendorOn(_ vendor: CCPAVendor) {
        toggledVendorsIds.remove(vendor._id)
        updateConsentStatus()
        onConsentsChange()
    }

    func onVendorOff(_ vendor: CCPAVendor) {
        toggledVendorsIds.insert(vendor._id)
        updateConsentStatus()
        onConsentsChange()
    }

    func updateConsentStatus() {
        if toggledVendorsIds.isEmpty && toggledCategoriesIds.isEmpty {
            consentStatus = .RejectedNone
        } else {
            consentStatus = .RejectedSome
        }
    }

    func onDoNotSellToggle() {
        consentStatus = (consentStatus == .ConsentedAll || consentStatus == .RejectedNone || consentStatus == .RejectedSome) ?
            .RejectedAll :
            .ConsentedAll
        onConsentsChange()
    }
}
