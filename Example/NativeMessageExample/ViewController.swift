//
//  ViewController.swift
//  NativeMessageExample
//
//  Created by Andre Herculano on 25.01.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import ConsentViewController

import UIKit
import ConsentViewController

class ViewController: UIViewController {
    var idfaStatus: SPIDFAStatus { SPIDFAStatus.current() }
    let myVendorId = "5ff4d000a228633ac048be41"
    let myPurposesId = ["6140b74a5e783f00145e8220", "6140b74a5e783f00145e8218"]

    @IBOutlet weak var idfaStatusLabel: UILabel!
    @IBOutlet weak var myVendorAcceptedLabel: UILabel!
    @IBOutlet weak var acceptMyVendorButton: UIButton!
    @IBOutlet weak var gdprPMButton: UIButton!
    @IBOutlet weak var ccpaPMButton: UIButton!

    var messageController: SPNativeMessageViewController!

    @IBAction func onNetworkCallsTap(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "wormholy_fire"), object: nil)
    }

    @IBAction func onClearConsentTap(_ sender: Any) {
        SPConsentManager.clearAllData()
        updateUI()
    }

    @IBAction func onGDPRPrivacyManagerTap(_ sender: Any) {
        consentManager.loadGDPRPrivacyManager(withId: "17257")
        showSpinner()
    }

    @IBAction func onCCPAPrivacyManagerTap(_ sender: Any) {
        consentManager.loadCCPAPrivacyManager(withId: "17258")
        showSpinner()
    }

    @IBAction func onAcceptMyVendorTap(_ sender: Any) {
        consentManager.customConsentGDPR(
            vendors: [myVendorId],
            categories: myPurposesId,
            legIntCategories: []) { [weak self] consents in
                let vendorAccepted = consents.vendorGrants[self?.myVendorId ?? ""]?.granted
                self?.updateMyVendorUI(vendorAccepted)
            }
    }

    lazy var consentManager: SPConsentManager = { SPConsentManager(
        accountId: 22,
        propertyName: try! SPPropertyName("andre.native"),
        campaigns: SPCampaigns(
            gdpr: SPCampaign(),
            ccpa: SPCampaign(),
            ios14: SPCampaign()
        ),
        delegate: self
    )}()

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        consentManager.loadMessage()
    }
}

// MARK: SPDelegate implementation
extension ViewController: SPDelegate {
    func onSPNativeMessageReady(_ message: SPNativeMessage) {
        messageController = SPNativeMessageViewController(messageContents: message, sdkDelegate: consentManager)
        present(messageController, animated: true)
        removeSpinner()
    }

    func onAction(_ action: SPAction, from controller: UIViewController) {
        print(action)
    }

    func onSPUIReady(_ controller: UIViewController) {
        present(controller, animated: true)
        removeSpinner()
    }

    func onConsentReady(userData: SPUserData) {
        print("onConsentReady:", userData)
        let vendorAccepted = userData.gdpr?.consents?.vendorGrants[myVendorId]?.granted ?? false
        updateMyVendorUI(vendorAccepted)
        updatePMButtons(ccpaApplies: consentManager.ccpaApplies, gdprApplies: consentManager.gdprApplies)
    }

    func onSPUIFinished(_ controller: UIViewController) {
        updateUI()
        dismiss(animated: true)
    }

    func onError(error: SPError) {
        print(error)
        removeSpinner()
        updateUI()
    }
}

// MARK: - UI methods
extension ViewController {
    func updateUI() {
        updateMyVendorUI()
        updatePMButtons()
        updateIDFAStatusLabel()
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
        updatePMButtons(ccpaApplies: consentManager.gdprApplies, gdprApplies: consentManager.ccpaApplies)
    }

    func updatePMButtons() {
        updateMyVendorUI(
            consentManager.userData.gdpr?.consents?.vendorGrants[myVendorId]?.granted
        )
    }

    func updateMyVendorUI(_ accepted: Bool?) {
        if let accepted = accepted {
            myVendorAcceptedLabel.text = accepted ? "accepted" : "rejected"
            myVendorAcceptedLabel.textColor = accepted ? .systemGreen : .systemRed
            acceptMyVendorButton.isEnabled = !accepted
        } else {
            acceptMyVendorButton.isEnabled = false
            myVendorAcceptedLabel.text = "unavailable"
            myVendorAcceptedLabel.textColor = .systemGray
        }
    }

    func updatePMButtons(ccpaApplies: Bool, gdprApplies: Bool) {
        gdprPMButton.isEnabled = gdprApplies
        ccpaPMButton.isEnabled = ccpaApplies
    }
}
