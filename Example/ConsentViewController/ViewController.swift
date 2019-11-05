//
//  ViewController.swift
//  Example
//
//  Created by Andre Herculano on 15.05.19.
//  Copyright © 2019 sourcepoint. All rights reserved.
//

import UIKit
import ConsentViewController

class ViewController: UIViewController, ConsentDelegate {
    let logger = Logger()
    var webview: ConsentWebView?

    func loadConsentManager(showPM: Bool) {
        let cvc = try! ConsentViewController(accountId: 22, siteId: 2372, siteName: "mobile.demo", PMId: "5c0e81b7d74b3c30c6852301", campaign: "stage", showPM: showPM, consentDelegate: self)
        cvc.webview = webview
        if let url = cvc.loadMessage() {
            webview?.loadWebContent(url: url, showPM: showPM)
            self.view.addSubview(webview!)
            self.webview?.isHidden = true
        }
    }

    func onMessageReady(controller: ConsentViewController) {
        self.webview?.isHidden = false
    }

    func onConsentReady(controller: ConsentViewController) {
        controller.getCustomVendorConsents { (vendors, error) in
            if let vendors = vendors {
                vendors.forEach({ vendor in self.logger.log("Consented to: %{public}@)", [vendor]) })
            } else {
                self.onErrorOccurred(error: error!)
            }
        }
        webview?.removeFromSuperview()
    }

    func onErrorOccurred(error: ConsentViewControllerError) {
        logger.log("Error: %{public}@", [error])
        webview?.removeFromSuperview()
    }

    @IBAction func onPrivacySettingsTap(_ sender: Any) {
        loadConsentManager(showPM: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        webview = ConsentWebView(frame: self.view.frame)
        loadConsentManager(showPM: false)
    }
}

