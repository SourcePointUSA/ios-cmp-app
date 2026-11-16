//
//  SPDidomiConsentManager.swift
//  Pods
//
//  Created by Andre Herculano on 14/1/26.
//

import Foundation
import UIKit
import Didomi

typealias DidomiUserStatus = CurrentUserStatus

@objcMembers open class SPDidomiConsentManager: NSObject, SPSDK {
    public static var VERSION: String = SPConsentManager.VERSION

    public var cleanUserDataOnError = false

    public var messageTimeoutInSeconds: TimeInterval = 0.0

    public var privacyManagerTab: SPPrivacyManagerTab = .Default

    public var messageLanguage: SPMessageLanguage = .BrowserDefault

    public var userData: SPUserData { Didomi.shared.getCurrentUserStatus().toSourcepoint() }

    public var gdprApplies: Bool { userData.gdpr?.applies ?? false }

    public var ccpaApplies: Bool { userData.ccpa?.applies ?? false }

    public var usnatApplies: Bool { userData.usnat?.applies ?? false }

    public var globalcmpApplies: Bool { userData.globalcmp?.applies ?? false }

    var didomiEventListener = SPDidomiEventListener()

    public weak var didomiUIController: UIViewController?

    weak var appDelegate: SPDelegate?

    private var isConsentUIReady = false
    private var isDidomiReady = false
    private var pendingLoadMessage = false

    // Required initializer from SPSDK protocol
    required convenience public init(
        accountId: Int,
        propertyId: Int,
        propertyName: SPPropertyName,
        campaigns: SPCampaigns,
        language: SPMessageLanguage,
        delegate: SPDelegate?
    ) {
        self.init(
            accountId: accountId,
            propertyId: propertyId,
            propertyName: propertyName,
            campaigns: campaigns,
            language: language,
            delegate: delegate,
            configFileName: nil
        )
    }

    public init(
        accountId: Int,
        propertyId: Int,
        propertyName: SPPropertyName,
        campaigns: SPCampaigns,
        language: SPMessageLanguage,
        delegate: SPDelegate?,
        configFileName: String?
    ) {
        super.init()
        setupDidomi(
            accountId: accountId,
            propertyId: propertyId,
            propertyName: propertyName,
            campaigns: campaigns,
            language: language,
            delegate: delegate,
            configFileName: configFileName
        )
    }

    // Common setup method
    private func setupDidomi(
        accountId: Int,
        propertyId: Int,
        propertyName: SPPropertyName,
        campaigns: SPCampaigns,
        language: SPMessageLanguage,
        delegate: SPDelegate?,
        configFileName: String?
    ) {
        appDelegate = delegate
        Didomi.shared.initialize(DidomiInitializeParameters(
            accountId: accountId,
            propertyId: propertyId,
            propertyName: propertyName.rawValue,
            configFileName: configFileName
        ))
        Didomi.shared.onReady { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.isDidomiReady = true

            // If loadMessage was called before ready, process it now
            if strongSelf.pendingLoadMessage {
                strongSelf.pendingLoadMessage = false
                strongSelf.checkAndProceedWithConsent()
            }
        }
        didomiEventListener.onAction = { [weak self] action in
            DispatchQueue.main.async {
                if let strongSelf = self, let didomiUIController = strongSelf.didomiUIController {
                    strongSelf.appDelegate?.onAction(action, from: didomiUIController)
                }
            }
        }
        didomiEventListener.onConsentChanged = { [weak self] in
            DispatchQueue.main.async {
                if let strongSelf = self, strongSelf.isConsentUIReady {
                    strongSelf.appDelegate?.onConsentReady?(userData: strongSelf.userData)
                }
            }
        }
        didomiEventListener.onConsentUIReady = { [weak self] viewController in
            DispatchQueue.main.async {
                if let strongSelf = self {
                    strongSelf.isConsentUIReady = true
                    strongSelf.appDelegate?.onSPUIReady(viewController)
                }
            }
        }
        didomiEventListener.onConsentUIFinished = { [weak self] viewController in
            DispatchQueue.main.async {
                if let strongSelf = self {
                    strongSelf.appDelegate?.onSPUIFinished(viewController)
                    strongSelf.appDelegate?.onSPFinished?(userData: strongSelf.userData)
                }
            }
        }
        Didomi.shared.addEventListener(listener: didomiEventListener.didomiEventListener)
    }

