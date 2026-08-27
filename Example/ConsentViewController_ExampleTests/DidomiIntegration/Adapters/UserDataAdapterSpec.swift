//
//  UserDataAdapterSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Claude on 27/08/2026.
//

@testable import ConsentViewController
import Didomi
import Foundation
import Nimble
import Quick

class UserDataAdapterSpec: QuickSpec {
    override func spec() {
        describe("UserDataAdapter") {
            var adapter: UserDataAdapter!
            var mockVendorProvider: MockVendorProvider!
            var mockPurposeProvider: MockPurposeProvider!

            beforeEach {
                mockVendorProvider = MockVendorProvider()
                mockPurposeProvider = MockPurposeProvider()

                let vendor = DidomiTestFixtures.createVendor(
                    id: "ddm-vendor-1",
                    spId: "sp-vendor-1",
                    purposeIDs: ["ddm-purpose-1"]
                )

                let purpose = DidomiTestFixtures.createPurpose(
                    id: "ddm-purpose-1",
                    spId: "sp-purpose-1"
                )

                mockVendorProvider.vendors = [vendor]
                mockPurposeProvider.purposes = [purpose]

                let gdprAdapter = GDPRConsentAdapter(
                    vendorProvider: mockVendorProvider,
                    purposeProvider: mockPurposeProvider
                )

                let ccpaAdapter = CCPAConsentAdapter(
                    vendorProvider: mockVendorProvider,
                    purposeProvider: mockPurposeProvider
                )

                adapter = UserDataAdapter(
                    gdprAdapter: gdprAdapter,
                    ccpaAdapter: ccpaAdapter
                )
            }

            describe("adapt") {
                it("creates SPUserData with GDPR consent when regulation is GDPR") {
                    let status = DidomiTestFixtures.createCurrentUserStatus(
                        regulation: .gdpr,
                        vendors: [
                            "ddm-vendor-1": DidomiTestFixtures.createVendorStatus(id: "ddm-vendor-1", enabled: true)
                        ],
                        purposes: [
                            "ddm-purpose-1": DidomiTestFixtures.createPurposeStatus(id: "ddm-purpose-1", enabled: true)
                        ]
                    )

                    let userData = adapter.adapt(from: status)

                    expect(userData.gdpr).toNot(beNil())
                    expect(userData.gdpr?.applies) == true
                    expect(userData.gdpr?.consents).toNot(beNil())
                    expect(userData.ccpa).to(beNil())
                    expect(userData.usnat).to(beNil())
                    expect(userData.globalcmp).to(beNil())
                }

                it("creates SPUserData with CCPA consent when regulation is CPRA") {
                    let status = DidomiTestFixtures.createCurrentUserStatus(
                        regulation: .cpra,
                        vendors: [
                            "ddm-vendor-1": DidomiTestFixtures.createVendorStatus(id: "ddm-vendor-1", enabled: false)
                        ],
                        purposes: [
                            "ddm-purpose-1": DidomiTestFixtures.createPurposeStatus(id: "ddm-purpose-1", enabled: true)
                        ]
                    )

                    let userData = adapter.adapt(from: status)

                    expect(userData.ccpa).toNot(beNil())
                    expect(userData.ccpa?.applies) == true
                    expect(userData.ccpa?.consents).toNot(beNil())
                    expect(userData.gdpr).to(beNil())
                    expect(userData.usnat).to(beNil())
                    expect(userData.globalcmp).to(beNil())
                }

                it("creates empty SPUserData when regulation is none") {
                    let status = DidomiTestFixtures.createCurrentUserStatus(
                        regulation: .none,
                        vendors: [:],
                        purposes: [:]
                    )

                    let userData = adapter.adapt(from: status)

                    expect(userData.gdpr).to(beNil())
                    expect(userData.ccpa).to(beNil())
                    expect(userData.usnat).to(beNil())
                    expect(userData.globalcmp).to(beNil())
                }

                it("wraps GDPR consent in SPConsent with applies=true") {
                    let status = DidomiTestFixtures.createCurrentUserStatus(
                        regulation: .gdpr,
                        vendors: [:],
                        purposes: [:]
                    )

                    let userData = adapter.adapt(from: status)

                    expect(userData.gdpr?.applies) == true
                }

                it("wraps CCPA consent in SPConsent with applies=true") {
                    let status = DidomiTestFixtures.createCurrentUserStatus(
                        regulation: .cpra,
                        vendors: [:],
                        purposes: [:]
                    )

                    let userData = adapter.adapt(from: status)

                    expect(userData.ccpa?.applies) == true
                }
            }
        }
    }
}
