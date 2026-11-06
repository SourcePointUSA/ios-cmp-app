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
            case .cpra:
                ccpa = SPConsent(consents: mapToCCPAConsent(), applies: true)
                usnat = SPConsent(consents: mapToUSNatConsent(), applies: true)
            case .vcdpa, .cpa, .ctdpa, .ucpa, .dpdpa, .fdbr, .icdpa, .incdpa, .kcdpa, .mcdpa, .mncdpa, .modpa, .ndpa, .nhpa, .njdpa, .ocpa, .ridtppa, .tdpsa, .tipa:
                // US state privacy laws map to USNAT in Sourcepoint
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

        // Map vendors
        for (vendorId, vendorStatus) in vendors where vendorStatus.enabled {
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

            vendorGrants[spVendorId] = SPGDPRVendorGrant(
                granted: allPurposesGranted,
                purposeGrants: purposeGrants
            )

            acceptedVendors.append(spVendorId)
        }

        // Read TC string directly from UserDefaults since Didomi doesn't expose it from migration
        let tcString = UserDefaults.standard.string(forKey: "IABTCF_TCString") ?? ""

        // Map purposes/categories
        for (purposeId, purposeStatus) in purposes where purposeStatus.enabled {
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
            euconsent: tcString,
            tcfData: nil,
            childPmId: nil,
            dateCreated: parseDateString(created),
            expirationDate: parseDateString(updated).addingYears(1),
            applies: true,
            consentStatus: ConsentStatus(),
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
            guard let vendor = Didomi.shared.getVendor(vendorId: vendorId),
                  let spVendorId = vendor.namespaces?.sp else {
                continue
            }
            rejectedVendors.append(spVendorId)
        }

        // Map rejected purposes/categories (those with enabled=false)
        for (purposeId, purposeStatus) in purposes where !purposeStatus.enabled {
            guard let purpose = Didomi.shared.getPurpose(purposeId: purposeId),
                  let spPurposeId = purpose.namespaces?.sp else {
                continue
            }
            rejectedCategories.append(spPurposeId)
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

        return SPCCPAConsent(
            uuid: userID.isEmpty ? nil : userID,
            status: status,
            rejectedVendors: rejectedVendors,
            rejectedCategories: rejectedCategories,
            signedLspa: false,
            childPmId: nil,
            applies: true,
            dateCreated: parseDateString(created),
            expirationDate: parseDateString(updated).addingYears(1),
            consentStatus: ConsentStatus(),
            webConsentPayload: nil,
            GPPData: parseGPPData()
        )
    }

    private func mapToUSNatConsent() -> SPUSNatConsent {
        var vendorsList: [SPConsentable] = []
        var categoriesList: [SPConsentable] = []

        let allVendors = Didomi.shared.getRequiredVendors()
        let allPurposes = Didomi.shared.getRequiredPurposes()

        // Map vendors - assume all configured vendors are consented for USNAT migration
        for vendor in allVendors {
            guard let spVendorId = vendor.namespaces?.sp else {
                continue
            }
            // Check if we have status in CurrentUserStatus, otherwise default to consented
            let consented = vendors[vendor.id]?.enabled ?? true
            vendorsList.append(SPConsentable(id: spVendorId, consented: consented))
        }

        // Map purposes/categories - assume all configured purposes are consented for USNAT migration
        for purpose in allPurposes {
            guard let spPurposeId = purpose.namespaces?.sp else {
                continue
            }
            // Check if we have status in CurrentUserStatus, otherwise default to consented
            let consented = purposes[purpose.id]?.enabled ?? true
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
            consentStatus: ConsentStatus(),
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

    private func parseGPPData() -> SPJson {
        // Parse GPP string into JSON structure
        // Note: SPJson is provided by SPMobileCore framework
        // For Didomi integration, GPP data is managed internally by Didomi SDK
        // and exposed via the gppString property on CurrentUserStatus
        return SPJson()
    }

    private func parseConsentStrings() -> [SPUSNatConsent.ConsentString] {
        // Extract consent strings from GPP data in UserDefaults
        // Didomi doesn't expose GPP string via CurrentUserStatus for USNAT, so read directly
        var consentStrings: [SPUSNatConsent.ConsentString] = []

        let gppString = UserDefaults.standard.string(forKey: "IABGPP_HDR_GppString") ?? ""
        let gppSID = UserDefaults.standard.string(forKey: "IABGPP_GppSID") ?? ""

        if !gppString.isEmpty, let sectionId = Int(gppSID) {
            // Map section ID to section name
            let sectionName: String
            switch sectionId {
            case 7: sectionName = "uspca" // California (CPRA)
            case 8: sectionName = "uspva" // Virginia
            case 9: sectionName = "uspco" // Colorado
            case 10: sectionName = "uspct" // Connecticut
            case 11: sectionName = "uspfl" // Florida
            case 12: sectionName = "usct" // Connecticut (alternative)
            default: sectionName = "usnat" // Generic US National
            }

            consentStrings.append(SPUSNatConsent.ConsentString(
                sectionId: sectionId,
                sectionName: sectionName,
                consentString: gppString
            ))
        }

        return consentStrings
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