    public static func clearAllData() {
        Didomi.shared.reset()
    }

    public func loadMessage(forAuthId authId: String? = nil, publisherData: [String: String]? = [:]) {
        loadMessage(forAuthId: authId, publisherData: publisherData?.mapValues { AnyEncodable($0) })
    }

    public func loadMessage(forAuthId authId: String? = nil, publisherData: SPPublisherData? = [:]) {
        OSLogger.standard.begin("MessageFlow")

        // Wait for Didomi to be ready before checking shouldUserStatusBeCollected
        if isDidomiReady {
            checkAndProceedWithConsent()
        } else {
            pendingLoadMessage = true
        }
    }

    private func checkAndProceedWithConsent() {
        // Check if user status should be collected (only call after ready event)
        if !Didomi.shared.shouldUserStatusBeCollected() {
            // If user status collection is not needed, call callbacks immediately
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.appDelegate?.onConsentReady?(userData: self.userData)
                self.appDelegate?.onSPFinished?(userData: self.userData)
            }
            return
        }

        if let didomiUIController {
            Didomi.shared.setupUI(containerController: didomiUIController)
        }
    }

    public func loadGDPRPrivacyManager(withId id: String, tab: SPPrivacyManagerTab = .Default, useGroupPmIfAvailable: Bool = false) {
        OSLogger.standard.begin("MessageFlow")
        Didomi.shared.showPreferences()
    }

    public func loadCCPAPrivacyManager(withId id: String, tab: SPPrivacyManagerTab = .Default, useGroupPmIfAvailable: Bool = false) {
        OSLogger.standard.begin("MessageFlow")
        Didomi.shared.showPreferences()
    }

    public func loadUSNatPrivacyManager(withId id: String, tab: SPPrivacyManagerTab = .Default, useGroupPmIfAvailable: Bool = false) {
        OSLogger.standard.begin("MessageFlow")
        Didomi.shared.showPreferences()
    }

    public func loadGlobalCmpPrivacyManager(withId id: String, tab: SPPrivacyManagerTab = .Default, useGroupPmIfAvailable: Bool = false) {
        OSLogger.standard.begin("MessageFlow")
        Didomi.shared.showPreferences()
    }

    public func loadPreferenceCenter(withId id: String) {
        OSLogger.standard.begin("MessageFlow")
        Didomi.shared.showPreferences()
    }

    public func customConsentGDPR(vendors: [String], categories: [String], legIntCategories: [String], handler: @escaping (SPGDPRConsent) -> Void) {
        // TODO: we'll need a way to convert SP ids into DDM ids.
        Didomi.shared.setUserStatus(
            enabledConsentPurposeIds: Set<String>(),
            disabledConsentPurposeIds: Set<String>(),
            enabledLIPurposeIds: Set<String>(),
            disabledLIPurposeIds: Set<String>(),
            enabledConsentVendorIds: Set<String>(),
            disabledConsentVendorIds: Set<String>(),
            enabledLIVendorIds: Set<String>(),
            disabledLIVendorIds: Set<String>()
        )
    }

    public func deleteCustomConsentGDPR(vendors: [String], categories: [String], legIntCategories: [String], handler: @escaping (SPGDPRConsent) -> Void) {
        // TODO: we'll need a way to convert SP ids into DDM ids.
        Didomi.shared.setUserStatus(
            enabledConsentPurposeIds: Set<String>(),
            disabledConsentPurposeIds: Set<String>(),
            enabledLIPurposeIds: Set<String>(),
            disabledLIPurposeIds: Set<String>(),
            enabledConsentVendorIds: Set<String>(),
            disabledConsentVendorIds: Set<String>(),
            enabledLIVendorIds: Set<String>(),
            disabledLIVendorIds: Set<String>()
        )
    }

    public func rejectAll(campaignType: SPCampaignType) {
        Didomi.shared.setUserDisagreeToAll()
    }

    public func dismissMessage() {
        if Didomi.shared.isNoticeVisible() {
            Didomi.shared.hideNotice()
        } else if Didomi.shared.isPreferencesVisible() {
            Didomi.shared.hidePreferences()
        }
    }

    public func onMessageInactivityTimeout() {
        // TODO: implement this on DDM
    }

    public func onError(_ error: SPError) {
        OSLogger.standard.end("MessageFlow")
        DispatchQueue.main.async { [weak self] in
            self?.appDelegate?.onError?(error: error)
        }
    }

    public func finished(_ vcFinished: UIViewController) {}
    public func loaded(_ controller: UIViewController) {}
    public func action(_ action: SPAction, from controller: UIViewController) {}
}

