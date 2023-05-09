//
//  SPGDPRConsent.swift
//  GDPRConsentViewController
//
//  Created by Andre Herculano on 19.12.19.
//

import Foundation

struct LastMessageData: Codable {
    var id, categoryId, subCategoryId: Int
    var partitionUUID: String
}

extension LastMessageData {
    init(from metadata: MessageMetaData) {
        id = Int(metadata.messageId) ?? 0
        categoryId = metadata.categoryId.rawValue
        subCategoryId = metadata.subCategoryId.rawValue
        partitionUUID = metadata.messagePartitionUUID ?? ""
    }
}

/// A dictionary in which the keys represent the Vendor Id
public typealias SPGDPRVendorGrants = [GDPRVendorId: SPGDPRVendorGrant]
public typealias GDPRVendorId = String

/// A dictionary in which the keys represent the Purpose Id and the values indicate if that purpose is granted (`true`) or not (`false`) on a legal basis.
public typealias SPGDPRPurposeGrants = [SPGDPRPurposeId: Bool]
public typealias SPGDPRPurposeId = String

/// Encapuslates data about a particular vendor being "granted" based on its purposes
@objcMembers public class SPGDPRVendorGrant: NSObject, Codable {
    enum CodingKeys: String, CodingKey {
        case purposeGrants
        case granted = "vendorGrant"
    }

    /// if all purposes are granted, the vendorGrant will be set to `true`
    public let granted: Bool
    public let purposeGrants: SPGDPRPurposeGrants

    // returns true if granted or any of its purposes is true
    var softGranted: Bool { granted || purposeGrants.first { $0.value }?.value ?? false }

    override public var description: String {
        "VendorGrant(granted: \(granted), purposeGrants: \(purposeGrants))"
    }

    public init(granted: Bool = false, purposeGrants: SPGDPRPurposeGrants = [:]) {
        self.granted = granted
        self.purposeGrants = purposeGrants
    }

    override public func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? SPGDPRVendorGrant else {
            return false
        }
        return other.granted == granted && other.purposeGrants == purposeGrants
    }
}

/**
    SPGDPRConsent encapsulates all consent data from a user.
 */
@objcMembers public class SPGDPRConsent: NSObject, Codable, CampaignConsent {
    enum CodingKeys: String, CodingKey {
        case uuid
        case euconsent
        case tcfData = "TCData"
        case vendorGrants = "grants"
        case childPmId
        case consentStatus
        case webConsentPayload
    }

    /// The snapshot of user consents. It contains information of all purposes on a vendor per vendor basis.
    ///
    /// The vendorGrants can be seen as an object in the following shape:
    /// ```{
    ///     "vendor1Id": {
    ///         "granted": true,
    ///         "purpose1id": true,
    ///         "purpose2id": true
    ///         ...
    ///     },
    ///     ...
    /// }
    /// ```
    /// The `granted` attribute indicated whether the vendor has **all** purposes it needs to be
    /// considered fully consented. Either via legitimate interest or explicit user consent.
    /// Each key/value pair of `"purposeId: Bool`, indicates if that purpose has been consented
    /// either via leg. interest or explicit user consent.
    public var vendorGrants: SPGDPRVendorGrants

    /// The iAB consent string.
    public var euconsent: String

    /// A dictionary with all TCFv2 related data
    public var tcfData: SPJson?

    /// That's the internal Sourcepoint id we give to this consent profile
    public var uuid: String?

    /// In case `/getMessages` request was done with `groupPmId`, `childPmId` will be returned
    var childPmId: String?

    /// A list of ids of the categories accepted by the user in all its vendors.
    /// If a category has been rejected in a single vendor, its id won't part of the `acceptedCategories` list.
    public var acceptedCategories: [String] {
        let categoryGrants = vendorGrants
            .flatMap { $0.value.purposeGrants }
        return Set<String>(categoryGrants.map { $0.key })
            .filter { id in
                categoryGrants
                    .filter { $0.key == id }
                    .allSatisfy { $0.value }
            }
    }

    /// The date in which the consent profile was created or updated
    public var dateCreated = SPDateCreated.now()

    /// Determines if the GDPR legislation applies for this user
    public var applies = false

    /// Required by SP endpoints
    var consentStatus: ConsentStatus

    /// Required by SP endpoints
    var lastMessage: LastMessageData?

    /// Used by the rendering app
    var webConsentPayload: SPWebConsentPayload?

    override open var description: String {
        """
        UserConsents(
            uuid: \(uuid ?? "")
            vendorGrants: \(vendorGrants),
            euconsent: \(euconsent)
        )
        """
    }

    init(
        uuid: String? = nil,
        vendorGrants: SPGDPRVendorGrants,
        euconsent: String,
        tcfData: SPJson,
        childPmId: String? = nil,
        consentStatus: ConsentStatus = ConsentStatus(),
        webConsentPayload: SPWebConsentPayload? = nil
    ) {
        self.uuid = uuid
        self.vendorGrants = vendorGrants
        self.euconsent = euconsent
        self.tcfData = tcfData
        self.childPmId = childPmId
        self.consentStatus = consentStatus
        self.webConsentPayload = webConsentPayload
    }

    /// Convenience initialiser to return an empty consent object.
    public static func empty() -> SPGDPRConsent { SPGDPRConsent(
        vendorGrants: SPGDPRVendorGrants(),
        euconsent: "",
        tcfData: SPJson(),
        childPmId: nil
    )}

    override public func isEqual(_ object: Any?) -> Bool {
        if let other = object as? SPGDPRConsent {
            return other.uuid == uuid &&
            other.euconsent.elementsEqual(euconsent) &&
            other.vendorGrants.allSatisfy { key, value in vendorGrants[key]?.isEqual(value) ?? false }
        }
        return false
    }
}
