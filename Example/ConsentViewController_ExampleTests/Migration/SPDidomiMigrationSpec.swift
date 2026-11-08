//
//  SPDidomiMigrationSpec.swift
//  ConsentViewController_ExampleTests
//
//  Integration test for Didomi SDK's Sourcepoint consent data migration.
//
//  With existing Sourcepoint data (`sp.state`) and `loadMessage` called, Didomi migrates the data
//  and no notice must be shown: `onSPUIReady` is never called, while `onConsentReady` and
//  `onSPFinished` are called with `SPUserData` mapped back from the migrated Didomi data.
//

@testable import ConsentViewController
import Didomi
import Foundation
import Nimble
import Quick
import XCTest

// swiftlint:disable force_try function_body_length line_length type_body_length

private enum Ids {
    static let gdprVendors = [
        "5e7ced57b8e05c485246cce0",
        "5e7e1298b8e05c4854221be9",
        "5f1b2fbeb8e05c306f2a1eb9",
        "5ff4d000a228633ac048be41"
    ]
    /// Consent purposes each GDPR vendor declares in `SourcepointConfigGDPR.json`
    static let gdprVendorPurposes: [String: Set<String>] = [
        "5e7ced57b8e05c485246cce0": ["60b65857619abe242bed971e", "608bad95d08d3112188e0e29", "608bad95d08d3112188e0e36", "608bad96d08d3112188e0e59"],
        "5e7e1298b8e05c4854221be9": ["65c4a19739cd2b04ba0cb4a6", "65c4a19739cd2b04ba0cb4b0", "65c4a19739cd2b04ba0cb4ba", "65c4a19739cd2b04ba0cb49c"],
        "5f1b2fbeb8e05c306f2a1eb9": ["608bad95d08d3112188e0e29", "608bad95d08d3112188e0e2f"],
        "5ff4d000a228633ac048be41": ["608bad95d08d3112188e0e36"]
    ]
    static let gdprConsentCategories: Set<String> = [
        "60b65857619abe242bed971e", "608bad95d08d3112188e0e29", "608bad95d08d3112188e0e36", "608bad96d08d3112188e0e59",
        "65c4a19739cd2b04ba0cb49c", "65c4a19739cd2b04ba0cb4a6", "65c4a19739cd2b04ba0cb4b0", "65c4a19739cd2b04ba0cb4ba"
    ]
    static let gdprLegIntCategory = "608bad95d08d3112188e0e2f"
    static let gdprLegIntVendor = "5f1b2fbeb8e05c306f2a1eb9"

    static let usVendors = ["5e37fc3e56a5e60e003a7120", "602f88b0a228631ff1133d19", "5e71706f69966540e4554efd"]
    static let usCategories = [
        "65a6a785cc78fac48ab34e65", "65a6a785cc78fac48ab34e6a", "65a6a785cc78fac48ab34e6f", "65a6a785cc78fac48ab34e74",
        "65a6a785cc78fac48ab34e79", "65a6a785cc78fac48ab34e7e", "65a6a785cc78fac48ab34e83", "65a6a785cc78fac48ab34e88",
        "65a6a785cc78fac48ab34e8d", "65a6a785cc78fac48ab34e92", "65a6a785cc78fac48ab34e97", "65a6a785cc78fac48ab34e9c",
        "648c9c48e17a3c7a82360c54"
    ]
}

/// One migration scenario: Sourcepoint data for a legislation + the Didomi config that resolves to it
private struct MigrationScenario {
    let name: String
    let config: String
    let setup: () -> Void
    /// `dateCreated` of the Sourcepoint data, the migration must preserve it
    let dateCreated: String
    let verify: (SPUserData) -> Void
}

private func isoDate(_ string: String) -> Date {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    return formatter.date(from: string)!
}

