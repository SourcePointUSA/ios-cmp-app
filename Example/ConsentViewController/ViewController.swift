//
//  ViewController.swift
//  Example
//
//  Created by Andre Herculano on 15.05.19.
//  Copyright © 2019 sourcepoint. All rights reserved.
//

// swiftlint:disable force_unwrapping

import ConsentViewController
import UIKit

class ViewController: UIViewController {
    var sdkStatus: SDKStatus = .notStarted
    var idfaStatus: SPIDFAStatus { SPIDFAStatus.current() }
    var myVendorAccepted: VendorStatus = .Unknown

    lazy var config = { Config(fromStorageWithDefaults: Config(
        accountId: 22,
        propertyId: 16893,
        propertyName: "mobile.multicampaign.demo",
        campaigns: SPCampaigns(
            gdpr: SPCampaign(),
            ccpa: SPCampaign(),
            usnat: SPCampaign(),
            ios14: SPCampaign(),
            globalcmp: SPCampaign(),
            preferences: SPCampaign(),
            environment: .Public
        ),
        gdprPmId: "488393",
        ccpaPmId: "509688",
        usnatPmId: "988851",
        globalcmpPmId: "1323762",
        preferenceCenterId: "1306779"
    ))}()

    lazy var consentManager: SPDidomiConsentManager = { SPDidomiConsentManager(
        accountId: config.accountId,
        propertyId: config.propertyId,
        propertyName: try! SPPropertyName(config.propertyName), // swiftlint:disable:this force_try
        campaigns: config.campaigns,
        language: config.language ?? .BrowserDefault,
        delegate: self,
        configFileName: "SourcepointConfigGDPR"
    )}()

    @IBOutlet var sdkStatusLabel: UILabel!
    @IBOutlet var idfaStatusLabel: UILabel!
    @IBOutlet var myVendorAcceptedLabel: UILabel!
    @IBOutlet var acceptMyVendorButton: UIButton!
    @IBOutlet var deleteMyVendorButton: UIButton!
    @IBOutlet var gdprPMButton: UIButton!
    @IBOutlet var ccpaPMButton: UIButton!
    @IBOutlet weak var usnatPMButton: UIButton!
    @IBOutlet weak var globalcmpPMButton: UIButton!
    @IBOutlet weak var preferencesPMButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        sdkStatus = .running
        sdkStatusLabel.accessibilityIdentifier = "sdkStatusLabel"
        myVendorAcceptedLabel.accessibilityIdentifier = "customVendorLabel"
        consentManager.didomiUIController = self
        consentManager.loadMessage(forAuthId: nil, publisherData: ["foo": AnyEncodable(99)])
        updateUI()

