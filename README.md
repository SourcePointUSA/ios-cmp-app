
# iOS Setup guide

**Important** if you're not using the new message builder, make sure to use pod version < 3. The README for the older version can be found [here](https://github.com/SourcePointUSA/ios-cmp-app/blob/d3c999a2245d2e5660806321c3979eaa32838642/README.md).


We strongly recommend the use of [CocoaPods](https://cocoapods.org) in order to install our SDK.
In your `Podfile` add the following line to your app target:

```
pod ConsentViewController
```

# Usage

It's pretty simple, here are 5 easy steps for you:

1. implement the `ConsentDelegate` protocol
2. instantiate the `ConsentViewController` with your Account ID, site id, site name, privacy manager id, campaign environment, a flag to show the privacy manager directly or not and the consent delegate
3. call `.loadMessage()`
4. present the controller when the message is ready to be displayed
5. profit!

## Swift
```swift
import UIKit
import ConsentViewController

class ViewController: UIViewController, ConsentDelegate {
    let logger = Logger()

    func loadConsentManager(showPM: Bool) {
        let cvc = try! ConsentViewController(accountId: 22, siteId: 2372, siteName: "mobile.demo", PMId: "5c0e81b7d74b3c30c6852301", campaign: "stage", showPM: showPM, consentDelegate: self)
        cvc.loadMessage()
    }

    func onMessageReady(controller: ConsentViewController) {
        self.present(controller, animated: false, completion: nil)
    }

    func onConsentReady(controller: ConsentViewController) {
        controller.getCustomVendorConsents { (vendors, error) in
            if let vendors = vendors {
                vendors.forEach({ vendor in self.logger.log("Consented to: %{public}@)", [vendor]) })
            } else {
                self.onErrorOccurred(error: error!)
            }
        }
        self.dismiss(animated: false, completion: nil)
    }

    func onErrorOccurred(error: ConsentViewControllerError) {
        self.dismiss(animated: false, completion: nil)
    }

    @IBAction func onPrivacySettingsTap(_ sender: Any) {
        loadConsentManager(showPM: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadConsentManager(showPM: false)
    }
}
```

## Objective-C
```obj-c
// don't forget to @import ConsentViewController;

ConsentViewController *cvc = [[ConsentViewController alloc] initWithAccountId:22 siteName:@"mobile.demo" stagingCampaign:false andReturnError:nil];

[cvc setTargetingParamString:@"MyPrivacyManager" value:@"true"];

[cvc setOnMessageReady:^(ConsentViewController * consentSDK) {
    [self presentViewController:consentSDK animated:false completion:NULL];
}];

[cvc setOnInteractionComplete:^(ConsentViewController * consentSDK) {
    [consentSDK getCustomPurposeConsentsWithCompletionHandler:^(NSArray<PurposeConsent *>* purposeConsents) {
        NSLog(@"User has given consent to the purposes: %@", purposeConsents);
    }];

    [consentSDK dismissViewControllerAnimated:false completion:NULL];
}];

[cvc loadMessage];

```
