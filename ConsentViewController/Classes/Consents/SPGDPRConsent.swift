//
//  SPGDPRConsent.swift
//  GDPRConsentViewController
//
//  Created by Andre Herculano on 19.12.19.
//

import Foundation

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
@objcMembers public class SPGDPRConsent: NSObject, Codable, CampaignConsent, NSCopying {
    enum CodingKeys: String, CodingKey {
        case applies, uuid, euconsent, childPmId, consentStatus,
             webConsentPayload, acceptedLegIntCategories, acceptedLegIntVendors,
             acceptedVendors, acceptedCategories, acceptedSpecialFeatures, dateCreated,
             expirationDate
        case googleConsentMode = "gcmStatus"
        case tcfData = "TCData"
        case vendorGrants = "grants"
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

    /// The date in which the consent profile was created or updated
    public var dateCreated = SPDate.now()

    /// Determines if the GDPR legislation applies for this user
    public var applies = false

    /// Required by SP endpoints
    public var consentStatus: ConsentStatus

    /// Information required by Google's Firebase Analytics SDK, GCM 2.0
    public var googleConsentMode: SPGCMData?

    /// Required by SP endpoints
    var lastMessage: LastMessageData?

    /// Used by the rendering app
    var webConsentPayload: SPWebConsentPayload?

    var expirationDate: SPDate
    var acceptedLegIntCategories: [String]
    var acceptedLegIntVendors: [String]
    var acceptedVendors: [String]
    public var acceptedCategories: [String]
    var acceptedSpecialFeatures: [String]

    override open var description: String {
        """
        UserConsents(
            uuid: \(uuid ?? "")
            vendorGrants: \(vendorGrants),
            euconsent: \(euconsent)
        )
        """
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        applies = try container.decodeIfPresent(Bool.self, forKey: .applies) ?? false
        uuid = try container.decodeIfPresent(String.self, forKey: .uuid)
        euconsent = try container.decode(String.self, forKey: .euconsent)
        tcfData = try container.decodeIfPresent(SPJson.self, forKey: .tcfData)
        vendorGrants = try container.decode(SPGDPRVendorGrants.self, forKey: .vendorGrants)
        childPmId = try container.decodeIfPresent(String.self, forKey: .childPmId)
        consentStatus = try container.decode(ConsentStatus.self, forKey: .consentStatus)
        webConsentPayload = try container.decodeIfPresent(SPWebConsentPayload.self, forKey: .webConsentPayload)
        acceptedLegIntCategories = try container.decodeIfPresent(Array.self, forKey: .acceptedLegIntCategories) ?? []
        acceptedLegIntVendors = try container.decodeIfPresent(Array.self, forKey: .acceptedLegIntVendors) ?? []
        acceptedVendors = try container.decodeIfPresent(Array.self, forKey: .acceptedVendors) ?? []
        acceptedCategories = try container.decodeIfPresent(Array.self, forKey: .acceptedCategories) ?? []
        acceptedSpecialFeatures = try container.decodeIfPresent(Array.self, forKey: .acceptedSpecialFeatures) ?? []
        expirationDate = try container.decodeIfPresent(SPDate.self, forKey: .expirationDate) ?? .distantFuture()
        googleConsentMode = try container.decodeIfPresent(SPGCMData.self, forKey: .googleConsentMode)
        if let date = try container.decodeIfPresent(SPDate.self, forKey: .dateCreated) {
            dateCreated = date
        }
    }

    init(
        uuid: String? = nil,
        vendorGrants: SPGDPRVendorGrants,
        euconsent: String,
        tcfData: SPJson?,
        childPmId: String? = nil,
        dateCreated: SPDate,
        expirationDate: SPDate,
        applies: Bool,
        consentStatus: ConsentStatus = ConsentStatus(),
        lastMessage: LastMessageData? = nil,
        webConsentPayload: SPWebConsentPayload? = nil,
        googleConsentMode: SPGCMData? = nil,
        acceptedLegIntCategories: [String] = [],
        acceptedLegIntVendors: [String] = [],
        acceptedVendors: [String] = [],
        acceptedCategories: [String] = [],
        acceptedSpecialFeatures: [String] = []
    ) {
        self.uuid = uuid
        self.vendorGrants = vendorGrants
        self.euconsent = euconsent
        self.tcfData = tcfData
        self.childPmId = childPmId
        self.dateCreated = dateCreated
        self.expirationDate = expirationDate
        self.applies = applies
        self.consentStatus = consentStatus
        self.lastMessage = lastMessage
        self.webConsentPayload = webConsentPayload
        self.googleConsentMode = googleConsentMode
        self.acceptedLegIntCategories = acceptedLegIntCategories
        self.acceptedLegIntVendors = acceptedLegIntVendors
        self.acceptedVendors = acceptedVendors
        self.acceptedCategories = acceptedCategories
        self.acceptedSpecialFeatures = acceptedSpecialFeatures
    }

    /// Convenience initialiser to return an empty consent object.
    public static func empty() -> SPGDPRConsent { SPGDPRConsent(
        vendorGrants: SPGDPRVendorGrants(),
        euconsent: "",
        tcfData: SPJson(),
        childPmId: nil,
        dateCreated: .now(),
        expirationDate: .distantFuture(),
        applies: false,
        acceptedLegIntCategories: [],
        acceptedLegIntVendors: [],
        acceptedVendors: [],
        acceptedCategories: [],
        acceptedSpecialFeatures: []
    )}

    override public func isEqual(_ object: Any?) -> Bool {
        if let other = object as? SPGDPRConsent {
            return other.uuid == uuid &&
            other.euconsent.elementsEqual(euconsent) &&
            other.vendorGrants.allSatisfy { key, value in
                vendorGrants[key]?.isEqual(value) ?? false
            }
        }
        return false
    }

    public func copy(with zone: NSZone? = nil) -> Any {
        SPGDPRConsent(
            uuid: uuid,
            vendorGrants: vendorGrants,
            euconsent: euconsent,
            tcfData: tcfData ?? SPJson(),
            childPmId: childPmId,
            dateCreated: dateCreated,
            expirationDate: expirationDate,
            applies: applies,
            consentStatus: consentStatus,
            lastMessage: lastMessage,
            webConsentPayload: webConsentPayload,
            googleConsentMode: googleConsentMode,
            acceptedLegIntCategories: acceptedLegIntCategories,
            acceptedLegIntVendors: acceptedLegIntVendors,
            acceptedVendors: acceptedVendors,
            acceptedCategories: acceptedCategories,
            acceptedSpecialFeatures: acceptedSpecialFeatures
        )
    }
}
