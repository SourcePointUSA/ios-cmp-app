![Swift](https://github.com/SourcePointUSA/ios-cmp-app/workflows/Swift/badge.svg?branch=develop)

## How to install

### CocoaPods
In your `Podfile` add the following line to your app target:

```
pod 'ConsentViewController', '6.0.1'
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

1. implement the `SPDelegate` protocol
2. instantiate the `SPConsentManager` with your Account ID, property name, campaigns and an instance of `SPDelegate`
3. call `.loadMessage()`
4. present the controller when the message is ready to be displayed (`onSPUIReady`).
5. profit!

### Swift
```swift
import ConsentViewController

class ViewController: UIViewController {
    @IBAction func onClearConsentTap(_ sender: Any) {
        SPConsentManager.clearAllData()
    }

    @IBAction func onGDPRPrivacyManagerTap(_ sender: Any) {
        consentManager.loadGDPRPrivacyManager(withId: "13111", tab: .Features)
    }

    @IBAction func onCCPAPrivacyManagerTap(_ sender: Any) {
        consentManager.loadCCPAPrivacyManager(withId: "14967")
    }

    lazy var consentManager: SPConsentManager = { SPConsentManager(
        accountId: 22,
        propertyName: try! SPPropertyName("mobile.multicampaign.demo"),
        campaigns: SPCampaigns(
            gdpr: SPCampaign(),
            ccpa: SPCampaign(),
            ios14: SPCampaign()
        ),
        delegate: self
    )}()

    override func viewDidLoad() {
        super.viewDidLoad()
        consentManager.loadMessage()
    }
}

extension ViewController: SPDelegate {
    func onSPUIReady(_ controller: SPMessageViewController) {
        controller.modalPresentationStyle = .overFullScreen
        present(controller, animated: true)
    }

    func onAction(_ action: SPAction, from controller: SPMessageViewController) {
        print(action)
    }

    func onSPUIFinished(_ controller: SPMessageViewController) {
        dismiss(animated: true)
    }

    func onConsentReady(consents: SPUserData) {
        print("onConsentReady:", consents)
    }

    func onError(error: SPError) {
        print("Something went wrong: ", error)
    }
}
```

### Objective-C
```obj-c

#import "ViewController.h"
@import ConsentViewController;

@interface ViewController ()<SPDelegate> {
    SPConsentManager *consentManager;
}
@end

@implementation ViewController

    - (void)viewDidLoad {
        [super viewDidLoad];

SPPropertyName *propertyName = [[SPPropertyName alloc] init:@"mobile.multicampaign.demo" error:NULL];

SPCampaign *campaign = [[SPCampaign alloc]
    initWithEnvironment: SPCampaignEnvPublic
    targetingParams: [NSDictionary dictionary]];

SPCampaigns *campaigns = [[SPCampaigns alloc]
    initWithGdpr: campaign
    ccpa: campaign
    ios14: campaign];

consentManager = [[SPConsentManager alloc]
    initWithAccountId:22
    propertyName: propertyName
    campaigns: campaigns
    delegate: self];

[consentManager loadMessageForAuthId: NULL];
    }

    - (void)onSPUIReady:(SPMessageViewController * _Nonnull)controller {
        [self presentViewController:controller animated:true completion:NULL];
    }

    - (void)onAction:(SPAction * _Nonnull)action from:(SPMessageViewController * _Nonnull)controller {
        NSLog(@"onAction: %@", action);
    }

    - (void)onSPUIFinished:(SPMessageViewController * _Nonnull)controller {
        [self dismissViewControllerAnimated:true completion:nil];
    }

    - (void)onConsentReadyWithConsents:(SPUserData *)consents {
        NSLog(@"onConsentReady: %@", consents);
    }
@end
```
## Loading the Privacy Manager on demand
You can load the Privacy Manager (that UI with the toggles) any time, programatically, by calling either
* `.loadGDPRPrivacyManager(withId: String, tab: SPPrivacyManagerTab = .Default)` or
* `.loadCCPAPrivacyManager(withId: String, tab: SPPrivacyManagerTab = .Default)`

The SDK will follow the same exact same lifecycle as with the 1st layer consent message. First calling the delegate method `onSPUIReady` when the PM is ready, `onAction` when the user takes an action, `onSPUIFinished` when the PM is ready to be removed from the View stack and, finally,  `onConsentReady` once the SDK receives the consent data back from the server.

## Programatically consenting an user
It's possible to programatically consent the current user to a list of custom vendors, categories and legitimate interest caregories with the method:
```swift
func customConsentToGDPR(
    vendors: [String],
    categories: [String],
    legIntCategories: [String],
    handler: @escaping (SPGDPRConsent) -> Void
)
```

The vendor grants will be re-generated, this time taking into consideration the list of vendors, categories and legitimate interest categories you pass as parameters. The method is asynchronous so you must pass a completion handler that will receive back an instance of `SPGDPRConsent` in case of success or it'll call the delegate method `onError` in case of failure.

It's important to notice, this method is intended to be used for **custom** vendors and purposes only. For IAB vendors and purposes, it's still required to get consent via the consent message or privacy manager.

## Authenticated Consent
In order to use the authenticated consent all you need to do is replace `.loadMessage()` with `.loadMessage(forAuthId: String)`. Example:
```swift
consentManager.loadMessage(forAuthId: "JohnDoe")
```
In Obj-C that'd be:
```objc
[consentManager loadMessage forAuthId: @"JohnDoe"]
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
consentManager.loadMessage(forAuthId: myAuthId)

// after the `onConsentReady` is called
myWebView.setConsentFor(authId: authid)
myWebView.load(urlRequest)
```
A few remarks:
1. The web content being loaded (web property) needs to share the same vendor list as the app.
2. The vendor list's consent scope needs to be set to _Shared Site_ instead of _Single Site_

## Overwriting default language
By default, the SDK will instruct the message to render itself using the locale defined by the `WKWebView`. If you wish to overwrite this behaviour and force a message to be displayed in a certain language, you need to set the `.messageLanguage` attribute of the `SPConsentManager` _before_ calling `.loadMessage() / .loadPrivacyManager()`. 
```swift
consentManager.messageLanguage = .German
consentManager.loadMessage()
```
In Obj-C that'd be:
```objc
consentManager.messageLanguage = SPMessageLanguageGerman;
[consentManager loadMessage];
```
It's important to notice that if any of the components of the message doesn't have a translation for that language, the component will be rendered in english as a fallback.

## Setting Targeting Parameters
Targeting params are a set of key/value pairs passed to the scenario. In the scenario you're able to conditionaly show a message or another based on those values.
You can set targeting params individiually per campaign like so:

```swift
let myCampaign = SPCampaign(environment: .Public, targetingParams: ["foo": "bar"])
```

In Obj-C that'd be:
```objc
SPCampaign *myCampaign = [[SPCampaign alloc]
    initWithEnvironment: SPCampaignEnvPublic
    targetingParams: [[NSDictionary alloc] initWithObjectsAndKeys:@"value1", @"key1"]
];
```

## `pubData`
When the user takes an action within the consent UI, it's possible to attach an arbitrary payload to the action data an have it sent to our endpoints. For more information on how to do that check our wiki: [Sending arbitrary data when the user takes an action](https://github.com/SourcePointUSA/ios-cmp-app/wiki/Sending-arbitrary-data-when-the-user-takes-an-action.)

## Rendering the message natively
Have a look at this neat [wiki](https://github.com/SourcePointUSA/ios-cmp-app/wiki/Rendering-consent-message-natively) we put together.

## Frequently Asked Questions
### 1. How big is the SDK?
The SDK is pretty slim, there are no assets, no dependencies, just pure code. Since we use Swift, its size will vary depending on the configuration of your project but it should not exceed `2 MB`.
### 2. What's the lowest iOS version supported?
iOS 10 onwards.
### 3. What if IDFA is not supported (iOS < 14)
We encapsulate the IDFA status in our own enum called `SPIDFAstatus`. In case the SDK is running on an iOS version that does not support IDFA, the status will be `unavailable`. Otherwise, it'll assume one of the 3 values:
* `unknown`: User has never been prompted to accept/reject tracking (the native iOS ATT prompt).
* `accepted`: User accepted the ATT prompt, giving your app access to the IDFA.
* `rejected`: User rejected the ATT prompt, denyinh your app access to the IDFA.

We'll update this list over time, if you have any questions feel free to open an issue or concact your SourcePoint account manager.

