//
//  ViewController.swift
//  NativeMessageExample
//
//  Created by Andre Herculano on 25.01.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import ConsentViewController

class ViewController: UIViewController, GDPRConsentDelegate {
    func inspectData(_ tag: String) {
        print(tag, UserDefaults.standard.dictionaryWithValues(forKeys: [
            "sp_gdpr_meta",
            "sp_gdpr_euconsent",
            "sp_gdpr_consentUUID",
            GDPRConsentViewController.IAB_CONSENT_CMP_PRESENT,            GDPRConsentViewController.IAB_CONSENT_SUBJECT_TO_GDPR,            GDPRConsentViewController.IAB_CONSENT_CONSENT_STRING,            GDPRConsentViewController.IAB_CONSENT_PARSED_PURPOSE_CONSENTS,            GDPRConsentViewController.IAB_CONSENT_PARSED_VENDOR_CONSENTS
        ]))
    }
    
    lazy var consentViewController: GDPRConsentViewController = { return GDPRConsentViewController(
        accountId: 22,
        propertyId: 2372,
        propertyName: try! GDPRPropertyName("mobile.demo"),
        PMId: "5c0e81b7d74b3c30c6852301",
        campaignEnv: .Public,
        consentDelegate: self
    )}()
    
    @IBAction func onSettingsTap(_ sender: Any) {
        consentViewController.loadPrivacyManager()
    }
    
    func consentUIWillShow(message: GDPRMessage) {
        let messageController = GDPRNativeMessageViewController(messageContents: message, delegate: self)
        messageController.modalPresentationStyle = .popover
        present(messageController, animated: true, completion: nil)
    }
    
    func consentUIWillShow() {
        present(consentViewController, animated: true, completion: nil)
    }
    
    func consentUIDidDisappear() {
        inspectData("consentUIDidDisappear")
        dismiss(animated: true, completion: nil)
    }
    
    func onConsentReady(gdprUUID: GDPRUUID, userConsent: GDPRUserConsent) {
        inspectData("onConsentReady")
        print("onConsentReady: ", gdprUUID, userConsent)
    }
    
    func onAction(_ action: GDPRAction, consents: PMConsents?) {
        consentViewController.reportAction(action, consents: consents)
    }
    
    func onError(error: GDPRConsentViewControllerError?) {
        print("ERROR: ", error?.description ?? "<empty>")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        consentViewController.loadNativeMessage(forAuthId: nil)
    }
}

