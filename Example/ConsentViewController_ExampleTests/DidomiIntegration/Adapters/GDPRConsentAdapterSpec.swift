//
//  GDPRConsentAdapterSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Claude on 27/08/2026.
//

@testable import ConsentViewController
import Didomi
import Foundation
import Nimble
import Quick

class GDPRConsentAdapterSpec: QuickSpec {
    override func spec() {
        describe("GDPRConsentAdapter") {
            var adapter: GDPRConsentAdapter!
            var mockVendorProvider: MockVendorProvider!
            var mockPurposeProvider: MockPurposeProvider!
            var vendor1: Vendor!
            var vendor2: Vendor!
            var purpose1: Purpose!
            var purpose2: Purpose!

            beforeEach {
                mockVendorProvider = MockVendorProvider()
                mockPurposeProvider = MockPurposeProvider()

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

                mockVendorProvider.vendors = [vendor1, vendor2]
                mockPurposeProvider.purposes = [purpose1, purpose2]

                adapter = GDPRConsentAdapter(
                    vendorProvider: mockVendorProvider,
                    purposeProvider: mockPurposeProvider
                )
            }

            describe("adapt") {
                it("builds complete GDPR consent object") {
                    let status = DidomiTestFixtures.createCurrentUserStatus(
                        regulation: .gdpr,
                        userID: "test-user-123",
                        created: "2024-01-01T00:00:00Z",
                        consentString: "test-tc-string",
                        vendors: [
                            "ddm-vendor-1": DidomiTestFixtures.createVendorStatus(id: "ddm-vendor-1", enabled: true),
                            "ddm-vendor-2": DidomiTestFixtures.createVendorStatus(id: "ddm-vendor-2", enabled: false)
                        ],
                        purposes: [
                            "ddm-purpose-1": DidomiTestFixtures.createPurposeStatus(id: "ddm-purpose-1", enabled: true),
                            "ddm-purpose-2": DidomiTestFixtures.createPurposeStatus(id: "ddm-purpose-2", enabled: true)
                        ]
                    )

                    let consent = adapter.adapt(from: status)

                    expect(consent.uuid) == "test-user-123"
                    expect(consent.euconsent) == "test-tc-string"
                    expect(consent.applies) == true
                    expect(consent.vendorGrants.count) == 2
                }

                it("builds vendor grants correctly") {
                    let status = DidomiTestFixtures.createCurrentUserStatus(
                        vendors: [
                            "ddm-vendor-1": DidomiTestFixtures.createVendorStatus(id: "ddm-vendor-1", enabled: true)
                        ],
                        purposes: [
                            "ddm-purpose-1": DidomiTestFixtures.createPurposeStatus(id: "ddm-purpose-1", enabled: true),
                            "ddm-purpose-2": DidomiTestFixtures.createPurposeStatus(id: "ddm-purpose-2", enabled: false)
                        ]
                    )

                    let consent = adapter.adapt(from: status)

                    expect(consent.vendorGrants["sp-vendor-1"]?.granted) == true
                    expect(consent.vendorGrants["sp-vendor-1"]?.purposeGrants["sp-purpose-1"]) == true
                    expect(consent.vendorGrants["sp-vendor-1"]?.purposeGrants["sp-purpose-2"]) == false
                }

                it("builds accepted vendors list") {
                    let status = DidomiTestFixtures.createCurrentUserStatus(
                        vendors: [
                            "ddm-vendor-1": DidomiTestFixtures.createVendorStatus(id: "ddm-vendor-1", enabled: true),
                            "ddm-vendor-2": DidomiTestFixtures.createVendorStatus(id: "ddm-vendor-2", enabled: true)
                        ],
                        purposes: [
                            "ddm-purpose-1": DidomiTestFixtures.createPurposeStatus(id: "ddm-purpose-1", enabled: true)
                        ]
                    )

                    let consent = adapter.adapt(from: status)

                    expect(consent.acceptedVendors.count) == 2
                    expect(consent.acceptedVendors).to(contain("sp-vendor-1", "sp-vendor-2"))
                }

                it("builds accepted legInt vendors list") {
                    let status = DidomiTestFixtures.createCurrentUserStatus(
                        vendors: [
                            "ddm-vendor-1": DidomiTestFixtures.createVendorStatus(id: "ddm-vendor-1", enabled: true),
                            "ddm-vendor-2": DidomiTestFixtures.createVendorStatus(id: "ddm-vendor-2", enabled: false)
                        ],
                        purposes: [
                            "ddm-purpose-2": DidomiTestFixtures.createPurposeStatus(id: "ddm-purpose-2", enabled: true)
                        ]
                    )

                    let consent = adapter.adapt(from: status)

                    expect(consent.acceptedLegIntVendors.count) == 1
                    expect(consent.acceptedLegIntVendors).to(contain("sp-vendor-1"))
                }

                it("builds accepted categories list") {
                    let status = DidomiTestFixtures.createCurrentUserStatus(
                        vendors: [:],
                        purposes: [
                            "ddm-purpose-1": DidomiTestFixtures.createPurposeStatus(id: "ddm-purpose-1", enabled: true),
                            "ddm-purpose-2": DidomiTestFixtures.createPurposeStatus(id: "ddm-purpose-2", enabled: false)
                        ]
                    )

                    let consent = adapter.adapt(from: status)

                    expect(consent.acceptedCategories.count) == 1
                    expect(consent.acceptedCategories).to(contain("sp-purpose-1"))
                }

                it("builds accepted legInt categories list") {
                    let status = DidomiTestFixtures.createCurrentUserStatus(
                        vendors: [:],
                        purposes: [
                            "ddm-purpose-1": DidomiTestFixtures.createPurposeStatus(id: "ddm-purpose-1", enabled: true),
                            "ddm-purpose-2": DidomiTestFixtures.createPurposeStatus(id: "ddm-purpose-2", enabled: true)
                        ]
                    )

                    let consent = adapter.adapt(from: status)

                    expect(consent.acceptedLegIntCategories.count) == 1
                    expect(consent.acceptedLegIntCategories).to(contain("sp-purpose-2"))
                }

                it("handles empty userID") {
                    let status = DidomiTestFixtures.createCurrentUserStatus(
                        userID: "",
                        vendors: [:],
                        purposes: [:]
                    )

                    let consent = adapter.adapt(from: status)

                    expect(consent.uuid).to(beNil())
                }

                it("sets proper date values") {
                    let status = DidomiTestFixtures.createCurrentUserStatus(
                        created: "2024-01-15T12:30:00Z",
                        vendors: [:],
                        purposes: [:]
                    )

                    let consent = adapter.adapt(from: status)

                    expect(consent.dateCreated).toNot(beNil())
                    expect(consent.expirationDate).toNot(beNil())
                }
            }
        }
    }
}
