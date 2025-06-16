[![Test](https://github.com/SourcePointUSA/ios-cmp-app/actions/workflows/swift.yml/badge.svg)](https://github.com/SourcePointUSA/ios-cmp-app/actions/workflows/swift.yml)

## How to install

### CocoaPods

In your `Podfile` add the following line to your app target:

```
pod 'ConsentViewController', '7.9.1'
```

The SDK has a static transitive dependency. If you use `use_frameworks!` in your Podfile, make sure to link it statically:

```ruby
use_frameworks! :linkage => :static
```

### Carthage

We also support [Carthage](https://github.com/Carthage/Carthage). It requires a couple more steps to install so we dedicated a whole [wiki page](https://github.com/SourcePointUSA/ios-cmp-app/wiki/SDK-integration-using-Carthage) for it.
Let us know if we missed any step.

### Swift Package Manager

We also support [Swift Package Manager](https://swift.org/package-manager/) for both iOS and tvOS. It is a tool for automating the distribution of Swift code and is integrated into the swift compiler.

To add our SDK package as dependency to your Xcode project, In Xcode select File > Swift Packages > Add Package Dependency and enter our SDK repository URL.

Or you can use `Package.swift` file and add the dependency there:

```swift
// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "MyPackage",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        .library(name: "MyPackage", targets: ["MyPackage"]),
    ],
    dependencies: [
        .package(
            name: "ConsentViewController",
            url: "https://github.com/SourcePointUSA/ios-cmp-app",
                .upToNextMinor(from: "7.9.1")
        ),
    ],
    targets: [
        .target(
            name: "MyPackage",
            dependencies: [
                "ConsentViewController"
            ]
        )
    ]
)

```

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
        consentManager.loadUSNATPrivacyManager(withId: "14967")
    }

    lazy var consentManager: SPSDK = { SPConsentManager(
        accountId: 22,
        propertyId: 16893,
        propertyName: try! SPPropertyName("mobile.multicampaign.demo"),
        campaigns: SPCampaigns(
            gdpr: SPCampaign(), //only include if this campaign type is enabled in the Sourcepoint portal
            usnat: SPCampaign(), //only include if this campaign type is enabled in the Sourcepoint portal
            ccpa: SPCampaign(), //only include if this campaign type is enabled in the Sourcepoint portal
            ios14: SPCampaign() //only include if this campaign type is enabled in the Sourcepoint portal
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
        present(controller, animated: true)
    }

    func onAction(_ action: SPAction, from controller: SPMessageViewController) {
        print(action)
    }

    func onSPUIFinished(_ controller: SPMessageViewController) {
        dismiss(animated: true)
    }

    func onConsentReady(userData: SPUserData) {
        print("onConsentReady:", userData)
        // checking if a gdpr vendor is consented
        userData.gdpr?.consents?.vendorGrants["myVendorId"]?.granted

        // checking if a ccpa vendor is rejected (on ccpa, vendors are accepted by default)
        userData.ccpa?.consents?.rejectedVendors.contains("myVendorId")
    }

    func onSPFinished(userData: SPUserData) {
        print("sourcepoint sdk done")
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

        SPCampaign *campaign = [[SPCampaign alloc] initWithTargetingParams: [NSDictionary dictionary]];

        SPCampaigns *campaigns = [[SPCampaigns alloc]
            initWithGdpr: campaign //only include if this campaign type is enabled in the Sourcepoint portal
            usnat: campaign //only include if this campaign type is enabled in the Sourcepoint portal
            ccpa: campaign //only include if this campaign type is enabled in the Sourcepoint portal
            ios14: campaign //only include if this campaign type is enabled in the Sourcepoint portal
            environment: SPCampaignEnvPublic];

        consentManager = [[SPConsentManager alloc]
            initWithAccountId:22
            propertyId: 16893
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

    - (void)onConsentReadyWithConsents:(SPUserData *)userData {
        NSLog(@"onConsentReady");
        NSLog(@"GDPR Applies: %d", userData.objcGDPRApplies);
        NSLog(@"GDPR: %@", userData.objcGDPRConsents);
        NSLog(@"CCPA Applies: %d", userData.objcCCPAApplies);
        NSLog(@"CCPA: %@", userData.objcCCPAConsents);
    }

    - (void)onSPUIFinished:(SPMessageViewController * _Nonnull)controller {
        NSLog(@"sourcepoint sdk done");
    }
@end
```

## Configure account details in `SPConsentManager`

The `SpConsentManager` initializer contains your organization's account and property details. The SDK will use the details configured in `SPConsentManager` to pull in the relevant campaigns that you have set-up in the Sourcepoint portal.

```swift
lazy var consentManager: SPConsentManager = { SPConsentManager(
    accountId: 22,
    propertyId: 16893,
    propertyName: try! SPPropertyName("mobile.multicampaign.demo"),
    campaigns: SPCampaigns(
        gdpr: SPCampaign(),
        usnat: SPCampaign()
    ),
    delegate: self
)}()
```

| Field          | **Description**                                                                                                                                                           |
| -------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `accountId`    | Organization's account ID found in the Sourcepoint portal                                                                                                                 |
| `propertyId`   | ID for property found in the Sourcepoint portal                                                                                                                           |
| `propertyName` | Name of property found in the Sourcepoint portal                                                                                                                          |
| `campaigns`    | Campaigns launched on the property through the Sourcepoint portal. Accepts `gdpr` \| `ccpa` \| `usnat` \| `ios14`. See table below for information on each campaign type. |

Refer to the table below regarding the different campaigns that can be implemented via the SDK:

| Campaign | **Description**                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| -------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `gdpr`   | Used if your property runs a GDPR TCF or GDPR Standard campaign                                                                                                                                                                                                                                                                                                                                                                                    |
| `ccpa`   | Used if your property runs a U.S. Privacy (Legacy) campaign                                                                                                                                                                                                                                                                                                                                                                                        |
| `usnat`  | Used if your property runs a U.S. Multi-State Privacy campaign. Please do not attempt to utilize both `ccpa` and `usnat` simultaneously as this poses a compliance risk for your organization. <br><br>This campaign type should only be implemented via `SPConsentManager` on mobile devices. [Click here](#global-privacy-platform-multi-state-privacy-msps-support-for-tvos) to learn more about implementing U.S. Multi-State Privacy on tvOS. |
| `ios14`  | Used if your property runs a iOS Tracking Message campaign                                                                                                                                                                                                                                                                                                                                                                                         |

## Loading the Privacy Manager on demand

You can load the Privacy Manager (that UI with the toggles) any time, programmatically, by calling either

- `.loadGDPRPrivacyManager(withId: String, tab: SPPrivacyManagerTab = .Default)`
- `.loadCCPAPrivacyManager(withId: String, tab: SPPrivacyManagerTab = .Default)`
- `.loadUSNATPrivacyManager(withId: String, tab: SPPrivacyManagerTab = .Default)`

The SDK will follow the same exact same lifecycle as with the 1st layer consent message. First calling the delegate method `onSPUIReady` when the PM is ready, `onAction` when the user takes an action, `onSPUIFinished` when the PM is ready to be removed from the View stack and, finally, `onConsentReady` once the SDK receives the consent data back from the server.

## Understanding the `SPDelegate` protocol (delegate methods)

### onSPUIReady(\_ controller: UIViewController)

The SDK will wrap the web message into a `UIViewController` and call the `onSPUIReady` when there is a message to be displayed.

**_NOTE:_** `onSPUIReady` overrides `modalPresentationStyle` of the ViewController to be `.overFullScreen`. We identified some swiping gestures using other types of `modalPresentationStyle` causes the webview rendering the message to be unresponsive. We encourage you to keep using `.overFullScreen` until this issue is fixed.

### optional onSPNativeMessageReady(\_ message: SPNativeMessage)

The `onSPNativeMessageReady` is only called if the scenario returns a native message. It will be up to you to the `message` object on the screen using the layout you best see fit.

### onAction(\_ action: SPAction, from controller: UIViewController)

Whenever the user takes an action (e.g. tapping on a button), the SDK will call the `onAction` passing the `action` as parameter. **This delegate method runs in the main thread**.

#### What's inside `SPAction`

Among other internal data, you'll find:

- `type: SPActionType`: an enum signaling the type of action. Use XCode's quick help on `SPActionType` for more info.
- `campaignType: SPCampaignType`: an enum signaling the type of campaign in which the action was taken (`gdpr, ios14, ccpa, usnat, unknown`)
- `customActionId: String`: if the type of action is `Custom`, this attribute will contain the id you assigned to it when building the message in our message builder (publisher's portal).
- `publisherPayload: [String: AnyEncodable]`: also known as `pubData` in some of SP services, this is an arbitrary dictionary of key value pairs (set by your app) to be sent to our servers and later retrieved using the pubData API.

With exception of `PMCancel` and `ShowPrivacyManager` actions, the SDK will call the `onSPUIFinished` after handling the action.

### onSPUIFinished(\_ controller: UIViewController)

When an action is taken (see above), the SDK will handle it appropriately (sending a consent request to our servers, for example) and call the `onSPUIFinished` to indicate the message can be dismissed by your app.

### optional onConsentReady(userData: SPUserData)

The `onConsentReady` will be called in two different scenarios:

1. After `loadMessage` is called but there's no message to be displayed.
2. After the SDK receives the response for one of its consent requests. This happens after the user has taken a consent action (`AcceptAll`, `RejectAll`, `Save&Exit`) in the message or Privacy Manager.

Make sure to check XCode's quick help of `SPUserData` for more information on what data is available to your app during `onConsentReady`.

### optional onError(error: SPError)

In case of an error, the SDK will wrap the error in one of the `SPError` classes and eventually call the `onError(_ error: SPError)` callback. [Click here](https://github.com/SourcePointUSA/ios-cmp-app/wiki/iOS-error-codes) for more information on the error codes that can be generated by the SDK.

By default, the SDK preserves all user consent data from UserDefaults in case of `OnError` event is called.
Set `consentManager.cleanUserDataOnError` flag to `true` after you initialize `SPConsentManager` if you wish to opt-out from this behavior. This _may_ cause a consent message to be shown again, depending on your scenario.

## SPUserData structure

`SPUserData` contains all the information related to the user consent action. The structure of `SPUserData` is as follows:

```
SPUserData(
    gdpr: SPConsent<SPGDPRConsent>?(
        applies: Bool,
        consents: SPGDPRConsents(
            acceptedCategories: [String],
            applies: Bool,
            consentStatus: ConsentStatus,
            googleConsentMode: SPGCMData?,
            objcGoogleConsentMode: SPGCMDataObjc?, // available only on ObjC
            dateCreated: SPDate,
            euconsent: String,
            tcfData: SPJson?,
            uuid: String?,
            vendorGrants: Dictionary<String, SPGDPRVendorGrant>,
        )
    ),
    usnat: SPConsent<SPUSNatConsent>?(
        applies: Bool,
        consents: SPUSNatConsent(
            GPPData: GPPSpec
            statuses: {
                rejectedAny: Bool?,
                consentedToAll: Bool?,
                consentedToAny: Bool?,
                sellStatus: Bool?,
                shareStatus: Bool,
                sensitiveDataStatus: Bool?,
                gpcStatus: Bool?,
                hasConsentData: Bool?
            }
            consentStrings: [
                {
                    sectionId: String,
                    sectionName: String,
                    consentString: String
                }
            ]
            vendors: [{ id: String, consented: Bool }]
            categories: [{ id: String, consented: Bool }]
            uuid: String?
        )
    ),
    ccpa: SPConsent<SPCCPAConsent>?(
        applies: Bool,
        consents: SPCCPAConsent(
            dateCreated: SPDate
            GPPData: SPJson,
            rejectedCategories: [String],
            rejectedVendors: [String],
            signedLspa: Bool,
            status: String,
            uspstring: String,
            uuid: String?,
        )
    )
)
```

> [Click here](https://github.com/InteractiveAdvertisingBureau/Global-Privacy-Platform/blob/main/Core/CMP%20API%20Specification.md#in-app-key-names) to view the keys in `GPPSpec`.

## Google Consent Mode

[Google Consent Mode 2.0](https://developers.google.com/tag-platform/security/concepts/consent-mode) ensures that Google vendors on your property comply with an end-user's consent choices for purposes (called consent checks) defined by Google. It is implemented via [Google Analytics for Firebase SDK](https://developers.google.com/tag-platform/security/guides/app-consent?consentmode=advanced&platform=ios).

### Set default consent state for consent checks

Add the following keys to your app's `info.plist` to define the initial consent state (`.granted` | `.denied`) for each of Google's consent checks:

```xml
<key>GOOGLE_ANALYTICS_DEFAULT_ALLOW_ANALYTICS_STORAGE</key> <true/> // set this to `true` or `false` as required
<key>GOOGLE_ANALYTICS_DEFAULT_ALLOW_AD_STORAGE</key> <true/>
<key>GOOGLE_ANALYTICS_DEFAULT_ALLOW_AD_USER_DATA</key> <true/>
<key>GOOGLE_ANALYTICS_DEFAULT_ALLOW_AD_PERSONALIZATION_SIGNALS</key> <true/>
```

### Update consent checks

Use Google's `setConsent` method to update the relevant consent checks when the appropriate purposes are consented to/rejected.

> The consent checks updated via the `setConsent` method will vary and depends on how you are implementing Google Consent Mode 2.0 on your mobile property within the Sourcepoint portal. The method should only be called with consent checks that are mapped within your vendor list to custom purposes.<br><br>Review Sourcepoint's implementation documentation below for more information:
>
> - [Implement Google Consent Mode 2.0 on GDPR TCF (mobile)](https://docs.sourcepoint.com/hc/en-us/articles/26139951882643-Google-Consent-Mode-2-0-GDPR-TCF-mobile#h_01HPHHGSP42A36607MDC7NVBV9)
> - [Implement Google Consent Mode 2.0 on GDPR Standard (mobile)](https://docs.sourcepoint.com/hc/en-us/articles/26159382698387-Google-Consent-Mode-2-0-GDPR-Standard-mobile#h_01HPJ2MT0F5B1G8ZZVD5PNXT9S)

```swift
//Example only. Consent checks updated via setConsent will depend on implementation
func onSPFinished(userData: SPUserData) {
    let gcmData = userData.gdpr?.consents?.googleConsentMode
    Analytics.setConsent([
        .analyticsStorage: gcmData?.analyticsStorage == .granted ? .granted : .denied,
        .adStorage: gcmData?.adStorage == .granted ? .granted : .denied,
        .adUserData: gcmData?.adUserData == .granted ? .granted : .denied,
        .adPersonalization: gcmData?.adPersonalization == .granted ? .granted : .denied,
    ])
}
```

Be advised that the `googleConsentMode` object in `SPUserData` will only return values for Google consent checks that are mapped to a custom purpose within your vendor list. For all other Google consent checks, the response will be `null`.

## Adding or Removing custom consents

It's possible to programmatically consent the current user to a list of custom vendors, categories and legitimate interest categories with the method:

```swift
func customConsentToGDPR(
    vendors: [String],
    categories: [String],
    legIntCategories: [String],
    handler: @escaping (SPGDPRConsent) -> Void
)
```

The vendor grants will be re-generated, this time taking into consideration the list of vendors, categories and legitimate interest categories you pass as parameters. The method is asynchronous so you must pass a completion handler that will receive back an instance of `SPGDPRConsent` in case of success or it'll call the delegate method `onError` in case of failure.

Using the same strategy for the custom consent, it's possible to programmatically delete the current user consent to a list of vendors, categories and legitimate interest categories by using the following method:

```swift
func deleteCustomConsentGDPR(
   vendors: [String],
   categories: [String],
   legIntCategories: [String],
   handler: @escaping (SPGDPRConsent) -> Void
)
```

The method is asynchronous so you must pass a completion handler that will receive back an instance of SPGDPRConsent in case of success or it'll call the delegate method onError in case of failure.

It's important to notice, this methods are intended to be used for **custom** vendors and purposes only. For IAB vendors and purposes, it's still required to get consent via the consent message or privacy manager.

## Authenticated Consent

This feature makes use of what we call [Authenticated Consent](https://documentation.sourcepoint.com/consent_mp/authenticated-consent/authenticated-consent-overview). In a nutshell, you provide an identifier for the current user (username, user id, uuid or any unique string) and we'll take care of associating the consent profile to that identifier.

In order to use the authenticated consent all you need to do is replace `.loadMessage()` with `.loadMessage(forAuthId: String)`. Example:

```swift
consentManager.loadMessage(forAuthId: "JohnDoe")
```

In Obj-C that'd be:

```objc
[consentManager loadMessage forAuthId: @"JohnDoe"]
```

This way, if we already have consent for that token (`"JohDoe"`) we'll bring the consent profile from the server, overwriting whatever was stored in the device.

>If required for your app's log out process, your organization can call the [`clearAllData`](#delete-user-data) method to erase local data. Once cleared, your organization can then call `loadMessage` to collect consent from a non-authenticated user or `loadMessage` with a new `authId` for a new authenticated user. 

## Sharing consent with a `WKWebView`

After going through the message and consent flow (ie. after `onConsentReady`) the SDK will store the consent data in the `UserDefaults`. That data can then be injected into `WKWebView`s so the web portion of your app doesn't show a consent dialog and it'll contain the same consent data as the native part.

Example:

```swift
// somewhere earlier in your app's lifecycle
var userConsents: SPUserData?

func onSPFinished(userData: SPUserData) {
    userConsents = userData
}

let webview = WKWebView()
if let userConsents = userConsents {
    webview.load(URLRequest(URL(string: "https://my-url.com/?_sp_pass_consent=true")!))
    webview.preloadConsent(from: userConsents)
} else {
    webview.load(URLRequest(URL(string: "https://my-url.com/")!)) // load url without _sp_pass_consent=true
}
```

Note: The desitination url needs to implement the unified script.

A few remarks:

1. The web content being loaded (web property) needs to share the same vendor list as the app.
2. The vendor list's consent scope needs to be set to _Shared Site_ instead of _Single Site_
3. Your web content needs to be loaded (or loading) on the webview and our [web SDK](https://docs.sourcepoint.com/hc/en-us/articles/8073421891091-GDPR-TCF-and-U-S-Privacy-CCPA-implementation-guide-web-) should be included in it. Furthermore, you need to add the query param `_sp_pass_consent=true` to your URL, this will signal to Sourcepoint's web SDK it needs to wait for the consent data to be injected from the native code, instead of immediately querying it from our servers.

## Overwriting default language

By default, the SDK will instruct the message to render itself using the locale defined by the `WKWebView`. If you wish to overwrite this behavior and force a message to be displayed in a certain language, you need to set the `.messageLanguage` attribute of the `SPConsentManager` _before_ calling `.loadMessage() / .loadPrivacyManager()`.

```swift
consentManager.messageLanguage = .German
consentManager.loadMessage()
```

In Obj-C that'd be:

```objc
consentManager.messageLanguage = SPMessageLanguageGerman;
[consentManager loadMessage];
```

It's important to notice that if any of the components of the message doesn't have a translation for that language, the component will be rendered in the default language configured in the message builder.

> When the **Use Browser Default** toggle is enabled in the message builder, Sourcepoint will ignore the language setting configured in the SDK and use the default language configured in the message builder. If the end-user's browser language is not supported by a translation in the message builder, the default language set in the message builder will be used instead.

## Loading Stage campaigns

`SPConsentManager`'s constructor accepts an optional parameter called `campaignsEnv: SPCampaignEnv`. This parameter, when omitted will be `.Public` by default.
Currently, we don't support loading campaigns of different environments. In other words, you can only load all Stage or Public campaigns.

## Setting Targeting Parameters

Targeting params are a set of key/value pairs passed to the scenario. In the scenario you're able to conditionally show a message or another based on those values.
You can set targeting params individually per campaign like so:

```swift
let myCampaign = SPCampaign(targetingParams: ["foo": "bar"])
```

In Obj-C that'd be:

```objc
SPCampaign *myCampaign = [[SPCampaign alloc]
    initWithTargetingParams: [[NSDictionary alloc] initWithObjectsAndKeys:@"value1", @"key1"]
];
```

## Transfer opt-in/opt out preferences from U.S. Privacy (Legacy) to U.S. Multi-State Privacy

When migrating a property from the U.S. Privacy (Legacy) campaign to U.S. Multi-State Privacy campaign, the SDK will automatically detect previously set end-user opt-in/opt-out preferences for U.S. Privacy (Legacy) and have that transferred over to U.S. Multi-State Privacy.

> If an end-user rejected a vendor or category for U.S. Privacy, Sourcepoint will set the _Sharing of Personal Information Targeted Advertisting_ and _Sale of Personal Information_ privacy choices or the _Sale or Share of Personal Information/Targeted Advertising_ privacy choice (depending on your configuration) to **opted-out** when the preferences are transferred.

If you ever used authenticated consent for CCPA, you'll have to set the flag `transitionCCPAAuth` manually when configuring the campaigns to be loaded by the SDK. This way, the SDK will look for authenticated consent within CCPA profiles and carry that over to USNat, even if the user currently doesn't have CCPA local data (on a fresh install, for example).

```swift
var consentManager = SPConsentManager(
    accountId: accId,
    propertyId: propId,
    propertyName: try! SPPropertyName(propName),
    campaigns: SPCampaigns(usnat: SPCampaign(transitionCCPAAuth: true)), // <== here
    delegate: self
)
```

## Check end-user consent status for U.S. Multi-State Privacy

Your organization can check an end-user's consent status for a privacy choice by checking the `statuses` object for `usnat` in `SPUserData`.

In the following code snippets, replace `{status}` with a status from the table below:

| **Status**            | **Description**                                                                                                                                                                                                                                                              |
| --------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `sellStatus`          | Checks end-user consent status for _Sale of Personal Information_ privacy choice.                                                                                                                                                                                            |
| `shareStatus`         | Checks end-user consent status for _Sharing of Personal Information/Targeted Advertising_ privacy choice.                                                                                                                                                                    |
| `sensitiveDataStatus` | Checks end-user consent status for _Processing of Sensitive Personal Information_ privacy choice.<br><br>Each sensitive data category configured by your organization is collated under this single privacy choice.The end-user either opts into all the categories or none. |

The code snippets will check the configured status and execute the code you have set up for an end-user.

```swift
//Replace {status} with the appropriate status
if SPUserData.usnat?.consents?.statuses.{status} {
    //execute code
}
```

> If your organization has combined _Sharing of Personal Information/Targeted Advertising and Sale of Personal Information_ into a single privacy choice in the Sourcepoint portal, you can elect to check either `sellStatus` or `shareStatus` for the end-user consent status.

## Support U.S. Privacy (Legacy) with U.S. Multi-State Privacy

If you're transitioning from U.S. Privacy (Legacy) to U.S. Multi-State Privacy, you may want to continue supporting the legacy US privacy string (`IABUSPrivacy_String`).

> Since U.S. Privacy (Legacy) does not have support for sensitive data categories, any organization who require sensitive data opt-ins should not use this approach. Additionally, this approach should not be used by organizations who **_only_** require Sharing of Personal Information/Targeted Advertising. A `uspString` will only be set if you use either of the following privacy choices:
>
> - Sale of Personal Information
> - Sale or Sharing of Personal Information/Targeted Advertising

To do so, when instantiating the SDK, make sure to set the flag `.supportLegacyUSPString` to true. Example:

```swift
var consentManager = SPConsentManager(
    ...
    campaigns: SPCampaigns(usnat: SPCampaign(supportLegacyUSPString: true)), // <== here
    delegate: self
)
```

## Configuring the Message/Consents timeout

Before calling `.loadMessage` or `.loadPrivacyManager`, set the `.messageTimeoutInSeconds` attribute to a time interval that makes most sense for your own application. By default, we set it to 30 seconds.

In case of a timeout error, the `onError` callback will be called and the consent flow will stop there.

## `pubData`

When the user takes an action within the consent UI, it's possible to attach an arbitrary payload to the action data an have it sent to our endpoints. For more information on how to do that check our wiki: [Sending arbitrary data when the user takes an action](https://github.com/SourcePointUSA/ios-cmp-app/wiki/Sending-arbitrary-data-when-the-user-takes-an-action.)

## Rendering the message natively

Have a look at this neat [wiki](https://github.com/SourcePointUSA/ios-cmp-app/wiki/Rendering-consent-message-natively) we put together.

## App Tracking Transparency

To display the App Tracking Transparency authorization request for accessing the IDFA, update your `Info.plist`  to add the `NSUserTrackingUsageDescription` key with a custom message describing your usage. Here is an example description text:

```
<key>NSUserTrackingUsageDescription</key>
<string>This identifier will be used to deliver personalized ads to you.</string>
```

![App Tracking](https://github.com/SourcePointUSA/ios-cmp-app/blob/develop/wiki/assets/AppTracking.png)

## Event callbacks

iOS delegate methods are triggered in response to certain events for example, when a message is ready to be displayed or the end-user opens the privacy manager.
This section describes the purpose and action for each of these functions.

The iOS implementation of Sourcepoint's CMP has five event callbacks:

- [`onSPUIReady(_ controller: UIViewController)`](#onSPUIReady)
- [`onAction(_ action: SPAction, from controller: UIViewController)`](#onAction)
- [`onSPUIFinished()`](<#onSPUIFinished()>)
- [`onConsentReady()`](<#onConsentReady()>)
- [`onError()`](<#onError()>)

### `onSPUIReady` `(_ controller: UIViewController)`

The `onSPUIReady` delegate method is called when there is a "web-based" message to be displayed. The controller parameter is the view controller containing the message to be displayed.

### `onAction` `(_ action: SPAction, from controller: UIViewController)`

The `onAction` delegate method is called once the user takes an action in the first layer message or privacy manager.

The action: `SPAction` parameter, among other data (used internally), contains:

| Attribute                         | Description                                                                                                                                                                                                                                                        |
| --------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `type: SPActionType`              | Indicates the type of action, this is an enumerated value. For example, a response to the ATT message is `RequestATTAccess` or to show the privacy manager is `ShowPrivacyManager`.                                                                                |
| `campaignType: SPCampaignType`    | Indicates the type of campaign in which the action was taken. This is an enumerated value e.g. **gdpr, ios14, ccpa, usnat, unknown**.                                                                                                                              |
| `customActionId: String`          | If the type of action is Custom, this attribute will contain the id you assigned to it when building the message in our message builder (publisher's portal).                                                                                                      |
| `consentLanguage`                 | The language used in the messages.                                                                                                                                                                                                                                 |
| `publisherData: [String: String]` | This is an arbitrary dictionary of [String: String] containing data the publisher wishes to send to our servers so it can be retrieved via API later on. The publisher needs to set this field during the callback if they need the data to be sent to our server. |

### `onSPUIFinished()`

The `onSPUIFinished` delegate method is invoked when the SDK determines that the UI can be removed from the view hierarchy or dismissed. It typically occurs after the end-user has taken a consent action (e.g. Accept all, Reject all, Save & Exit).

With exception of `PMCancel` and `ShowPrivacyManager` actions, the SDK will call the onSPUIFinished after handling the action.

### `onConsentReady()`

The `onConsentReady` will be called in two different scenarios:

- After `loadMessage` is called but there's no message to be displayed
- After the SDK receives a response for one of its consent requests. This happens after the user has taken a consent action (`AcceptAll`, `RejectAll`, `Save&Exit`) in the message or Privacy Manager

The `onConsentReady` delegate method sends the consent action to the server and receives a response, the SDK will store the data in the `UserDefaults`.

### `onError()`

The SDK will in all cases wrap the error in one of the SPError class and eventually call the func `onError(_ error: SPError)` callback. By default, the SDK preserves all user consent data from UserDefaults in case of `OnError` event is called.
Set `consentManager.cleanUserDataOnError` flag to `true` after you initialize `SPConsentManager` if you wish to opt-out from this behavior. If set to `true` such use case will erase all user consent data from UserDefaults. This _may_ cause a consent message to be shown again, depending on your scenario.

## Google Additional Consent (GDPR TCF)

Google additional consent is a concept created by Google and the IAB Framework to pass end-user consent to Google Ad Technology Providers (ATP) despite not adhering to the IAB TCF framework. [Click here](https://docs.sourcepoint.com/hc/en-us/articles/4405115143955) for more information.

Google additional consent is supported by our mobile SDKs and is stored in the `IABTCF_AddtlConsent` key in the `UserDefaults`. Look for that key in the user's local storage and pass the value to Google's SDKs.

## Global Privacy Platform Multi-State Privacy (MSPS) Support for tvOS

Starting with version `7.3.0`, if your tvOS configuration contains a `ccpa` campaign, it will automatically set GPP data. Unless configured otherwise, the following MSPA atrributes will default to:

- `MspaCoveredTransaction`: no
- `MspaOptOutOptionMode`: notApplicable
- `MspaServiceProviderMode`: notApplicable

Optionally, your organization can customize support for the MSPS by configuring the above attributes as part of the GPP config. [Click here](<https://github.com/SourcePointUSA/ios-cmp-app/wiki/Global-Privacy-Platform-(GPP)-Multi%E2%80%90State-Privacy-(MSPS)>) for more information on each attribute, possible values, and examples for signatories and non-signatories of the MSPA

Example:

```swift
let campaigns = SPCampaigns(
    ccpa: SPCampaign(gppConfig: SPGPPConfig(
        MspaCoveredTransaction: .yes, // optional,
        MspaOptOutOptionMode: .yes, // optional
        MspaServiceProviderMode: .notApplicable // optional
    ))
)
```

> **Note**: While `SPGPPConfig` can be passed to any `SPCampaign`, it only affects the CCPA campaign.

## Delete user data

Utilize the following method if an end-user requests to have their data deleted:

```swift
//Swift
SPConsentManager.clearAllData()
```

```obj-c
//Objective C
[SPConsentManager clearAllData];
```

## Set a Privacy Manager Id for the Property Group

Property groups allow your organization to group properties together in order to simplify configurations for mass campaigns and updates.
In order to use a `Privacy Manager Id for the Property Group`, you should edit the SDK configuration object as follows:

```swift
lazy var consentManager: SPConsentManager = { SPConsentManager(
   accountId: 22,
   propertyName: try! SPPropertyName("mobile.multicampaign.demo"),
   campaigns: SPCampaigns(
       gdpr: SPCampaign(groupPmId: "123") // <- "123" is the id of the privacy manager for the property group
   ),
   delegate: self
)}()
```

After adding the `Privacy Manager Id for the Property Group` you should set the flag `useGroupPmIfAvailable`, in the `loadGDPRPrivacyManager`, to true:

```swift
consentManager.loadGDPRPrivacyManager(withId: "111", useGroupPmIfAvailable: true)
```

> **Note**: CCPA campaign `Privacy Manager Id for the Property Group` feature is currently not supported.

## Programmatically rejecting all for a user

It's possible to programmatically issue a "reject all" action in behalf of the current user by calling the `rejectAll(campaignType)` function. The `rejectAll` function behaves exactly the same way as if a user would have pressed the "reject all" button on the 1st layer or privacy manager.
Upon completion, the sdk will call either `onConsentReady` in case of success or `onError` in case of failure.

```swift
    consentManager.rejectAll(campaignType: .gdpr)
```

## Frequently Asked Questions

### 1. How big is the SDK?

The library adds approximately 2.8 MB to your app’s final binary (measured using Xcode’s Archive in Release mode on arm64). Notice this number may vary depending on your app's minimum iOS deployment target and whether you build it for Debug or Release.

### 2. What's the lowest iOS version supported?

iOS 10 onwards.

### 3. What if IDFA is not supported (iOS < 14)

We encapsulate the IDFA status in our own enum called `SPIDFAstatus`. In case the SDK is running on an iOS version that does not support IDFA, the status will be `unavailable`. Otherwise, it'll assume one of the 3 values:

- `unknown`: User has never been prompted to accept/reject tracking (the native iOS ATT prompt).
- `accepted`: User accepted the ATT prompt, giving your app access to the IDFA.
- `rejected`: User rejected the ATT prompt, denying your app access to the IDFA.

We'll update this list over time, if you have any questions feel free to open an issue or contact your SourcePoint account manager.

### 3. Are deep links supported?

Sourcepoint does not support deep linking due to an HTML sanitizer used in our message rendering app (used by our in-app SDKs to render messages in a webview). Changing the configuration to our HTML sanitizer would compromise our security and introduce vulnerabilities for cross-site scripting (XSS) attacks.

Your organization can mirror deep linking by creating a button with a **Custom Action** choice option in your first layer message and leveraging the following code in your implementation:

```swift
func onAction(_ action: SPAction, from controller: UIViewController) {
    if action.type == .Custom,
       action.customActionId == "id-specified-in-portal" {
        // navigate user to intended page
    }
}
```