private func verifyGDPR(_ userData: SPUserData, accepted: Bool) {
    expect(userData.ccpa).to(beNil())
    expect(userData.usnat).to(beNil())
    guard let gdpr = userData.gdpr, let consents = gdpr.consents else {
        fail("userData.gdpr.consents should not be nil")
        return
    }
    expect(gdpr.applies).to(beTrue())
    expect(consents.euconsent).toNot(beEmpty())

    // Every vendor has a grant, with purpose granularity. Rejected vendors have `granted: false` grants.
    expect(Set(consents.vendorGrants.keys)).to(equal(Set(Ids.gdprVendors)))
    for (vendorId, grant) in consents.vendorGrants {
        expect(grant.granted).to(equal(accepted), description: "vendor \(vendorId) granted")
        let purposeGrants = grant.purposeGrants
        expect(Set(purposeGrants.keys)).to(equal(Ids.gdprVendorPurposes[vendorId]), description: "purposes of vendor \(vendorId)")
        for (purposeId, granted) in purposeGrants {
            expect(granted).to(equal(accepted), description: "purpose \(purposeId) of vendor \(vendorId)")
        }
    }

    expect(Set(consents.acceptedVendors)).to(equal(accepted ? Set(Ids.gdprVendors) : []))
    expect(Set(consents.acceptedCategories)).to(equal(accepted ? Ids.gdprConsentCategories : []))
    expect(Set(consents.acceptedLegIntVendors)).to(equal(accepted ? [Ids.gdprLegIntVendor] : []))
    expect(Set(consents.acceptedLegIntCategories)).to(equal(accepted ? [Ids.gdprLegIntCategory] : []))

    // Consent status derived from the migrated Didomi status
    let status = consents.consentStatus
    let scope = accepted ? "ALL" : "NONE"
    expect(status.hasConsentData).to(beTrue())
    expect(status.consentedAll).to(equal(accepted))
    expect(status.consentedToAll).to(equal(accepted))
    expect(status.consentedToAny).to(equal(accepted))
    expect(status.rejectedAll).to(equal(!accepted))
    expect(status.rejectedAny).to(equal(!accepted))
    expect(status.rejectedLI).to(equal(!accepted))
    expect(status.granularStatus?.vendorConsent).to(equal(scope))
    expect(status.granularStatus?.vendorLegInt).to(equal(scope))
    expect(status.granularStatus?.purposeConsent).to(equal(scope))
    expect(status.granularStatus?.purposeLegInt).to(equal(scope))

    // TCF data: TC string from Didomi, the rest of the IABTCF_ values as Didomi stored them
    let tcfData = consents.tcfData?.objectValue
    expect(tcfData?["IABTCF_TCString"]?.stringValue).to(equal(consents.euconsent))
    expect(tcfData?["IABTCF_gdprApplies"]).to(equal(.number(1)))
    expect(tcfData?["IABTCF_PurposeConsents"]?.stringValue).toNot(beNil())
    expect(tcfData?["IABTCF_VendorConsents"]?.stringValue).toNot(beNil())
}

private func verifyCCPA(_ userData: SPUserData, accepted: Bool) {
    expect(userData.gdpr).to(beNil())
    expect(userData.usnat).to(beNil())
    guard let ccpa = userData.ccpa, let consents = ccpa.consents else {
        fail("userData.ccpa.consents should not be nil")
        return
    }
    expect(ccpa.applies).to(beTrue())
    if accepted {
        expect(consents.status).to(equal(CCPAConsentStatus.RejectedNone))
        expect(consents.rejectedVendors).to(beEmpty())
        expect(consents.rejectedCategories).to(beEmpty())
    } else {
        expect(consents.status).to(equal(CCPAConsentStatus.RejectedAll))
        expect(Set(consents.rejectedVendors)).to(equal(Set(Ids.usVendors)))
        expect(Set(consents.rejectedCategories)).to(equal(Set(Ids.usCategories)))
    }
    verifyGPPData(consents.GPPData)

    // US Privacy String as Didomi stored it: version 1, notice given, opted out only if rejected, LSPA signed (config)
    expect(consents.uspstring).to(equal(accepted ? "1YNY" : "1YYY"))
    expect(consents.signedLspa).to(beTrue())
}

