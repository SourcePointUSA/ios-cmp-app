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

extension SPMobileCore.SPCampaignType {
    func toNative() -> SPCampaignType {
        switch name {
        case "Gdpr":
            return .gdpr
        case "Ccpa":
            return .ccpa
        case "UsNat":
            return .usnat
        case "IOS14":
            return .ios14

        default:
            return .unknown
        }
    }
}

extension SPMobileCore.MessagesResponse.Message {
    func toNative(metaData: SPMobileCore.MessagesResponse.MessageMetaData) -> Message? {
        return try? Message(decoderDataString: self.encodeToJson(categoryId: metaData.categoryId, subCategoryId: metaData.subCategoryId))
    }
}

extension SPMobileCore.MessagesResponse.MessageMetaData {
    func toNative() -> MessageMetaData {
        return MessageMetaData(
            categoryId: MessageCategory(rawValue: Int(categoryId.rawValue_)) ?? .unknown,
            subCategoryId: MessageSubCategory(rawValue: Int(subCategoryId.rawValue_)) ?? .unknown,
            messageId: String(messageId),
            messagePartitionUUID: messagePartitionUUID
        )
    }
}

extension [SPMobileCore.MessageToDisplay]? {
    func toNative() -> [MessageToDisplay]? {
        return self?.map {
            // swiftlint:disable:next force_unwrapping
            MessageToDisplay(message: $0.message.toNative(metaData: $0.metaData)!,
                             metadata: $0.metaData.toNative(),
                             // swiftlint:disable:next force_unwrapping
                             url: URL(string: $0.url)!,
                             type: $0.type.toNative())
        }
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

extension SPMobileCore.SPUserData {
    func toNative() -> SPUserData {
        return SPUserData(
            gdpr: self.gdpr.toNative(),
            ccpa: self.ccpa.toNative(),
            usnat: self.usnat.toNative()
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
        return SPMobileCore.SPMessageLanguage.entries.first { $0.shortCode == self.rawValue} ?? SPMobileCore.SPMessageLanguage.english
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
    func toCore(propertyId: Int, accountId: Int) -> SPMobileCore.State {
        return SPMobileCore.State.init(
            gdpr: self.gdpr.toCore(metaData: self.gdprMetaData),
            ccpa: self.ccpa.toCore(metaData: self.ccpaMetaData),
            usNat: self.usnat.toCore(metaData: self.usNatMetaData),
            ios14: self.ios14.toCore(),
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
            ios14: ios14.toCore()
        )
    }
}
