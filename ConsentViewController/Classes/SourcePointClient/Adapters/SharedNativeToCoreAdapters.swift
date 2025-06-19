//
//  SharedNativeToCoreAdapters.swift
//  Pods
//
//  Created by Dmytro Fedko on 13.06.2025.
//

import Foundation
import SPMobileCore

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

extension SPError {
    func toCore() -> CoreSPError {
        return CoreSPError(
            code: String(code),
            description: description,
            causedBy: nil,
            campaignType: campaignType.toCore()
        )
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
            gpcStatus: KotlinBoolean(bool: gpcStatus),
            systemCategories: nil,
            customCategories: nil
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

extension SPPublisherData {
    func toCore() -> String? {
        return try? self.toJsonString()
    }
}

extension SPJson {
    func toCoreString() -> String? {
        if let encoded = try? JSONEncoder().encode(self),
           let stringified = String(data: encoded, encoding: .utf8) {
            return stringified
        }
        return nil
    }
}

extension SPAction {
    func toCore() -> SPMobileCore.SPAction {
        return SPMobileCore.SPAction.companion.doInit(
            type: self.type.toCore(),
            campaignType: self.campaignType.toCore(),
            messageId: self.messageId,
            pmPayload: self.pmPayload.toCoreString(),
            encodablePubData: try? self.encodablePubData.toJsonString()
        )
    }
}

extension SPMessageLanguage {
    func toCore() -> SPMobileCore.SPMessageLanguage {
        SPMobileCore.SPMessageLanguage.entries.first { $0.shortCode.lowercased() == rawValue.lowercased() } ?? SPMobileCore.SPMessageLanguage.english
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

    func toCore() -> SPMobileCore.Kotlinx_datetimeInstant {
        return InstantKt.toInstant(SPDate(date: self.date).originalDateString)
    }
}

extension SPCampaignType {
    func toCore() -> SPMobileCore.SPCampaignType {
        switch self {
        case .gdpr: return .gdpr
        case .ccpa: return .ccpa
        case .usnat: return .usnat
        case .ios14: return .ios14
        case .globalcmp: return .globalcmp
        case .preferences: return .preferences
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
    func toCore() -> [SPMobileCore.UserConsents.Consentable] {
        return self.map { SPMobileCore.UserConsents.Consentable(id: $0.id, systemId: nil, consented: $0.consented) }
    }
}

extension SPCampaignEnv {
    func toCore() -> SPMobileCore.SPCampaignEnv {
        switch self {
        case .Public: return SPMobileCore.SPCampaignEnv.public_
        case .Stage: return SPMobileCore.SPCampaignEnv.stage
        }
    }
}

extension SPCampaign? {
    func toCore() -> SPMobileCore.SPCampaign? {
        if self != nil { return SPMobileCore.SPCampaign(
            targetingParams: self?.targetingParams ?? [:],
            groupPmId: self?.groupPmId,
            gppConfig: SPMobileCore.IncludeData.GPPConfig(
                MspaCoveredTransaction: self?.GPPConfig?.MspaCoveredTransaction?.toCore(),
                MspaOptOutOptionMode: self?.GPPConfig?.MspaOptOutOptionMode?.toCore(),
                MspaServiceProviderMode: self?.GPPConfig?.MspaServiceProviderMode?.toCore(),
                uspString: KotlinBoolean(bool: self?.GPPConfig?.uspString)
            ),
            transitionCCPAAuth: KotlinBoolean(bool: self?.transitionCCPAAuth),
            supportLegacyUSPString: KotlinBoolean(bool: self?.supportLegacyUSPString)
        )} else { return nil }
    }
}

extension SPCampaigns {
    func toCore() -> SPMobileCore.SPCampaigns {
        return SPMobileCore.SPCampaigns(
            environment: environment.toCore(),
            gdpr: gdpr.toCore(),
            ccpa: ccpa.toCore(),
            usnat: usnat.toCore(),
            globalcmp: globalcmp.toCore(),
            ios14: ios14.toCore(),
            preferences: preferences.toCore()
        )
    }
}
