//
//  ViewController.swift
//  Example
//
//  Created by Andre Herculano on 15.05.19.
//  Copyright © 2019 sourcepoint. All rights reserved.
//

import UIKit
import ConsentViewController

class ViewController: UIViewController, GDPRConsentDelegate {
    lazy var consentViewController: GDPRConsentViewController = { return GDPRConsentViewController(
        accountId: 22,
        propertyId: 2372,
        propertyName: try! GDPRPropertyName("mobile.demo"),
        PMId: "5c0e81b7d74b3c30c6852301",
        campaignEnv: .Public,
        consentDelegate: self
    )}()
    
    func consentUIWillShow() {
        present(consentViewController, animated: true, completion: nil)
    }

    func consentUIDidDisappear() {
        dismiss(animated: true, completion: nil)
    }
    
    func onConsentReady(gdprUUID: GDPRUUID, userConsent: GDPRUserConsent) {
        print("ConsentUUID: \(gdprUUID)")
        userConsent.acceptedVendors.forEach({ vendorId in print("Vendor: \(vendorId)") })
        userConsent.acceptedCategories.forEach({ purposeId in print("Purpose: \(purposeId)") })
        print(UserDefaults.standard.dictionaryRepresentation().filter { (key, _) in
            key.starts(with: "sp_") || key.starts(with: "IAB")
        })
        let consentString = UserDefaults.standard.string(forKey: GDPRConsentViewController.IAB_CONSENT_CONSENT_STRING) ?? "<empty>"
        print("Consent String: \(consentString)")
    }

    func onError(error: GDPRConsentViewControllerError?) {
        print("Error: \(error.debugDescription)")
    }

    @IBAction func onPrivacySettingsTap(_ sender: Any) {
        consentViewController.loadPrivacyManager()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        consentViewController.loadMessage()
    }
}