/// GPP data comes from Didomi's `gppString`, not from `UserDefaults`
private func verifyGPPData(_ gppData: SPJson?) {
    let gppString = gppData?.objectValue?["IABGPP_HDR_GppString"]?.stringValue
    expect(gppString).toNot(beNil())
    expect(gppString).toNot(beEmpty())
    guard let gpp = gppString.flatMap({ GPPString($0) }) else {
        fail("GPP data should hold a valid GPP string, got \(String(describing: gppString))")
        return
    }
    expect(gppData?.objectValue?["IABGPP_GppSID"]?.stringValue).to(equal(gpp.sections.map { String($0.id) }.joined(separator: "_")))
    for section in gpp.sections {
        expect(gppData?.objectValue?["IABGPP_\(section.id)_String"]?.stringValue).to(equal(section.value))
    }
}

private func verifyUSNat(_ userData: SPUserData, accepted: Bool) {
    expect(userData.gdpr).to(beNil())
    expect(userData.ccpa).to(beNil())
    guard let usnat = userData.usnat, let consents = usnat.consents else {
        fail("userData.usnat.consents should not be nil")
        return
    }
    expect(usnat.applies).to(beTrue())
    expect(Set(consents.vendors.map { $0.id })).to(equal(Set(Ids.usVendors)))
    expect(Set(consents.categories.map { $0.id })).to(equal(Set(Ids.usCategories)))
    for vendor in consents.vendors {
        expect(vendor.consented).to(equal(accepted), description: "vendor \(vendor.id) consented")
    }
    for category in consents.categories {
        expect(category.consented).to(equal(accepted), description: "category \(category.id) consented")
    }
    let statuses = consents.statuses
    expect(statuses.hasConsentData).to(beTrue())
    expect(statuses.consentedToAll).to(equal(accepted))
    expect(statuses.consentedToAny).to(equal(accepted))
    expect(statuses.rejectedAny).to(equal(!accepted))
    expect(consents.consentStrings).toNot(beEmpty())
    for consentString in consents.consentStrings {
        expect(consentString.sectionName).to(equal(GPPString.usSectionNames[consentString.sectionId]))
        expect(consentString.consentString).toNot(beEmpty())
    }
    verifyGPPData(consents.GPPData)
}

