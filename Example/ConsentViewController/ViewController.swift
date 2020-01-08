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
    let logger = Logger()

    func loadConsentManager(showPM: Bool) {
        try! ConsentViewController(
            accountId: 22,
            propertyId: 2372,
            property: "mobile.demo",
            PMId: "5c0e81b7d74b3c30c6852301",
            campaign: "stage",
            showPM: showPM,
            consentDelegate: self
        ).loadMessage()
    }

    @IBAction func onPrivacySettingsTap(_ sender: Any) {
        loadConsentManager(showPM: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadConsentManager(showPM: false)
    }
}


// MARK: ConsentDelegate

extension ViewController: ConsentDelegate {
    func onMessageReady(controller: ConsentViewController) {
        controller.modalPresentationStyle = .overFullScreen
        present(controller, animated: true, completion: nil)
    }

    func onConsentReady(controller: ConsentViewController) {
        controller.getCustomVendorConsents { [weak self] (vendors, _) in
            if let vendors = vendors { vendors.forEach({ vendor in
                self?.logger.log("Consented to: %{public}@)", [vendor])  
            })}
        }
        dismiss(animated: true, completion: nil)
    }

    func onErrorOccurred(error: ConsentViewControllerError) {
        logger.log("Error: %{public}@", [error])
        dismiss(animated: true, completion: nil)
    }
}

