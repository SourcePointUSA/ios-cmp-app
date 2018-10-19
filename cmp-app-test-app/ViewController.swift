//
//  ViewController.swift
//  cmp-app-test-app
//
//  Created by Dmitri Rabinowitz on 8/13/18.
//  Copyright © 2018 Sourcepoint. All rights reserved.
//

import UIKit
import SourcePoint_iOS_SDK


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
        consentWebView.setTargetingParam(key: "c", value: 100)
        
        // optional, sets debug level defaults to OFF
        consentWebView.debugLevel = ConsentWebView.DebugLevel.OFF
        
        // optional, callback triggered when message data is loaded when called message data
        // will be available as String at cbw.msgJSON
        consentWebView.onReceiveMessageData = { (cbw: ConsentWebView) in
            print("msgJSON from backend", cbw.msgJSON as Any)
        }
        
        // optional, callback triggered when message choice is selected when called choice
        // type will be available as Integer at cbw.choiceType
        consentWebView.onMessageChoiceSelect = { cbw in
            print("Choice type selected by user", cbw.choiceType as Any)
        }
        
        // optional, callback triggered when consent data is captured when called
        // euconsent will be available as String at cLib.euconsent and under
        // PreferenceManager.getDefaultSharedPreferences(activity).getString(EU_CONSENT_KEY, null);
        // consentUUID will be available as String at cLib.consentUUID and under
        // PreferenceManager.getDefaultSharedPreferences(activity).getString(CONSENT_UUID_KEY null);
        consentWebView.onInteractionComplete = { (cbw: ConsentWebView) in
            print(
                "eu consent prop",
                cbw.euconsent as Any,
                "consent uuid prop",
                cbw.consentUUID as Any,
                "eu consent in storage",
                UserDefaults.standard.string(forKey: ConsentWebView.EU_CONSENT_KEY) as Any,
                "consent uuid in storage",
                UserDefaults.standard.string(forKey: ConsentWebView.CONSENT_UUID_KEY) as Any,
                "custom vendor consent",
                cbw.getVendorConsents(["5bc76807196d3c5730cbab05", "5bc768d8196d3c5730cbab06"]),
                "IABConsent_ConsentString in storage",
                UserDefaults.standard.string(forKey: ConsentWebView.IAB_CONSENT_CONSENT_STRING) as Any
            )
        }
        
        view.backgroundColor = UIColor.gray
        
        view.addSubview(consentWebView.view)

        // IABConsent_CMPPresent must be set immediately after loading the ConsentWebView
        print(
            "IABConsent_CMPPresent in storage",
            UserDefaults.standard.string(forKey: ConsentWebView.IAB_CONSENT_CMP_PRESENT) as Any,
            "IABConsent_SubjectToGDPR in storage",
            UserDefaults.standard.string(forKey: ConsentWebView.IAB_CONSENT_SUBJECT_TO_GDPR) as Any
        )
    }
}
