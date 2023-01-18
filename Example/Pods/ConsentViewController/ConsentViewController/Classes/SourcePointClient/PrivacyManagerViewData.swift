//
//  PrivacyManagerViewData.swift
//  ConsentViewController-tvOS
//
//  Created by Andre Herculano on 28.05.21.
//

import Foundation

private func findViewBy(id: String, _ rootView: SPNativeView) throws -> SPNativeView {
    guard let view = rootView.byId(id) as? SPNativeView else {
        throw UnableToFindView(withId: id)
    }
    return view
}

struct PrivacyManagerViewData {
    let homeView, categoriesView, vendorsView, categoryDetailsView, vendorDetailsView: SPNativeView
    let privacyPolicyView: SPNativeView?
}

extension PrivacyManagerViewData {
    init(from rootView: SPNativeView) throws {
        homeView = try findViewBy(id: "HomeView", rootView)
        categoriesView = try findViewBy(id: "CategoriesView", rootView)
        vendorsView = try findViewBy(id: "VendorsView", rootView)
        categoryDetailsView = try findViewBy(id: "CategoryDetailsView", rootView)
        vendorDetailsView = try findViewBy(id: "VendorDetailsView", rootView)
        privacyPolicyView = rootView.byId("PrivacyPolicyView") as? SPNativeView
    }
}

extension PrivacyManagerViewData: Equatable, Decodable {
    static func == (lhs: PrivacyManagerViewData, rhs: PrivacyManagerViewData) -> Bool {
        lhs.homeView == rhs.homeView &&
            lhs.categoriesView == rhs.categoriesView &&
            lhs.vendorsView == rhs.vendorsView &&
            lhs.categoryDetailsView == rhs.categoryDetailsView &&
            lhs.vendorDetailsView == rhs.vendorDetailsView &&
            lhs.privacyPolicyView == rhs.privacyPolicyView
    }
}
