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

    func loadConsentManager(showPM: Bool) {
        let cvc = try! ConsentViewController(accountId: 22, propertyId: 2372, property: "mobile.demo", PMId: "5c0e81b7d74b3c30c6852301", campaign: "stage", showPM: showPM, consentDelegate: self)
        cvc.isTelemetryEnabled = false
        cvc.loadMessage()
    }

    func onMessageReady(controller: ConsentViewController) {
        present(controller, animated: false, completion: nil)
    }

    func onConsentReady(controller: ConsentViewController) {
        controller.getCustomVendorConsents { [weak self] (vendors, error) in
            if let vendors = vendors {
                vendors.forEach({ vendor in self?.logger.log("Consented to: %{public}@)", [vendor]) })
            } else {
                self?.onErrorOccurred(error: error!)
            }
        }
        dismiss(animated: false, completion: nil)
    }

    func onErrorOccurred(error: ConsentViewControllerError) {
        logger.log("Error: %{public}@", [error])
        dismiss(animated: false, completion: nil)
    }

    @IBAction func onPrivacySettingsTap(_ sender: Any) {
        loadConsentManager(showPM: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadConsentManager(showPM: false)
    }
}

