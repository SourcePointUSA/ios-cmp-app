//
//  ViewController.swift
//  SPMBuild
//
//  Created by Andre Herculano on 01.02.22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import ConsentViewController

/// This App exists solely to make sure our SPM package is building

class ViewController: UIViewController {
    let consentManager = SPConsentManager(
        accountId: 00,
        propertyName: try! SPPropertyName("any"),
        campaigns: SPCampaigns(gdpr: SPCampaign()),
        delegate: nil
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        consentManager.loadMessage()
    }
}

