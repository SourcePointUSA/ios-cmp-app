//
//  ViewController.swift
//  NativePMExampleApp
//
//  Created by Vilas on 25/03/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import ConsentViewController
import UIKit

class ViewController: UIViewController {
    var activityIndicator = UIActivityIndicatorView(style: .white)
    var sdkStatus = SDKStatus.notStarted

    var campaigns: SPCampaigns {
        var gdpr, ccpa: SPCampaign?
        if UserDefaults.standard.bool(forKey: "app.campaigns.gdpr") {
            gdpr = SPCampaign()
        }
        if UserDefaults.standard.bool(forKey: "app.campaigns.ccpa") {
            ccpa = SPCampaign()
        }
        return SPCampaigns(gdpr: gdpr, ccpa: ccpa, environment: .Public)
    }

    lazy var consentManager: SPSDK = {
        SPConsentManager(
            accountId: 22,
            propertyId: 17935,
            // swiftlint:disable:next force_try
            propertyName: try! SPPropertyName("appletv.demo"),
            campaigns: campaigns,
            language: SPMessageLanguage(rawValue: UserDefaults.standard.string(forKey: "app.lang") ?? "")!,
            delegate: self
        )
    }()

    @IBOutlet var gdprButton: UIButton!
    @IBOutlet var ccpaButton: UIButton!
    @IBOutlet var sdkStatusLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        sdkStatusLabel.accessibilityIdentifier = "sdkStatusLabel"
        ccpaButton.setTitle("CCPA (does not apply)", for: .disabled)
        gdprButton.setTitle("GDPR (does not apply)", for: .disabled)
        updateButtons()
        consentManager.loadMessage()
        updateSdkStatus(.running)
    }

    @IBAction func onGDPRTap(_ sender: Any) {
        consentManager.loadGDPRPrivacyManager(withId: "529561")
    }

    @IBAction func onCCPATap(_ sender: Any) {
        consentManager.loadCCPAPrivacyManager(withId: "753802")
    }
}

extension ViewController: SPDelegate {
    func onSPUIReady(_ controller: UIViewController) {
        print("onSPUIReady")
        present(controller, animated: true)
    }

    func onAction(_ action: SPAction, from controller: UIViewController) {
        print("onAction:", action)
    }

    func onSPUIFinished(_ controller: UIViewController) {
        print("onSPUIFinished")
        dismiss(animated: true)
    }

    func onConsentReady(userData: SPUserData) {
        print("onConsentReady:", userData)
        updateButtons()
    }

    func onError(error: SPError) {
        stopActivityIndicator()
        print("ERROR: ", error.description)
        updateSdkStatus(.errored)
    }

    func onSPFinished(userData: SPUserData) {
        updateSdkStatus(.done)
    }
}

// MARK: - UI Utils
extension ViewController {
    func updateButtons() {
        ccpaButton.isEnabled = consentManager.ccpaApplies
        gdprButton.isEnabled = consentManager.gdprApplies
    }

    func showActivityIndicator(on parentView: UIView?) {
        if let containerView = parentView {
            activityIndicator.startAnimating()
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            activityIndicator.color = .black
            containerView.addSubview(activityIndicator)
            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
            ])
        }
    }

    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }

    func updateSdkStatus(_ status: SDKStatus) {
        sdkStatus = status
        sdkStatusLabel.text = sdkStatus.rawValue
    }
}

enum SDKStatus: String {
    case notStarted = "(SDK not started)"
    case running = "(SDK running)"
    case done = "(SDK done)"
    case errored = "(SDK errored)"
}
