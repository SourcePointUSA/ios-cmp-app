//
//  Adapters.swift
//  Pods
//
//  Created by Andre Herculano on 10/9/24.
//

import Foundation
import SPMobileCore

// swiftlint:disable file_length

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

extension SPAction {
    func toCore() -> SPMobileCore.SPAction {
        return SPMobileCore.SPAction(
            type: self.type.toCore(),
            campaignType: self.campaignType.toCore(),
            messageId: self.messageId,
            pmPayload: self.pmPayload.toCore(),
            encodablePubData: JsonKt.encodeToJsonObject(self.encodablePubData.toCore())
        )
    }
}

// swiftlint:disable cyclomatic_complexity
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
// swiftlint:enable cyclomatic_complexity

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

    func toCore() -> String {
        return SPDate(date: self.date).originalDateString
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

extension SPGDPRVendorGrants {
    func toCore() -> [String: GDPRConsent.VendorGrantsValue] {
        return self.mapValues { GDPRConsent.VendorGrantsValue(vendorGrant: $0.granted, purposeGrants: $0.purposeGrants.mapValues {KotlinBoolean(bool: $0)}) }
    }
}

extension CCPAConsentStatus {
    func toCore() -> SPMobileCore.CCPAConsent.CCPAConsentStatus? {
        switch self {
        case .ConsentedAll: return SPMobileCore.CCPAConsent.CCPAConsentStatus.consentedall
        case .RejectedAll: return SPMobileCore.CCPAConsent.CCPAConsentStatus.rejectedall
        case .RejectedSome: return SPMobileCore.CCPAConsent.CCPAConsentStatus.rejectedsome
        case .RejectedNone: return SPMobileCore.CCPAConsent.CCPAConsentStatus.rejectednone
        case .LinkedNoAction: return SPMobileCore.CCPAConsent.CCPAConsentStatus.linkednoaction
        case .Unknown: return nil
        }
    }
}

extension SPGCMData {
    func toCore() -> SPMobileCore.GDPRConsent.GCMStatus {
        return SPMobileCore.GDPRConsent.GCMStatus(
            analyticsStorage: self.analyticsStorage?.rawValue,
            adStorage: self.adStorage?.rawValue,
            adUserData: self.adUserData?.rawValue,
            adPersonalization: self.adPersonalization?.rawValue
        )
    }
}

extension [SPConsentable] {
    func toCore() -> [SPMobileCore.USNatConsent.USNatConsentable] {
        return self.map { SPMobileCore.USNatConsent.USNatConsentable(id: $0.id, consented: $0.consented) }
    }
}

extension SourcepointClientCoordinator.State {
    func toCore() -> SPMobileCore.State {
        return SPMobileCore.State(
            gdpr: self.gdpr?.toCore(),
            ccpa: self.ccpa?.toCore(),
            usNat: self.usnat?.toCore(),
            gdprMetaData: self.gdprMetaData?.toCore(),
            ccpaMetaData: self.ccpaMetaData?.toCore(),
            usNatMetaData: self.usNatMetaData?.toCore()
        )
    }
}

extension SPGDPRConsent {
    func toCore() -> SPMobileCore.GDPRConsent {
        return SPMobileCore.GDPRConsent(
            applies: self.applies,
            dateCreated: self.dateCreated.toCore(),
            expirationDate: self.expirationDate.toCore(),
            uuid: self.uuid,
            childPmId: self.childPmId,
            euconsent: self.euconsent,
            legIntCategories: self.acceptedLegIntVendors,
            legIntVendors: self.acceptedLegIntVendors,
            vendors: self.acceptedVendors,
            categories: self.acceptedCategories,
            specialFeatures: self.acceptedSpecialFeatures,
            grants: self.vendorGrants.toCore(),
            gcmStatus: self.googleConsentMode?.toCore(),
            webConsentPayload: self.webConsentPayload,
            consentStatus: self.consentStatus.toCore(),
            tcData: self.tcfData?.objectValue?.mapValues { JsonKt.toJsonPrimitive($0) } ?? [:]
        )
    }
}

extension SPCCPAConsent {
    func toCore() -> SPMobileCore.CCPAConsent {
        return SPMobileCore.CCPAConsent(
            applies: self.applies,
            uuid: self.uuid,
            dateCreated: self.dateCreated.toCore(),
            expirationDate: self.expirationDate.toCore(),
            signedLspa: KotlinBoolean(bool: self.signedLspa),
            uspstring: self.uspstring,
            rejectedVendors: self.rejectedVendors,
            rejectedCategories: self.rejectedCategories,
            status: self.status.toCore(),
            webConsentPayload: self.webConsentPayload,
            gppData: self.GPPData.objectValue?.mapValues { JsonKt.toJsonPrimitive($0) } ?? [:]
        )
    }
}

extension SPUSNatConsent {
    func toCore() -> SPMobileCore.USNatConsent {
        return SPMobileCore.USNatConsent(
            applies: self.applies,
            dateCreated: self.dateCreated.toCore(),
            expirationDate: self.expirationDate.toCore(),
            uuid: self.uuid,
            webConsentPayload: self.webConsentPayload,
            consentStatus: self.consentStatus.toCore(),
            consentStrings: self.consentStrings.map {
                USNatConsent.USNatConsentSection(sectionId: Int32($0.sectionId), sectionName: $0.sectionName, consentString: $0.consentString)
            },
            userConsents: USNatConsent.USNatUserConsents(vendors: self.userConsents.vendors.toCore(), categories: self.userConsents.categories.toCore()),
            gppData: self.GPPData?.objectValue?.mapValues { JsonKt.toJsonPrimitive($0) } ?? [:]
        )
    }
}

extension SourcepointClientCoordinator.State.GDPRMetaData {
    func toCore() -> SPMobileCore.State.GDPRMetaData {
        return .init(
            additionsChangeDate: self.additionsChangeDate.toCore(),
            legalBasisChangeDate: self.legalBasisChangeDate?.toCore(),
            sampleRate: self.sampleRate,
            wasSampled: KotlinBoolean(bool: self.wasSampled),
            wasSampledAt: KotlinFloat(float: self.wasSampledAt), 
            vendorListId: self.vendorListId
        )
    }
}

extension SourcepointClientCoordinator.State.CCPAMetaData {
    func toCore() -> SPMobileCore.State.CCPAMetaData {
        return .init(
            sampleRate: self.sampleRate,
            wasSampled: KotlinBoolean(bool: self.wasSampled),
            wasSampledAt: KotlinFloat(float: self.wasSampledAt)
        )
    }
}

extension SourcepointClientCoordinator.State.UsNatMetaData {
    func toCore() -> SPMobileCore.State.UsNatMetaData {
        return .init(
            additionsChangeDate: self.additionsChangeDate.toCore(),
            sampleRate: self.sampleRate,
            wasSampled: KotlinBoolean(bool: self.wasSampled),
            wasSampledAt: KotlinFloat(float: self.wasSampledAt),
            vendorListId: self.vendorListId,
            applicableSections: self.applicableSections.map { KotlinInt(integerLiteral: $0) }
        )
    }
}
