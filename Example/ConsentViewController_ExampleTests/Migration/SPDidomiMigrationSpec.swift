//
//  SPDidomiMigrationSpec.swift
//  ConsentViewController_ExampleTests
//
//  Integration test for Didomi SDK's Sourcepoint consent data migration
//

@testable import ConsentViewController
import Didomi
import Foundation
import Nimble
import Quick
import XCTest

// swiftlint:disable force_try function_body_length line_length

class SPDidomiMigrationSpec: QuickSpec {
    override class func spec() {
        describe("Didomi SDK Sourcepoint Consent Migration") {
            let accountId = 22
            let propertyId = 16893
            let propertyName = try! SPPropertyName("mobile.multicampaign.demo")
            let campaigns = SPCampaigns(
                gdpr: SPCampaign(),
                ccpa: SPCampaign(),
                usnat: SPCampaign()
            )

            var mockDelegate: MockDidomiDelegate!
            var consentManager: SPDidomiConsentManager!

            context("when Sourcepoint GDPR consent data exists and Didomi data does not") {
                beforeEach {
                    clearAllConsentData()
                    setupSourcepointGDPRConsentData()

                    // Enable bundle swizzling to redirect config file lookups
                    BundleSwizzler.enableConfigFileRedirection("SourcepointConfigGDPR")

                    mockDelegate = MockDidomiDelegate()
                    consentManager = SPDidomiConsentManager(
                        accountId: accountId,
                        propertyId: propertyId,
                        propertyName: propertyName,
                        campaigns: campaigns,
                        language: .BrowserDefault,
                        delegate: mockDelegate,
                        configFileName: "SourcepointConfigGDPR"
                    )
                }

                afterEach {
                    BundleSwizzler.disableConfigFileRedirection()
                    clearAllConsentData()
                    mockDelegate = nil
                    consentManager = nil
                }

                it("should migrate Sourcepoint GDPR data and return it with correct values") {
                    consentManager.loadMessage(forAuthId: nil, publisherData: SPPublisherData())

                    expect(mockDelegate.isOnSPUIReadyCalled).toEventually(beFalse(), timeout: .seconds(10))
                    expect(mockDelegate.isOnConsentReadyCalled).toEventually(beTrue(), timeout: .seconds(10))
                    expect(mockDelegate.isOnSPFinishedCalled).toEventually(beTrue(), timeout: .seconds(10))

                    let userData = mockDelegate.capturedUserData

                    expect(userData).notTo(beNil())
                    expect(userData?.gdpr).notTo(beNil())

                    expect(userData?.gdpr?.consents?.euconsent).toNot(beEmpty())

                    let expectedVendors = ["5f1b2fbeb8e05c306f2a1eb9", "5e7e1298b8e05c4854221be9", "5e7ced57b8e05c485246cce0"]
                    for vendorId in expectedVendors {
                        expect(userData?.gdpr?.consents?.acceptedVendors).to(contain(vendorId),
                            description: "Should contain vendor \(vendorId) from migrated Sourcepoint data")
                    }

                    let expectedCategories = ["608bad95d08d3112188e0e29", "608bad95d08d3112188e0e36", "608bad96d08d3112188e0e59"]
                    for categoryId in expectedCategories {
                        expect(userData?.gdpr?.consents?.acceptedCategories).to(contain(categoryId),
                            description: "Should contain category \(categoryId) from migrated Sourcepoint data")
                    }

                    // Validate vendor grants were migrated with purpose-level granularity
                    expect(userData?.gdpr?.consents?.vendorGrants).toNot(beEmpty())

                    // Check vendor grants for specific vendor
                    if let vendorGrant = userData?.gdpr?.consents?.vendorGrants["5e7ced57b8e05c485246cce0"] {
                        expect(vendorGrant.granted).to(beTrue(), description: "Vendor should be granted")
                        expect(vendorGrant.purposeGrants).toNot(beEmpty(), description: "Purpose grants should exist")

                        // Verify specific purpose grants for this vendor
                        expect(vendorGrant.purposeGrants["60b65857619abe242bed971e"]).to(beTrue())
                        expect(vendorGrant.purposeGrants["608bad95d08d3112188e0e29"]).to(beTrue())
                    }

                    // Validate legitimate interest data was migrated
                    expect(userData?.gdpr?.consents?.acceptedLegIntCategories).to(contain("608bad95d08d3112188e0e2f"))
                    expect(userData?.gdpr?.consents?.acceptedLegIntVendors).to(contain("5f1b2fbeb8e05c306f2a1eb9"))
                }
            }

            xcontext("when Sourcepoint CCPA consent data exists and Didomi data does not") {
                beforeEach {
                    clearAllConsentData()
                    setupSourcepointCCPAConsentData()

                    // Enable bundle swizzling to redirect config file lookups
                    BundleSwizzler.enableConfigFileRedirection("SourcepointConfigCCPA")

                    mockDelegate = MockDidomiDelegate()
                    consentManager = SPDidomiConsentManager(
                        accountId: accountId,
                        propertyId: propertyId,
                        propertyName: propertyName,
                        campaigns: campaigns,
                        language: .BrowserDefault,
                        delegate: mockDelegate,
                        configFileName: "SourcepointConfigCCPA"
                    )
                }

                afterEach {
                    BundleSwizzler.disableConfigFileRedirection()
                    clearAllConsentData()
                    mockDelegate = nil
                    consentManager = nil
                }

                it("should call onConsentReady and onSPFinished after migration") {
                    consentManager.loadMessage(forAuthId: nil, publisherData: SPPublisherData())

                    expect(mockDelegate.isOnConsentReadyCalled).toEventually(
                        beTrue(),
                        timeout: .seconds(10),
                        pollInterval: .milliseconds(500),
                        description: "onConsentReady should be called, but it wasn't"
                    )

                    expect(mockDelegate.isOnSPFinishedCalled).toEventually(
                        beTrue(),
                        timeout: .seconds(10),
                        pollInterval: .milliseconds(500),
                        description: "onSPFinished should be called but it wasn't"
                    )

                    expect(mockDelegate.isOnSPUIReadyCalled).to(
                        beFalse(),
                        description: "onSPUIReady should NOT be called, but it was."
                    )
                }

                it("should migrate Sourcepoint CCPA data and return it with correct values") {
                    // This test validates that Sourcepoint CCPA data stored in UserDefaults
                    // is properly migrated by Didomi and converted back to SPUserData format
                    consentManager.loadMessage(forAuthId: nil, publisherData: SPPublisherData())

                    expect(mockDelegate.isOnConsentReadyCalled).toEventually(beTrue(), timeout: .seconds(10))

                    guard let userData = mockDelegate.capturedUserData else {
                        fail("userData should not be nil")
                        return
                    }

                    // Verify CCPA consent was migrated
                    guard let ccpaConsent = userData.ccpa?.consents else {
                        fail("CCPA consent should not be nil after migration")
                        return
                    }

                    // Validate UUID matches stored Sourcepoint data
                    expect(ccpaConsent.uuid).to(equal("51757a9e-31a3-4f2b-bc49-5314094075a6"))

                    // Validate status - stored data has "consentedAll" which maps to RejectedNone
                    expect(ccpaConsent.status).to(equal(CCPAConsentStatus.RejectedNone),
                        description: "Status should be RejectedNone for consentedAll")

                    // Validate rejected arrays are empty (since user consented to all)
                    expect(ccpaConsent.rejectedVendors).to(beEmpty(),
                        description: "Rejected vendors should be empty when user consented to all")
                    expect(ccpaConsent.rejectedCategories).to(beEmpty(),
                        description: "Rejected categories should be empty when user consented to all")

                    // Validate GPP data exists
                    expect(ccpaConsent.GPPData).toNot(beNil())
                }
            }

            xcontext("when Sourcepoint USNAT consent data exists and Didomi data does not") {
                beforeEach {
                    clearAllConsentData()
                    setupSourcepointUSNATConsentData()

                    // Enable bundle swizzling to redirect config file lookups
                    BundleSwizzler.enableConfigFileRedirection("SourcepointConfigUSNAT")

                    mockDelegate = MockDidomiDelegate()
                    consentManager = SPDidomiConsentManager(
                        accountId: accountId,
                        propertyId: propertyId,
                        propertyName: propertyName,
                        campaigns: campaigns,
                        language: .BrowserDefault,
                        delegate: mockDelegate,
                        configFileName: "SourcepointConfigUSNAT"
                    )
                }

                afterEach {
                    BundleSwizzler.disableConfigFileRedirection()
                    clearAllConsentData()
                    mockDelegate = nil
                    consentManager = nil
                }

                it("should call onConsentReady and onSPFinished after migration") {
                    consentManager.loadMessage(forAuthId: nil, publisherData: SPPublisherData())

                    expect(mockDelegate.isOnConsentReadyCalled).toEventually(
                        beTrue(),
                        timeout: .seconds(10),
                        pollInterval: .milliseconds(500),
                        description: "onConsentReady should be called, but it wasn't"
                    )

                    expect(mockDelegate.isOnSPFinishedCalled).toEventually(
                        beTrue(),
                        timeout: .seconds(10),
                        pollInterval: .milliseconds(500),
                        description: "onSPFinished should be called but it wasn't"
                    )

                    expect(mockDelegate.isOnSPUIReadyCalled).to(
                        beFalse(),
                        description: "onSPUIReady should NOT be called, but it was."
                    )
                }

                it("should migrate Sourcepoint USNat data and return it with correct values") {
                    // This test validates that Sourcepoint USNat data stored in UserDefaults
                    // is properly migrated by Didomi and converted back to SPUserData format
                    consentManager.loadMessage(forAuthId: nil, publisherData: SPPublisherData())

                    expect(mockDelegate.isOnConsentReadyCalled).toEventually(beTrue(), timeout: .seconds(10))

                    guard let userData = mockDelegate.capturedUserData else {
                        fail("userData should not be nil")
                        return
                    }

                    // Verify USNat consent was migrated
                    guard let usnatConsent = userData.usnat?.consents else {
                        fail("USNat consent should not be nil after migration")
                        return
                    }

                    // Validate UUID matches stored Sourcepoint data
                    expect(usnatConsent.uuid).to(equal("24764a40-a0aa-49d9-95ee-d2f1e111aacc_143"))

                    // Validate categories were migrated (stored data has 13 categories)
                    expect(usnatConsent.categories).toNot(beEmpty(),
                        description: "Categories should be populated from migrated data")

                    // Check for expected category IDs from stored Sourcepoint data
                    let categoryIds = usnatConsent.categories.map { $0.id }
                    let expectedCategories = [
                        "65a6a785cc78fac48ab34e65",  // Targeted Advertising
                        "65a6a785cc78fac48ab34e6a",  // Sale of Personal Information
                        "65a6a785cc78fac48ab34e6f",  // Sharing of Personal Information
                        "648c9c48e17a3c7a82360c54"   // Another category from stored data
                    ]

                    for categoryId in expectedCategories {
                        expect(categoryIds).to(contain(categoryId),
                            description: "Should contain category \(categoryId) from migrated Sourcepoint data")
                    }

                    // Verify all migrated categories have consented=true (stored data shows all consented)
                    for category in usnatConsent.categories {
                        expect(category.id).toNot(beEmpty(), description: "Category ID should not be empty")
                        expect(category.consented).to(beTrue(),
                            description: "Category \(category.id) should be consented from migrated data")
                    }

                    // Validate consent strings were migrated
                    expect(usnatConsent.consentStrings).toNot(beEmpty(),
                        description: "Consent strings should be populated from migrated GPP data")

                    // Verify at least one consent string has section 12 (usct)
                    let hasSectionId12 = usnatConsent.consentStrings.contains { $0.sectionId == 12 }
                    expect(hasSectionId12).to(beTrue(),
                        description: "Should have consent string for section 12 (usct)")

                    // Validate vendors list exists (may be empty if no vendors in stored data)
                    expect(usnatConsent.vendors).toNot(beNil())

                    // Validate GPP data exists
                    expect(usnatConsent.GPPData).toNot(beNil())
                }
            }
        }

        // Helper function to clear all consent data
        func clearAllConsentData() {
            let userDefaults = UserDefaults.standard
            let allKeys = userDefaults.dictionaryRepresentation().keys

            let keysToRemove = allKeys.filter { key in
                let lowercaseKey = key.lowercased()
                return key.contains("IAB") || lowercaseKey.contains("didomi") || key.hasPrefix("sp_") || key.hasPrefix("sp.")
            }

            for key in keysToRemove {
                userDefaults.removeObject(forKey: key)
            }

            userDefaults.synchronize()
        }

        // Helper function to set up Sourcepoint GDPR consent data
        func setupSourcepointGDPRConsentData() {
            let consentData: [String: Any] = [
                "gdpr": [
                    "consents": [
                        "applies": true,
                        "categories": [
                            "608bad95d08d3112188e0e29",
                            "608bad95d08d3112188e0e36",
                            "608bad96d08d3112188e0e59",
                            "60b65857619abe242bed971e",
                            "65c4a19739cd2b04ba0cb49c",
                            "65c4a19739cd2b04ba0cb4a6",
                            "65c4a19739cd2b04ba0cb4b0",
                            "65c4a19739cd2b04ba0cb4ba"
                        ],
                        "consentStatus": [
                            "consentedAll": false,
                            "consentedToAny": true,
                            "granularStatus": [
                                "defaultConsent": false,
                                "previousOptInAll": false,
                                "purposeConsent": "SOME",
                                "purposeLegInt": "ALL",
                                "vendorConsent": "ALL",
                                "vendorLegInt": "ALL"
                            ],
                            "hasConsentData": true,
                            "rejectedAny": true,
                            "rejectedLI": false
                        ],
                        "dateCreated": "2026-11-02T15:19:01.957Z",
                        "euconsent": "CQtDjkAQtDjkAAGABBENC3FgAKCAAEAAAAiQASAAAAAAQAAAAhAAIAJA.IASAAAAAAQAA.YAAAAAAAAAAA",
                        "grants": [
                            "5e7ced57b8e05c485246cce0": [
                                "purposeGrants": [
                                    "60b65857619abe242bed971e": true,
                                    "608bad95d08d3112188e0e29": true,
                                    "608bad95d08d3112188e0e36": true,
                                    "608bad96d08d3112188e0e59": true
                                ],
                                "vendorGrant": true
                            ],
                            "5e7e1298b8e05c4854221be9": [
                                "purposeGrants": [
                                    "65c4a19739cd2b04ba0cb4a6": true,
                                    "65c4a19739cd2b04ba0cb4b0": true,
                                    "65c4a19739cd2b04ba0cb4ba": true,
                                    "65c4a19739cd2b04ba0cb49c": true
                                ],
                                "vendorGrant": true
                            ],
                            "5f1b2fbeb8e05c306f2a1eb9": [
                                "purposeGrants": [
                                    "608bad95d08d3112188e0e2f": true,
                                    "608bad95d08d3112188e0e29": true
                                ],
                                "vendorGrant": true
                            ],
                            "5ff4d000a228633ac048be41": [
                                "purposeGrants": [
                                    "608bad95d08d3112188e0e2f": false,
                                    "608bad95d08d3112188e0e3d": false,
                                    "608bad95d08d3112188e0e36": true
                                ],
                                "vendorGrant": false
                            ]
                        ],
                        "legIntCategories": [
                            "608bad95d08d3112188e0e2f"
                        ],
                        "legIntVendors": [
                            "5f1b2fbeb8e05c306f2a1eb9"
                        ],
                        "uuid": "a2c209da-c5c6-46b5-98f5-a81ea9e732d2_61",
                        "vendors": [
                            "5f1b2fbeb8e05c306f2a1eb9",
                            "5e7e1298b8e05c4854221be9",
                            "5e7ced57b8e05c485246cce0"
                        ]
                    ]
                ]
            ]

            // Convert to JSON and store as Data (not string)
            if let jsonData = try? JSONSerialization.data(withJSONObject: consentData, options: []) {
                // Store in UserDefaults with the key that Sourcepoint SDK uses for Didomi migration
                UserDefaults.standard.set(jsonData, forKey: "sp.state")
                UserDefaults.standard.synchronize()

                // Verify the data was set
                let stored = UserDefaults.standard.data(forKey: "sp.state")
                print("✓ Sourcepoint data stored: \(stored != nil), size: \(stored?.count ?? 0) bytes")
            } else {
                print("✗ Failed to serialize Sourcepoint consent data")
            }

            // Add IAB TCF data to UserDefaults (simulating what Didomi should write after migration)
            UserDefaults.standard.set("2~899~dv.", forKey: "IABTCF_AddtlConsent")
            UserDefaults.standard.set(6, forKey: "IABTCF_CmpSdkID")
            UserDefaults.standard.set(2, forKey: "IABTCF_CmpSdkVersion")
            UserDefaults.standard.set("000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000", forKey: "IABTCF_DisclosedVendors")
            UserDefaults.standard.set(1, forKey: "IABTCF_EnableAdvertiserConsentMode")
            UserDefaults.standard.set(1, forKey: "IABTCF_gdprApplies")
            UserDefaults.standard.set(5, forKey: "IABTCF_PolicyVersion")
            UserDefaults.standard.set("ES", forKey: "IABTCF_PublisherCC")
            UserDefaults.standard.set("00000000000", forKey: "IABTCF_PublisherConsent")
            UserDefaults.standard.set("00000000000", forKey: "IABTCF_PublisherCustomPurposesConsents")
            UserDefaults.standard.set("00000000000", forKey: "IABTCF_PublisherCustomPurposesLegitimateInterests")
            UserDefaults.standard.set("00000000000", forKey: "IABTCF_PublisherLegitimateInterests")
            UserDefaults.standard.set("000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000", forKey: "IABTCF_PublisherRestrictions2")
            UserDefaults.standard.set("10100000100", forKey: "IABTCF_PurposeConsents")
            UserDefaults.standard.set("01000000000", forKey: "IABTCF_PurposeLegitimateInterests")
            UserDefaults.standard.set(0, forKey: "IABTCF_PurposeOneTreatment")
            UserDefaults.standard.set("00", forKey: "IABTCF_SpecialFeaturesOptIns")
            UserDefaults.standard.set("CQtDjkAQtDjkAAGABBENC3FgAKCAAEAAAAiQASAAAAAAQAAAAhAAIAJA.IASAAAAAAQAA.YAAAAAAAAAAA", forKey: "IABTCF_TCString")
            UserDefaults.standard.set(0, forKey: "IABTCF_UseNonStandardTexts")
            UserDefaults.standard.set("000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000", forKey: "IABTCF_VendorConsents")
            UserDefaults.standard.set("000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000", forKey: "IABTCF_VendorLegitimateInterests")
            UserDefaults.standard.synchronize()
            print("✓ IAB TCF data added to UserDefaults")
        }

        // Helper function to set up Sourcepoint CCPA consent data
        func setupSourcepointCCPAConsentData() {
            let consentData: [String: Any] = [
                "ccpa": [
                    "consents": [
                        "applies": true,
                        "consentedAll": true,
                        "rejectedAll": false,
                        "rejectedVendors": [],
                        "rejectedCategories": [],
                        "dateCreated": "2026-11-02T15:11:20.713Z",
                        "expirationDate": "2027-11-02T15:11:20.563Z",
                        "GPPData": [
                            "IABGPP_7_String": "BVQqAAAAAgA",
                            "IABGPP_GppSID": "7",
                            "IABGPP_HDR_GppString": "DBABLA~BVQqAAAAAgA",
                            "IABGPP_HDR_Sections": "7",
                            "IABGPP_HDR_Version": "1",
                            "IABGPP_USNAT_Gpc": 0,
                            "IABGPP_USNAT_GpcSegmentType": 1,
                            "IABGPP_USNAT_KnownChildSensitiveDataConsents": "0_0",
                            "IABGPP_USNAT_MspaCoveredTransaction": 2,
                            "IABGPP_USNAT_MspaOptOutOptionMode": 0,
                            "IABGPP_USNAT_MspaServiceProviderMode": 0,
                            "IABGPP_USNAT_PersonalDataConsents": 0,
                            "IABGPP_USNAT_SaleOptOut": 2,
                            "IABGPP_USNAT_SaleOptOutNotice": 1,
                            "IABGPP_USNAT_SensitiveDataLimitUseNotice": 0,
                            "IABGPP_USNAT_SensitiveDataProcessing": "0_0_0_0_0_0_0_0_0_0_0_0",
                            "IABGPP_USNAT_SensitiveDataProcessingOptOutNotice": 0,
                            "IABGPP_USNAT_SharingNotice": 1,
                            "IABGPP_USNAT_SharingOptOut": 2,
                            "IABGPP_USNAT_SharingOptOutNotice": 1,
                            "IABGPP_USNAT_TargetedAdvertisingOptOut": 2,
                            "IABGPP_USNAT_TargetedAdvertisingOptOutNotice": 1,
                            "IABGPP_USNAT_Version": 1
                        ],
                        "signedLspa": false,
                        "status": "consentedAll",
                        "uuid": "51757a9e-31a3-4f2b-bc49-5314094075a6",
                        "webConsentPayload": "{\"actions\":[],\"cookies\":[{\"key\":\"ccpaConsentAll\",\"value\":true,\"setPath\":true,\"maxAge\":31536000},{\"key\":\"ccpaReject\",\"value\":false,\"setPath\":true,\"maxAge\":31536000},{\"key\":\"consentStatus\",\"value\":\"consentedAll\",\"setPath\":true,\"maxAge\":31536000}],\"consentedAll\":true,\"dateCreated\":\"2026-11-02T15:11:20.563Z\",\"expirationDate\":\"2027-11-02T15:11:20.563Z\",\"rejectedAll\":false,\"rejectedCategories\":[],\"rejectedVendors\":[],\"signedLspa\":false,\"status\":\"consentedAll\"}"
                    ],
                    "metaData": [
                        "wasSampled": true,
                        "wasSampledAt": 1
                    ]
                ]
            ]

            // Convert to JSON and store as Data (not string)
            if let jsonData = try? JSONSerialization.data(withJSONObject: consentData, options: []) {
                // Store in UserDefaults with the key that Sourcepoint SDK uses for Didomi migration
                UserDefaults.standard.set(jsonData, forKey: "sp.state")
                UserDefaults.standard.synchronize()

                // Verify the data was set
                let stored = UserDefaults.standard.data(forKey: "sp.state")
                print("✓ Sourcepoint CCPA data stored: \(stored != nil), size: \(stored?.count ?? 0) bytes")
            } else {
                print("✗ Failed to serialize Sourcepoint CCPA consent data")
            }
        }

        // Helper function to set up Sourcepoint USNAT consent data
        func setupSourcepointUSNATConsentData() {
            let consentData: [String: Any] = [
                "usnat": [
                    "consents": [
                        "applies": true,
                        "consentStatus": [
                            "consentedToAll": true,
                            "consentedToAny": true,
                            "granularStatus": [
                                "gpcStatus": false,
                                "sellStatus": true,
                                "sensitiveDataStatus": true,
                                "shareStatus": true
                            ],
                            "hasConsentData": true,
                            "rejectedAny": false
                        ],
                        "consentStrings": [
                            [
                                "consentString": "BVqqqgIA",
                                "sectionId": 12,
                                "sectionName": "usct"
                            ]
                        ],
                        "dateCreated": "2026-11-02T15:11:23.837Z",
                        "GPPData": [
                            "IABGPP_12_String": "BVqqqgIA",
                            "IABGPP_GppSID": "12",
                            "IABGPP_HDR_GppString": "DBABVg~BVqqqgIA",
                            "IABGPP_HDR_Sections": "12",
                            "IABGPP_HDR_Version": "1",
                            "IABGPP_USCT_Gpc": 0,
                            "IABGPP_USCT_GpcSegmentType": 1,
                            "IABGPP_USCT_KnownChildSensitiveDataConsents": "0_0_0",
                            "IABGPP_USCT_MspaCoveredTransaction": 2,
                            "IABGPP_USCT_MspaOptOutOptionMode": 0,
                            "IABGPP_USCT_MspaServiceProviderMode": 0,
                            "IABGPP_USCT_SaleOptOut": 2,
                            "IABGPP_USCT_SaleOptOutNotice": 1,
                            "IABGPP_USCT_SensitiveDataProcessing": "2_2_2_2_2_2_2_2",
                            "IABGPP_USCT_SharingNotice": 1,
                            "IABGPP_USCT_TargetedAdvertisingOptOut": 2,
                            "IABGPP_USCT_TargetedAdvertisingOptOutNotice": 1,
                            "IABGPP_USCT_Version": 1
                        ],
                        "userConsents": [
                            "categories": [
                                ["_id": "65a6a785cc78fac48ab34e65", "consented": true, "systemId": 5],
                                ["_id": "65a6a785cc78fac48ab34e6a", "consented": true, "systemId": 4],
                                ["_id": "65a6a785cc78fac48ab34e6f", "consented": true, "systemId": 6],
                                ["_id": "65a6a785cc78fac48ab34e74", "consented": true, "systemId": 7],
                                ["_id": "65a6a785cc78fac48ab34e79", "consented": true, "systemId": 8],
                                ["_id": "65a6a785cc78fac48ab34e7e", "consented": true, "systemId": 9],
                                ["_id": "65a6a785cc78fac48ab34e83", "consented": true, "systemId": 10],
                                ["_id": "65a6a785cc78fac48ab34e88", "consented": true, "systemId": 11],
                                ["_id": "65a6a785cc78fac48ab34e8d", "consented": true, "systemId": 12],
                                ["_id": "65a6a785cc78fac48ab34e92", "consented": true, "systemId": 13],
                                ["_id": "65a6a785cc78fac48ab34e97", "consented": true, "systemId": 15],
                                ["_id": "65a6a785cc78fac48ab34e9c", "consented": true, "systemId": 14],
                                ["_id": "648c9c48e17a3c7a82360c54", "consented": true, "systemId": 3]
                            ]
                        ],
                        "uuid": "24764a40-a0aa-49d9-95ee-d2f1e111aacc_143",
                        "webConsentPayload": "{\"actions\":[],\"categories\":[\"65a6a785cc78fac48ab34e65\",\"65a6a785cc78fac48ab34e6a\",\"65a6a785cc78fac48ab34e6f\",\"65a6a785cc78fac48ab34e74\",\"65a6a785cc78fac48ab34e79\",\"65a6a785cc78fac48ab34e7e\",\"65a6a785cc78fac48ab34e83\",\"65a6a785cc78fac48ab34e88\",\"65a6a785cc78fac48ab34e8d\",\"65a6a785cc78fac48ab34e92\",\"65a6a785cc78fac48ab34e97\",\"65a6a785cc78fac48ab34e9c\",\"648c9c48e17a3c7a82360c54\"],\"consentStatus\":{\"rejectedAny\":false,\"consentedToAll\":true,\"consentedToAny\":true,\"granularStatus\":{\"sellStatus\":true,\"shareStatus\":true,\"sensitiveDataStatus\":true,\"gpcStatus\":false},\"hasConsentData\":true,\"previousOptInAll\":false},\"consentStrings\":[{\"sectionId\":12,\"sectionName\":\"usct\",\"consentString\":\"BVqqqgIA\"}],\"cookies\":[{\"key\":\"usnatUUID\",\"value\":\"24764a40-a0aa-49d9-95ee-d2f1e111aacc_143\",\"maxAge\":31536000,\"shareRootDomain\":true},{\"key\":\"consentDateUsnat\",\"value\":\"2026-11-02T15:11:23.837Z\",\"maxAge\":31536000,\"shareRootDomain\":true}],\"dateCreated\":\"2026-11-02T15:11:23.837Z\",\"userConsents\":{\"applies\":true,\"categories\":[{\"_id\":\"65a6a785cc78fac48ab34e65\",\"systemId\":5,\"consented\":true},{\"_id\":\"65a6a785cc78fac48ab34e6a\",\"systemId\":4,\"consented\":true},{\"_id\":\"65a6a785cc78fac48ab34e6f\",\"systemId\":6,\"consented\":true},{\"_id\":\"65a6a785cc78fac48ab34e74\",\"systemId\":7,\"consented\":true},{\"_id\":\"65a6a785cc78fac48ab34e79\",\"systemId\":8,\"consented\":true},{\"_id\":\"65a6a785cc78fac48ab34e7e\",\"systemId\":9,\"consented\":true},{\"_id\":\"65a6a785cc78fac48ab34e83\",\"systemId\":10,\"consented\":true},{\"_id\":\"65a6a785cc78fac48ab34e88\",\"systemId\":11,\"consented\":true},{\"_id\":\"65a6a785cc78fac48ab34e8d\",\"systemId\":12,\"consented\":true},{\"_id\":\"65a6a785cc78fac48ab34e92\",\"systemId\":13,\"consented\":true},{\"_id\":\"65a6a785cc78fac48ab34e97\",\"systemId\":15,\"consented\":true},{\"_id\":\"65a6a785cc78fac48ab34e9c\",\"systemId\":14,\"consented\":true},{\"_id\":\"648c9c48e17a3c7a82360c54\",\"systemId\":3,\"consented\":true}],\"vendors\":[]},\"uuid\":\"24764a40-a0aa-49d9-95ee-d2f1e111aacc_143\"}"
                    ],
                    "metaData": [
                        "additionsChangeDate": "2024-04-04T16:45:00.631Z",
                        "applicableSections": [12],
                        "vendorListId": "65a01016e17a3c7a831ec515",
                        "wasSampled": true,
                        "wasSampledAt": 1
                    ]
                ]
            ]

            // Convert to JSON and store as Data (not string)
            if let jsonData = try? JSONSerialization.data(withJSONObject: consentData, options: []) {
                // Store in UserDefaults with the key that Sourcepoint SDK uses for Didomi migration
                UserDefaults.standard.set(jsonData, forKey: "sp.state")
                UserDefaults.standard.synchronize()

                // Verify the data was set
                let stored = UserDefaults.standard.data(forKey: "sp.state")
                print("✓ Sourcepoint USNAT data stored: \(stored != nil), size: \(stored?.count ?? 0) bytes")
            } else {
                print("✗ Failed to serialize Sourcepoint USNAT consent data")
            }
        }
    }
}

