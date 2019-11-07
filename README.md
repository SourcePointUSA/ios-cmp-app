
# iOS Setup guide

## How to install

### CocoaPods
:heavy_exclamation_mark: **IMPORTANT** if you're not yet using the new message builder, make sure to use pod version < 3.
```
pod 'ConsentViewController', '< 3.0.0'
```
The README for the older version can be found [here](https://github.com/SourcePointUSA/ios-cmp-app/blob/d3c999a2245d2e5660806321c3979eaa32838642/README.md).


We strongly recommend the use of [CocoaPods](https://cocoapods.org) in order to install our SDK.
In your `Podfile` add the following line to your app target:

```
pod 'ConsentViewController', '>= 3.0.0'
```
### Carthage
We also support [Carthage](https://github.com/Carthage/Carthage). It requires a couple more steps to install so we dedicated a whole [wiki page](https://github.com/SourcePointUSA/ios-cmp-app/wiki/Step-by-step-guide-for-Carthage) for it.
Let us know if we missed any step.

## How to use it

It's pretty simple, here are 5 easy steps for you:

1. implement the `ConsentDelegate` protocol
2. instantiate the `ConsentViewController` with your Account ID, site id, site name, privacy manager id, campaign environment, a flag to show the privacy manager directly or not and the consent delegate
3. call `.loadMessage()`
4. present the controller when the message is ready to be displayed
5. profit!

### Swift
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

### Objective-C
```obj-c

#import "ViewController.h"
@import ConsentViewController;

@interface ViewController ()<ConsentDelegate>
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    ConsentViewController *cvc = [[ConsentViewController alloc] initWithAccountId:22 siteId:2372 siteName:@"mobile.demo" PMId:@"5c0e81b7d74b3c30c6852301" campaign:@"stage" showPM:false consentDelegate:self andReturnError:nil];

    [cvc loadMessage];
}

- (void)onConsentReadyWithController:(ConsentViewController * _Nonnull)controller {
    [controller getCustomVendorConsentsWithCompletionHandler:^(NSArray<VendorConsent *> * vendors, ConsentViewControllerError * error) {
        if (error != nil) {
            [self onErrorOccurredWithError:error];
        } else {
            for (id vendor in vendors) {
                NSLog(@"Consented to: %@", vendor);
            }
        }
    }];
    [controller dismissViewControllerAnimated:false completion:NULL];
}

- (void)onErrorOccurredWithError:(ConsentViewControllerError * _Nonnull)error {
    NSLog(@"Error: %@", error);
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)onMessageReadyWithController:(ConsentViewController * _Nonnull)controller {
    [self presentViewController:controller animated:false completion:NULL];
}
@end

```
