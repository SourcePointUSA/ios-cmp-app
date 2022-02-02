//
//  ViewController.swift
//  Example
//
//  Created by Andre Herculano on 15.05.19.
//  Copyright © 2019 sourcepoint. All rights reserved.
//

import UIKit
import ConsentViewController

class ViewController: UIViewController {
    var idfaStatus: SPIDFAStatus { SPIDFAStatus.current() }
    let myVendorId = "5ff4d000a228633ac048be41"
    let myPurposesId = ["608bad95d08d3112188e0e36", "608bad95d08d3112188e0e2f"]

    @IBOutlet weak var idfaStatusLabel: UILabel!
    @IBOutlet weak var myVendorAcceptedLabel: UILabel!
    @IBOutlet weak var acceptMyVendorButton: UIButton!
    @IBOutlet weak var gdprPMButton: UIButton!
    @IBOutlet weak var ccpaPMButton: UIButton!

    @IBAction func onNetworkCallsTap(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "wormholy_fire"), object: nil)
    }

    @IBAction func onClearConsentTap(_ sender: Any) {
        SPConsentManager.clearAllData()
    }

    @IBAction func onGDPRPrivacyManagerTap(_ sender: Any) {
        consentManager.loadGDPRPrivacyManager(withId: "488393")
    }

    @IBAction func onCCPAPrivacyManagerTap(_ sender: Any) {
        consentManager.loadCCPAPrivacyManager(withId: "509688")
    }

    @IBAction func onAcceptMyVendorTap(_ sender: Any) {
        consentManager.customConsentGDPR(
            vendors: [myVendorId],
            categories: myPurposesId,
            legIntCategories: []) { [weak self] consents in
            let vendorAccepted = consents.vendorGrants[self?.myVendorId ?? ""]?.granted ?? false
            self?.updateMyVendorUI(vendorAccepted)
        }
    }

    lazy var consentManager: SPSDK = { SPConsentManager(
        accountId: 22,
        propertyName: try! SPPropertyName("mobile.multicampaign.demo"),
        campaigns: SPCampaigns(
            gdpr: SPCampaign(),
            ccpa: SPCampaign(),
            ios14: SPCampaign()
        ),
        delegate: self
    )}()

    override func viewDidLoad() {
        super.viewDidLoad()
        updateIDFAStatusLabel()
        consentManager.loadMessage()
    }
}

// MARK: - SPDelegate implementation
extension ViewController: SPDelegate {
    func onSPUIReady(_ controller: UIViewController) {
        controller.modalPresentationStyle = .overFullScreen
        present(controller, animated: true)
    }

    func onAction(_ action: SPAction, from controller: UIViewController) {
        print(action)
    }

    func onSPUIFinished(_ controller: UIViewController) {
        updateIDFAStatusLabel()
        dismiss(animated: true)
    }

    func onConsentReady(userData: SPUserData) {
        print("onConsentReady:", userData)
        let vendorAccepted = userData.gdpr?.consents?.vendorGrants[myVendorId]?.granted ?? false
        updateMyVendorUI(vendorAccepted)
        updatePMButtons(ccpaApplies: consentManager.ccpaApplies, gdprApplies: consentManager.gdprApplies)
    }

    func onSPFinished(userData: SPUserData) {
        print("SDK DONE")
    }

    func onError(error: SPError) {
        print("Something went wrong: ", error)
    }
}

// MARK: - UI methods
extension ViewController {
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

    func updateMyVendorUI(_ accepted: Bool) {
        myVendorAcceptedLabel.text = accepted ? "accepted" : "rejected"
        myVendorAcceptedLabel.textColor = accepted ? .systemGreen : .systemRed
        acceptMyVendorButton.isEnabled = !accepted
    }

    func updatePMButtons(ccpaApplies: Bool, gdprApplies: Bool) {
        gdprPMButton.isEnabled = gdprApplies
        ccpaPMButton.isEnabled = ccpaApplies
    }
}