// MARK: Didomi's stubbing

extension DidomiInitializeParameters {
    convenience init(accountId: Int, propertyId: Int, propertyName: String, configFileName: String? = nil) {
        if let configFileName = configFileName {
            self.init(
                apiKey: "eea5ad63-29d4-4552-9dac-2edebe1fe518",
                localConfigurationPath: configFileName,
                disableDidomiRemoteConfig: true,
                noticeID: "BVP3EcHb",
                handleConsentUIAutomatically: false
            )
        } else {
            self.init(
                apiKey: "eea5ad63-29d4-4552-9dac-2edebe1fe518",
                noticeID: "BVP3EcHb",
                handleConsentUIAutomatically: false
            )
        }
    }
}

extension DidomiUserStatus {
    // TODO: provide all legislation consents from DDM
    /// With SP, developers get an object `SPUserData` with all legislation consents, regardless if they apply to the current geolocation or not.
    /// We might have to implement a way on DDM to get that for all legislations, not only the "current".
    func toSourcepoint() -> SPUserData {
        var gdpr: SPConsent<SPGDPRConsent>? = nil
        var ccpa: SPConsent<SPCCPAConsent>? = nil
        var usnat: SPConsent<SPUSNatConsent>? = nil
        var preferences: SPConsent<SPPreferencesConsent>? = nil
        var globalcmp: SPConsent<SPGlobalCmpConsent>? = nil

        switch regulation {
            case .gdpr:
                gdpr = SPConsent(consents: mapToGDPRConsent(), applies: true)
            case .ccpa:
                ccpa = SPConsent(consents: mapToCCPAConsent(), applies: true)
            case .vcdpa, .cpra, .cpa, .ctdpa, .ucpa, .dpdpa, .fdbr, .icdpa, .incdpa, .kcdpa, .mcdpa, .mncdpa, .modpa, .ndpa, .nhpa, .njdpa, .ocpa, .ridtppa, .tdpsa, .tipa:
                // US state privacy laws (CPRA included) map to USNAT in Sourcepoint
                usnat = SPConsent(consents: mapToUSNatConsent(), applies: true)
            default: break
        }

        return SPUserData(gdpr: gdpr, ccpa: ccpa, usnat: usnat, globalcmp: globalcmp, preferences: preferences)
    }

    // Build a lookup dictionary of vendors from Didomi SDK
    private static func buildVendorLookup() -> [String: Vendor] {
        let requiredVendors = Didomi.shared.getRequiredVendors()
        var lookup: [String: Vendor] = [:]

        for vendor in requiredVendors {
            lookup[vendor.id] = vendor
        }

        return lookup
    }

