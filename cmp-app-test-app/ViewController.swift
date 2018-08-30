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
            // required, must be set first used to find account
            accountId: 22,
            // required, must be set second used to find scenario
            siteName: "app.ios.cmp"
        )
        
        // optional, used for logging purposes for which page of the app the consent lib was
        // rendered on
        consentWebView.page = "main"
        
        // optional, used for running stage campaigns
        consentWebView.isStage = false
        
        // optional, used for running against our stage endpoints
        consentWebView.isInternalStage = true
        
        // optional, should not ever be needed provide a custom url for the messaging page
        // (overrides internal stage)
        consentWebView.inAppMessagingPageUrl = nil
        
        // optional, should not ever be needed provide a custom domain for mms (overrides
        // internal stage)
        consentWebView.mmsDomain = nil
        
        // optional, should not ever be needed provide a custom domain for cmp (overrides
        // internal stage)
        consentWebView.cmpDomain = nil
        
        // optional, set custom targeting parameters supports Strings and Integers
        consentWebView.setTargetingParam(key: "a", value: "b")
        consentWebView.setTargetingParam(key: "b", value: "c")
        
        // optional, sets debug level defaults to OFF
        consentWebView.debugLevel = ConsentWebView.DebugLevel.OFF
        
        // optional, callback triggered when message data is loaded when called message data
        // will be available as String at cbw.msgJSON
        consentWebView.onReceiveMessageData = { cbw in
            print(cbw.msgJSON as Any)
        }
        
        // optional, callback triggered when message choice is selected when called choice
        // type will be available as Integer at cbw.choiceType
        consentWebView.onMessageChoiceSelect = { cbw in
            print(cbw.choiceType as Any)
        }
        
        // optional, callback triggered when consent data is captured when called
        // euconsent will be available as String at cLib.euconsent and under
        // PreferenceManager.getDefaultSharedPreferences(activity).getString(EU_CONSENT_KEY, null);
        // consentUUID will be available as String at cLib.consentUUID and under
        // PreferenceManager.getDefaultSharedPreferences(activity).getString(CONSENT_UUID_KEY null);
        consentWebView.onInteractionComplete = { cbw in
            print(
                cbw.euconsent as Any,
                cbw.consentUUID as Any,
                UserDefaults.standard.string(forKey: ConsentWebView.EU_CONSENT_KEY) as Any,
                UserDefaults.standard.string(forKey: ConsentWebView.CONSENT_UUID_KEY) as Any
            )
        }
        
        view.backgroundColor = UIColor.gray
        
        view.addSubview(consentWebView.view)
    }
}

