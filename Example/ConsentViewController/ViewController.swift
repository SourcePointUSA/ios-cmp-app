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
        propertyId: 7639,
        propertyName: try! GDPRPropertyName("tcfv2.mobile.webview"),
        PMId: "122058",
        campaignEnv: .Public,
        consentDelegate: self
    )}()

    @IBAction func onClearConsentTap(_ sender: Any) {
        let spStoredData = UserDefaults.standard.dictionaryRepresentation().filter {
            $0.key.starts(with: GDPRConsentViewController.SP_GDPR_KEY_PREFIX) ||
            $0.key.starts(with: GDPRConsentViewController.IAB_KEY_PREFIX)
        }
        spStoredData.isEmpty ?
            print("There's no consent data stored") :
            print("Deleting following consent data: ", spStoredData)
        consentViewController.clearAllData()
    }

    @IBAction func onPrivacySettingsTap(_ sender: Any) {
        consentViewController.loadPrivacyManager()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        consentViewController.loadMessage()
    }
}

extension ViewController: GDPRConsentDelegate {
    func onAction(_ action: GDPRAction) {
        print("User took the action: \(action.type.description)")
    }

    func gdprConsentUIWillShow() {
        present(consentViewController, animated: true, completion: nil)
    }

    func consentUIDidDisappear() {
        dismiss(animated: true, completion: nil)
    }

    func onConsentReady(gdprUUID: GDPRUUID, userConsent: GDPRUserConsent) {
        print("ConsentUUID: \(gdprUUID)")
        userConsent.acceptedVendors.forEach { vendorId in print("Vendor: \(vendorId)") }
        userConsent.acceptedCategories.forEach { purposeId in print("Purpose: \(purposeId)") }

        print(UserDefaults.standard.dictionaryWithValues(forKeys: userConsent.tcfData.dictionaryValue?.keys.sorted() ?? []))
    }

    func onError(error: GDPRConsentViewControllerError?) {
        print("Error: \(error.debugDescription)")
    }
}