    // swiftlint:disable function_body_length cyclomatic_complexity
    private func mapToGDPRConsent() -> SPGDPRConsent {
        var vendorGrants: SPGDPRVendorGrants = [:]
        var acceptedVendors: [String] = []
        var acceptedCategories: [String] = []
        var acceptedLegIntVendors: [String] = []
        var acceptedLegIntCategories: [String] = []
        var acceptedSpecialFeatures: [String] = []

        // Build vendor lookup from Didomi SDK
        let vendorLookup = DidomiUserStatus.buildVendorLookup()

        // Map vendors. Disabled vendors also get a grant (granted: false), same as Sourcepoint does.
        for (vendorId, vendorStatus) in vendors {
            // Get vendor from Didomi SDK
            let vendor = vendorLookup[vendorId]
            let spVendorId = vendor?.namespaces?.sp ?? vendorId

            // Build purpose grants for this vendor
            var purposeGrants: SPGDPRPurposeGrants = [:]
            var allPurposesGranted = true

            if let vendor = vendor {
                // Map consent purposes
                for purposeId in vendor.purposeIDs {
                    if let purposeStatus = purposes[purposeId],
                       let purpose = Didomi.shared.getPurpose(purposeId: purposeId),
                       let spPurposeId = purpose.namespaces?.sp {
                        purposeGrants[spPurposeId] = purposeStatus.enabled
                        if !purposeStatus.enabled {
                            allPurposesGranted = false
                        }
                    } else {
                        allPurposesGranted = false
                    }
                }

                // Map legitimate interest purposes
                for purposeId in vendor.legIntPurposeIDs {
                    if let purposeStatus = purposes[purposeId],
                       let purpose = Didomi.shared.getPurpose(purposeId: purposeId),
                       let spPurposeId = purpose.namespaces?.sp {
                        purposeGrants[spPurposeId] = purposeStatus.enabled
                        if !purposeStatus.enabled {
                            allPurposesGranted = false
                        }
                        if purposeStatus.enabled {
                            if !acceptedLegIntCategories.contains(spPurposeId) {
                                acceptedLegIntCategories.append(spPurposeId)
                            }
                        }
                    } else {
                        allPurposesGranted = false
                    }
                }

                if vendorStatus.enabled {
                    // Check for legitimate interest vendors
                    if !vendor.legIntPurposeIDs.isEmpty {
                        acceptedLegIntVendors.append(spVendorId)
                    }

                    // Map special features
                    for specialFeatureId in vendor.specialFeatureIDs {
                        if !acceptedSpecialFeatures.contains(specialFeatureId) {
                            acceptedSpecialFeatures.append(specialFeatureId)
                        }
                    }
                }
            }

            vendorGrants[spVendorId] = SPGDPRVendorGrant(
                granted: vendorStatus.enabled && allPurposesGranted,
                purposeGrants: purposeGrants
            )

            if vendorStatus.enabled {
                acceptedVendors.append(spVendorId)
            }
        }

        // Map purposes/categories. Purposes only used for legitimate interest are not consent categories.
        let consentPurposeIds = Set(vendorLookup.values.flatMap { $0.purposeIDs })
        for (purposeId, purposeStatus) in purposes where purposeStatus.enabled && consentPurposeIds.contains(purposeId) {
            guard let purpose = Didomi.shared.getPurpose(purposeId: purposeId),
                  let spPurposeId = purpose.namespaces?.sp else {
                continue
            }

            if !acceptedCategories.contains(spPurposeId) {
                acceptedCategories.append(spPurposeId)
            }
        }

        return SPGDPRConsent(
            uuid: userID.isEmpty ? nil : userID,
            vendorGrants: vendorGrants,
            euconsent: consentString,
            tcfData: tcfData(),
            childPmId: nil,
            dateCreated: parseDateString(created),
            expirationDate: parseDateString(updated).addingYears(1),
            applies: true,
            consentStatus: gdprConsentStatus(vendorLookup: vendorLookup, consentPurposeIds: consentPurposeIds),
            webConsentPayload: nil,
            googleConsentMode: nil,
            acceptedLegIntCategories: acceptedLegIntCategories,
            acceptedLegIntVendors: acceptedLegIntVendors,
            acceptedVendors: acceptedVendors,
            acceptedCategories: acceptedCategories,
            acceptedSpecialFeatures: acceptedSpecialFeatures
        )
    }
    // swiftlint:enable function_body_length

    private func mapToCCPAConsent() -> SPCCPAConsent {
        var rejectedVendors: [String] = []
        var rejectedCategories: [String] = []

        // Map rejected vendors (those with enabled=false)
        for (vendorId, vendorStatus) in vendors where !vendorStatus.enabled {
            if let vendor = Didomi.shared.getVendor(vendorId: vendorId),
               let spVendorId = vendor.namespaces?.sp {
                rejectedVendors.append(spVendorId)
            } else {
                // If we can't find the vendor in Didomi, the vendorId might already be the SP ID
                // This happens when Didomi ID == SP ID in the config
                rejectedVendors.append(vendorId)
            }
        }

        // Map rejected purposes/categories (those with enabled=false)
        for (purposeId, purposeStatus) in purposes where !purposeStatus.enabled {
            if let purpose = Didomi.shared.getPurpose(purposeId: purposeId),
               let spPurposeId = purpose.namespaces?.sp {
                rejectedCategories.append(spPurposeId)
            } else {
                // If we can't find the purpose in Didomi, the purposeId might already be the SP ID
                // This happens when Didomi ID == SP ID in the config
                rejectedCategories.append(purposeId)
            }
        }

        // Determine status
        let totalVendors = vendors.count
        let totalPurposes = purposes.count
        let status: CCPAConsentStatus

        if rejectedVendors.isEmpty && rejectedCategories.isEmpty {
            status = .RejectedNone
        } else if rejectedVendors.count == totalVendors && rejectedCategories.count == totalPurposes {
            status = .RejectedAll
        } else {
            status = .RejectedSome
        }

        let uspString = usPrivacyString()

        return SPCCPAConsent(
            uuid: userID.isEmpty ? nil : userID,
            status: status,
            rejectedVendors: rejectedVendors,
            rejectedCategories: rejectedCategories,
            signedLspa: uspString.map { $0.count == 4 && $0.last == "Y" } ?? false,
            childPmId: nil,
            applies: true,
            dateCreated: parseDateString(created),
            expirationDate: parseDateString(updated).addingYears(1),
            consentStatus: ConsentStatus(),
            webConsentPayload: nil,
            GPPData: parseGPPData(),
            uspStringOverride: uspString
        )
    }

