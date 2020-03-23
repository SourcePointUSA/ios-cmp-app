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
    var messageController: GDPRNativeMessageViewController?
    var activityIndicator = UIActivityIndicatorView(style: .gray)

    lazy var consentViewController: GDPRConsentViewController = { return GDPRConsentViewController(
        accountId: 22,
        propertyId: 7094,
        propertyName: try! GDPRPropertyName("tcfv2.mobile.demo"),
        PMId: "100699",
        campaignEnv: .Public,
        targetingParams: ["native": "true"], // this is only necessary because of our own scenario
        consentDelegate: self
    )}()

    @IBAction func onSettingsTap(_ sender: Any) {
        consentViewController.loadPrivacyManager()
        showActivityIndicator(on: view)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        consentViewController.loadNativeMessage(forAuthId: nil)
    }
}

extension ViewController: GDPRConsentDelegate {
    /// called when there's a message to show and its content (`GDPRMessage`) is ready
    func consentUIWillShow(message: GDPRMessage) {
        messageController = GDPRNativeMessageViewController(messageContents: message, consentViewController: consentViewController)
        messageController!.modalPresentationStyle = .popover
        present(messageController!, animated: true, completion: nil)
    }

    /// called when the web consent UI is ready (in this case the Privacy Manager)
    func gdprConsentUIWillShow() {
        if messageController?.viewIfLoaded?.window != nil {
            messageController?.present(consentViewController, animated: true, completion: nil)
        } else {
            present(consentViewController, animated: true, completion: nil)
        }
        stopActivityIndicator()
    }

    /// called after an action is taken by the user and the consent info is returned by SourcePoint's endpoints
    func onConsentReady(gdprUUID: GDPRUUID, userConsent: GDPRUserConsent) {
        print("onConsentReady: ", storedSDKData())
        print("onConsentReady: ", gdprUUID, userConsent)
    }

    /// called on every Consent Message / PrivacyManager action. For more info on the different kinds of actions check
    /// `GDPRActionType`
    func onAction(_ action: GDPRAction, consents: PMConsents?) {
        switch action.type {
        case .PMCancel:
            dismissPrivacyManager()
        case .ShowPrivacyManager:
            showActivityIndicator(on: messageController?.view)
        default:
            consentViewController.reportAction(action, consents: consents)
            dismiss(animated: true, completion: nil)
        }
    }

    func onError(error: GDPRConsentViewControllerError?) {
        print("ERROR: ", error?.description ?? "<empty>")
    }
}

/// Util methods for ViewController
extension ViewController {
    private func dismissPrivacyManager() {
        if messageController?.viewIfLoaded?.window != nil {
            messageController?.dismiss(animated: true, completion: nil)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }

    func storedSDKData() -> [String: Any] {
        UserDefaults.standard.dictionaryRepresentation().filter { (key, _) in
            key.starts(with: "sp_gdpr_") || key.starts(with: GDPRConsentViewController.IAB_KEY_PREFIX)
        }
    }

    func showActivityIndicator(on parentView: UIView?) {
        if let containerView = parentView {
            activityIndicator.startAnimating()
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            activityIndicator.color = .black
            containerView.addSubview(activityIndicator)
            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            ])
        }
    }

    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
}

