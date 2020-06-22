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
    static let vendorXId = "5e4a5fbf26de4a77922b38a6"
    var vendorXAccepted = false

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
        vendorXAccepted = false
        updateCustomVendorUI()
    }

    @IBAction func onPrivacySettingsTap(_ sender: Any) {
        consentViewController.loadPrivacyManager()
    }

    @IBAction func onAcceptVendorXTap(_ sender: Any) {
        consentViewController.customConsentTo(vendors: [ViewController.vendorXId], categories: [], legIntCategories: []) { [weak self] consents in
            self?.vendorXAccepted = consents.acceptedVendors.contains(ViewController.vendorXId)
            self?.updateCustomVendorUI()
        }
    }

    @IBOutlet weak var vendorXStatusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        consentViewController.loadMessage()
    }
}

// MARK: CustomConsent
extension ViewController {
    func updateCustomVendorUI() {
        vendorXStatusLabel.text = vendorXAccepted ?
            "Accepted" :
            "Rejected"
    }
}

extension ViewController: GDPRConsentDelegate {
    func onAction(_ action: GDPRAction) {
        print("User took the action: \(action.type.description)")
        // To verify the ConsentViewController SDK version use below code,
        // To print out on debug console use : po Bundle(for: GDPRConsentViewController.self).infoDictionary?["CFBundleShortVersionString"]
        print("ConsentViewController SDK version: \(Bundle(for: GDPRConsentViewController.self).infoDictionary?["CFBundleShortVersionString"] ?? 1.0)")

    }

    func gdprConsentUIWillShow() {
        present(consentViewController, animated: true, completion: nil)
    }

    func consentUIDidDisappear() {
        dismiss(animated: true, completion: nil)
    }

    func onConsentReady(gdprUUID: GDPRUUID, userConsent: GDPRUserConsent) {
        print("ConsentUUID: \(gdprUUID)")
        vendorXAccepted = userConsent.acceptedVendors.contains(ViewController.vendorXId)
        userConsent.acceptedVendors.forEach { vendorId in print("Vendor: \(vendorId)") }
        userConsent.acceptedCategories.forEach { purposeId in print("Purpose: \(purposeId)") }
        print("VendorGrants(\(userConsent.vendorGrants))")

        print(UserDefaults.standard.dictionaryWithValues(forKeys: userConsent.tcfData.dictionaryValue?.keys.sorted() ?? []))
        
        updateCustomVendorUI()
    }

    func onError(error: GDPRConsentViewControllerError?) {
        print("Error: \(error.debugDescription)")
    }
}
