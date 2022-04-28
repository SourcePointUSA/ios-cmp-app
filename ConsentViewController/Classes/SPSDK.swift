//
//  SPSDK.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 10.02.21.
//

import Foundation

@objc public protocol SPCCPA {
    @objc func loadCCPAPrivacyManager(withId id: String, tab: SPPrivacyManagerTab)
    @objc var ccpaApplies: Bool { get }
}

@objc public protocol SPGDPR {
    @objc func loadGDPRPrivacyManager(withId id: String, tab: SPPrivacyManagerTab)
    @objc var gdprApplies: Bool { get }
}

@objc public protocol SPSDK: SPGDPR, SPCCPA, SPMessageUIDelegate {
    @objc static var VERSION: String { get }
    @objc static func clearAllData()
    @objc var cleanUserDataOnError: Bool { get set }
    @objc var messageTimeoutInSeconds: TimeInterval { get set }
    @objc var privacyManagerTab: SPPrivacyManagerTab { get set }
    @objc var messageLanguage: SPMessageLanguage { get set }
    @objc var userData: SPUserData { get }
    @objc init(
        accountId: Int,
        propertyName: SPPropertyName,
        campaignsEnv: SPCampaignEnv,
        campaigns: SPCampaigns,
        delegate: SPDelegate?
    )
    @objc func loadMessage(forAuthId authId: String?, publisherData: SPPublisherData?)
    @objc func customConsentGDPR(
        vendors: [String],
        categories: [String],
        legIntCategories: [String],
        handler: @escaping (SPGDPRConsent) -> Void
    )
    @objc func logErrorMetrics(_ error: SPError)
}

public extension SPSDK {
    init(
        accountId: Int,
        propertyName: SPPropertyName,
        campaignsEnv: SPCampaignEnv = .Public,
        campaigns: SPCampaigns,
        delegate: SPDelegate?
    ) {
        self.init(accountId: accountId, propertyName: propertyName, campaignsEnv: campaignsEnv, campaigns: campaigns, delegate: delegate)
    }

    func loadMessage(forAuthId authId: String? = "", pubData: SPPublisherData? = [:]) {
        loadMessage(forAuthId: authId, publisherData: pubData)
    }

    func loadCCPAPrivacyManager(withId id: String, tab: SPPrivacyManagerTab = .Default, useGroupPmIfAvailable: Bool = false) {
        if useGroupPmIfAvailable, let childPmId = SPUserDefaults(storage: UserDefaults.standard).ccpaChildPMId {
            // not available for ccpa
            logErrorMetrics(LogCustomMetricsChildPmIdError(fallbackId: id, usedId: childPmId, useGroupPmIfAvailable: useGroupPmIfAvailable))
            fatalError("loadCCPAPrivacyManager with childPmId has not been implemented")
        } else {
            loadCCPAPrivacyManager(withId: id, tab: tab)
            logErrorMetrics(LogCustomMetricsChildPmIdError(fallbackId: id, usedId: id, useGroupPmIfAvailable: useGroupPmIfAvailable))
        }
    }

    func loadGDPRPrivacyManager(withId id: String, tab: SPPrivacyManagerTab = .Default, useGroupPmIfAvailable: Bool = false) {
        if useGroupPmIfAvailable, let childPmId = SPUserDefaults(storage: UserDefaults.standard).gdprChildPMId {
            loadGDPRPrivacyManager(withId: childPmId, tab: tab)
            logErrorMetrics(LogCustomMetricsChildPmIdError(fallbackId: id, usedId: childPmId, useGroupPmIfAvailable: useGroupPmIfAvailable))
        } else {
            loadGDPRPrivacyManager(withId: id, tab: tab)
            logErrorMetrics(LogCustomMetricsChildPmIdError(fallbackId: id, usedId: id, useGroupPmIfAvailable: useGroupPmIfAvailable))
        }
    }
}