class SPDidomiMigrationSpec: QuickSpec {
    override class func spec() {
        describe("GPPString") {
            it("reads the section ids from the header") {
                expect(GPPString("DBABLA~BVQqAAAAAgA")?.sections).to(equal([GPPString.Section(id: 7, value: "BVQqAAAAAgA")]))
                expect(GPPString("DBABVg~BVqqqgIA")?.sections).to(equal([GPPString.Section(id: 12, value: "BVqqqgIA")]))
            }

            it("reads several sections") {
                // Example from the GPP spec: sections 2 (tcfeuv2) and 6 (uspv1)
                let gpp = GPPString("DBACNYA~CPXxRfAPXxRfAAfKABENB-CgAAAAAAAAAAYgAAAAAAAA~1YNN")
                expect(gpp?.sections).to(equal([
                    GPPString.Section(id: 2, value: "CPXxRfAPXxRfAAfKABENB-CgAAAAAAAAAAYgAAAAAAAA"),
                    GPPString.Section(id: 6, value: "1YNN")
                ]))
            }

            it("returns nil for invalid strings") {
                expect(GPPString("")).to(beNil())
                expect(GPPString("DBABLA")).to(beNil())
                expect(GPPString("not-gpp~BVQqAAAAAgA")).to(beNil())
            }
        }

        describe("Didomi SDK Sourcepoint Consent Migration") {
            let accountId = 22
            let propertyId = 16893
            let propertyName = try! SPPropertyName("mobile.multicampaign.demo")
            let campaigns = SPCampaigns(
                gdpr: SPCampaign(),
                ccpa: SPCampaign(),
                usnat: SPCampaign()
            )

            let scenarios = [
                MigrationScenario(name: "GDPR accept all", config: "SourcepointConfigGDPR", setup: setupSourcepointGDPRConsentData, dateCreated: "2026-11-02T15:19:01.957Z") { verifyGDPR($0, accepted: true) },
                MigrationScenario(name: "GDPR reject all", config: "SourcepointConfigGDPR", setup: setupSourcepointGDPRRejectAllConsentData, dateCreated: "2026-11-06T10:53:08.816Z") { verifyGDPR($0, accepted: false) },
                MigrationScenario(name: "CCPA accept all", config: "SourcepointConfigCCPA", setup: setupSourcepointCCPAConsentData, dateCreated: "2026-11-02T15:11:20.713Z") { verifyCCPA($0, accepted: true) },
                MigrationScenario(name: "CCPA reject all", config: "SourcepointConfigCCPA", setup: setupSourcepointCCPARejectAllConsentData, dateCreated: "2026-11-06T10:53:10.891Z") { verifyCCPA($0, accepted: false) },
                MigrationScenario(name: "USNAT accept all", config: "SourcepointConfigUSNAT", setup: setupSourcepointUSNATConsentData, dateCreated: "2026-11-06T09:34:15.658Z") { verifyUSNat($0, accepted: true) },
                MigrationScenario(name: "USNAT reject all", config: "SourcepointConfigUSNAT", setup: setupSourcepointUSNATRejectAllConsentData, dateCreated: "2026-11-06T09:34:15.658Z") { verifyUSNat($0, accepted: false) }
            ]

            for scenario in scenarios {
                context("when Sourcepoint \(scenario.name) data exists and Didomi data does not") {
                    var mockDelegate: MockDidomiDelegate!
                    var consentManager: SPDidomiConsentManager!

                    beforeEach {
                        resetDidomi()
                        clearAllConsentData()
                        scenario.setup()

                        // Enable bundle swizzling to redirect config file lookups
                        BundleSwizzler.enableConfigFileRedirection(scenario.config)

                        mockDelegate = MockDidomiDelegate()
                        consentManager = SPDidomiConsentManager(
                            accountId: accountId,
                            propertyId: propertyId,
                            propertyName: propertyName,
                            campaigns: campaigns,
                            language: .BrowserDefault,
                            delegate: mockDelegate,
                            configFileName: scenario.config
                        )
                    }

                    afterEach {
                        BundleSwizzler.disableConfigFileRedirection()
                        resetDidomi()
                        clearAllConsentData()
                        mockDelegate = nil
                        consentManager = nil
                    }

                    it("migrates without showing a notice and calls onConsentReady and onSPFinished with the migrated userData") {
                        consentManager.loadMessage(forAuthId: nil, publisherData: SPPublisherData())

                        expect(mockDelegate.count(.consentReady)).toEventually(equal(1), timeout: .seconds(10))
                        expect(mockDelegate.count(.finished)).toEventually(equal(1), timeout: .seconds(10))

                        // No notice: onSPUIReady must never be called, not even after a grace period
                        expect(mockDelegate.count(.uiReady)).toNever(beGreaterThan(0), until: .seconds(2))
                        expect(mockDelegate.count(.uiFinished)).to(equal(0))
                        expect(mockDelegate.count(.action)).to(equal(0))
                        expect(mockDelegate.count(.error)).to(equal(0))
                        expect(Didomi.shared.isNoticeVisible()).to(beFalse())
                        expect(Didomi.shared.isPreferencesVisible()).to(beFalse())
                        expect(Didomi.shared.shouldUserStatusBeCollected()).to(beFalse())

                        // Each of the callbacks was called exactly once, consent first
                        expect(mockDelegate.count(.consentReady)).to(equal(1))
                        expect(mockDelegate.count(.finished)).to(equal(1))
                        expect(mockDelegate.events).to(equal([.consentReady, .finished]))

                        // Both callbacks and the manager see the very same migrated data
                        guard let consentReadyData = mockDelegate.consentReadyUserData,
                              let finishedData = mockDelegate.finishedUserData else {
                            fail("userData should be passed to onConsentReady and onSPFinished")
                            return
                        }
                        let managerData = consentManager.userData
                        for other in [consentReadyData, managerData] {
                            expect(other.gdpr == finishedData.gdpr).to(beTrue(), description: "gdpr differs between callbacks and manager")
                            expect(other.ccpa == finishedData.ccpa).to(beTrue(), description: "ccpa differs between callbacks and manager")
                            expect(other.usnat == finishedData.usnat).to(beTrue(), description: "usnat differs between callbacks and manager")
                        }

                        scenario.verify(finishedData)

                        // The migration preserves the date the consent was originally given
                        let createdAt = (finishedData.gdpr?.consents?.dateCreated
                            ?? finishedData.ccpa?.consents?.dateCreated
                            ?? finishedData.usnat?.consents?.dateCreated)?.date
                        expect(createdAt).toNot(beNil())
                        expect(createdAt?.timeIntervalSince1970).to(beCloseTo(isoDate(scenario.dateCreated).timeIntervalSince1970, within: 1))
                    }
                }
            }
        }

        // `Didomi.shared.reset()` called before the SDK is ready is deferred until it is, which would wipe the
        // migrated consent. So only reset an SDK that is already ready (left over from a previous scenario).
        func resetDidomi() {
            if Didomi.shared.isReady() {
                Didomi.shared.reset()
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
                            "consentedAll": true,
                            "consentedToAny": true,
                            "granularStatus": [
                                "defaultConsent": false,
                                "previousOptInAll": false,
                                "purposeConsent": "ALL",
                                "purposeLegInt": "ALL",
                                "vendorConsent": "ALL",
                                "vendorLegInt": "ALL"
                            ],
                            "hasConsentData": true,
                            "rejectedAny": false,
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
                                    "608bad95d08d3112188e0e36": true
                                ],
                                "vendorGrant": true
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
                            "5e7ced57b8e05c485246cce0",
                            "5ff4d000a228633ac048be41"
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
            } else {
            }

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
            } else {
            }

        }

        // Helper function to set up Sourcepoint USNAT consent data
        func setupSourcepointUSNATConsentData() {
            let consentData: [String: Any] = [
                "usNat": [
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
                            ] as [String: Any],
                            "hasConsentData": true,
                            "rejectedAny": false
                        ] as [String: Any],
                        "consentStrings": [
                            [
                                "consentString": "BVqqqgIA",
                                "sectionId": 12,
                                "sectionName": "usct"
                            ] as [String: Any]
                        ],
                        "dateCreated": "2026-11-06T09:34:15.658Z",
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
                        ] as [String: Any],
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
                            ],
                            "vendors": [
                                ["_id": "5e37fc3e56a5e60e003a7120", "consented": true],
                                ["_id": "602f88b0a228631ff1133d19", "consented": true],
                                ["_id": "5e71706f69966540e4554efd", "consented": true]
                            ]
                        ] as [String: Any],
                        "uuid": "2e46a615-b65f-4fbd-895d-1bdcafd92887",
                        "webConsentPayload": "{\"actions\":[],\"categories\":[],\"consentStatus\":{\"rejectedAny\":false,\"consentedToAll\":true,\"consentedToAny\":false,\"granularStatus\":{\"sellStatus\":false,\"shareStatus\":false,\"sensitiveDataStatus\":false,\"gpcStatus\":false},\"hasConsentData\":false,\"previousOptInAll\":false},\"consentStrings\":[],\"cookies\":[],\"dateCreated\":\"2026-11-06T09:49:53.590Z\",\"userConsents\":{\"applies\":false,\"categories\":[{\"_id\":\"65a6a785cc78fac48ab34e65\",\"systemId\":5,\"consented\":true},{\"_id\":\"65a6a785cc78fac48ab34e6a\",\"systemId\":4,\"consented\":true},{\"_id\":\"65a6a785cc78fac48ab34e6f\",\"systemId\":6,\"consented\":true},{\"_id\":\"65a6a785cc78fac48ab34e74\",\"systemId\":7,\"consented\":true},{\"_id\":\"65a6a785cc78fac48ab34e79\",\"systemId\":8,\"consented\":true},{\"_id\":\"65a6a785cc78fac48ab34e7e\",\"systemId\":9,\"consented\":true},{\"_id\":\"65a6a785cc78fac48ab34e83\",\"systemId\":10,\"consented\":true},{\"_id\":\"65a6a785cc78fac48ab34e88\",\"systemId\":11,\"consented\":true},{\"_id\":\"65a6a785cc78fac48ab34e8d\",\"systemId\":12,\"consented\":true},{\"_id\":\"65a6a785cc78fac48ab34e92\",\"systemId\":13,\"consented\":true},{\"_id\":\"65a6a785cc78fac48ab34e97\",\"systemId\":15,\"consented\":true},{\"_id\":\"65a6a785cc78fac48ab34e9c\",\"systemId\":14,\"consented\":true},{\"_id\":\"648c9c48e17a3c7a82360c54\",\"systemId\":3,\"consented\":true}],\"vendors\":[{\"_id\":\"5e37fc3e56a5e60e003a7120\",\"consented\":true},{\"_id\":\"602f88b0a228631ff1133d19\",\"consented\":true},{\"_id\":\"5e71706f69966540e4554efd\",\"consented\":true}]}}"
                    ] as [String: Any],
                    "metaData": [
                        "additionsChangeDate": "2024-04-04T16:45:00.631Z",
                        "applicableSections": [12],
                        "messagePartitionUUID": "7c963ff3-5d49-465f-b21e-83c0ba1e0ab9",
                        "vendorListId": "65a01016e17a3c7a831ec515",
                        "wasSampled": true,
                        "wasSampledAt": 1
                    ] as [String: Any]
                ] as [String: Any]
            ]

            // Convert to JSON and store as Data (not string)
            if let jsonData = try? JSONSerialization.data(withJSONObject: consentData, options: []) {
                // Store in UserDefaults with the key that Sourcepoint SDK uses for Didomi migration
                UserDefaults.standard.set(jsonData, forKey: "sp.state")
                UserDefaults.standard.synchronize()

                // Verify the data was set
                let stored = UserDefaults.standard.data(forKey: "sp.state")
            } else {
            }

        }

        // Helper function to set up Sourcepoint GDPR reject all consent data
        func setupSourcepointGDPRRejectAllConsentData() {
            let consentData: [String: Any] = [
                "gdpr": [
                    "consents": [
                        "applies": true,
                        "categories": [] as [String],
                        "vendors": [] as [String],
                        "legIntCategories": [] as [String],
                        "legIntVendors": [] as [String],
                        "consentStatus": [
                            "consentedAll": false,
                            "consentedToAny": false,
                            "granularStatus": [
                                "defaultConsent": false,
                                "previousOptInAll": false,
                                "purposeConsent": "NONE",
                                "purposeLegInt": "NONE",
                                "vendorConsent": "NONE",
                                "vendorLegInt": "NONE"
                            ] as [String: Any],
                            "hasConsentData": true,
                            "rejectedAny": true,
                            "rejectedLI": true
                        ] as [String: Any],
                        "dateCreated": "2026-11-06T10:53:08.816Z",
                        "euconsent": "CQtQvUAQtQvUAAGABCENC3FgAAAAAAAAAAiQAAAAAAAA.IASAAAAAAQAA.YAAAAAAAAAAA",
                        "grants": [
                            "5e7ced57b8e05c485246cce0": [
                                "purposeGrants": [
                                    "60b65857619abe242bed971e": false,
                                    "608bad95d08d3112188e0e29": false,
                                    "608bad95d08d3112188e0e36": false,
                                    "608bad96d08d3112188e0e59": false
                                ] as [String: Any],
                                "vendorGrant": false
                            ] as [String: Any],
                            "5e7e1298b8e05c4854221be9": [
                                "purposeGrants": [
                                    "65c4a19739cd2b04ba0cb4a6": false,
                                    "65c4a19739cd2b04ba0cb4b0": false,
                                    "65c4a19739cd2b04ba0cb4ba": false,
                                    "65c4a19739cd2b04ba0cb49c": false
                                ] as [String: Any],
                                "vendorGrant": false
                            ] as [String: Any],
                            "5f1b2fbeb8e05c306f2a1eb9": [
                                "purposeGrants": [
                                    "608bad95d08d3112188e0e2f": false,
                                    "608bad95d08d3112188e0e29": false
                                ] as [String: Any],
                                "vendorGrant": false
                            ] as [String: Any],
                            "5ff4d000a228633ac048be41": [
                                "purposeGrants": [
                                    "608bad95d08d3112188e0e36": false
                                ] as [String: Any],
                                "vendorGrant": false
                            ] as [String: Any]
                        ] as [String: Any],
                        "TCData": [
                            "IABTCF_TCString": "CQtQvUAQtQvUAAGABCENC3FgAAAAAAAAAAiQAAAAAAAA.IASAAAAAAQAA.YAAAAAAAAAAA",
                            "IABTCF_gdprApplies": 1,
                            "IABTCF_PurposeConsents": "00000000000",
                            "IABTCF_VendorConsents": "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
                        ] as [String: Any],
                        "uuid": "53dcbf0d-e1db-4a27-9b4b-fb9f9c73236f_62"
                    ] as [String: Any],
                    "metaData": [
                        "messagePartitionUUID": "3f6971af-c031-4b48-9d98-9944c62547b8",
                        "vendorListId": "608badf1a22863112f750a18"
                    ] as [String: Any]
                ] as [String: Any]
            ]

            if let jsonData = try? JSONSerialization.data(withJSONObject: consentData, options: []) {
                UserDefaults.standard.set(jsonData, forKey: "sp.state")
                UserDefaults.standard.synchronize()

                // Verify the data was set
                let stored = UserDefaults.standard.data(forKey: "sp.state")

                // Debug: Print the actual JSON to verify structure
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print(jsonString)
                }
            } else {
            }
        }

        // Helper function to set up Sourcepoint CCPA reject all consent data
        func setupSourcepointCCPARejectAllConsentData() {
            let consentData: [String: Any] = [
                "ccpa": [
                    "consents": [
                        "applies": true,
                        "dateCreated": "2026-11-06T10:53:10.891Z",
                        "GPPData": [
                            "IABGPP_7_String": "BVQVAAAAAgA",
                            "IABGPP_GppSID": "7",
                            "IABGPP_HDR_GppString": "DBABLA~BVQVAAAAAgA"
                        ] as [String: Any],
                        "consentedAll": false,
                        "rejectedAll": true,
                        "signedLspa": false,
                        "status": "rejectedAll",
                        "rejectedCategories": [] as [String],
                        "rejectedVendors": [] as [String],
                        "uuid": "e9ccd840-e86f-4578-bdbe-c285cf14bcef"
                    ] as [String: Any],
                    "metaData": [
                        "messagePartitionUUID": "0f7a409a-23de-4598-a39a-148cc3aa7325"
                    ] as [String: Any]
                ] as [String: Any]
            ]

            if let jsonData = try? JSONSerialization.data(withJSONObject: consentData, options: []) {
                UserDefaults.standard.set(jsonData, forKey: "sp.state")
                UserDefaults.standard.synchronize()

                // Verify the data was set
                let stored = UserDefaults.standard.data(forKey: "sp.state")
            } else {
            }

        }

        // Helper function to set up Sourcepoint USNAT reject all consent data
        func setupSourcepointUSNATRejectAllConsentData() {
            let consentData: [String: Any] = [
                "usNat": [
                    "consents": [
                        "applies": true,
                        "consentStatus": [
                            "consentedToAll": false,
                            "consentedToAny": false,
                            "granularStatus": [
                                "gpcStatus": false,
                                "sellStatus": true,
                                "sensitiveDataStatus": true,
                                "shareStatus": true
                            ] as [String: Any],
                            "hasConsentData": true,
                            "rejectedAny": true
                        ] as [String: Any],
                        "consentStrings": [
                            [
                                "consentString": "BAAAAAAAA",
                                "sectionId": 12,
                                "sectionName": "usct"
                            ] as [String: Any]
                        ],
                        "dateCreated": "2026-11-06T09:34:15.658Z",
                        "GPPData": [
                            "IABGPP_12_String": "BAAAAAAAA",
                            "IABGPP_GppSID": "12"
                        ] as [String: Any],
                        "userConsents": [
                            "categories": [
                                ["_id": "65a6a785cc78fac48ab34e65", "consented": false, "systemId": 5],
                                ["_id": "65a6a785cc78fac48ab34e6a", "consented": false, "systemId": 4],
                                ["_id": "65a6a785cc78fac48ab34e6f", "consented": false, "systemId": 6],
                                ["_id": "65a6a785cc78fac48ab34e74", "consented": false, "systemId": 7],
                                ["_id": "65a6a785cc78fac48ab34e79", "consented": false, "systemId": 8],
                                ["_id": "65a6a785cc78fac48ab34e7e", "consented": false, "systemId": 9],
                                ["_id": "65a6a785cc78fac48ab34e83", "consented": false, "systemId": 10],
                                ["_id": "65a6a785cc78fac48ab34e88", "consented": false, "systemId": 11],
                                ["_id": "65a6a785cc78fac48ab34e8d", "consented": false, "systemId": 12],
                                ["_id": "65a6a785cc78fac48ab34e92", "consented": false, "systemId": 13],
                                ["_id": "65a6a785cc78fac48ab34e97", "consented": false, "systemId": 15],
                                ["_id": "65a6a785cc78fac48ab34e9c", "consented": false, "systemId": 14],
                                ["_id": "648c9c48e17a3c7a82360c54", "consented": false, "systemId": 3]
                            ],
                            "vendors": [
                                ["_id": "5e37fc3e56a5e60e003a7120", "consented": false],
                                ["_id": "602f88b0a228631ff1133d19", "consented": false],
                                ["_id": "5e71706f69966540e4554efd", "consented": false]
                            ]
                        ] as [String: Any],
                        "uuid": "2e46a615-b65f-4fbd-895d-1bdcafd92887"
                    ] as [String: Any],
                    "metaData": [
                        "messagePartitionUUID": "7c963ff3-5d49-465f-b21e-83c0ba1e0ab9",
                        "vendorListId": "65a01016e17a3c7a831ec515"
                    ] as [String: Any]
                ] as [String: Any]
            ]

            if let jsonData = try? JSONSerialization.data(withJSONObject: consentData, options: []) {
                UserDefaults.standard.set(jsonData, forKey: "sp.state")
                UserDefaults.standard.synchronize()

                // Verify the data was set
                let stored = UserDefaults.standard.data(forKey: "sp.state")
            } else {
            }

        }
    }
}

