//
//  SPUserDataCoreToNativeAdapter.swift
//  Pods
//
//  Created by Dmytro Fedko on 13.06.2025.
//

import Foundation
import SPMobileCore

extension SPMobileCore.SPUserData {
    func toNative() -> SPUserData {
        return SPUserData(
            gdpr: self.gdpr.toNative(),
            ccpa: self.ccpa.toNative(),
            usnat: self.usnat.toNative(),
            globalcmp: self.globalcmp.toNative(),
            preferences: self.preferences.toNative()
        )
    }
}

extension SPUserDataSPConsent<GDPRConsent>? {
    func toNative() -> SPConsent<SPGDPRConsent>? {
        return SPConsent<SPGDPRConsent>.init(
            consents: self?.consents?.toNative(),
            applies: self?.consents?.applies ?? false
        )
    }
}

extension SPUserDataSPConsent<CCPAConsent>? {
    func toNative() -> SPConsent<SPCCPAConsent>? {
        return SPConsent<SPCCPAConsent>.init(
            consents: self?.consents?.toNative(),
            applies: self?.consents?.applies ?? false
        )
    }
}

extension SPUserDataSPConsent<USNatConsent>? {
    func toNative() -> SPConsent<SPUSNatConsent>? {
        return SPConsent<SPUSNatConsent>.init(
            consents: self?.consents?.toNative(),
            applies: self?.consents?.applies ?? false
        )
    }
}

extension SPUserDataSPConsent<GlobalCmpConsent>? {
    func toNative() -> SPConsent<SPGlobalCmpConsent>? {
        return SPConsent<SPGlobalCmpConsent>.init(
            consents: self?.consents?.toNative(),
            applies: self?.consents?.applies ?? false
        )
    }
}

extension SPUserDataSPConsent<PreferencesConsent>? {
    func toNative() -> SPConsent<SPPreferencesConsent>? {
        return SPConsent<SPPreferencesConsent>.init(
            consents: self?.consents?.toNative(),
            applies: true
        )
    }
}

extension SPMobileCore.GDPRConsent {
    func toNative() -> SPGDPRConsent {
        return .init(
            uuid: self.uuid,
            vendorGrants: self.grants.mapValues { $0.toNative() },
            euconsent: self.euconsent ?? "",
            tcfData: self.tcData.toNative(),
            dateCreated: SPDate(string: self.dateCreated.instantToString()),
            expirationDate: SPDate(string: self.expirationDate.instantToString()),
            applies: self.applies,
            consentStatus: self.consentStatus.toNative(),
            webConsentPayload: self.webConsentPayload,
            googleConsentMode: self.gcmStatus?.toNative(),
            acceptedLegIntCategories: self.legIntCategories,
            acceptedLegIntVendors: self.legIntVendors,
            acceptedVendors: self.vendors,
            acceptedCategories: self.categories,
            acceptedSpecialFeatures: self.specialFeatures
        )
    }
}

extension SPMobileCore.CCPAConsent {
    func toNative() -> SPCCPAConsent {
        return .init(
            uuid: self.uuid,
            status: self.status?.toNative() ?? .RejectedNone,
            rejectedVendors: self.rejectedVendors,
            rejectedCategories: self.rejectedCategories,
            signedLspa: self.signedLspa?.boolValue ?? false,
            applies: self.applies,
            dateCreated: SPDate(string: self.dateCreated.instantToString()),
            expirationDate: SPDate(string: self.expirationDate.instantToString()),
            consentStatus: ConsentStatus(consentedAll: self.consentedAll, rejectedAll: self.rejectedAll),
            webConsentPayload: self.webConsentPayload,
            GPPData: self.gppData.toNative() ?? SPJson()
        )
    }
}

extension SPMobileCore.USNatConsent {
    func toNative() -> SPUSNatConsent {
        return .init(
            uuid: self.uuid,
            applies: self.applies,
            dateCreated: SPDate(string: self.dateCreated.instantToString()),
            expirationDate: SPDate(string: self.expirationDate.instantToString()),
            consentStrings: self.consentStrings.map { $0.toNative() },
            webConsentPayload: self.webConsentPayload,
            categories: self.userConsents.categories.map { $0.toNative() },
            vendors: self.userConsents.vendors.map { $0.toNative() },
            consentStatus: self.consentStatus.toNative(),
            GPPData: self.gppData.toNative()
        )
    }
}

extension SPMobileCore.GlobalCmpConsent {
    func toNative() -> SPGlobalCmpConsent {
        return .init(
            uuid: self.uuid,
            applies: self.applies,
            dateCreated: SPDate(string: self.dateCreated.instantToString()),
            expirationDate: SPDate(string: self.expirationDate.instantToString()),
            userConsents: SPGlobalCmpConsent.UserConsents(
                vendors: self.userConsents.vendors.map { $0.toNative() },
                categories: self.userConsents.categories.map { $0.toNative() }
            ),
            consentStatus: self.consentStatus.toNative(),
            webConsentPayload: self.webConsentPayload
        )
    }
}

extension SPMobileCore.PreferencesConsent {
    func toNative() -> SPPreferencesConsent {
        return .init(
            dateCreated: SPDate(string: self.dateCreated?.instantToString() ?? SPDate.now().originalDateString),
            messageId: self.messageId != nil ? String(Int(truncating: self.messageId ?? 0)) : nil,
            uuid: self.uuid,
            status: self.status?.map { $0.toNative() } ?? [],
            rejectedStatus: self.rejectedStatus?.map { $0.toNative() } ?? []
        )
    }
}

extension SPMobileCore.PreferencesConsent.PreferencesStatus {
    func toNative() -> SPPreferencesConsent.Status {
        return .init(
            categoryId: Int(self.categoryId),
            channels: self.channels?.map { $0.toNative() } ?? [],
            changed: self.changed?.boolValue,
            dateConsented: SPDate(string: self.dateConsented?.instantToString() ?? SPDate.now().originalDateString),
            subType: self.subType.toNative(),
            versionId: self.versionId
        )
    }
}

extension SPMobileCore.PreferencesConsent.PreferencesStatusPreferencesChannels {
    func toNative() -> SPPreferencesConsent.Channel { return .init(id: Int(self.channelId), status: self.status) }
}

extension SPMobileCore.PreferencesConsent.PreferencesSubType? {
    func toNative() -> SPPreferencesConsent.SubType {
        switch self {
        case .aipolicy: return .AIPolicy
        case .legalpolicy: return .LegalPolicy
        case .privacypolicy: return .PrivacyPolicy
        case .termsandconditions: return .TermsAndConditions
        case .termsofsale: return .TermsOfSale
        case .unknown: return .Unknown
        default: return .Unknown
        }
    }
}
