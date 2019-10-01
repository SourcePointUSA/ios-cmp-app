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
    func loadConsentManager(myPrivacyManager: Bool) {

         let cvc = try! ConsentViewController(accountId: 22, siteId: 2372, siteName: "mobile.demo", PMId: "5c0e81b7d74b3c30c6852301", campaign: "stage", showPM: false)
                
        cvc.debugLevel = .DEBUG

        cvc.onMessageReady = { controller in
            self.present(controller, animated: false, completion: nil)
        }

        cvc.onConsentReady = { controller in
            controller.getCustomVendorConsents(completionHandler: { (vendorConsents, error) in
                if let vendorConsents = vendorConsents {
                    vendorConsents.forEach({ consent in print("Consented to \(consent)") })
                }else {
                     print(String(describing: error))
                }
            })
            self.dismiss(animated: false, completion: nil)
        }

        cvc.loadMessage()
    }

    @IBAction func onPrivacySettingsTap(_ sender: Any) {
        loadConsentManager(myPrivacyManager: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadConsentManager(myPrivacyManager: false)
    }
}

