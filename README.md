
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

private func buildConsentViewController(showPM: Bool, addToView parentView: UIView) {
do {
let consentViewController = try ConsentViewController(
accountId: 22,
siteName: "mobile.demo",
stagingCampaign: false
)

consentViewController.messageTimeoutInSeconds = TimeInterval(30)

consentViewController.onMessageReady = { controller in
parentView.addSubview(controller.view)
controller.view.frame = parentView.bounds
self.stopSpinner()
}

// optional, set custom targeting parameters supports Strings and Integers
consentViewController.setTargetingParam(key: "CMP", value: String(showPM))

consentViewController.onErrorOccurred = { error in
consentViewController.view.removeFromSuperview()
print(error)
self.stopSpinner()
}

consentViewController.onInteractionComplete = { cvc in
do {
print(
// Standard IAB values in UserDefaults
"\n IABConsent_ConsentString in storage",
UserDefaults.standard.string(forKey: ConsentViewController.IAB_CONSENT_CONSENT_STRING) as Any,
"\n IABConsent_ParsedPurposeConsents in storage",
UserDefaults.standard.string(forKey: ConsentViewController.IAB_CONSENT_PARSED_PURPOSE_CONSENTS) as Any,
"\n IABConsent_ParsedVendorConsents in storage",
UserDefaults.standard.string(forKey: ConsentViewController.IAB_CONSENT_PARSED_VENDOR_CONSENTS) as Any,
// API for getting IAB Purpose Consents
"\n IAB purpose consent for \"Ad selection, delivery, reporting\"",
try cvc.getIABPurposeConsents([3])
)


cvc.view.removeFromSuperview()
} catch {
print(error)
}
}

consentViewController.loadMessage()
} catch {
print(error)
}
}

@IBAction func showPrivacyManager(_ sender: Any) {
startSpinner()
buildConsentViewController(showPM: true, addToView: view)
}

func startSpinner() {
let alert = UIAlertController(title: nil, message: "Just a second...", preferredStyle: .alert)
let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
loadingIndicator.hidesWhenStopped = true
loadingIndicator.style = UIActivityIndicatorView.Style.gray
loadingIndicator.startAnimating();
alert.view.addSubview(loadingIndicator)
present(alert, animated: true, completion: nil)
}

func stopSpinner() {
dismiss(animated: false, completion: nil)
}

override func viewDidLoad() {
super.viewDidLoad()

buildConsentViewController(showPM: false, addToView: view)

//IABConsent_CMPPresent must be set immediately after loading the ConsentViewController
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
