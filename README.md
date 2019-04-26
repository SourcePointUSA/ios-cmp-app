
# iOS Setup guide

We strongly recommend the use of [CocoaPods](https://cocoapods.org) in order to install our SDK.
In your `Podfile` add the following line to your app target:

```
pod ConsentViewController
```

# Usage

* Instantiate a ConsentViewController object in your main ViewController, set configuration variables and a onInteractionComplete callback and add the ConsentViewController to your ViewController as a subview:

```swift
import UIKit
import ConsentViewController

class ViewController: UIViewController {
    var consentViewController: ConsentViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        try ConsentViewController(
                accountId: 22,
                siteName: "mobile.demo",
                stagingCampaign: false
            )
        // optional, set custom targeting parameters supports Strings and Integers
        consentViewController.setTargetingParam(key: "CMP", value: String(showPM))

        // optional, sets debug level defaults to OFF
        consentViewController.debugLevel = ConsentViewController.DebugLevel.OFF

        consentViewController.willShowMessage = { cvc in print("the message will show") }

        // optional, callback triggered when message choice is selected when called choice
        // type will be available as Integer at cvc.choiceType
        consentViewController.onMessageChoiceSelect = { cvc in
            print("Choice type selected by user", cvc.choiceType as Any)
        }

        consentViewController.onErrorOccurred = { cvc in print(cvc.error!) }

        // optional, callback triggered when consent data is captured when called
        // euconsent will be available as String at cLib.euconsent and under
        // PreferenceManager.getDefaultSharedPreferences(activity).getString(EU_CONSENT_KEY, null);
        // consentUUID will be available as String at cLib.consentUUID and under
        // PreferenceManager.getDefaultSharedPreferences(activity).getString(CONSENT_UUID_KEY null);
        consentViewController.onInteractionComplete = { cvc in
            do {
                print(
                    "\n eu consent prop",
                    cvc.euconsent as Any,
                    "\n consent uuid prop",
                    cvc.consentUUID as Any,
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

                    // API for getting IAB Purpose Consents
                    "\n IAB purpose consent for \"Ad selection, delivery, reporting\"",
                    cvc.getIABPurposeConsents([3])
                )
                print("Custom vendor consents")
                for consent in try cvc.getCustomVendorConsents() {
                    print("Custom Vendor Consent id: \(consent.id), name: \(consent.name)")
                }
                print("Custom purpose consents")
                for consent in try cvc.getCustomPurposeConsents() {
                    print("Custom Purpose Consent id: \(consent.id), name: \(consent.name)")
                }
            }
            catch { print(error) }
        }

        view.backgroundColor = UIColor.gray

        view.addSubview(consentViewController.view)

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
