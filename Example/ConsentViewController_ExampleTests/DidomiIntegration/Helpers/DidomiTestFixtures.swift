//
//  DidomiTestFixtures.swift
//  ConsentViewController_ExampleTests
//
//  Created by Claude on 27/08/2026.
//

@testable import ConsentViewController
import Didomi
import Foundation
import ObjectiveC

enum DidomiTestFixtures {

    // MARK: - Vendor Fixtures

    static func createVendor(
        id: String,
        name: String = "Test Vendor",
        spId: String? = nil,
        purposeIDs: [String] = [],
        legIntPurposeIDs: [String] = []
    ) -> Vendor {
        let namespaces = spId != nil ? Vendor.Namespaces(sp: spId) : nil

        return Vendor(
            id: id,
            name: name,
            namespaces: namespaces,
            purposeIDs: Set(purposeIDs),
            legIntPurposeIDs: Set(legIntPurposeIDs),
            isIAB: false
        )
    }

    // MARK: - Purpose Fixtures

    static func createPurpose(
        id: String,
        name: String = "Test Purpose",
        spId: String? = nil
    ) -> Purpose {
        let namespaces = spId != nil ? Purpose.Namespaces(sp: spId) : nil

        return Purpose(
            id: id,
            name: name,
            namespaces: namespaces
        )
    }

    // MARK: - CurrentUserStatus Fixtures

    static func createCurrentUserStatus(
        regulation: Regulation = .gdpr,
        userID: String = "test-user-id",
        created: String = "2024-01-01T00:00:00Z",
        consentString: String = "test-consent-string",
        vendors: [String: CurrentUserStatus.VendorStatus] = [:],
        purposes: [String: CurrentUserStatus.PurposeStatus] = [:]
    ) -> CurrentUserStatus {
        // Use JSON decoding to create CurrentUserStatus
        let json: [String: Any] = [
            "regulation": regulation.description,
            "user_id": userID,
            "created": created,
            "updated": created, // Use same value as created for tests
            "consent_string": consentString,
            "addtl_consent": "",
            "didomi_dcs": "",
            "gpp_string": "",
            "vendors": vendorsToJSON(vendors),
            "purposes": purposesToJSON(purposes)
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: json) else {
            fatalError("Failed to create JSON data for CurrentUserStatus")
        }

        let decoder = Foundation.JSONDecoder()
        do {
            let status: CurrentUserStatus = try decoder.decode(CurrentUserStatus.self, from: jsonData)
            return status
        } catch {
            fatalError("Failed to create CurrentUserStatus from JSON: \(error)")
        }
    }

    static func createVendorStatus(id: String, enabled: Bool) -> CurrentUserStatus.VendorStatus {
        return CurrentUserStatus.VendorStatus(id: id, enabled: enabled)
    }

    static func createPurposeStatus(id: String, enabled: Bool) -> CurrentUserStatus.PurposeStatus {
        return CurrentUserStatus.PurposeStatus(id: id, enabled: enabled)
    }

    // MARK: - Private Helpers

    private static func vendorsToJSON(_ vendors: [String: CurrentUserStatus.VendorStatus]) -> [String: [String: Any]] {
        vendors.mapValues { ["id": $0.id, "enabled": $0.enabled] }
    }

    private static func purposesToJSON(_ purposes: [String: CurrentUserStatus.PurposeStatus]) -> [String: [String: Any]] {
        purposes.mapValues { ["id": $0.id, "enabled": $0.enabled] }
    }

}
