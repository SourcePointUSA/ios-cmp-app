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
            
            consentViewController.messageTimeoutInSeconds = TimeInterval(30)
            
            consentViewController.onMessageReady = { controller in
                parentView.addSubview(controller.view)
                controller.view.frame = parentView.bounds
                self.stopSpinner()
            }
            
            // optional, set custom targeting parameters supports Strings and Integers
            consentViewController.setTargetingParam(key: "CMP", value: String(showPM))
            
            consentViewController.onErrorOccurred = { error in
                consentViewController.view.removeFromSuperview()
                print(error)
                self.stopSpinner()
            }
            
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
                }
                catch { print(error) }
                cvc.view.removeFromSuperview()
            }
            
            consentViewController.loadMessage()
        } catch { print(error) }
    }
    
    @IBAction func showPrivacyManager(_ sender: Any) {
        startSpinner()
        buildConsentViewController(showPM: true, addToView: view)
    }
    
    func startSpinner() {
        let alert = UIAlertController(title: nil, message: "Just a second...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    func stopSpinner() {
        dismiss(animated: false, completion: nil)
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
