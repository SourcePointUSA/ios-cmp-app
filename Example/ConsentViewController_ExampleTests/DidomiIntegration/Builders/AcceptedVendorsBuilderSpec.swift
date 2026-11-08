//
//  AcceptedVendorsBuilderSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Claude on 27/08/2026.
//

@testable import ConsentViewController
import Didomi
import Foundation
import Nimble
import Quick

class AcceptedVendorsBuilderSpec: QuickSpec {
    override func spec() {
        describe("AcceptedVendorsBuilder") {
            var vendor1: Vendor!
            var vendor2: Vendor!
            var vendor3: Vendor!
            var vendorMap: [String: Vendor]!

            beforeEach {
                vendor1 = DidomiTestFixtures.createVendor(
                    id: "ddm-vendor-1",
                    spId: "sp-vendor-1",
                    purposeIDs: ["purpose-1"]
                )

                vendor2 = DidomiTestFixtures.createVendor(
                    id: "ddm-vendor-2",
                    spId: "sp-vendor-2",
                    legIntPurposeIDs: ["purpose-2"]
                )

                vendor3 = DidomiTestFixtures.createVendor(
                    id: "ddm-vendor-3",
                    spId: "sp-vendor-3",
                    purposeIDs: [],
                    legIntPurposeIDs: []
                )

                vendorMap = [
                    "ddm-vendor-1": vendor1,
                    "ddm-vendor-2": vendor2,
                    "ddm-vendor-3": vendor3
                ]
            }

            describe("buildAcceptedVendors") {
                it("returns vendors with consent purposes enabled") {
                    let vendors: [String: CurrentUserStatus.VendorStatus] = [
                        "ddm-vendor-1": DidomiTestFixtures.createVendorStatus(id: "ddm-vendor-1", enabled: true),
                        "ddm-vendor-2": DidomiTestFixtures.createVendorStatus(id: "ddm-vendor-2", enabled: true),
                        "ddm-vendor-3": DidomiTestFixtures.createVendorStatus(id: "ddm-vendor-3", enabled: true)
                    ]

                    let result = AcceptedVendorsBuilder.buildAcceptedVendors(
                        from: vendors,
                        vendorMap: vendorMap
                    )

                    expect(result.count) == 1
                    expect(result).to(contain("sp-vendor-1"))
                }

                it("excludes disabled vendors") {
                    let vendors: [String: CurrentUserStatus.VendorStatus] = [
                        "ddm-vendor-1": DidomiTestFixtures.createVendorStatus(id: "ddm-vendor-1", enabled: false)
                    ]

                    let result = AcceptedVendorsBuilder.buildAcceptedVendors(
                        from: vendors,
                        vendorMap: vendorMap
                    )

                    expect(result.count) == 0
                }

                it("excludes vendors with empty purpose IDs") {
                    let vendors: [String: CurrentUserStatus.VendorStatus] = [
                        "ddm-vendor-3": DidomiTestFixtures.createVendorStatus(id: "ddm-vendor-3", enabled: true)
                    ]

                    let result = AcceptedVendorsBuilder.buildAcceptedVendors(
                        from: vendors,
                        vendorMap: vendorMap
                    )

                    expect(result.count) == 0
                }
            }

            describe("buildAcceptedLegIntVendors") {
                it("returns vendors with legInt purposes enabled") {
                    let vendors: [String: CurrentUserStatus.VendorStatus] = [
                        "ddm-vendor-1": DidomiTestFixtures.createVendorStatus(id: "ddm-vendor-1", enabled: true),
                        "ddm-vendor-2": DidomiTestFixtures.createVendorStatus(id: "ddm-vendor-2", enabled: true),
                        "ddm-vendor-3": DidomiTestFixtures.createVendorStatus(id: "ddm-vendor-3", enabled: true)
                    ]

                    let result = AcceptedVendorsBuilder.buildAcceptedLegIntVendors(
                        from: vendors,
                        vendorMap: vendorMap
                    )

                    expect(result.count) == 1
                    expect(result).to(contain("sp-vendor-2"))
                }

                it("excludes disabled vendors") {
                    let vendors: [String: CurrentUserStatus.VendorStatus] = [
                        "ddm-vendor-2": DidomiTestFixtures.createVendorStatus(id: "ddm-vendor-2", enabled: false)
                    ]

                    let result = AcceptedVendorsBuilder.buildAcceptedLegIntVendors(
                        from: vendors,
                        vendorMap: vendorMap
                    )

                    expect(result.count) == 0
                }
            }
        }
    }
}
