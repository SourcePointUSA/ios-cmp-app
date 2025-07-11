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
        globalcmpPmId: "1323762"
    ))}()

    lazy var consentManager: SPSDK = { SPConsentManager(
        accountId: config.accountId,
        propertyId: config.propertyId,
        propertyName: try! SPPropertyName(config.propertyName), // swiftlint:disable:this force_try
        campaigns: config.campaigns,
        language: config.language ?? .BrowserDefault,
        delegate: self
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

    override func viewDidLoad() {
        super.viewDidLoad()
        sdkStatus = .running
        sdkStatusLabel.accessibilityIdentifier = "sdkStatusLabel"
        myVendorAcceptedLabel.accessibilityIdentifier = "customVendorLabel"
        consentManager.loadMessage(forAuthId: nil, publisherData: ["foo": AnyEncodable(99)])
        updateUI()
    }

    @IBAction func onNetworkCallsTap(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "wormholy_fire"), object: nil)
    }

    @IBAction func onClearConsentTap(_ sender: Any) {
        SPConsentManager.clearAllData()
        myVendorAccepted = .Unknown
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
}

// MARK: - SPDelegate implementation
extension ViewController: SPDelegate {
    func onSPUIReady(_ controller: UIViewController) {
        present(controller, animated: true)
    }

    func onAction(_ action: SPAction, from controller: UIViewController) {
        print("onAction:", action.type.description)
        action.publisherData = ["foo": .init("any encodable")]
        updateUI()
    }

    func onSPUIFinished(_ controller: UIViewController) {
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
            globalcmpApplies: consentManager.globalcmpApplies
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

    func updatePMButtons(ccpaApplies: Bool, gdprApplies: Bool, usnatApplies: Bool, globalcmpApplies: Bool) {
        gdprPMButton.isEnabled = gdprApplies
        ccpaPMButton.isEnabled = ccpaApplies
        usnatPMButton.isEnabled = usnatApplies
        globalcmpPMButton.isEnabled = globalcmpApplies
    }

    func updateSDKStatusLabel() {
        sdkStatusLabel.text = sdkStatus.rawValue
    }
}

// swiftlint:enable force_unwrapping
