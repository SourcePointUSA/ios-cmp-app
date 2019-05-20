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
        let cvc = try! ConsentViewController(accountId: 630, siteName: "test.skynews.ios", stagingCampaign: false)

//        cvc.enableNewPM(true)

        cvc.setTargetingParam(key: "displayMode", value: myPrivacyManager ? "userRequested" : "appLaunch")

        cvc.onMessageReady = { controller in
            self.present(controller, animated: false, completion: nil)
        }

        cvc.onInteractionComplete = { controller in
            controller.getCustomVendorConsents(completionHandler: { vendorConsents in
                vendorConsents.forEach({ consent in print("Consented to \(consent)") })
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

