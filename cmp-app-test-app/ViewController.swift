//
//  ViewController.swift
//  cmp-app-test-app
//
//  Created by Dmitri Rabinowitz on 8/13/18.
//  Copyright © 2018 Sourcepoint. All rights reserved.
//

import UIKit
class ViewController: UIViewController {
    var consentWebView: ConsentWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        consentWebView = ConsentWebView(
            // required, must be set second used to find scenario
            siteName: "dev.local",
            // optional, used for logging purposes for which page of the app the consent lib was
            // rendered on
            page: "main",
            // optional, callback triggered when message data is loaded when called message data
            // will be available as String at cbw.msgJSON
            onReceiveMessageData: { cbw in
                print(cbw.msgJSON as Any)
            },
            // optional, callback triggered when message choice is selected when called choice
            // type will be available as Integer at cbw.choiceType
            onMessageChoiceSelect: { cbw in
                print(cbw.choiceType as Any)
            },
            // optional, callback triggered when consent data is captured when called
            // euconsent will be available as String at cLib.euconsent and under
            // PreferenceManager.getDefaultSharedPreferences(activity).getString(EU_CONSENT_KEY, null);
            // consentUUID will be available as String at cLib.consentUUID and under
            // PreferenceManager.getDefaultSharedPreferences(activity).getString(CONSENT_UUID_KEY null);
            onSendConsentData: { cbw in
                print(cbw.euconsent as Any, cbw.consentUUID as Any)
            }
        )
        view.addSubview(consentWebView.view)
    }
}

