//
//  NativeStateAdapter.swift
//  Pods
//
//  Created by Dmytro Fedko on 13.06.2025.
//

import Foundation
import SPMobileCore

extension SourcepointClientCoordinator.State {
    func toCore(propertyId: Int, accountId: Int) -> SPMobileCore.State {
        return SPMobileCore.State.init(
            gdpr: self.gdpr.toCore(metaData: self.gdprMetaData),
            ccpa: self.ccpa.toCore(metaData: self.ccpaMetaData),
            usNat: self.usnat.toCore(metaData: self.usNatMetaData),
            ios14: self.ios14.toCore(),
            globalcmp: emptyGlobalCmpState(),
            preferences: emptyPreferencesState(),
            authId: self.storedAuthId,
            propertyId: Int32(propertyId),
            accountId: Int32(accountId),
            localVersion: Int32(self.localVersion ?? 1),
            localState: self.localState?.toCoreString() ?? "",
            nonKeyedLocalState: self.nonKeyedLocalState?.toCoreString() ?? ""
        )
    }
}

extension SPGDPRConsent? {
    func toCore(metaData: SourcepointClientCoordinator.State.GDPRMetaData?) -> SPMobileCore.State.GDPRState {
        return SPMobileCore.State.GDPRState(
            metaData: metaData.toCore(),
            consents: SPMobileCore.GDPRConsent(
                applies: self?.applies ?? false,
                dateCreated: self?.dateCreated.toCore() ?? SPDate(date: Date.distantPast).toCore(),
                expirationDate: self?.expirationDate.toCore() ?? SPDate(date: Date.distantPast).toCore(),
                uuid: self?.uuid,
                euconsent: self?.euconsent,
                legIntCategories: self?.acceptedLegIntVendors ?? [],
                legIntVendors: self?.acceptedLegIntVendors ?? [],
                vendors: self?.acceptedVendors ?? [],
                categories: self?.acceptedCategories ?? [],
                specialFeatures: self?.acceptedSpecialFeatures ?? [],
                grants: self?.vendorGrants.toCore() ?? [:],
                gcmStatus: self?.googleConsentMode?.toCore(),
                webConsentPayload: self?.webConsentPayload,
                consentStatus: self?.consentStatus.toCore() ?? ConsentStatus().toCore(),
                tcData: self?.tcfData?.objectValue?.mapValues { JsonKt.toJsonPrimitive($0) } ?? [:]
            ),
            childPmId: self?.childPmId
        )
    }
}

extension SPCCPAConsent? {
    func toCore(metaData: SourcepointClientCoordinator.State.CCPAMetaData?) -> SPMobileCore.State.CCPAState {
        return SPMobileCore.State.CCPAState(
            metaData: metaData.toCore(),
            consents: SPMobileCore.CCPAConsent(
                applies: self?.applies ?? false,
                uuid: self?.uuid,
                dateCreated: self?.dateCreated.toCore() ?? SPDate(date: Date.distantPast).toCore(),
                expirationDate: self?.expirationDate.toCore() ?? SPDate(date: Date.distantPast).toCore(),
                signedLspa: KotlinBoolean(bool: self?.signedLspa),
                rejectedAll: self?.consentStatus.rejectedAll ?? false,
                consentedAll: self?.consentStatus.consentedAll ?? false,
                rejectedVendors: self?.rejectedVendors ?? [],
                rejectedCategories: self?.rejectedCategories ?? [],
                status: self?.status.toCore(),
                webConsentPayload: self?.webConsentPayload,
                gppData: self?.GPPData.objectValue?.mapValues { JsonKt.toJsonPrimitive($0) } ?? [:]
            ),
            childPmId: self?.childPmId
        )
    }
}

extension SPUSNatConsent? {
    func toCore(metaData: SourcepointClientCoordinator.State.UsNatMetaData?) -> SPMobileCore.State.USNatState {
        return SPMobileCore.State.USNatState(
            metaData: metaData.toCore(),
            consents: SPMobileCore.USNatConsent(
                applies: self?.applies ?? false,
                dateCreated: self?.dateCreated.toCore() ?? SPDate(date: Date.distantPast).toCore(),
                expirationDate: self?.expirationDate.toCore() ?? SPDate(date: Date.distantPast).toCore(),
                uuid: self?.uuid,
                webConsentPayload: self?.webConsentPayload,
                consentStatus: self?.consentStatus.toCore() ?? ConsentStatus().toCore(),
                consentStrings: self?.consentStrings.map {
                    USNatConsent.USNatConsentSection(sectionId: Int32($0.sectionId), sectionName: $0.sectionName, consentString: $0.consentString)
                } ?? [],
                userConsents: USNatConsent.USNatUserConsents(vendors: self?.userConsents.vendors.toCore() ?? [], categories: self?.userConsents.categories.toCore() ?? []),
                gppData: self?.GPPData?.objectValue?.mapValues { JsonKt.toJsonPrimitive($0) } ?? [:]
            ),
            childPmId: nil
        )
    }
}

