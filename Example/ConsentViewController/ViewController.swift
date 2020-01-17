//
//  ViewController.swift
//  Example
//
//  Created by Andre Herculano on 15.05.19.
//  Copyright © 2019 sourcepoint. All rights reserved.
//

import UIKit
import ConsentViewController

class ViewController: UIViewController, ConsentDelegate {
    let logger = Logger()

    lazy var consentViewController: ConsentViewController = { return ConsentViewController(
        accountId: 22,
        propertyId: 2372,
        propertyName: try! PropertyName("mobile.demo"),
        PMId: "5c0e81b7d74b3c30c6852301",
        campaignEnv: .Stage,
        consentDelegate: self
    )}()
    
    func consentUIWillShow() {
        present(consentViewController, animated: true, completion: nil)
    }

    func consentUIDidDisappear() {
        dismiss(animated: true, completion: nil)
    }
    
    public func onConsentReady(consentUUID: ConsentUUID, userConsent: UserConsent) {
        self.logger.log("ConsentUUID: %{public}@", [consentUUID])
        userConsent.acceptedVendors.forEach({ [weak self] vendorId in
            self?.logger.log("Vendor(%{public}@)", [vendorId])
        })
        userConsent.acceptedCategories.forEach({ [weak self] purposeId in
            self?.logger.log("Purpose(%{public}@)", [purposeId])
        })
        self.logger.log("Consent String: %{public}@", [(UserDefaults.standard.string(forKey: ConsentViewController.IAB_CONSENT_CONSENT_STRING) ?? "<empty>")])
    }

    func onError(error: ConsentViewControllerError?) {
        logger.log("Error: %{public}@", [error ?? ""])
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onPrivacySettingsTap(_ sender: Any) {
        consentViewController.loadPrivacyManager()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        consentViewController.loadMessage()
    }
}

