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
    @IBAction func onClearConsentTap(_ sender: Any) {
        UserDefaults.standard.dictionaryRepresentation().keys
            .filter { $0.starts(with: "sp_") }
            .forEach { UserDefaults.standard.removeObject(forKey: $0)}
    }

    @IBAction func onPrivacySettingsTap(_ sender: Any) {
        consentManager.loadGDPRPrivacyManager()
    }

    @IBAction func onAcceptVendorXTap(_ sender: Any) {}

    var gdprCampaign: SPCampaign { SPCampaign() }

    var ccpaCampaign: SPCampaign { SPCampaign() }

    var ios14Campaign: SPCampaign { SPCampaign() }

    lazy var consentManager: SPConsentManager = { SPConsentManager(
        accountId: 22,
        propertyName: try! SPPropertyName("mobile.multicampaign.demo"),
        campaigns: SPCampaigns(
            gdpr: gdprCampaign,
            ccpa: ccpaCampaign,
            ios14: ios14Campaign
        ),
        delegate: self
    )}()

    override func viewDidLoad() {
        super.viewDidLoad()
        consentManager.loadMessage()
    }

    func onSPUIReady(_ viewController: UIViewController) {
        viewController.modalPresentationStyle = .overFullScreen
        present(viewController, animated: true)
    }

    func onAction(_ action: SPAction, from controller: SPMessageViewController) {
        print(action)
    }

    func onSPUIFinished() {
//        dismiss(animated: true)
    }

    func onConsentReady(consents: SPConsents) {
        print("onConsentReady:", consents)
    }

    func onError(error: SPError) {
        print("Something went wrong: ", error)
    }
}