extension SourcepointClientCoordinator.State.AttCampaign? {
    func toCore() -> SPMobileCore.AttCampaign {
        return SPMobileCore.AttCampaign(
            status: self?.status.toCore(),
            // swiftlint:disable:next force_unwrapping
            messageId: self?.messageId != nil ? KotlinInt(int: Int(self!.messageId!)) : nil,
            partitionUUID: self?.partitionUUID
        )
    }
}

func emptyGlobalCmpState() -> SPMobileCore.State.GlobalCmpState {
    return SPMobileCore.State.GlobalCmpState(
        metaData: SPMobileCore.State.GlobalCmpStateGlobalCmpMetaData(
            additionsChangeDate: SPDate(date: Date.distantPast).toCore(),
            sampleRate: 1,
            wasSampled: nil,
            wasSampledAt: nil,
            vendorListId: nil,
            applicableSections: []
        ),
        consents: SPMobileCore.GlobalCmpConsent(
            applies: false,
            categories: [],
            consentStatus: ConsentStatus().toCore(),
            dateCreated: SPDate(date: Date.distantPast).toCore(),
            expirationDate: SPDate(date: Date.distantPast).toCore(),
            gpcEnabled: nil,
            uuid: nil,
            userConsents: USNatConsent.USNatUserConsents(vendors: [], categories: []),
        ),
        childPmId: nil
    )
}

func emptyPreferencesState() -> SPMobileCore.State.PreferencesState {
    return SPMobileCore.State.PreferencesState(
        metaData: SPMobileCore.State.PreferencesStatePreferencesMetaData(
            configurationId: "",
            additionsChangeDate: SPDate(date: Date.distantPast).toCore(),
            legalDocLiveDate: nil
        ),
        consents: SPMobileCore.PreferencesConsent(
            dateCreated: nil,
            messageId: nil,
            status: nil,
            rejectedStatus: nil,
            uuid: nil
        )
    )
}

extension SourcepointClientCoordinator.State.GDPRMetaData? {
    func toCore() -> SPMobileCore.State.GDPRStateGDPRMetaData {
        return SPMobileCore.State.GDPRStateGDPRMetaData.init(
            additionsChangeDate: self?.additionsChangeDate.toCore() ?? SPDate(date: Date.distantPast).toCore(),
            legalBasisChangeDate: self?.legalBasisChangeDate?.toCore() ?? SPDate(date: Date.distantPast).toCore(),
            sampleRate: self?.sampleRate ?? 1,
            wasSampled: KotlinBoolean(bool: self?.wasSampled),
            wasSampledAt: KotlinFloat(float: self?.wasSampledAt),
            vendorListId: self?.vendorListId
        )
    }
}

extension SourcepointClientCoordinator.State.CCPAMetaData? {
    func toCore() -> SPMobileCore.State.CCPAStateCCPAMetaData {
        return SPMobileCore.State.CCPAStateCCPAMetaData.init(
            sampleRate: self?.sampleRate ?? 1,
            wasSampled: KotlinBoolean(bool: self?.wasSampled),
            wasSampledAt: KotlinFloat(float: self?.wasSampledAt)
        )
    }
}

extension SourcepointClientCoordinator.State.UsNatMetaData? {
    func toCore() -> SPMobileCore.State.USNatStateUsNatMetaData {
        return SPMobileCore.State.USNatStateUsNatMetaData.init(
            additionsChangeDate: self?.additionsChangeDate.toCore() ?? SPDate(date: Date.distantPast).toCore(),
            sampleRate: self?.sampleRate ?? 1,
            wasSampled: KotlinBoolean(bool: self?.wasSampled),
            wasSampledAt: KotlinFloat(float: self?.wasSampledAt),
            vendorListId: self?.vendorListId,
            applicableSections: self?.applicableSections.compactMap { KotlinInt(integerLiteral: $0) } ?? []
        )
    }
}
