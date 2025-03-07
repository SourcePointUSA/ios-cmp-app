//
//  Adapters.swift
//  Pods
//
//  Created by Andre Herculano on 10/9/24.
//

import Foundation
import SPMobileCore

extension SPMobileCore.CCPAConsent.CCPAConsentStatus {
    func toNative() -> CCPAConsentStatus {
        switch name {
            case "ConsentedAll": return .ConsentedAll
            case "RejectedAll": return .RejectedAll
            case "RejectedSome": return .RejectedSome
            case "RejectedNone": return .RejectedNone
            case "LinkedNoAction": return .LinkedNoAction
            default: return .Unknown
        }
    }
}

extension SPMobileCore.USNatConsent.USNatConsentSection {
    func toNative() -> SPUSNatConsent.ConsentString {
        .init(
            sectionId: Int(sectionId),
            sectionName: sectionName,
            consentString: consentString
        )
    }
}

extension SPMobileCore.USNatConsent.USNatConsentable {
    func toNative() -> SPConsentable {
        .init(id: id, consented: consented)
    }
}

extension SPMobileCore.USNatConsent.USNatUserConsents {
    func toNative() -> SPUSNatConsent.UserConsents {
        .init(
            vendors: vendors.map { $0.toNative() },
            categories: categories.map { $0.toNative() }
        )
    }
}

extension SPMobileCore.GDPRConsent.VendorGrantsValue {
    func toNative() -> SPGDPRVendorGrant {
        .init(
            granted: vendorGrant,
            purposeGrants: purposeGrants.mapValues { $0.boolValue }
        )
    }
}

extension SPMobileCore.GDPRConsent.GCMStatus {
    func toNative() -> SPGCMData {
        .init(
            adStorage: .init(rawValue: adStorage ?? ""),
            analyticsStorage: .init(rawValue: analyticsStorage ?? ""),
            adUserData: .init(rawValue: adUserData ?? ""),
            adPersonalization: .init(rawValue: adPersonalization ?? "")
        )
    }
}

extension SPMobileCore.ConsentStatus {
    func toNative() -> ConsentStatus {
        .init(
            granularStatus: granularStatus?.toNative(),
            rejectedAny: rejectedAny?.boolValue,
            rejectedLI: rejectedLI?.boolValue,
            consentedAll: consentedAll?.boolValue,
            consentedToAll: consentedToAll?.boolValue,
            consentedToAny: consentedToAny?.boolValue,
            rejectedAll: rejectedAll?.boolValue,
            vendorListAdditions: vendorListAdditions?.boolValue,
            legalBasisChanges: legalBasisChanges?.boolValue,
            hasConsentData: hasConsentData?.boolValue
        )
    }
}

extension [String: Kotlinx_serialization_jsonJsonPrimitive] {
    func toNative() -> SPJson? {
        try? SPJson(compactMapValues { ($0.isString ? $0.content : Int($0.content) as Any) })
    }
}

extension SPMobileCore.GDPRConsent {
    func toNativeAsAddOrDeleteCustomConsentResponse() -> AddOrDeleteCustomConsentResponse {
        .init(grants: grants.mapValues { $0.toNative() })
    }
}

extension SPMobileCore.ConsentStatus.ConsentStatusGranularStatus {
    func toNative() -> ConsentStatus.GranularStatus {
        .init(
            vendorConsent: vendorConsent,
            vendorLegInt: vendorLegInt,
            purposeConsent: purposeConsent,
            purposeLegInt: purposeLegInt,
            previousOptInAll: previousOptInAll?.boolValue,
            defaultConsent: defaultConsent?.boolValue
        )
    }
}

extension KotlinBoolean {
    public convenience init?(bool value: Bool?) {
        guard let bool = value else { return nil }
        self.init(bool: bool)
    }
}

extension KotlinInt {
    public convenience init?(int value: Int?) {
        guard let int = value else { return nil }
        self.init(int: Int32(int))
    }
}

extension KotlinFloat {
    public convenience init?(float value: Float?) {
        guard let float = value else { return nil }
        self.init(float: float)
    }
}

extension ConsentStatus {
    func toCore(rejectedVendors: [String]? = nil, rejectedCategories: [String]? = nil) -> SPMobileCore.ConsentStatus {
        return SPMobileCore.ConsentStatus.init(
            rejectedAny: KotlinBoolean(bool: rejectedAny),
            rejectedLI: KotlinBoolean(bool: rejectedLI),
            rejectedAll: KotlinBoolean(bool: rejectedAll),
            consentedAll: KotlinBoolean(bool: consentedAll),
            consentedToAll: KotlinBoolean(bool: consentedToAll),
            consentedToAny: KotlinBoolean(bool: consentedToAny),
            hasConsentData: KotlinBoolean(bool: hasConsentData),
            vendorListAdditions: KotlinBoolean(bool: vendorListAdditions),
            legalBasisChanges: KotlinBoolean(bool: legalBasisChanges),
            granularStatus: granularStatus?.toCore(),
            rejectedVendors: rejectedVendors,
            rejectedCategories: rejectedCategories
        )
    }
}

