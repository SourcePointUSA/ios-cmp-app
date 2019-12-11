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

    lazy var consentViewController: ConsentViewController = {
        return ConsentViewController(accountId: 22, propertyId: 2372, property: "mobile.demo", PMId: "5c0e81b7d74b3c30c6852301", campaign: "stage", consentDelegate: self)
    }()
    
    func onPMReady() {
        present(consentViewController, animated: false, completion: nil)
    }

    func onMessageReady() {
        consentViewController.modalPresentationStyle = .overFullScreen
        present(consentViewController, animated: true, completion: nil)
    }

    func onConsentReady() {
        consentViewController.getCustomVendorConsents { [weak self] (vendors, error) in
            if let vendors = vendors {
                vendors.forEach({ vendor in self?.logger.log("Consented to: %{public}@)", [vendor]) })
            } else {
                self?.onError(error: error)
            }
        }
        dismiss(animated: true, completion: nil)
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