// Mock delegate for testing
class MockDidomiDelegate: SPDelegate {
    private let queue = DispatchQueue(label: "MockDidomiDelegate", attributes: .concurrent)

    private var _isOnSPUIFinishedCalled = false
    private var _isOnSPUIReadyCalled = false
    private var _isOnErrorCalled = false
    private var _isOnActionCalled = false
    private var _isOnConsentReadyCalled = false
    private var _isOnSPFinishedCalled = false

    var isOnSPUIFinishedCalled: Bool {
        queue.sync { _isOnSPUIFinishedCalled }
    }
    var isOnSPUIReadyCalled: Bool {
        queue.sync { _isOnSPUIReadyCalled }
    }
    var isOnErrorCalled: Bool {
        queue.sync { _isOnErrorCalled }
    }
    var isOnActionCalled: Bool {
        queue.sync { _isOnActionCalled }
    }
    var isOnConsentReadyCalled: Bool {
        queue.sync { _isOnConsentReadyCalled }
    }
    var isOnSPFinishedCalled: Bool {
        queue.sync { _isOnSPFinishedCalled }
    }

    var capturedUserData: SPUserData?
    var capturedAction: SPAction?
    var capturedError: SPError?

    func onError(error: SPError) {
        print("MockDelegate: onError called on thread: \(Thread.current)")
        queue.async(flags: .barrier) {
            self._isOnErrorCalled = true
        }
        capturedError = error
    }

