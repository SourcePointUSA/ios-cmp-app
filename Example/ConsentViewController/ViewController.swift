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
        campaign: .gdpr,
        gdprPmId: "488393",
        ccpaPmId: "509688",
        usnatPmId: "988851"
    ))}()

    lazy var consentManager: SPDidomiConsentManager = makeConsentManager()

    func makeConsentManager() -> SPDidomiConsentManager {
        SPDidomiConsentManager(
            apiKey: config.didomiApiKey,
            noticeId: config.didomiNoticeId,
            language: config.language ?? .BrowserDefault,
            configFileName: config.campaign.configFileName,
            delegate: self
        )
    }

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
        globalcmpPMButton.isHidden = true
        preferencesPMButton.isHidden = true
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
        AppDelegate.clearConsentUserDefaults()

        sdkStatus = .notStarted
        updateUI()
    }

    @IBAction func onLoadMessagesTap(_ sender: Any) {
        print("onLoadMessagesTap")
        sdkStatus = .running
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
        consentManager.loadGlobalCmpPrivacyManager(withId: "")
    }

    @IBAction func onPreferenceCenterTap(_ sender: Any) {
        consentManager.loadPreferenceCenter(withId: "")
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
        consentManager = makeConsentManager()

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
        // Didomi may present its preferences on top of the notice, so we always present from the top-most controller.
        topMostViewController().present(controller, animated: true)
    }

    func onAction(_ action: SPAction, from controller: UIViewController) {
        print("onAction:", action.type.description)
        action.publisherData = ["foo": .init("any encodable")]
        updateUI()
    }

    func onSPUIFinished(_ controller: UIViewController) {
        print("onSPUIFinished")
        updateUI()
        if controller.presentingViewController != nil {
            controller.dismiss(animated: true)
        }
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
        updatePMButtons()
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

    func updatePMButtons() {
        let isReady = sdkStatus == .finished
        gdprPMButton.isEnabled = isReady && config.campaign == .gdpr
        ccpaPMButton.isEnabled = isReady && config.campaign == .ccpa
        usnatPMButton.isEnabled = isReady && config.campaign == .usnat
    }

    func updateSDKStatusLabel() {
        sdkStatusLabel.text = sdkStatus.rawValue
    }
}

extension UIViewController {
    func topMostViewController() -> UIViewController {
        var top = self
        while let presented = top.presentedViewController {
            top = presented
        }
        return top
    }
}

// swiftlint:enable force_unwrapping
