//
//  VendorGrantsBuilderSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Claude on 27/08/2026.
//

@testable import ConsentViewController
import Didomi
import Foundation
import Nimble
import Quick

class VendorGrantsBuilderSpec: QuickSpec {
    override func spec() {
        describe("VendorGrantsBuilder") {
            var vendor1: Vendor!
            var vendor2: Vendor!
            var purpose1: Purpose!
            var purpose2: Purpose!
            var vendorMap: [String: Vendor]!
            var purposeMap: [String: Purpose]!

            beforeEach {
                vendor1 = DidomiTestFixtures.createVendor(
                    id: "ddm-vendor-1",
                    name: "Vendor 1",
                    spId: "sp-vendor-1",
                    purposeIDs: ["ddm-purpose-1"],
                    legIntPurposeIDs: ["ddm-purpose-2"]
                )

                vendor2 = DidomiTestFixtures.createVendor(
                    id: "ddm-vendor-2",
                    name: "Vendor 2",
                    spId: "sp-vendor-2",
                    purposeIDs: ["ddm-purpose-1"]
                )

                purpose1 = DidomiTestFixtures.createPurpose(
                    id: "ddm-purpose-1",
                    name: "Purpose 1",
                    spId: "sp-purpose-1"
                )

                purpose2 = DidomiTestFixtures.createPurpose(
                    id: "ddm-purpose-2",
                    name: "Purpose 2",
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

            describe("build") {
                it("builds vendor grants with purpose-level granularity") {
                    let vendors: [String: CurrentUserStatus.VendorStatus] = [
                        "ddm-vendor-1": DidomiTestFixtures.createVendorStatus(id: "ddm-vendor-1", enabled: true),
                        "ddm-vendor-2": DidomiTestFixtures.createVendorStatus(id: "ddm-vendor-2", enabled: false)
                    ]

                    let purposes: [String: CurrentUserStatus.PurposeStatus] = [
                        "ddm-purpose-1": DidomiTestFixtures.createPurposeStatus(id: "ddm-purpose-1", enabled: true),
                        "ddm-purpose-2": DidomiTestFixtures.createPurposeStatus(id: "ddm-purpose-2", enabled: false)
                    ]

                    let grants = VendorGrantsBuilder.build(
                        from: vendors,
                        purposes: purposes,
                        vendorMap: vendorMap,
                        purposeMap: purposeMap
                    )

                    expect(grants.count) == 2
                    expect(grants["sp-vendor-1"]?.granted) == true
                    expect(grants["sp-vendor-1"]?.purposeGrants["sp-purpose-1"]) == true
                    expect(grants["sp-vendor-1"]?.purposeGrants["sp-purpose-2"]) == false

                    expect(grants["sp-vendor-2"]?.granted) == false
                    expect(grants["sp-vendor-2"]?.purposeGrants["sp-purpose-1"]) == true
                }

                it("skips vendors without SP namespace") {
                    let vendorWithoutSP = DidomiTestFixtures.createVendor(
                        id: "ddm-vendor-3",
                        spId: nil
                    )

                    let vendors: [String: CurrentUserStatus.VendorStatus] = [
                        "ddm-vendor-3": DidomiTestFixtures.createVendorStatus(id: "ddm-vendor-3", enabled: true)
                    ]

                    let grants = VendorGrantsBuilder.build(
                        from: vendors,
                        purposes: [:],
                        vendorMap: ["ddm-vendor-3": vendorWithoutSP],
                        purposeMap: [:]
                    )

                    expect(grants.count) == 0
                }

                it("handles empty vendor list") {
                    let grants = VendorGrantsBuilder.build(
                        from: [:],
                        purposes: [:],
                        vendorMap: vendorMap,
                        purposeMap: purposeMap
                    )

                    expect(grants.count) == 0
                }

                it("handles purposes without SP namespace") {
                    let purposeWithoutSP = DidomiTestFixtures.createPurpose(
                        id: "ddm-purpose-3",
                        spId: nil
                    )

                    let vendor = DidomiTestFixtures.createVendor(
                        id: "ddm-vendor-1",
                        spId: "sp-vendor-1",
                        purposeIDs: ["ddm-purpose-3"]
                    )

                    let vendors: [String: CurrentUserStatus.VendorStatus] = [
                        "ddm-vendor-1": DidomiTestFixtures.createVendorStatus(id: "ddm-vendor-1", enabled: true)
                    ]

                    let purposes: [String: CurrentUserStatus.PurposeStatus] = [
                        "ddm-purpose-3": DidomiTestFixtures.createPurposeStatus(id: "ddm-purpose-3", enabled: true)
                    ]

                    let grants = VendorGrantsBuilder.build(
                        from: vendors,
                        purposes: purposes,
                        vendorMap: ["ddm-vendor-1": vendor],
                        purposeMap: ["ddm-purpose-3": purposeWithoutSP]
                    )

                    expect(grants["sp-vendor-1"]?.purposeGrants.count) == 0
                }
            }
        }
    }
}
