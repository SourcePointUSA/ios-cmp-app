//
//  Wrapper.swift
//  Pods
//
//  Created by Andre Herculano on 14/4/25.
//

// This file exists to satisfy SwiftPM's requirement for a source file.
// The actual purpose of this target is to bundle tvOS-only resources (e.g., XIBs).

import Foundation
import UIKit

@_exported import ConsentViewControllerCore

@objcMembers public class SPConsentManagerTvOS: NSObject, SPSDK {
    public static var VERSION = SPConsentManager.VERSION

    public var cleanUserDataOnError: Bool {
        get { wrapped.cleanUserDataOnError }
        set { wrapped.cleanUserDataOnError = newValue }
    }

    public var messageTimeoutInSeconds: TimeInterval {
        get { wrapped.messageTimeoutInSeconds }
        set { wrapped.messageTimeoutInSeconds = newValue }
    }

    public var privacyManagerTab: SPPrivacyManagerTab {
        get { wrapped.privacyManagerTab }
        set { wrapped.privacyManagerTab = newValue }
    }

    public var messageLanguage: SPMessageLanguage {
        get { wrapped.messageLanguage }
        set { wrapped.messageLanguage = newValue }
    }

    public var userData: SPUserData { wrapped.userData }

    public var gdprApplies: Bool { wrapped.gdprApplies }

    public var ccpaApplies: Bool { wrapped.ccpaApplies }

    public var usnatApplies: Bool { wrapped.usnatApplies }

    let wrapped: SPConsentManager

    public required init(
        accountId: Int,
        propertyId: Int,
        propertyName: SPPropertyName,
        campaigns: SPCampaigns,
        language: SPMessageLanguage,
        delegate: (any SPDelegate)?) {
            let url = Bundle(for: Self.self).url(forResource: "ConsentViewController_ConsentViewControllerTvOS", withExtension: "bundle")!
            let resourceBundle = Bundle(url: url)!

            ConsentViewControllerCore.SPPMHeader.nib = UINib(nibName: "SPPMHeader", bundle: resourceBundle)
            ConsentViewControllerCore.LongButtonViewCell.nib = UINib(nibName: "LongButtonViewCell", bundle: resourceBundle)
            ConsentViewControllerCore.SPMessageViewController.bundle = resourceBundle

            wrapped = .init(
                accountId: accountId,
                propertyId: propertyId,
                propertyName: propertyName,
                campaigns: campaigns,
                delegate: delegate
            )
    }

    public func loadMessage(forAuthId authId: String?, publisherData: [String : String]?) {
        wrapped.loadMessage(forAuthId: authId, publisherData: publisherData)
    }

    public func loadMessage(forAuthId authId: String?, publisherData: SPPublisherData?) {
        wrapped.loadMessage(forAuthId: authId, publisherData: publisherData)
    }

    @objc public func loadUSNatPrivacyManager(withId id: String, tab: SPPrivacyManagerTab, useGroupPmIfAvailable: Bool) {
        wrapped.loadUSNatPrivacyManager(withId: id, tab: tab, useGroupPmIfAvailable: useGroupPmIfAvailable)
    }

    @objc public func loadGDPRPrivacyManager(withId id: String, tab: SPPrivacyManagerTab, useGroupPmIfAvailable: Bool) {
        wrapped.loadGDPRPrivacyManager(withId: id, tab: tab, useGroupPmIfAvailable: useGroupPmIfAvailable)
    }

    @objc public func loadCCPAPrivacyManager(withId id: String, tab: SPPrivacyManagerTab, useGroupPmIfAvailable: Bool) {
        wrapped.loadCCPAPrivacyManager(withId: id, tab: tab, useGroupPmIfAvailable: useGroupPmIfAvailable)
    }

    public static func clearAllData() {
        SPConsentManager.clearAllData()
    }
    
    public func customConsentGDPR(vendors: [String], categories: [String], legIntCategories: [String], handler: @escaping (SPGDPRConsent) -> Void) {
        wrapped.customConsentGDPR(vendors: vendors, categories: categories, legIntCategories: legIntCategories, handler: handler)
    }
    
    public func deleteCustomConsentGDPR(vendors: [String], categories: [String], legIntCategories: [String], handler: @escaping (SPGDPRConsent) -> Void) {
        wrapped.deleteCustomConsentGDPR(vendors: vendors, categories: categories, legIntCategories: legIntCategories, handler: handler)
    }
    
    public func rejectAll(campaignType: SPCampaignType) {
        wrapped.rejectAll(campaignType: campaignType)
    }
    
    public func loaded(_ controller: UIViewController) {
        wrapped.loaded(controller)
    }
    
    public func action(_ action: SPAction, from controller: UIViewController) {
        wrapped.onAction(action, from: controller)
    }
    
    public func onError(_ error: SPError) {
        wrapped.onError(error)
    }
    
    public func finished(_ vcFinished: UIViewController) {
        wrapped.finished(vcFinished)
    }
}