    private func mapToUSNatConsent() -> SPUSNatConsent {
        var vendorsList: [SPConsentable] = []
        var categoriesList: [SPConsentable] = []

        let allVendors = Didomi.shared.getRequiredVendors()
        let allPurposes = Didomi.shared.getRequiredPurposes()

        // Map all configured vendors
        for vendor in allVendors {
            guard let spVendorId = vendor.namespaces?.sp else {
                continue
            }
            // No status in CurrentUserStatus means the user hasn't consented
            let consented = vendors[vendor.id]?.enabled ?? false
            vendorsList.append(SPConsentable(id: spVendorId, consented: consented))
        }

        // Map all configured purposes/categories
        for purpose in allPurposes {
            guard let spPurposeId = purpose.namespaces?.sp else {
                continue
            }
            // No status in CurrentUserStatus means the user hasn't consented
            let consented = purposes[purpose.id]?.enabled ?? false
            categoriesList.append(SPConsentable(id: spPurposeId, consented: consented))
        }

        // Parse consent strings from GPP data
        let consentStrings = parseConsentStrings()

        return SPUSNatConsent(
            uuid: userID.isEmpty ? nil : userID,
            applies: true,
            dateCreated: parseDateString(created),
            expirationDate: parseDateString(updated).addingYears(1),
            consentStrings: consentStrings,
            webConsentPayload: nil,
            categories: categoriesList,
            vendors: vendorsList,
            consentStatus: usnatConsentStatus(vendors: vendorsList, categories: categoriesList),
            GPPData: parseGPPData()
        )
    }

    // Helper methods
    private func parseDateString(_ dateString: String) -> SPDate {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        if let date = formatter.date(from: dateString) {
            return SPDate(date: date)
        }
        return SPDate.now()
    }

    // MARK: Consent status

    /// Didomi has a single enabled flag per vendor/purpose. Legitimate interest ones are told apart by being declared as such by the vendors.
    private func gdprConsentStatus(vendorLookup: [String: Vendor], consentPurposeIds: Set<String>) -> ConsentStatus {
        let legIntPurposeIds = Set(vendorLookup.values.flatMap { $0.legIntPurposeIDs })
        let vendorStates = vendors.values.map { $0.enabled }
        let legIntVendorStates = vendors.values.filter { !(vendorLookup[$0.id]?.legIntPurposeIDs.isEmpty ?? true) }.map { $0.enabled }
        let purposeStates = purposes.values.filter { consentPurposeIds.contains($0.id) }.map { $0.enabled }
        let legIntPurposeStates = purposes.values.filter { legIntPurposeIds.contains($0.id) }.map { $0.enabled }
        let consentStates = vendorStates + purposeStates
        let allStates = consentStates + legIntVendorStates + legIntPurposeStates
        let hasConsentData = !allStates.isEmpty

        var status = ConsentStatus()
        status.hasConsentData = hasConsentData
        status.consentedAll = hasConsentData && !allStates.contains(false)
        status.consentedToAll = status.consentedAll
        status.consentedToAny = allStates.contains(true)
        status.rejectedAll = hasConsentData && !allStates.contains(true)
        status.rejectedAny = consentStates.contains(false)
        status.rejectedLI = (legIntVendorStates + legIntPurposeStates).contains(false)
        status.granularStatus = ConsentStatus.GranularStatus(
            vendorConsent: DidomiUserStatus.scope(of: vendorStates),
            vendorLegInt: DidomiUserStatus.scope(of: legIntVendorStates),
            purposeConsent: DidomiUserStatus.scope(of: purposeStates),
            purposeLegInt: DidomiUserStatus.scope(of: legIntPurposeStates),
            previousOptInAll: false,
            defaultConsent: false
        )
        return status
    }

