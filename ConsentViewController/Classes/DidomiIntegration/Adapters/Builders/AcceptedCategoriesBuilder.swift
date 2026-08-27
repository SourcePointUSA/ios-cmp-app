//
//  AcceptedCategoriesBuilder.swift
//  ConsentViewController
//
//  Created by Claude on 27/08/2026.
//

import Didomi
import Foundation

enum AcceptedCategoriesBuilder {
    static func buildAcceptedCategories(
        from purposes: [String: CurrentUserStatus.PurposeStatus],
        purposeMap: [String: Purpose]
    ) -> [String] {
        purposes
            .filter { $0.value.enabled }
            .compactMap { purposeMap[$0.key]?.namespaces?.sp }
    }

    static func buildAcceptedLegIntCategories(
        from purposes: [String: CurrentUserStatus.PurposeStatus],
        purposeMap: [String: Purpose],
        legIntPurposeIds: Set<String>
    ) -> [String] {
        purposes
            .filter { $0.value.enabled && legIntPurposeIds.contains($0.key) }
            .compactMap { purposeMap[$0.key]?.namespaces?.sp }
    }
}
