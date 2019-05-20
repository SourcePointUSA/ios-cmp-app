
# iOS Setup guide

We strongly recommend the use of [CocoaPods](https://cocoapods.org) in order to install our SDK.
In your `Podfile` add the following line to your app target:

```
pod ConsentViewController
```

# Usage

It's pretty simple, here are 5 easy steps for you:

1. instantiate the `ConsentViewController` with your Account ID and site name.
2. set `ConsentViewController` callback functions
3. call `.loadMessage()`
4. present the controller when the message is ready to be displayed
5. profit!

## Swift
```swift
let cvc = try! ConsentViewController(accountId: 22, siteName: "mobile.demo", stagingCampaign: false)

cvc.setTargetingParam(key: "MyPrivacyManager", value: String(myPrivacyManager))

cvc.onMessageReady = { controller in
    self.present(controller, animated: false, completion: nil)
}

cvc.onInteractionComplete = { controller in
    controller.getCustomVendorConsents(completionHandler: { vendorConsents in
        vendorConsents.forEach({ consent in print("Consented to \(consent)") })
    })
    self.dismiss(animated: false, completion: nil)
}

cvc.loadMessage()
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
@end

```

# Complete Docs
For the complete docs open the `./SourcePoint_iOS_SDK/docs/index.html` in the browser.
In order to generate the docs you'll need first to install the `jazzy` gem:

    gem install jazzy

Then, from the folder `./SourcePoint_iOS_SDK` run

    jazzy