    func onSPUIReady(_ controller: UIViewController) {
        print("MockDelegate: onSPUIReady called on thread: \(Thread.current)")
        queue.async(flags: .barrier) {
            self._isOnSPUIReadyCalled = true
        }
    }

    func onAction(_ action: SPAction, from controller: UIViewController) {
        print("MockDelegate: onAction called on thread: \(Thread.current)")
        queue.async(flags: .barrier) {
            self._isOnActionCalled = true
        }
        capturedAction = action
    }

    func onSPUIFinished(_ controller: UIViewController) {
        print("MockDelegate: onSPUIFinished called on thread: \(Thread.current)")
        queue.async(flags: .barrier) {
            self._isOnSPUIFinishedCalled = true
        }
    }

    func onConsentReady(userData: SPUserData) {
        print("MockDelegate: onConsentReady called on thread: \(Thread.current)")
        queue.async(flags: .barrier) {
            self._isOnConsentReadyCalled = true
        }
        capturedUserData = userData
    }

    func onSPFinished(userData: SPUserData) {
        print("MockDelegate: onSPFinished called on thread: \(Thread.current)")
        queue.async(flags: .barrier) {
            self._isOnSPFinishedCalled = true
        }
        capturedUserData = userData
    }
}

// swiftlint:enable force_try function_body_length line_length
