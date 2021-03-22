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

    var gdprCampaign: SPCampaign { SPCampaign(
        targetingParams: ["legislation": "GDPR", "location": "EU"]
    )}

    var ccpaCampaign: SPCampaign { SPCampaign(
        targetingParams: ["legislation": "CCPA", "location": "EU"]
    )}

    lazy var consentManager: SPConsentManager = { SPConsentManager(
        accountId: 22,
        propertyName: try! SPPropertyName("unified.mobile.demo"),
        campaigns: SPCampaigns(gdpr: gdprCampaign, ccpa: ccpaCampaign),
        delegate: self
    )}()

    func printLocalStorage() {
        UserDefaults.standard.dictionaryRepresentation().filter { (key, _) in
            key.starts(with: "sp_") || key.starts(with: "IAB")
        }.map { (key, value) -> Any in
            switch value.self {
            case is Data: return (key, try! JSONSerialization.jsonObject(with: value as! Data, options: .allowFragments))
            default: return (key, value)
            }
        }.forEach {
            print($0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        consentManager.loadMessage()
    }

    func onSPUIReady(_ viewController: UIViewController) {
        viewController.modalPresentationStyle = .overFullScreen
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
        print("onConsentReady:", consents)
    }

    func onError(error: SPError) {
        print("Something went wrong: ", error)
    }
}
