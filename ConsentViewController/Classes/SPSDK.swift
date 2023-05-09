//
//  SPSDK.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 10.02.21.
//

import Foundation

@objc public protocol SPCCPA {
    @objc var ccpaApplies: Bool { get }

    @objc func loadCCPAPrivacyManager(withId id: String, tab: SPPrivacyManagerTab, useGroupPmIfAvailable: Bool)
}

@objc public protocol SPGDPR {
    @objc var gdprApplies: Bool { get }

    @objc func loadGDPRPrivacyManager(withId id: String, tab: SPPrivacyManagerTab, useGroupPmIfAvailable: Bool)
}

@objc public protocol SPSDK: SPGDPR, SPCCPA, SPMessageUIDelegate {
    @objc static var VERSION: String { get }
    @objc var cleanUserDataOnError: Bool { get set }
    @objc var messageTimeoutInSeconds: TimeInterval { get set }
    @objc var privacyManagerTab: SPPrivacyManagerTab { get set }
    @objc var messageLanguage: SPMessageLanguage { get set }
    @objc var userData: SPUserData { get }
    @objc init(
        accountId: Int,
        propertyId: Int,
        propertyName: SPPropertyName,
        campaigns: SPCampaigns,
        language: SPMessageLanguage,
        delegate: SPDelegate?
    )
    @objc static func clearAllData()
    @objc func loadMessage(forAuthId authId: String?, publisherData: SPPublisherData?)
    @objc func customConsentGDPR(
        vendors: [String],
        categories: [String],
        legIntCategories: [String],
        handler: @escaping (SPGDPRConsent) -> Void
    )
    @objc func deleteCustomConsentGDPR(
        vendors: [String],
        categories: [String],
        legIntCategories: [String],
        handler: @escaping (SPGDPRConsent) -> Void
    )
}

public extension SPSDK {
    init(
        accountId: Int,
        propertyId: Int,
        propertyName: SPPropertyName,
        campaigns: SPCampaigns,
        language: SPMessageLanguage = .BrowserDefault,
        delegate: SPDelegate?
    ) {
        self.init(
            accountId: accountId,
            propertyId: propertyId,
            propertyName: propertyName,
            campaigns: campaigns,
            language: language,
            delegate: delegate
        )
    }

    func loadMessage(forAuthId authId: String? = nil, pubData: SPPublisherData? = [:]) {
        loadMessage(forAuthId: authId, publisherData: pubData)
    }

    func loadCCPAPrivacyManager(withId id: String, tab: SPPrivacyManagerTab = .Default, useGroupPmIfAvailable: Bool = false) {
        loadCCPAPrivacyManager(withId: id, tab: tab, useGroupPmIfAvailable: useGroupPmIfAvailable)
    }

    func loadGDPRPrivacyManager(withId id: String, tab: SPPrivacyManagerTab = .Default, useGroupPmIfAvailable: Bool = false) {
        loadGDPRPrivacyManager(withId: id, tab: tab, useGroupPmIfAvailable: useGroupPmIfAvailable)
    }
}