private extension NSLock {
    func sync<T>(_ block: () -> T) -> T {
        lock()
        defer { unlock() }
        return block()
    }
}

/// Records every SPDelegate callback, thread-safe (callbacks arrive on the main queue, tests poll from Nimble)
class MockDidomiDelegate: SPDelegate {
    enum Event: Equatable {
        case uiReady, uiFinished, action, error, consentReady, finished
    }

    private let lock = NSLock()
    private var _events: [Event] = []
    private var _consentReadyUserData: SPUserData?
    private var _finishedUserData: SPUserData?

    var events: [Event] { lock.sync { _events } }
    var consentReadyUserData: SPUserData? { lock.sync { _consentReadyUserData } }
    var finishedUserData: SPUserData? { lock.sync { _finishedUserData } }

    func count(_ event: Event) -> Int {
        lock.sync { _events.filter { $0 == event }.count }
    }

    func onError(error: SPError) {
        lock.sync { _events.append(.error) }
    }

    func onSPUIReady(_ controller: UIViewController) {
        lock.sync { _events.append(.uiReady) }
    }

    func onAction(_ action: SPAction, from controller: UIViewController) {
        lock.sync { _events.append(.action) }
    }

    func onSPUIFinished(_ controller: UIViewController) {
        lock.sync { _events.append(.uiFinished) }
    }

    func onConsentReady(userData: SPUserData) {
        lock.sync {
            _events.append(.consentReady)
            _consentReadyUserData = userData
        }
    }

    func onSPFinished(userData: SPUserData) {
        lock.sync {
            _events.append(.finished)
            _finishedUserData = userData
        }
    }
}

// swiftlint:enable force_try function_body_length line_length type_body_length
