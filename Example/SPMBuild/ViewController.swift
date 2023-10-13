//
//  ViewController.swift
//  SPMBuild
//
//  Created by Andre Herculano on 01.02.22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import ConsentViewController
import UIKit

/// This App exists solely to make sure our SPM package is building

class ViewController: UIViewController {
    let consentManager = SPConsentManager(
        accountId: 0,
        propertyId: 0,
        // swiftlint:disable:next force_try
        propertyName: try! SPPropertyName("any"),
        campaigns: SPCampaigns(gdpr: SPCampaign()),
        delegate: nil
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        consentManager.loadMessage(pubData: nil)
    }
}
