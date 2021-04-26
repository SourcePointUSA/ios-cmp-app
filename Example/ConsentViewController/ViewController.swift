//
//  ViewController.swift
//  Example
//
//  Created by Andre Herculano on 15.05.19.
//  Copyright © 2019 sourcepoint. All rights reserved.
//

import UIKit
import ConsentViewController

class ViewController: UIViewController, SPDelegate {
    @IBOutlet weak var idfaStatusLabel: UILabel!

    @IBAction func onClearConsentTap(_ sender: Any) {
        SPConsentManager.clearAllData()
    }

    @IBAction func onGDPRPrivacyManagerTap(_ sender: Any) {
        consentManager.loadGDPRPrivacyManager(withId: "13111", tab: .Features)
    }

    @IBAction func onCCPAPrivacyManagerTap(_ sender: Any) {
        consentManager.loadCCPAPrivacyManager(withId: "14967")
    }


    lazy var consentManager: SPConsentManager = { SPConsentManager(
        accountId: 22,
        propertyName: try! SPPropertyName("mobile.multicampaign.demo"),
        campaigns: SPCampaigns(
            gdpr: SPCampaign(),
            ccpa: SPCampaign(),
            ios14: SPCampaign()
        ),
        delegate: self
    )}()

    func loadIDFAStatusLabel() {
        idfaStatusLabel.text = SPIDFAStatus.current().description
        switch SPIDFAStatus.current() {
        case .unknown: idfaStatusLabel.textColor = .systemYellow
        case .accepted: idfaStatusLabel.textColor = .systemGreen
        case .denied: idfaStatusLabel.textColor = .systemRed
        case .unavailable: idfaStatusLabel.textColor = .systemGray
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadIDFAStatusLabel()
        consentManager.loadMessage()
    }

    func onSPUIReady(_ controller: SPMessageViewController) {
        controller.modalPresentationStyle = .overFullScreen
        present(controller, animated: true)
    }

    func onAction(_ action: SPAction, from controller: SPMessageViewController) {
        print(action)
    }

    func onSPUIFinished(_ controller: SPMessageViewController) {
        loadIDFAStatusLabel()
        dismiss(animated: true)
    }

    func onConsentReady(consents: SPUserData) {
        print("onConsentReady:", consents)
    }

    func onError(error: SPError) {
        print("Something went wrong: ", error)
    }
}
