//
//  ViewController.swift
//  Example
//
//  Created by Andre Herculano on 15.05.19.
//  Copyright © 2019 sourcepoint. All rights reserved.
//

import UIKit
import ConsentViewController

class ViewController: UIViewController {
    
    func loadConsentManager() {
        let cvc = try! ConsentViewController(accountId: 22, siteName: "mobile.demo", stagingCampaign: false)
        
        cvc.setTargetingParam(key: "MyPrivacyManager", value: "true")
        
        let webview = WebView(frame: self.view.frame)
        cvc.webview = webview
        
        cvc.onErrorOccurred = { error in
            print(error)
            webview.removeFromSuperview()
        }
        
        cvc.onInteractionComplete = { controller in
            controller.getCustomVendorConsents(completionHandler: { vendorConsents in
                vendorConsents.forEach({ consent in print("Consented to \(consent)") })
            })
            webview.removeFromSuperview()
        }
        
        
        if let url = cvc.loadMessage() {
            webview.loadWebContent(url: url)
            self.view.addSubview(webview)
        }
    }
    
    @IBAction func onPrivacySettingsTap(_ sender: Any) {
        loadConsentManager()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadConsentManager()
    }
}

