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
        propertyId: 2372,
        propertyName: try! GDPRPropertyName("mobile.demo"),
        PMId: "5c0e81b7d74b3c30c6852301",
        campaignEnv: .Public,
        targetingParams: ["native": "true"], // this is only necessary due to our own scenario
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
    func gdprConsentUIWillShow(message: GDPRMessage) {
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
        inspectData("onConsentReady")
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

    func inspectData(_ tag: String) {
        print(tag, UserDefaults.standard.dictionaryWithValues(forKeys: [
            "sp_gdpr_meta",
            "sp_gdpr_euconsent",
            "sp_gdpr_consentUUID",
            GDPRConsentViewController.IAB_CONSENT_CMP_PRESENT,
            GDPRConsentViewController.IAB_CONSENT_SUBJECT_TO_GDPR,
            GDPRConsentViewController.IAB_CONSENT_CONSENT_STRING,
            GDPRConsentViewController.IAB_CONSENT_PARSED_PURPOSE_CONSENTS,
            GDPRConsentViewController.IAB_CONSENT_PARSED_VENDOR_CONSENTS
        ]))
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

