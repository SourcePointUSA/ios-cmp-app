//
//  ViewController.swift
//
//  Created by SourcePoint
//  Copyright (c) 2019 SourcePoint. All rights reserved.

import UIKit
import ConsentViewController

class ViewController: UIViewController {
    var consentViewController: ConsentViewController!

    private func buildConsentViewController(showPM: Bool) throws -> ConsentViewController {
        let consentViewController = try ConsentViewController(
                accountId: 22,
                siteName: "mobile.demo",
                stagingCampaign: false
            )
        // optional, set custom targeting parameters supports Strings and Integers
        consentViewController.setTargetingParam(key: "CMP", value: String(showPM))

        // optional, sets debug level defaults to OFF
        consentViewController.debugLevel = ConsentViewController.DebugLevel.OFF

        consentViewController.willShowMessage = { cvc in print("the message will show") }

        // optional, callback triggered when message choice is selected when called choice
        // type will be available as Integer at cvc.choiceType
        consentViewController.onMessageChoiceSelect = { cvc in
            print("Choice type selected by user", cvc.choiceType as Any)
        }

        consentViewController.onErrorOccurred = { error in print(error) }

        // optional, callback triggered when consent data is captured when called
        // euconsent will be available as String at cLib.euconsent and under
        // PreferenceManager.getDefaultSharedPreferences(activity).getString(EU_CONSENT_KEY, null);
        // consentUUID will be available as String at cLib.consentUUID and under
        // PreferenceManager.getDefaultSharedPreferences(activity).getString(CONSENT_UUID_KEY null);
        consentViewController.onInteractionComplete = { cvc in
            do {
                print(
                    "\n eu consent prop",
                    cvc.euconsent as Any,
                    "\n consent uuid prop",
                    cvc.consentUUID as Any,
                    "\n eu consent in storage",
                    UserDefaults.standard.string(forKey: ConsentViewController.EU_CONSENT_KEY) as Any,
                    "\n consent uuid in storage",
                    UserDefaults.standard.string(forKey: ConsentViewController.CONSENT_UUID_KEY) as Any,

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
        }

        return consentViewController
    }

    @IBAction func showPrivacyManager(_ sender: Any) {
        do {
            try view.addSubview(buildConsentViewController(showPM: true).view)
        } catch { print(error) }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            try view.addSubview(buildConsentViewController(showPM: false).view)
        } catch { print(error) }

        // IABConsent_CMPPresent must be set immediately after loading the ConsentViewController
        print(
            "IABConsent_CMPPresent in storage",
            UserDefaults.standard.string(forKey: ConsentViewController.IAB_CONSENT_CMP_PRESENT) as Any,
            "IABConsent_SubjectToGDPR in storage",
            UserDefaults.standard.string(forKey: ConsentViewController.IAB_CONSENT_SUBJECT_TO_GDPR) as Any
        )
    }
}
