//
//  PrivacyManagerRequestresponse.swift
//  Pods
//
//  Created by Vilas on 15/04/21.
//

import Foundation

@objc public class SPPrivacyManagerResponse: NSObject, Decodable {
    let homeView: SPPrivacyManager
    let categoriesView: SPPrivacyManager
    let categoryDetails: SPPrivacyManager
    let vendorsView: SPPrivacyManager
    let vendorDetails: SPPrivacyManager
    let privacyPolicyView: SPPrivacyManager?

    public init(
        homeView: SPPrivacyManager,
        categoriesView: SPPrivacyManager,
        categoryDetails: SPPrivacyManager,
        vendorsView: SPPrivacyManager,
        vendorDetails: SPPrivacyManager,
        privacyPolicyView: SPPrivacyManager
    ) {
        self.homeView = homeView
        self.categoriesView = categoriesView
        self.categoryDetails = categoryDetails
        self.vendorsView = vendorsView
        self.vendorDetails = vendorDetails
        self.privacyPolicyView = privacyPolicyView
    }
}
