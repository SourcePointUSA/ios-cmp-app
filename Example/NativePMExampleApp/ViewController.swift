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
    var activityIndicator = UIActivityIndicatorView(style: .medium)

    @IBOutlet weak var sourcepointSDKButton: UIButton!

    @IBAction func loadSourcepointSDKAction(_ sender: Any) {
        consentManager.loadGDPRPrivacyManager(withId: "488393")
    }

    lazy var consentManager: SPConsentManager = { SPConsentManager(
        accountId: 22,
        propertyName: try! SPPropertyName("mobile.multicampaign.demo"),
        campaigns: SPCampaigns(
            gdpr: SPCampaign(),
            ios14: SPCampaign()
        ),
        delegate: self
    )}()

    override func viewDidLoad() {
        super.viewDidLoad()
        consentManager.loadMessage()
    }
}

extension ViewController: SPDelegate {
    func onSPUIReady(_ controller: SPMessageViewController) {
        print("onSPUIReady")
        present(controller, animated: true)
    }

    func onAction(_ action: SPAction, from controller: SPMessageViewController) {}

    func onSPUIFinished(_ controller: SPMessageViewController) {
        dismiss(animated: true)
    }

    func onConsentReady(userData: SPUserData) {
        print("onConsentReady:", userData)
    }

    func onError(error: SPError) {
        stopActivityIndicator()
        print("ERROR: ", error.description )
    }
}

// MARK: - UI Utils
extension ViewController {
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

