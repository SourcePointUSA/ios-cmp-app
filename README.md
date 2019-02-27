
# iOS Setup guide

We strongly recommend the use of [CocoaPods](https://cocoapods.org) in order to install our SDK.
In your `Podfile` add the following line to your app target:

```
pod ConsentViewController
```

# How to use the ConsentViewController widget

* Instantiate a ConsentViewController object in your main ViewController, set configuration variables and a onInteractionComplete callback and add the ConsentViewController to your ViewController as a subview:

```swift
import UIKit
import ConsentViewController

class ViewController: UIViewController {
    var ConsentViewController: ConsentViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        ConsentViewController = ConsentViewController(
            // required, must be set first used to find account
            accountId: 22,
            // required, must be set second used to find scenario
            siteName: "app.ios.cmp"
        )

        // optional, used for logging purposes for which page of the app the consent lib was
        // rendered on
        ConsentViewController.page = "main"

        // optional, used for running stage campaigns
        ConsentViewController.isStage = false

        // optional, used for running against our stage endpoints
        ConsentViewController.isInternalStage = true

        // optional, should not ever be needed provide a custom url for the messaging page
        // (overrides internal stage)
        ConsentViewController.inAppMessagingPageUrl = nil

        // optional, should not ever be needed provide a custom domain for mms (overrides
        // internal stage)
        ConsentViewController.mmsDomain = nil

        // optional, should not ever be needed provide a custom domain for cmp (overrides
        // internal stage)
        ConsentViewController.cmpDomain = nil

        // optional, set custom targeting parameters supports Strings and Integers
        ConsentViewController.setTargetingParam(key: "a", value: "b")
        ConsentViewController.setTargetingParam(key: "c", value: 100)

        // optional, sets debug level defaults to OFF
        ConsentViewController.debugLevel = ConsentViewController.DebugLevel.OFF

        // optional, callback triggered when message data is loaded when called message data
        // will be available as String at cbw.msgJSON
        ConsentViewController.onReceiveMessageData = { (cbw: ConsentViewController) in
            print("msgJSON from backend", cbw.msgJSON as Any)
        }

        // optional, callback triggered when message choice is selected when called choice
        // type will be available as Integer at cbw.choiceType
        ConsentViewController.onMessageChoiceSelect = { cbw in
            print("Choice type selected by user", cbw.choiceType as Any)
        }

        // optional, callback triggered when consent data is captured when called
        // euconsent will be available as String at cLib.euconsent and under
        // PreferenceManager.getDefaultSharedPreferences(activity).getString(EU_CONSENT_KEY, null);
        // consentUUID will be available as String at cLib.consentUUID and under
        // PreferenceManager.getDefaultSharedPreferences(activity).getString(CONSENT_UUID_KEY null);
        ConsentViewController.onInteractionComplete = { (cbw: ConsentViewController) in
            print(
                "\n eu consent prop",
                cbw.euconsent as Any,
                "\n consent uuid prop",
                cbw.consentUUID as Any,
                "\n eu consent in storage",
                UserDefaults.standard.string(forKey: ConsentViewController.EU_CONSENT_KEY) as Any,
                "\n consent uuid in storage",
                UserDefaults.standard.string(forKey: ConsentViewController.CONSENT_UUID_KEY) as Any,

                // Standard IAB values in UserDefaults
                "\n IABConsent_ConsentString in storage",
                UserDefaults.standard.string(forKey: ConsentViewController.IAB_CONSENT_CONSENT_STRING) as Any,
                "\n IABConsent_ParsedPurposeConsents in storage",
                UserDefaults.standard.string(forKey: ConsentViewController.IAB_CONSENT_PARSED_PURPOSE_CONSENTS) as Any,
                "\n IABConsent_ParsedVendorConsents in storage",
                UserDefaults.standard.string(forKey: ConsentViewController.IAB_CONSENT_PARSED_VENDOR_CONSENTS) as Any,

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

        view.addSubview(ConsentViewController.view)

        // IABConsent_CMPPresent must be set immediately after loading the ConsentViewController
        print(
            "IABConsent_CMPPresent in storage",
            UserDefaults.standard.string(forKey: ConsentViewController.IAB_CONSENT_CMP_PRESENT) as Any,
            "IABConsent_SubjectToGDPR in storage",
            UserDefaults.standard.string(forKey: ConsentViewController.IAB_CONSENT_SUBJECT_TO_GDPR) as Any
        )
    }
}
```

# Complete Docs
For the complete docs open the `./SourcePoint_iOS_SDK/docs/index.html` in the browser.
In order to generate the docs you'll need first to install the `jazzy` gem:

    gem install jazzy

Then, from the folder `./SourcePoint_iOS_SDK` run

    jazzy
