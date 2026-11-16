//
//  AcceptedCategoriesBuilderSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Claude on 27/08/2026.
//

@testable import ConsentViewController
import Didomi
import Foundation
import Nimble
import Quick

class AcceptedCategoriesBuilderSpec: QuickSpec {
    override func spec() {
        describe("AcceptedCategoriesBuilder") {
            var purpose1: Purpose!
            var purpose2: Purpose!
            var purpose3: Purpose!
            var purposeMap: [String: Purpose]!

            beforeEach {
                purpose1 = DidomiTestFixtures.createPurpose(
                    id: "ddm-purpose-1",
                    spId: "sp-purpose-1"
                )

                purpose2 = DidomiTestFixtures.createPurpose(
                    id: "ddm-purpose-2",
                    spId: "sp-purpose-2"
                )

                purpose3 = DidomiTestFixtures.createPurpose(
                    id: "ddm-purpose-3",
                    spId: nil
                )

                purposeMap = [
                    "ddm-purpose-1": purpose1,
                    "ddm-purpose-2": purpose2,
                    "ddm-purpose-3": purpose3
                ]
            }

            describe("buildAcceptedCategories") {
                it("returns enabled purposes with SP namespace") {
                    let purposes: [String: CurrentUserStatus.PurposeStatus] = [
                        "ddm-purpose-1": DidomiTestFixtures.createPurposeStatus(id: "ddm-purpose-1", enabled: true),
                        "ddm-purpose-2": DidomiTestFixtures.createPurposeStatus(id: "ddm-purpose-2", enabled: false)
                    ]

                    let result = AcceptedCategoriesBuilder.buildAcceptedCategories(
                        from: purposes,
                        purposeMap: purposeMap
                    )

                    expect(result.count) == 1
                    expect(result).to(contain("sp-purpose-1"))
                }

                it("excludes purposes without SP namespace") {
                    let purposes: [String: CurrentUserStatus.PurposeStatus] = [
                        "ddm-purpose-3": DidomiTestFixtures.createPurposeStatus(id: "ddm-purpose-3", enabled: true)
                    ]

                    let result = AcceptedCategoriesBuilder.buildAcceptedCategories(
                        from: purposes,
                        purposeMap: purposeMap
                    )

                    expect(result.count) == 0
                }

                it("handles empty purposes") {
                    let result = AcceptedCategoriesBuilder.buildAcceptedCategories(
                        from: [:],
                        purposeMap: purposeMap
                    )

                    expect(result.count) == 0
                }
            }

            describe("buildAcceptedLegIntCategories") {
                it("returns enabled purposes that are legInt") {
                    let legIntPurposeIds: Set<String> = ["ddm-purpose-1"]

                    let purposes: [String: CurrentUserStatus.PurposeStatus] = [
                        "ddm-purpose-1": DidomiTestFixtures.createPurposeStatus(id: "ddm-purpose-1", enabled: true),
                        "ddm-purpose-2": DidomiTestFixtures.createPurposeStatus(id: "ddm-purpose-2", enabled: true)
                    ]

                    let result = AcceptedCategoriesBuilder.buildAcceptedLegIntCategories(
                        from: purposes,
                        purposeMap: purposeMap,
                        legIntPurposeIds: legIntPurposeIds
                    )

                    expect(result.count) == 1
                    expect(result).to(contain("sp-purpose-1"))
                }

                it("excludes non-legInt purposes") {
                    let legIntPurposeIds: Set<String> = []

                    let purposes: [String: CurrentUserStatus.PurposeStatus] = [
                        "ddm-purpose-1": DidomiTestFixtures.createPurposeStatus(id: "ddm-purpose-1", enabled: true)
                    ]

                    let result = AcceptedCategoriesBuilder.buildAcceptedLegIntCategories(
                        from: purposes,
                        purposeMap: purposeMap,
                        legIntPurposeIds: legIntPurposeIds
                    )

                    expect(result.count) == 0
                }
            }
        }
    }
}
