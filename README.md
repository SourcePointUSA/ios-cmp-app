
# iOS Setup guide

* Clone https://github.com/SourcePointUSA/ios-cmp-app repository to an arbitrary directory on your system.
Open your existing iOS app in xcode
Make sure you do NOT have the SourcePoint_iOS_SDK project open in xcode and drag SourcePoint_iOS_SDK/SourcePoint_iOS_SDK.xcodeproj file to xcode’s navigation panel on the left, directly under the root item of your project. <img width="664" alt="screen shot 2018-11-01 at 10 06 25 am" src="https://user-images.githubusercontent.com/2576311/47862463-930cf680-ddcb-11e8-8668-9016db8edb49.png">

* Change the active scheme to SourcePoint_iOS_SDK on the top bar and build the library from Product -> Build (cmd + B). <img width="854" alt="screen shot 2018-11-01 at 11 33 04 am" src="https://user-images.githubusercontent.com/2576311/47862464-930cf680-ddcb-11e8-9477-9b956c8f9ff2.png">


* Select the project (root item) on the left navigation panel in xcode and select the target you want to add the CMP library to under the TARGETS list. Expand SourcePoint_iOS_SDK.xcodeproj/SourcePoint_iOS_SDK/Products in the navigation panel and drag Consent_String_SDK_Swift.framewrok to the list of “Embedded Binaries” <img width="1130" alt="screen shot 2018-11-01 at 11 35 06 am" src="https://user-images.githubusercontent.com/2576311/47862465-930cf680-ddcb-11e8-9b05-947c0de39451.png">


* Import SourcePoint_iOS_SDK module in your AppDelegate.swift to test the library can be imported successfully
Switch back the active schema to your own project and run the app and you should be all set

# How to use the ConsentWebView widget

* Open your project’s info.plist file and make sure you have App Transport Security Settings/Allow Arbitrary Loads set to YES <img width="856" alt="screen shot 2018-11-01 at 11 36 50 am" src="https://user-images.githubusercontent.com/2576311/47862466-93a58d00-ddcb-11e8-99e8-2acaac6aef2b.png">


* Instantiate a ConsentWebView object in your main ViewController, set configuration variables and a onInteractionComplete callback and add the ConsentWebView to your ViewController as a subview:

```swift
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
                "\n eu consent prop",
                cbw.euconsent as Any,
                "\n consent uuid prop",
                cbw.consentUUID as Any,
                "\n eu consent in storage",
                UserDefaults.standard.string(forKey: ConsentWebView.EU_CONSENT_KEY) as Any,
                "\n consent uuid in storage",
                UserDefaults.standard.string(forKey: ConsentWebView.CONSENT_UUID_KEY) as Any,

                // Standard IAB values in UserDefaults
                "\n IABConsent_ConsentString in storage",
                UserDefaults.standard.string(forKey: ConsentWebView.IAB_CONSENT_CONSENT_STRING) as Any,
                "\n IABConsent_ParsedPurposeConsents in storage",
                UserDefaults.standard.string(forKey: ConsentWebView.IAB_CONSENT_PARSED_PURPOSE_CONSENTS) as Any,
                "\n IABConsent_ParsedVendorConsents in storage",
                UserDefaults.standard.string(forKey: ConsentWebView.IAB_CONSENT_PARSED_VENDOR_CONSENTS) as Any,

                // API for getting IAB Vendor Consents
                "\n IAB vendor consent for Smaato Inc",
                cbw.getIABVendorConsents([82]),
 
                // API for getting IAB Purpose Consents
                "\n IAB purpose consent for \"Ad selection, delivery, reporting\"",
                cbw.getIABPurposeConsents([3]),

                // Get custom vendor results:
                "\n custom vendor consents",
                cbw.getCustomVendorConsents(forIds: ["5bc76807196d3c5730cbab05", "5bc768d8196d3c5730cbab06"]),

                // Get purpose results:
                "\n all purpose consents ",
                cbw.getPurposeConsents(),
                "\n filtered purpose consents ",
                cbw.getPurposeConsents(forIds: ["5bc4ac5c6fdabb0010940ab1", "5bc4ac5c6fdabb0010940aae", "invalid_id_returns_nil" ]),
                "\n consented to measurement purpose ",
                cbw.getPurposeConsent(forId: "5bc4ac5c6fdabb0010940ab1")
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
```

# How to build the and export the framework as a binary [untested]
* On the top left corner in Xcode select `SourcePoint_iOS_SDK` as the active scheme and select `Generic iOS Device` as the target device.
* Clean and then build the project under Product menu.
* Under the Products branch in Project Navigator on the left right click on `SourcePoint_iOS_SDK.framework` and select `Show in Finder`, it should point you to the location of a `SourcePoint_iOS_SDK.framework` file, that's you compiled framework you can import to other projects.

# Complete Docs
For the complete docs open the `./SourcePoint_iOS_SDK/docs/index.html` in the browser.
In order to generate the docs you'll need first to install the `jazzy` gem:

    gem install jazzy

Then, from the folder `./SourcePoint_iOS_SDK` run

    jazzy
