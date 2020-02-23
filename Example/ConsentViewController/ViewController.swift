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
    lazy var consentViewController: GDPRConsentViewController = { return GDPRConsentViewController(
        accountId: 22,
        propertyId: 7094,
        propertyName: try! GDPRPropertyName("tcfv2.mobile.demo"),
        PMId: "100699",
        campaignEnv: .Public,
        consentDelegate: self
    )}()

    @IBAction func onPrivacySettingsTap(_ sender: Any) {
        consentViewController.loadPrivacyManager()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        consentViewController.loadMessage()
    }
}

extension ViewController: GDPRConsentDelegate {
    func consentUIWillShow() {
        present(consentViewController, animated: true, completion: nil)
    }

    func consentUIDidDisappear() {
        dismiss(animated: true, completion: nil)
    }
    
    func onConsentReady(gdprUUID: GDPRUUID, userConsent: GDPRUserConsent) {
        print("ConsentUUID: \(gdprUUID)")
        userConsent.acceptedVendors.forEach { vendorId in print("Vendor: \(vendorId)") }
        userConsent.acceptedCategories.forEach { purposeId in print("Purpose: \(purposeId)") }
        
        // IAB Related Data
        print(UserDefaults.standard.dictionaryWithValues(forKeys: userConsent.tcfData.keys.sorted()))
    }

    func onError(error: GDPRConsentViewControllerError?) {
        print("Error: \(error.debugDescription)")
    }
}