        // Listen for UserDefaults import notifications
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleUserDefaultsImported),
            name: NSNotification.Name("UserDefaultsDataImported"),
            object: nil
        )
    }

    @IBAction func onNetworkCallsTap(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "wormholy_fire"), object: nil)
    }

    @IBAction func onClearConsentTap(_ sender: Any) {
        clearConsentUserDefaults()

        sdkStatus = .notStarted
        updateUI()
    }

    /// Clears all consent-related keys from UserDefaults
    /// Removes keys starting with "IAB_", containing "didomi" (case-insensitive), or starting with "sp"
    private func clearConsentUserDefaults() {
        let userDefaults = UserDefaults.standard
        let allKeys = userDefaults.dictionaryRepresentation().keys

        let keysToRemove = allKeys.filter { key in
            let lowercaseKey = key.lowercased()
            return key.contains("IAB") || lowercaseKey.contains("didomi") || lowercaseKey.hasPrefix("sp")
        }

        print("Clearing \(keysToRemove.count) UserDefaults keys:")
        for key in keysToRemove {
            print("  - \(key)")
            userDefaults.removeObject(forKey: key)
        }

        userDefaults.synchronize()
        print("UserDefaults cleared successfully")
    }

    @IBAction func onLoadMessagesTap(_ sender: Any) {
        print("onLoadMessagesTap")
        sdkStatus = .running
        consentManager = SPDidomiConsentManager(
            accountId: config.accountId,
            propertyId: config.propertyId,
            propertyName: try! SPPropertyName(config.propertyName), // swiftlint:disable:this force_try
            campaigns: config.campaigns,
            language: config.language ?? .BrowserDefault,
            delegate: self
        )
        consentManager.loadMessage(forAuthId: nil, publisherData: ["foo": AnyEncodable(99)])
        updateUI()
    }

    @IBAction func onGDPRPrivacyManagerTap(_ sender: Any) {
        consentManager.loadGDPRPrivacyManager(withId: config.gdprPmId!)
    }

    @IBAction func onCCPAPrivacyManagerTap(_ sender: Any) {
        consentManager.loadCCPAPrivacyManager(withId: config.ccpaPmId!)
    }

    @IBAction func onUSNatPrivacyManagerTap(_ sender: Any) {
        consentManager.loadUSNatPrivacyManager(withId: config.usnatPmId!)
    }

    @IBAction func onGlobalCmpPrivacyManagerTap(_ sender: Any) {
        consentManager.loadGlobalCmpPrivacyManager(withId: config.globalcmpPmId!)
    }

    @IBAction func onPreferenceCenterTap(_ sender: Any) {
        consentManager.loadPreferenceCenter(withId: config.preferenceCenterId!)
    }

    @IBAction func onAcceptMyVendorTap(_ sender: Any) {
        consentManager.customConsentGDPR(
            vendors: [config.myVendorId],
            categories: config.myPurposesId,
            legIntCategories: []) { consents in
                self.myVendorAccepted = VendorStatus(fromBool: consents.vendorGrants[self.config.myVendorId]?.granted)
                self.updateUI()
            }
    }

    @IBAction func onDeleteMyVendorTap(_ sender: Any) {
        consentManager.deleteCustomConsentGDPR(
            vendors: [config.myVendorId],
            categories: config.myPurposesId,
            legIntCategories: []) { consents in
                self.myVendorAccepted = VendorStatus(fromBool: consents.vendorGrants[self.config.myVendorId]?.granted)
                self.updateUI()
            }
    }

    @objc private func handleUserDefaultsImported() {
        // Re-initialize the consent manager to pick up imported data
        consentManager = SPDidomiConsentManager(
            accountId: config.accountId,
            propertyId: config.propertyId,
            propertyName: try! SPPropertyName(config.propertyName), // swiftlint:disable:this force_try
            campaigns: config.campaigns,
            language: config.language ?? .BrowserDefault,
            delegate: self
        )

        // Reset vendor status since we have new data
        myVendorAccepted = .Unknown

        // Update UI to reflect the new state
        sdkStatus = .notStarted
        updateUI()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - SPDelegate implementation
extension ViewController: SPDelegate {
    func onSPUIReady(_ controller: UIViewController) {
        print("onSPUIReady")
        present(controller, animated: true)
    }

    func onAction(_ action: SPAction, from controller: UIViewController) {
        print("onAction:", action.type.description)
        action.publisherData = ["foo": .init("any encodable")]
        updateUI()
    }

    func onSPUIFinished(_ controller: UIViewController) {
        print("onSPUIFinished")
        updateUI()
        dismiss(animated: true)
    }

    func onConsentReady(userData: SPUserData) {
        print("onConsentReady:", userData)
        myVendorAccepted = VendorStatus(
            fromBool: userData.gdpr?.consents?.vendorGrants[config.myVendorId]?.granted
        )
        updateUI()
    }

    func onSPFinished(userData: SPUserData) {
        print("SDK DONE")
        sdkStatus = .finished
        updateUI()
    }

    func onError(error: SPError) {
        print("Something went wrong: ", error)
        sdkStatus = .errored
        updateUI()
    }
}

// MARK: - UI methods
extension ViewController {
    func updateUI() {
        updateIDFAStatusLabel()
        updateMyVendorUI()
        updatePMButtons(
            ccpaApplies: consentManager.ccpaApplies,
            gdprApplies: consentManager.gdprApplies,
            usnatApplies: consentManager.usnatApplies,
            globalcmpApplies: consentManager.globalcmpApplies,
            isPreferencesCampaignPresent: config.campaigns.preferences != nil
        )
        updateSDKStatusLabel()
    }

    func updateIDFAStatusLabel() {
        idfaStatusLabel.text = idfaStatus.description
        switch idfaStatus {
        case .unknown: idfaStatusLabel.textColor = .systemYellow
        case .accepted: idfaStatusLabel.textColor = .systemGreen
        case .denied: idfaStatusLabel.textColor = .systemRed
        case .unavailable: idfaStatusLabel.textColor = .systemGray
        @unknown default: break
        }
    }

    func updateMyVendorUI() {
        myVendorAcceptedLabel.text = myVendorAccepted.rawValue
        switch myVendorAccepted {
            case .Unknown:
                myVendorAcceptedLabel.textColor = .systemGray
                acceptMyVendorButton.isEnabled = false
                deleteMyVendorButton.isEnabled = false

            case .Accepted:
                myVendorAcceptedLabel.textColor = .systemGreen
                acceptMyVendorButton.isEnabled = false
                deleteMyVendorButton.isEnabled = true

            case .Rejected:
                myVendorAcceptedLabel.textColor = .systemRed
                acceptMyVendorButton.isEnabled = true
                deleteMyVendorButton.isEnabled = false
        }
    }

    func updatePMButtons(ccpaApplies: Bool, gdprApplies: Bool, usnatApplies: Bool, globalcmpApplies: Bool, isPreferencesCampaignPresent: Bool) {
        gdprPMButton.isEnabled = gdprApplies
        ccpaPMButton.isEnabled = ccpaApplies
        usnatPMButton.isEnabled = usnatApplies
        globalcmpPMButton.isEnabled = globalcmpApplies
        preferencesPMButton.isEnabled = isPreferencesCampaignPresent
    }

    func updateSDKStatusLabel() {
        sdkStatusLabel.text = sdkStatus.rawValue
    }
}

// swiftlint:enable force_unwrapping
