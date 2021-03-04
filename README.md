![Swift](https://github.com/SourcePointUSA/ios-cmp-app/workflows/Swift/badge.svg?branch=develop)

## How to install

### CocoaPods
In your `Podfile` add the following line to your app target:

```
pod 'ConsentViewController', '5.3.6'
```

### Carthage
We also support [Carthage](https://github.com/Carthage/Carthage). It requires a couple more steps to install so we dedicated a whole [wiki page](https://github.com/SourcePointUSA/ios-cmp-app/wiki/SDK-integration-using-Carthage) for it.
Let us know if we missed any step.

### Swift Package Manager
We also support [Swift Package Manager](https://swift.org/package-manager/). It is a tool for automating the distribution of Swift code and is integrated into the swift compiler. It is in early development, but SourcePoint does support its use on iOS platform.

To add our SDK package as dependency to your Xcode project, In Xcode select File > Swift Packages > Add Package Dependency and enter our SDK repository URL.

### Manually add XCFramework
If you prefer not to use any of the dependency managers. You can add `ConsentViewController.xcframework` as a library to your project or workspace.
1. Download the [latest code version](https://github.com/SourcePointUSA/ios-cmp-app.git).
2. Open your project in Xcode, select your target and go to the General tab. In the Frameworks, Libraries, and Embedded Content section. drag and drop `ConsentViewController.xcframework` from downloaded project XCFramework folder.

```
https://github.com/SourcePointUSA/ios-cmp-app.git
```

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

    func onError(error: GDPRConsentViewControllerError) {
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
    
    NSDictionary *targetingParameter = [NSDictionary dictionary];

    cvc = [[GDPRConsentViewController alloc]
           initWithAccountId: 22
           propertyId: 7639
           propertyName: propertyName
           PMId: @"122058"
           campaignEnv: GDPRCampaignEnvPublic
           targetingParams:targetingParameter
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
## Loading the Privacy Manager on demand
You can load the Privacy Manager (that UI with the toggles) any time programatically by calling the `.loadPrivacyManager()` method. The SDK will follow the same exact same lifecycle as with the 1st layer consent message. First calling the delegate method `gdprConsentUIWillShow` when the PM is ready and then calling `onConsentReady` after the user takes an action.

## Programatically consenting an user
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

## Authenticated Consent
In order to use the authenticated consent all you need to do is replace `.loadMessage()` with `.loadMessage(forAuthId: String)`. Example:
```swift
  consentViewController.loadMessage(forAuthId: "JohnDoe")
```
In Obj-C that'd be:
```objc
  [consentViewController loadMessage forAuthId: @"JohnDoe"]
```
This way, if we already have consent for that token (`"JohDoe"`) we'll bring the consent profile from the server, overwriting whatever was stored in the device.
More about the `authId` below.

## Sharing consent with a `WKWebView`
```swift
let webview = WKWebView()
webview.setConsentFor(authId: String)
webview.load(URLRequest)
```

### The `authId`:
This feature makes use of what we call [Authenticated Consent](https://documentation.sourcepoint.com/consent_mp/authenticated-consent/authenticated-consent-overview). In a nutshell, you provide an identifier for the current user (username, user id, uuid or any unique string) and we'll take care of associating the consent profile to that identifier.
The authId will then assume 1 of the 3 values below:
1. **User is authenticated and have an id:**
In that case the `authId` is going to be that user id.
2. **User is _not_ authenticated and I'm only interested in using consent in this app.**
We recommend using a randomly generated `UUID` as `authId`. Make sure to persist this `authId` and always call the `.loadMessage(forAuthId: String)`
3. **User is _not_ authenticated and I want the consent to be shared _across_ apps I controll.**
In this case, you'll need an identifier that is guaranteed to be the same across apps you control. That's exactly what the [IDFV](https://developer.apple.com/documentation/uikit/uidevice/1620059-identifierforvendor) (Identifier for Vendor) is for. You don't need to store this id as it remains the same across app launches.

### Example
```swift
// let authId = // my user id
// let authId = // stored uuid || UUID().uuidString
let authId = UIDevice().identifierForVendor
consentViewController.loadMessage(forAuthId: myAuthId)

// after the `onConsentReady` is called
myWebView.setConsentFor(authId: authid)
myWebView.load(urlRequest)
```
A few remarks:
1. The web content being loaded (web property) needs to share the same vendor list as the app.
2. The vendor list's consent scope needs to be set to _Shared Site_ instead of _Single Site_

## Overwriting default language
By default, the SDK will instruct the message to render itself using the locale defined by the `WKWebView`. If you wish to overwrite this behaviour and force a message to be displayed in a certain language, you need to set the `.messageLanguage` attribute of the `GDPRConsentViewController` _before_ calling `.loadMessage() / .loadPrivacyManager()`. 
```swift
consentViewController.messageLanguage = .German
consentViewController.loadMessage()
```
In Obj-C that'd be:
```objc
cvc.messageLanguage = SPMessageLanguageGerman;
[cvc loadMessage];
```
It's important to notice that if any of the components of the message doesn't have a translation for that language, the component will be rendered in english as a fallback.

## Overwriting Privacy Manager tab
By default, the SDK will load default tab of privacy manager or the tab specified in the `Show Options`  action. If you wish to overwrite this behavior, you need to set the `.privacyManagerTab` attribute of `GDPRConsentViewController` _before_ calling `.loadMessage() / .loadPrivacyManager()`.
```swift
consentViewController.privacyManagerTab = .Vendors
consentViewController.loadMessage()
```
In Obj-C that'd be:
```objc
cvc.privacyManagerTab = SPPrivacyManagerTabPurposes;
[cvc loadMessage];
```
It's important to note that the order of precedence for the PM tab will be as follow:
1. PM tab set in the `Show Options` action (set in the dashboard)
2. If none, then the one provided by the developer
3. If none, the one set by default in the PM settings in the dashboard


## Setting Targeting Parameters
In order to set a targeting param all you need to do is passing `targetingParams:[string:string]` as a parametter in the ConsentViewController constructor. Example:

```swift
lazy var consentViewController: GDPRConsentViewController = { return GDPRConsentViewController(
       //other parameters here...
        targetingParams:["language":"fr"]
    )}()
```
In Obj-C that'd be:
```objc
NSMutableDictionary *targetingParameter = [[NSMutableDictionary alloc] init];
[targetingParameter setObject:@"fr" forKey:@"language"];

cvc = [[GDPRConsentViewController alloc]
       //other parameters here...
       targetingParams:targetingParameter
       consentDelegate: self];
```

In this example a key/value pair "language":"fr" is passed to the sp scenario and can be useded, wiht the proper scenario setup, to show a french message instead of a english one.

## Configuring the Message/Consents timeout
Before calling `.loadMessage` or `.loadPrivacyManager`, set the `.messageTimeoutInSeconds` attribute to a time interval that makes most sense for your own application. By default, we set it to 30 seconds.

In case of a timeout error, the `onError` callback will be called and the consent flow will stop there.

## `pubData`
When the user takes an action within the consent UI, it's possible to attach an arbitrary payload to the action data an have it sent to our endpoints. For more information on how to do that check our wiki: [Sending arbitrary data when the user takes an action](https://github.com/SourcePointUSA/ios-cmp-app/wiki/Sending-arbitrary-data-when-the-user-takes-an-action.)

## Rendering the message natively
Have a look at this neat [wiki](https://github.com/SourcePointUSA/ios-cmp-app/wiki/Rendering-consent-message-natively) we put together.

## Frequently Asked Questions
### 1. How big is the SDK?
The SDK is pretty slim, there are no assets, no dependencies, just pure code. Since we use Swift, its size will vary depending on the configuration of your project but it should not exceed `2 MB`.
### 2. What's the lowest iOS version supported?
Although our SDK can be technically added to projects targeting iOS 9, we support iOS >= 10 only.

We'll update this list over time, if you have any questions feel free to open an issue or concact your SourcePoint account manager.

