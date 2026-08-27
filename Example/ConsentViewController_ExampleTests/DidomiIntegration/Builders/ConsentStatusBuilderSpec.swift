//
//  ConsentStatusBuilderSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Claude on 27/08/2026.
//

@testable import ConsentViewController
import Didomi
import Foundation
import Nimble
import Quick

class ConsentStatusBuilderSpec: QuickSpec {
    override func spec() {
        describe("ConsentStatusBuilder") {
            describe("buildGDPR") {
                var status: CurrentUserStatus!
                var vendor1: Vendor!
                var vendor2: Vendor!
                var purpose1: Purpose!
                var purpose2: Purpose!
                var vendorMap: [String: Vendor]!
                var purposeMap: [String: Purpose]!

                beforeEach {
                    vendor1 = DidomiTestFixtures.createVendor(
                        id: "ddm-vendor-1",
                        spId: "sp-vendor-1",
                        legIntPurposeIDs: ["ddm-purpose-2"]
                    )

                    vendor2 = DidomiTestFixtures.createVendor(
                        id: "ddm-vendor-2",
                        spId: "sp-vendor-2"
                    )

                    purpose1 = DidomiTestFixtures.createPurpose(
                        id: "ddm-purpose-1",
                        spId: "sp-purpose-1"
                    )

                    purpose2 = DidomiTestFixtures.createPurpose(
                        id: "ddm-purpose-2",
                        spId: "sp-purpose-2"
                    )

                    vendorMap = [
                        "ddm-vendor-1": vendor1,
                        "ddm-vendor-2": vendor2
                    ]

                    purposeMap = [
                        "ddm-purpose-1": purpose1,
                        "ddm-purpose-2": purpose2
                    ]
                }

                it("sets consentedAll when all vendors and purposes enabled") {
                    status = DidomiTestFixtures.createCurrentUserStatus(
                        vendors: [
                            "ddm-vendor-1": DidomiTestFixtures.createVendorStatus(id: "ddm-vendor-1", enabled: true),
                            "ddm-vendor-2": DidomiTestFixtures.createVendorStatus(id: "ddm-vendor-2", enabled: true)
                        ],
                        purposes: [
                            "ddm-purpose-1": DidomiTestFixtures.createPurposeStatus(id: "ddm-purpose-1", enabled: true),
                            "ddm-purpose-2": DidomiTestFixtures.createPurposeStatus(id: "ddm-purpose-2", enabled: true)
                        ]
                    )

                    let result = ConsentStatusBuilder.buildGDPR(
                        from: status,
                        vendorMap: vendorMap,
                        purposeMap: purposeMap,
                        acceptedLegIntVendors: ["sp-vendor-1"]
                    )

                    expect(result.consentedAll) == true
                    expect(result.rejectedAll) == false
                    expect(result.rejectedAny) == false
                }

                it("sets rejectedAll when no vendors and purposes enabled") {
                    status = DidomiTestFixtures.createCurrentUserStatus(
                        vendors: [
                            "ddm-vendor-1": DidomiTestFixtures.createVendorStatus(id: "ddm-vendor-1", enabled: false),
                            "ddm-vendor-2": DidomiTestFixtures.createVendorStatus(id: "ddm-vendor-2", enabled: false)
                        ],
                        purposes: [
                            "ddm-purpose-1": DidomiTestFixtures.createPurposeStatus(id: "ddm-purpose-1", enabled: false),
                            "ddm-purpose-2": DidomiTestFixtures.createPurposeStatus(id: "ddm-purpose-2", enabled: false)
                        ]
                    )

                    let result = ConsentStatusBuilder.buildGDPR(
                        from: status,
                        vendorMap: vendorMap,
                        purposeMap: purposeMap,
                        acceptedLegIntVendors: []
                    )

                    expect(result.consentedAll) == false
                    expect(result.rejectedAll) == true
                    expect(result.rejectedAny) == true
                }

                it("sets rejectedAny when some vendors/purposes rejected") {
                    status = DidomiTestFixtures.createCurrentUserStatus(
                        vendors: [
                            "ddm-vendor-1": DidomiTestFixtures.createVendorStatus(id: "ddm-vendor-1", enabled: true),
                            "ddm-vendor-2": DidomiTestFixtures.createVendorStatus(id: "ddm-vendor-2", enabled: false)
                        ],
                        purposes: [
                            "ddm-purpose-1": DidomiTestFixtures.createPurposeStatus(id: "ddm-purpose-1", enabled: true),
                            "ddm-purpose-2": DidomiTestFixtures.createPurposeStatus(id: "ddm-purpose-2", enabled: true)
                        ]
                    )

                    let result = ConsentStatusBuilder.buildGDPR(
                        from: status,
                        vendorMap: vendorMap,
                        purposeMap: purposeMap,
                        acceptedLegIntVendors: ["sp-vendor-1"]
                    )

                    expect(result.rejectedAny) == true
                    expect(result.consentedAll) == false
                }

                it("sets rejectedLI when not all legInt vendors accepted") {
                    status = DidomiTestFixtures.createCurrentUserStatus(
                        vendors: [
                            "ddm-vendor-1": DidomiTestFixtures.createVendorStatus(id: "ddm-vendor-1", enabled: true)
                        ],
                        purposes: [:]
                    )

                    let result = ConsentStatusBuilder.buildGDPR(
                        from: status,
                        vendorMap: vendorMap,
                        purposeMap: purposeMap,
                        acceptedLegIntVendors: []
                    )

                    expect(result.rejectedLI) == true
                }

                it("builds rejected vendors and categories arrays") {
                    status = DidomiTestFixtures.createCurrentUserStatus(
                        vendors: [
                            "ddm-vendor-1": DidomiTestFixtures.createVendorStatus(id: "ddm-vendor-1", enabled: false),
                            "ddm-vendor-2": DidomiTestFixtures.createVendorStatus(id: "ddm-vendor-2", enabled: true)
                        ],
                        purposes: [
                            "ddm-purpose-1": DidomiTestFixtures.createPurposeStatus(id: "ddm-purpose-1", enabled: false),
                            "ddm-purpose-2": DidomiTestFixtures.createPurposeStatus(id: "ddm-purpose-2", enabled: true)
                        ]
                    )

                    let result = ConsentStatusBuilder.buildGDPR(
                        from: status,
                        vendorMap: vendorMap,
                        purposeMap: purposeMap,
                        acceptedLegIntVendors: []
                    )

                    expect(result.rejectedVendors).to(contain("sp-vendor-1"))
                    expect(result.rejectedCategories).to(contain("sp-purpose-1"))
                }
            }

            describe("buildCCPA") {
                it("returns RejectedNone when no rejections") {
                    let status = ConsentStatusBuilder.buildCCPA(
                        rejectedVendorsCount: 0,
                        rejectedCategoriesCount: 0,
                        totalVendorsCount: 5,
                        totalPurposesCount: 3
                    )

                    expect(status) == .RejectedNone
                }

                it("returns RejectedAll when all rejected") {
                    let status = ConsentStatusBuilder.buildCCPA(
                        rejectedVendorsCount: 5,
                        rejectedCategoriesCount: 3,
                        totalVendorsCount: 5,
                        totalPurposesCount: 3
                    )

                    expect(status) == .RejectedAll
                }

                it("returns RejectedSome when partial rejections") {
                    let status = ConsentStatusBuilder.buildCCPA(
                        rejectedVendorsCount: 2,
                        rejectedCategoriesCount: 1,
                        totalVendorsCount: 5,
                        totalPurposesCount: 3
                    )

                    expect(status) == .RejectedSome
                }
            }
        }
    }
}