    private func usnatConsentStatus(vendors: [SPConsentable], categories: [SPConsentable]) -> ConsentStatus {
        let states = vendors.map { $0.consented } + categories.map { $0.consented }
        var status = ConsentStatus()
        status.hasConsentData = !states.isEmpty
        status.consentedToAll = !states.isEmpty && !states.contains(false)
        status.consentedAll = status.consentedToAll
        status.consentedToAny = states.contains(true)
        status.rejectedAll = !states.isEmpty && !states.contains(true)
        status.rejectedAny = states.contains(false)
        // Didomi has no data for the granular (sell, share, sensitive data and GPC) statuses
        return status
    }

    private static func scope(of states: [Bool]) -> String? {
        if states.isEmpty { return nil }
        if !states.contains(false) { return "ALL" }
        return states.contains(true) ? "SOME" : "NONE"
    }

    // MARK: TCF and US Privacy data

    private static let tcfUserDefaultsKeys = [
        "IABTCF_CmpSdkID", "IABTCF_CmpSdkVersion", "IABTCF_PolicyVersion", "IABTCF_gdprApplies", "IABTCF_PublisherCC",
        "IABTCF_PurposeOneTreatment", "IABTCF_UseNonStandardTexts", "IABTCF_TCString", "IABTCF_VendorConsents",
        "IABTCF_VendorLegitimateInterests", "IABTCF_PurposeConsents", "IABTCF_PurposeLegitimateInterests",
        "IABTCF_SpecialFeaturesOptIns", "IABTCF_PublisherConsent", "IABTCF_PublisherLegitimateInterests",
        "IABTCF_PublisherCustomPurposesConsents", "IABTCF_PublisherCustomPurposesLegitimateInterests",
        "IABTCF_AddtlConsent", "IABTCF_EnableAdvertiserConsentMode"
    ]

    /// TCF data: the TC string and the additional consent string come from Didomi. Didomi doesn't expose the
    /// rest of the `IABTCF_*` values (which it writes to `UserDefaults` itself), so those are read from there.
    private func tcfData() -> SPJson? {
        var data: [SPJson.Key: SPJson] = [:]
        if !consentString.isEmpty { data[SPJson.Key("IABTCF_TCString")] = .string(consentString) }
        if !additionalConsent.isEmpty { data[SPJson.Key("IABTCF_AddtlConsent")] = .string(additionalConsent) }
        data[SPJson.Key("IABTCF_gdprApplies")] = .number(1)

        for key in DidomiUserStatus.tcfUserDefaultsKeys where data[SPJson.Key(key)] == nil {
            switch UserDefaults.standard.object(forKey: key) {
            case let string as String: data[SPJson.Key(key)] = .string(string)
            case let number as NSNumber: data[SPJson.Key(key)] = .number(number.doubleValue)
            default: continue
            }
        }
        return .object(data)
    }

    /// The US Privacy String comes from the `uspv1` section of Didomi's GPP string, if there's one.
    /// Otherwise, from the `IABUSPrivacy_String` that Didomi writes to `UserDefaults`.
    private func usPrivacyString() -> String? {
        let uspSectionId = 6
        if let section = GPPString(gppString)?.sections.first(where: { $0.id == uspSectionId }), !section.value.isEmpty {
            return section.value
        }
        return UserDefaults.standard.string(forKey: "IABUSPrivacy_String")
    }

    /// GPP data as exposed by Didomi's `gppString`, in the shape of the `IABGPP_*` keys of the GPP spec.
    private func parseGPPData() -> SPJson {
        guard let gpp = GPPString(gppString) else { return SPJson() }
        var data: [SPJson.Key: SPJson] = [
            SPJson.Key("IABGPP_HDR_GppString"): .string(gppString),
            SPJson.Key("IABGPP_GppSID"): .string(gpp.sections.map { String($0.id) }.joined(separator: "_"))
        ]
        for section in gpp.sections {
            data[SPJson.Key("IABGPP_\(section.id)_String")] = .string(section.value)
        }
        return .object(data)
    }

