//
//  ViewController.swift
//  NativeMessageExample
//
//  Created by Andre Herculano on 25.01.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import ConsentViewController

class ViewController: UIViewController {
    var messageController: SPNativeMessageViewController?
    var activityIndicator = UIActivityIndicatorView(style: .gray)

    lazy var consentViewController: GDPRConsentViewController = { return GDPRConsentViewController(
        accountId: 22,
        propertyId: 7094,
        propertyName: try! SPPropertyName("tcfv2.mobile.demo"),
        PMId: "179657",
        campaignEnv: .Public,
        consentDelegate: self
    )}()

    @IBAction func onSettingsTap(_ sender: Any) {
        consentViewController.loadPrivacyManager()
        showActivityIndicator(on: view)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        consentViewController.privacyManagerTab = .Vendors
        consentViewController.loadNativeMessage(forAuthId: nil)
    }
}

extension ViewController: SPDelegate {
    func onSPNativeMessageReady(_ message: SPNativeMessage) {
        messageController = SPNativeMessageViewController(messageContents: message, sdkDelegate: consentManager)
        present(messageController, animated: true)
        stopActivityIndicator()
    }

    func onAction(_ action: SPAction, from controller: UIViewController) {
        print(action)
    }

    func onSPUIReady(_ controller: UIViewController) {
        present(controller, animated: true)
        stopActivityIndicator()
    }

    func onSPUIFinished(_ controller: UIViewController) {
        dismiss(animated: true)
    }

    func onError(error: SPError) {
        print(error)
        stopActivityIndicator()
    }
}

/// Util methods for ViewController
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
