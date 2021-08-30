//
//  PrivacyManagerViewData.swift
//  ConsentViewController-tvOS
//
//  Created by Andre Herculano on 28.05.21.
//

import Foundation

private func findViewBy(id: String, _ pmResponse: SPPrivacyManagerResponse) throws -> SPNativeView {
    guard let view = pmResponse.message.byId(id) as? SPNativeView else {
        throw UnableToFindView(withId: id)
    }
    return view
}

struct PrivacyManagerViewData {
    let categories: [GDPRCategory]
    let homeView, categoriesView, vendorsView, categoryDetailsView, vendorDetailsView: SPNativeView
    let privacyPolicyView: SPNativeView?
}

extension PrivacyManagerViewData {
    init(from pmResponse: SPPrivacyManagerResponse) throws {
        homeView = try findViewBy(id: "HomeView", pmResponse)
        categoriesView = try findViewBy(id: "CategoriesView", pmResponse)
        vendorsView = try findViewBy(id: "VendorsView", pmResponse)
        categoryDetailsView = try findViewBy(id: "CategoryDetailsView", pmResponse)
        vendorDetailsView = try findViewBy(id: "VendorDetailsView", pmResponse)
        privacyPolicyView = pmResponse.message.byId("PrivacyPolicyView") as? SPNativeView
        categories = pmResponse.categories
    }
}

extension PrivacyManagerViewData: Equatable, Decodable {
    static func == (lhs: PrivacyManagerViewData, rhs: PrivacyManagerViewData) -> Bool {
        lhs.categories == rhs.categories &&
            lhs.homeView == rhs.homeView &&
            lhs.categoriesView == rhs.categoriesView &&
            lhs.vendorsView == rhs.vendorsView &&
            lhs.categoryDetailsView == rhs.categoryDetailsView &&
            lhs.vendorDetailsView == rhs.vendorDetailsView &&
            lhs.privacyPolicyView == rhs.privacyPolicyView
    }
}