    /// The US sections of Didomi's `gppString`
    private func parseConsentStrings() -> [SPUSNatConsent.ConsentString] {
        GPPString(gppString)?.sections.compactMap { section in
            guard let name = GPPString.usSectionNames[section.id] else { return nil }
            return SPUSNatConsent.ConsentString(sectionId: section.id, sectionName: name, consentString: section.value)
        } ?? []
    }
}

/// Minimal parser for a GPP string: `<header>~<section>~<section>...`.
/// The header lists the ids of the sections, in the same order they appear in the string.
/// - SeeAlso: https://github.com/InteractiveAdvertisingBureau/Global-Privacy-Platform/blob/main/Core/Consent%20String%20Specification.md
struct GPPString {
    struct Section: Equatable {
        let id: Int
        let value: String
    }

    static let usSectionNames: [Int: String] = [
        7: "usnat", 8: "usca", 9: "usva", 10: "usco", 11: "usut", 12: "usct", 13: "usfl", 14: "usmt", 15: "usor",
        16: "ustx", 17: "usde", 18: "usia", 19: "usne", 20: "usnh", 21: "usnj", 22: "ustn", 23: "usmn"
    ]

    let sections: [Section]

    init?(_ gppString: String) {
        let parts = gppString.split(separator: "~", omittingEmptySubsequences: false).map(String.init)
        guard parts.count > 1, var bits = GPPString.bits(fromBase64URL: parts[0]) else { return nil }
        // type (6 bits, always 3) and version (6 bits)
        guard bits.read(6) == 3, bits.read(6) != nil, let ids = bits.readFibonacciRanges(),
              ids.count == parts.count - 1 else { return nil }
        sections = zip(ids, parts.dropFirst()).map { Section(id: $0, value: $1) }
    }

    private static func bits(fromBase64URL string: String) -> GPPBitReader? {
        var base64 = string.replacingOccurrences(of: "-", with: "+").replacingOccurrences(of: "_", with: "/")
        while base64.count % 4 != 0 { base64 += "=" }
        guard let data = Data(base64Encoded: base64) else { return nil }
        return GPPBitReader(bytes: [UInt8](data))
    }
}

struct GPPBitReader {
    let bytes: [UInt8]
    var position = 0

    init(bytes: [UInt8]) { self.bytes = bytes }

    mutating func read(_ count: Int) -> Int? {
        guard position + count <= bytes.count * 8 else { return nil }
        var value = 0
        for _ in 0..<count { value = (value << 1) | readBit() }
        return value
    }

    private mutating func readBit() -> Int {
        let bit = Int(bytes[position / 8] >> UInt8(7 - position % 8)) & 1
        position += 1
        return bit
    }

    /// Fibonacci coded integer: bits are coefficients of 1, 2, 3, 5, 8..., terminated by two consecutive 1s
    mutating func readFibonacci() -> Int? {
        var value = 0, term = 1, next = 2, lastBit = 0
        while position < bytes.count * 8 {
            let bit = readBit()
            if bit == 1 && lastBit == 1 { return value }
            if bit == 1 { value += term }
            lastBit = bit
            (term, next) = (next, term + next)
        }
        return nil
    }

    /// 12 bit count, followed by single ids or `start..end` ranges, all as offsets from the previous id
    mutating func readFibonacciRanges() -> [Int]? {
        guard let count = read(12) else { return nil }
        var ids: [Int] = []
        var last = 0
        for _ in 0..<count {
            guard let isRange = read(1), let start = readFibonacci() else { return nil }
            if isRange == 1 {
                guard let length = readFibonacci() else { return nil }
                ids += Array((last + start)...(last + start + length))
                last += start + length
            } else {
                last += start
                ids.append(last)
            }
        }
        return ids
    }
}

// Helper extension for SPDate
private extension SPDate {
    func addingYears(_ years: Int) -> SPDate {
        let calendar = Calendar.current
        if let newDate = calendar.date(byAdding: .year, value: years, to: self.date) {
            return SPDate(date: newDate)
        }
        return self
    }
}
