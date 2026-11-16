//
//  CCPAConsentAdapterSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Claude on 27/08/2026.
//

@testable import ConsentViewController
import Didomi
import Foundation
import Nimble
import Quick

class CCPAConsentAdapterSpec: QuickSpec {
    override func spec() {
        describe("CCPAConsentAdapter") {
            var adapter: CCPAConsentAdapter!
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
                    spId: "sp-vendor-1"
                )

                vendor2 = DidomiTestFixtures.createVendor(
                    id: "ddm-vendor-2",
                    name: "Vendor 2",
                    spId: "sp-vendor-2"
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

                adapter = CCPAConsentAdapter(
                    vendorProvider: mockVendorProvider,
                    purposeProvider: mockPurposeProvider
                )
            }

            describe("adapt") {
                it("builds complete CCPA consent object") {
                    let status = DidomiTestFixtures.createCurrentUserStatus(
                        regulation: .cpra,
                        userID: "test-user-456",
                        created: "2024-02-01T00:00:00Z",
                        vendors: [
                            "ddm-vendor-1": DidomiTestFixtures.createVendorStatus(id: "ddm-vendor-1", enabled: false),
                            "ddm-vendor-2": DidomiTestFixtures.createVendorStatus(id: "ddm-vendor-2", enabled: true)
                        ],
                        purposes: [
                            "ddm-purpose-1": DidomiTestFixtures.createPurposeStatus(id: "ddm-purpose-1", enabled: false),
                            "ddm-purpose-2": DidomiTestFixtures.createPurposeStatus(id: "ddm-purpose-2", enabled: true)
                        ]
                    )

                    let consent = adapter.adapt(from: status)

                    expect(consent.uuid) == "test-user-456"
                    expect(consent.applies) == true
                    expect(consent.rejectedVendors.count) == 1
                    expect(consent.rejectedCategories.count) == 1
                }

                it("sets status to RejectedNone when all enabled") {
                    let status = DidomiTestFixtures.createCurrentUserStatus(
                        vendors: [
                            "ddm-vendor-1": DidomiTestFixtures.createVendorStatus(id: "ddm-vendor-1", enabled: true),
                            "ddm-vendor-2": DidomiTestFixtures.createVendorStatus(id: "ddm-vendor-2", enabled: true)
                        ],
                        purposes: [
                            "ddm-purpose-1": DidomiTestFixtures.createPurposeStatus(id: "ddm-purpose-1", enabled: true),
                            "ddm-purpose-2": DidomiTestFixtures.createPurposeStatus(id: "ddm-purpose-2", enabled: true)
                        ]
                    )

                    let consent = adapter.adapt(from: status)

                    expect(consent.status) == .RejectedNone
                    expect(consent.rejectedVendors.count) == 0
                    expect(consent.rejectedCategories.count) == 0
                }

                it("sets status to RejectedAll when all disabled") {
                    let status = DidomiTestFixtures.createCurrentUserStatus(
                        vendors: [
                            "ddm-vendor-1": DidomiTestFixtures.createVendorStatus(id: "ddm-vendor-1", enabled: false),
                            "ddm-vendor-2": DidomiTestFixtures.createVendorStatus(id: "ddm-vendor-2", enabled: false)
                        ],
                        purposes: [
                            "ddm-purpose-1": DidomiTestFixtures.createPurposeStatus(id: "ddm-purpose-1", enabled: false),
                            "ddm-purpose-2": DidomiTestFixtures.createPurposeStatus(id: "ddm-purpose-2", enabled: false)
                        ]
                    )

                    let consent = adapter.adapt(from: status)

                    expect(consent.status) == .RejectedAll
                    expect(consent.rejectedVendors.count) == 2
                    expect(consent.rejectedCategories.count) == 2
                }

                it("sets status to RejectedSome when partially disabled") {
                    let status = DidomiTestFixtures.createCurrentUserStatus(
                        vendors: [
                            "ddm-vendor-1": DidomiTestFixtures.createVendorStatus(id: "ddm-vendor-1", enabled: false),
                            "ddm-vendor-2": DidomiTestFixtures.createVendorStatus(id: "ddm-vendor-2", enabled: true)
                        ],
                        purposes: [
                            "ddm-purpose-1": DidomiTestFixtures.createPurposeStatus(id: "ddm-purpose-1", enabled: true),
                            "ddm-purpose-2": DidomiTestFixtures.createPurposeStatus(id: "ddm-purpose-2", enabled: true)
                        ]
                    )

                    let consent = adapter.adapt(from: status)

                    expect(consent.status) == .RejectedSome
                    expect(consent.rejectedVendors).to(contain("sp-vendor-1"))
                }

                it("builds rejected vendors list correctly") {
                    let status = DidomiTestFixtures.createCurrentUserStatus(
                        vendors: [
                            "ddm-vendor-1": DidomiTestFixtures.createVendorStatus(id: "ddm-vendor-1", enabled: false),
                            "ddm-vendor-2": DidomiTestFixtures.createVendorStatus(id: "ddm-vendor-2", enabled: false)
                        ],
                        purposes: [:]
                    )

                    let consent = adapter.adapt(from: status)

                    expect(consent.rejectedVendors.count) == 2
                    expect(consent.rejectedVendors).to(contain("sp-vendor-1", "sp-vendor-2"))
                }

                it("builds rejected categories list correctly") {
                    let status = DidomiTestFixtures.createCurrentUserStatus(
                        vendors: [:],
                        purposes: [
                            "ddm-purpose-1": DidomiTestFixtures.createPurposeStatus(id: "ddm-purpose-1", enabled: false),
                            "ddm-purpose-2": DidomiTestFixtures.createPurposeStatus(id: "ddm-purpose-2", enabled: true)
                        ]
                    )

                    let consent = adapter.adapt(from: status)

                    expect(consent.rejectedCategories.count) == 1
                    expect(consent.rejectedCategories).to(contain("sp-purpose-1"))
                }

                it("handles empty userID") {
                    let status = DidomiTestFixtures.createCurrentUserStatus(
                        regulation: .cpra,
                        userID: "",
                        vendors: [:],
                        purposes: [:]
                    )

                    let consent = adapter.adapt(from: status)

                    expect(consent.uuid).to(beNil())
                }

                it("sets signedLspa to false") {
                    let status = DidomiTestFixtures.createCurrentUserStatus(
                        regulation: .cpra,
                        vendors: [:],
                        purposes: [:]
                    )

                    let consent = adapter.adapt(from: status)

                    expect(consent.signedLspa) == false
                }
            }
        }
    }
}
