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
        let cvc = try! ConsentViewController(accountId: 808, siteId: 4601, siteName: "sourcepointnewscript.com", PMId: "5cacf7321b980a7ca04947c6", campaign: "public", showPM: myPrivacyManager)

//        cvc.setTargetingParam(key: "dispalyMode", value: "appLaunch")

        cvc.onMessageReady = { controller in
            self.present(controller, animated: false, completion: nil)
        }

        cvc.onInteractionComplete = { controller in
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

