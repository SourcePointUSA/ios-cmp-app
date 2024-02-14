//
//  ViewController.swift
//  SourcepointFirebaseDemo
//
//  Created by Andre Herculano on 12.02.24.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import ConsentViewController
import FirebaseAnalytics

class ViewController: UIViewController, SPDelegate {
    @IBOutlet weak var GCMFlagLabel: UILabel!
    @IBOutlet weak var TCStringTextView: UITextView!

    @IBAction func loadPMButton(_ sender: Any) {
        consentManager.loadGDPRPrivacyManager(withId: "674747")
    }

    lazy var consentManager: SPConsentManager = { SPConsentManager(
        accountId: 1772,
        propertyId: 21930,
        propertyName: try! SPPropertyName("tpi-test-space.web.app"),
        campaigns: SPCampaigns(gdpr: SPCampaign()),
        delegate: self
    )}()

    override func viewDidLoad() {
        super.viewDidLoad()

        consentManager.loadMessage(forAuthId: nil, pubData: nil)
    }

    func onAction(_ action: SPAction, from controller: UIViewController) {
        print(action)
    }

    func onSPUIReady(_ controller: UIViewController) {
        present(controller, animated: true)
    }

    func onSPUIFinished(_ controller: UIViewController) {
        dismiss(animated: true)
    }
}

// MARK: Firebase Google Consent Mode integration
extension ViewController {
    func onSPFinished(userData: SPUserData) {
        GCMFlagLabel.text = "\(UserDefaults.standard.bool(forKey: "IABTCF_EnableAdvertiserConsentMode"))"
        TCStringTextView.text = UserDefaults.standard.string(forKey: "IABTCF_TCString")

        let gcmData = userData.gdpr?.consents?.googleConsentMode
        Analytics.setConsent([
            .analyticsStorage: gcmData?.analyticsStorage == .granted ? .granted : .denied
        ])
    }
}

