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
        self.init(int: int)
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

extension SPPublisherData {
    func toCore() -> String? {
        return try? self.toJsonString()
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
}
