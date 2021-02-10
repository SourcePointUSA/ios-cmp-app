//
//  ViewController.swift
//  Example
//
//  Created by Andre Herculano on 15.05.19.
//  Copyright © 2019 sourcepoint. All rights reserved.
//

import UIKit
import AppTrackingTransparency
import AdSupport
import ConsentViewController

class ViewController: UIViewController, SPDelegate {
    @IBOutlet weak var vendorXStatusLabel: UILabel!
    @IBAction func onClearConsentTap(_ sender: Any) {}

    @IBAction func onGDPRSettingsTap(_ sender: Any) {
        consentManager.loadGDPRPrivacyManager()
    }

    @IBAction func onAcceptVendorXTap(_ sender: Any) {}

    lazy var consentManager: SPConsentManager = { SPConsentManager(campaigns: SPCampaigns(
        gdpr: SPCampaign(
            accountId: 22,
            propertyId: 123,
            pmId: "1",
            propertyName: try! SPPropertyName("test")
        )),
        delegate: self
    )}()

    override func viewDidLoad() {
        super.viewDidLoad()
        consentManager.loadMessage()
    }

    func onConsentUIReady(_ viewController: SPConsentViewController) {
        present(viewController, animated: true)
    }

    func onAction(_ action: SPAction) {
        print(action)
    }

    func onConsentUIFinished() {
        dismiss(animated: true)
        print("SDK finished")
    }

    func onConsentReady(consents: SPGDPRUserConsent) {
        print("GDPR onConsentReady")
    }

    func onConsentReady(consents: SPCCPAUserConsent) {
        print("CCPA onConsentReady")
    }

    func onError(error: SPError) {
        print("Something went wrong: ", error)
    }
}
