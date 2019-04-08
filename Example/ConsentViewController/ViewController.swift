//
//  ViewController.swift
//
//  Created by SourcePoint
//  Copyright (c) 2019 SourcePoint. All rights reserved.

import UIKit
import ConsentViewController

class ViewController: UIViewController {
    var consentViewController: ConsentViewController!

    private func buildConsentViewController(showPM: Bool, addToView parentView: UIView) {
        do {
            let consentViewController = try ConsentViewController(
                accountId: 22,
                siteName: "mobile.demo",
                stagingCampaign: false
            )

            consentViewController.messageTimeoutInSeconds = TimeInterval(5)

            consentViewController.onMessageReady = { controller in
                parentView.addSubview(controller.view)
                controller.view.frame = parentView.bounds
            }

            // optional, set custom targeting parameters supports Strings and Integers
            consentViewController.setTargetingParam(key: "CMP", value: String(showPM))

            consentViewController.onErrorOccurred = { error in print(error) }
            
            consentViewController.onInteractionComplete = { cvc in
                do {
                    print(
                        // Standard IAB values in UserDefaults
                        "\n IABConsent_ConsentString in storage",
                        UserDefaults.standard.string(forKey: ConsentViewController.IAB_CONSENT_CONSENT_STRING) as Any,
                        "\n IABConsent_ParsedPurposeConsents in storage",
                        UserDefaults.standard.string(forKey: ConsentViewController.IAB_CONSENT_PARSED_PURPOSE_CONSENTS) as Any,
                        "\n IABConsent_ParsedVendorConsents in storage",
                        UserDefaults.standard.string(forKey: ConsentViewController.IAB_CONSENT_PARSED_VENDOR_CONSENTS) as Any,
                        // API for getting IAB Purpose Consents
                        "\n IAB purpose consent for \"Ad selection, delivery, reporting\"",
                        try cvc.getIABPurposeConsents([3])
                    )
                    print("Custom vendor consents")
                    for consent in try cvc.getCustomVendorConsents() {
                        print("Custom Vendor Consent id: \(consent.id), name: \(consent.name)")
                    }
                    print("Custom purpose consents")
                    for consent in try cvc.getCustomPurposeConsents() {
                        print("Custom Purpose Consent id: \(consent.id), name: \(consent.name)")
                    }
                }
                catch { print(error) }
                cvc.view.removeFromSuperview()
            }

            consentViewController.loadMessage()
        } catch { print(error) }
    }

    @IBAction func showPrivacyManager(_ sender: Any) {
        buildConsentViewController(showPM: true, addToView: view)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        buildConsentViewController(showPM: false, addToView: view)

        // IABConsent_CMPPresent must be set immediately after loading the ConsentViewController
        print(
            "IABConsent_CMPPresent in storage",
            UserDefaults.standard.string(forKey: ConsentViewController.IAB_CONSENT_CMP_PRESENT) as Any,
            "IABConsent_SubjectToGDPR in storage",
            UserDefaults.standard.string(forKey: ConsentViewController.IAB_CONSENT_SUBJECT_TO_GDPR) as Any
        )
    }
}
