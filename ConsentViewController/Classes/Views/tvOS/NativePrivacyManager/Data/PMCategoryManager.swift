//
//  File.swift
//  ConsentViewController-tvOS
//
//  Created by Andre Herculano on 29.07.21.
//

import Foundation

protocol PMCategoryManager: AnyObject {
    associatedtype CategoryType: Hashable

    var onConsentsChange: () -> Void { get set }
    var categories: Set<CategoryType> { get }
    var toggledConsentCategoriesIds: Set<String> { get set }

    func onCategoryOn(_ category: CategoryType)
    func onCategoryOff(_ category: CategoryType)
}