extension ConsentStatus.GranularStatus {
    func toCore() -> SPMobileCore.ConsentStatus.ConsentStatusGranularStatus {
        return SPMobileCore.ConsentStatus.ConsentStatusGranularStatus.init(
            vendorConsent: vendorConsent,
            vendorLegInt: vendorLegInt,
            purposeConsent: purposeConsent,
            purposeLegInt: purposeLegInt,
            previousOptInAll: KotlinBoolean(bool: previousOptInAll),
            defaultConsent: KotlinBoolean(bool: defaultConsent),
            sellStatus: KotlinBoolean(bool: sellStatus),
            shareStatus: KotlinBoolean(bool: shareStatus),
            sensitiveDataStatus: KotlinBoolean(bool: sensitiveDataStatus),
            gpcStatus: KotlinBoolean(bool: gpcStatus)
        )
    }
}

extension SPGPPConfig.SPMspaBinaryFlag {
    func toCore() -> SPMobileCore.IncludeData.MspaBinaryFlag? {
        switch self {
        case .yes: return .yes
        case .no: return .no
        }
    }
}

extension SPGPPConfig.SPMspaTernaryFlag {
    func toCore() -> SPMobileCore.IncludeData.MspaTernaryFlag? {
        switch self {
        case .yes: return .yes
        case .no: return .no
        case .notApplicable: return .na
        }
    }
}

extension IncludeData {
    func toCore() -> SPMobileCore.IncludeData {
        var translateMessageVal = nil as Bool?
        #if os(tvOS)
        translateMessageVal = translateMessage
        #endif
        return SPMobileCore.IncludeData.init(
            tcData: SPMobileCore.IncludeData.TypeString(type: "RecordString"),
            webConsentPayload: SPMobileCore.IncludeData.TypeString(type: "string"),
            localState: SPMobileCore.IncludeData.TypeString(type: "RecordString"),
            categories: categories,
            translateMessage: KotlinBoolean(bool: translateMessageVal),
            gppData: SPMobileCore.IncludeData.GPPConfig(
                MspaCoveredTransaction: gppConfig.MspaCoveredTransaction?.toCore(),
                MspaOptOutOptionMode: gppConfig.MspaOptOutOptionMode?.toCore(),
                MspaServiceProviderMode: gppConfig.MspaServiceProviderMode?.toCore(),
                uspString: KotlinBoolean(bool: gppConfig.uspString)
            )
        )
    }
}

extension SPPublisherData {
    func toCore() -> String? {
        return try? self.toJsonString()
    }
}

extension SPJson {
    func toCore() -> String? {
        if let encoded = try? JSONEncoder().encode(self),
           let stringified = String(data: encoded, encoding: .utf8) {
            return stringified
        }
        return nil
    }
}

extension SPActionType {
    func toCore() -> SPMobileCore.SPActionType {
        switch self {
        case .AcceptAll: return .acceptall
        case .RejectAll: return .rejectall
        case .Custom: return .custom
        case .ShowPrivacyManager: return .showprivacymanager
        case .SaveAndExit: return .saveandexit
        case .Dismiss: return .dismiss
        case .PMCancel: return .pmcancel
        case .RequestATTAccess: return .requestattaccess
        case .IDFAAccepted: return .idfaaccepted
        case .IDFADenied: return .idfadenied
        case .Unknown: return .unknown
        @unknown default: return .unknown
        }
    }
}

extension SPIDFAStatus {
    func toCore() -> SPMobileCore.SPIDFAStatus {
        switch self {
        case .accepted: return .accepted
        case .denied: return .denied
        case .unavailable: return .unavailable
        case .unknown: return .unknown
        default: return .unknown
        }
    }
}

extension SPDate {
    init(string: String) {
        originalDateString = string
        date = Self.format.date(from: originalDateString) ?? Date()
    }

    init?(string: String?) {
        if let string = string {
            originalDateString = string
            date = Self.format.date(from: originalDateString) ?? Date()
        } else {
            return nil
        }
    }
}

extension SPCampaignType {
    func toCore() -> SPMobileCore.SPCampaignType {
        switch self {
        case .gdpr: return .gdpr
        case .ccpa: return .ccpa
        case .usnat: return .usnat
        case .ios14: return .ios14
        case .unknown: return .unknown
        }
    }
}
