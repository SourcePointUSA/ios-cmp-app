
# iOS Setup guide

## How to install

### CocoaPods
:heavy_exclamation_mark: **IMPORTANT** if you still haven't moved to TCFv2, use `v4.x`.
```
pod 'ConsentViewController', '< 5.0.0'
```
Refer to its [README](https://github.com/SourcePointUSA/ios-cmp-app/blob/163683c76513c61a7892c722014b5b2e45864ee8/README.md) for more information.


We strongly recommend the use of [CocoaPods](https://cocoapods.org) in order to install our SDK.
In your `Podfile` add the following line to your app target:

```
pod 'ConsentViewController', '5.2.0'
```

### Carthage
We also support [Carthage](https://github.com/Carthage/Carthage). It requires a couple more steps to install so we dedicated a whole [wiki page](https://github.com/SourcePointUSA/ios-cmp-app/wiki/Carthage-SDK-integration-guide) for it.
Let us know if we missed any step.

## How to use it

It's pretty simple, here are 5 easy steps for you:

1. implement the `GDPRConsentDelegate` protocol
2. instantiate the `GDPRConsentViewController` with your Account ID, property id, property, privacy manager id, campaign environment, a flag to show the privacy manager directly or not and the consent delegate
3. call `.loadMessage()`
4. present the controller when the message is ready to be displayed
5. profit!

### Swift
```swift
import ConsentViewController

class ViewController: UIViewController {
    lazy var consentViewController: GDPRConsentViewController = { return GDPRConsentViewController(
        accountId: 22,
        propertyId: 7639,
        propertyName: try! GDPRPropertyName("tcfv2.mobile.webview"),
        PMId: "122058",
        campaignEnv: .Public,
        consentDelegate: self
    )}()

    @IBAction func onPrivacySettingsTap(_ sender: Any) {
        consentViewController.loadPrivacyManager()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        consentViewController.loadMessage()
    }
}

extension ViewController: GDPRConsentDelegate {
    func gdprConsentUIWillShow() {
        present(consentViewController, animated: true, completion: nil)
    }

    func consentUIDidDisappear() {
        dismiss(animated: true, completion: nil)
    }

    func onConsentReady(gdprUUID: GDPRUUID, userConsent: GDPRUserConsent) {
        print("ConsentUUID: \(gdprUUID)")
        userConsent.acceptedVendors.forEach { vendorId in print("Vendor: \(vendorId)") }
        userConsent.acceptedCategories.forEach { purposeId in print("Purpose: \(purposeId)") }

        // IAB Related Data
        print(UserDefaults.standard.dictionaryWithValues(forKeys: userConsent.tcfData.dictionaryValue?.keys.sorted() ?? []))
    }

    func onError(error: GDPRConsentViewControllerError?) {
        print("Error: \(error.debugDescription)")
    }
}
```

### Objective-C
```obj-c

#import "ViewController.h"
@import ConsentViewController;

@interface ViewController ()<GDPRConsentDelegate> {
    GDPRConsentViewController *cvc;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    GDPRPropertyName *propertyName = [[GDPRPropertyName alloc] init:@"tcfv2.mobile.webview" error:NULL];

    cvc = [[GDPRConsentViewController alloc]
           initWithAccountId: 22
           propertyId: 7639
           propertyName: propertyName
           PMId: @"122058"
           campaignEnv: GDPRCampaignEnvPublic
           consentDelegate: self];

    [cvc loadMessage];
}

- (void)onConsentReadyWithGdprUUID:(NSString *)gdprUUID userConsent:(GDPRUserConsent *)userConsent {
    NSLog(@"ConsentUUID: %@", gdprUUID);
    NSLog(@"ConsentString: %@", userConsent.euconsent);
    for (id vendorId in userConsent.acceptedVendors) {
        NSLog(@"Consented to Vendor(id: %@)", vendorId);
    }
    for (id purposeId in userConsent.acceptedCategories) {
        NSLog(@"Consented to Purpose(id: %@)", purposeId);
    }
}

- (void)gdprConsentUIWillShow {
    [self presentViewController:cvc animated:true completion:NULL];
}

- (void)consentUIDidDisappear {
    [self dismissViewControllerAnimated:true completion:nil];
}
@end
```

### Programatically consenting an user
It's possible to programatically consent the current user to a list of custom vendors, categories and legitimate interest caregories with the method:
```swift
func customConsentTo(
        vendors: [String],
        categories: [String],
        legIntCategories: [String],
        completionHandler: @escaping (GDPRUserConsent) -> Void)
```

The ids passed will be appended to the list of already accepted vendors, categories and leg. int. categories. The method is asynchronous so you must pass a completion handler that will receive back an instance of `GDPRUserConsent` in case of success or it'll call the delegate method `onError` in case of failure.

It's important to notice, this method is intended to be used for **custom** vendors and purposes only. For IAB vendors and purposes, it's still required to get consent via the consent message or privacy manager.

### Authenticated Consent

In order to use the authenticated consent all you need to do is replace `.loadMessage()` with `.loadMessage(forAuthId: String)`. Example:

```swift
  consentViewController.loadMessage(forAuthId: "JohnDoe")
```

In Obj-C that'd be:
```objc
  [consentViewController loadMessage forAuthId: @"JohnDoe"]
```

This way, if we already have consent for that token (`"JohDoe"`) we'll bring the consent profile from the server, overwriting whatever was stored in the device.

## Setting Targeting Parameters

In order to set a targeting param all you need to do is passing `targetingParams:[string:string]` as a parametter in the ConsentViewController constructor. Example:

```swift
lazy var consentViewController: GDPRConsentViewController = { return GDPRConsentViewController(
       //other parametters here...
        targetingParams:["language":"fr"]
    )}()
```

In this example a key/value pair "language":"fr" is passed to the sp scenario and can be useded, wiht the proper scenario setup, to show a french message instead of a english one.

## Configuring the Message/Consents timeout
Just set the `.messageTimeoutInSeconds` attribute to a time interval that makes most sense for your own application. By default, we set it to 30 seconds.

In case of a timeout error, the `onError` callback will be called and the consent flow will stop there.

## Rendering the message natively

Have a look at this neat [wiki](https://github.com/SourcePointUSA/ios-cmp-app/wiki/Rendering-consent-message-natively) we put together.
