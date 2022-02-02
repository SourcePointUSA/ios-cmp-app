//
//  ViewController.swift
//  NativePMExampleApp
//
//  Created by Vilas on 25/03/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import ConsentViewController

class ViewController: UIViewController {
    var activityIndicator = UIActivityIndicatorView(style: .white)

    @IBOutlet weak var gdprButton: UIButton!
    @IBOutlet weak var ccpaButton: UIButton!

    @IBAction func onGDPRTap(_ sender: Any) {
        consentManager.loadGDPRPrivacyManager(withId: "561622")
    }

    @IBAction func onCCPATap(_ sender: Any) {
        consentManager.loadCCPAPrivacyManager(withId: "562032")
    }

    lazy var consentManager: SPConsentManager = { SPConsentManager(
        accountId: 22,
        propertyName: try! SPPropertyName("appletv.demo"),
        campaignsEnv: .Stage,
        campaigns: SPCampaigns(
            gdpr: SPCampaign(),
            ccpa: SPCampaign()
        ),
        delegate: self
    )}()

    override func viewDidLoad() {
        super.viewDidLoad()
        ccpaButton.setTitle("CCPA (does not apply)", for: .disabled)
        gdprButton.setTitle("GDPR (does not apply)", for: .disabled)
        updateButtons()
        consentManager.loadMessage()
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
}

