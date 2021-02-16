//
//  ViewController.swift
//  Example
//
//  Created by Andre Herculano on 15.05.19.
//  Copyright © 2019 sourcepoint. All rights reserved.
//

import UIKit
import ConsentViewController

class ViewController: UIViewController, SPDelegate {
    @IBOutlet weak var vendorXStatusLabel: UILabel!
    @IBAction func onClearConsentTap(_ sender: Any) {}

    @IBAction func onPrivacySettingsTap(_ sender: Any) {
        consentManager.loadGDPRPrivacyManager()
    }

    @IBAction func onAcceptVendorXTap(_ sender: Any) {}

    var campaign: SPCampaign { SPCampaign(
        accountId: 22,
        propertyId: 10589,
        pmId: "1",
        propertyName: try! SPPropertyName("unified.mobile.demo")
    ) }

    lazy var consentManager: SPConsentManager = { SPConsentManager(
        campaigns: SPCampaigns(gdpr: campaign, ccpa: campaign),
        delegate: self
    )}()

    override func viewDidLoad() {
        super.viewDidLoad()
        consentManager.loadMessage()
    }

    func onSPUIReady(_ viewController: UIViewController) {
        present(viewController, animated: true)
    }

    func onAction(_ action: SPAction) {
        print(action)
    }

    func onSPUIFinished() {
        dismiss(animated: true)
        print("SDK finished")
    }

    func onConsentReady(consents: SPConsents) {
        print("GDPR onConsentReady:", consents)
    }

    func onError(error: SPError) {
        print("Something went wrong: ", error)
    }
}
