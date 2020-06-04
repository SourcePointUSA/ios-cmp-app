## 5.2.2 (Jun, 04, 2020)
* Add `vendorGrants` attribute to `GDPRUserConsent` class. The `vendorGrants` attribute, simply put, is an dictionary reprensenting the consent state (on a legal basis) of all vendors and its purposes for the current user. For example:
```swift
[
  "vendorId1": VendorGrant(
    vendorGrant: Bool,
    purposeGrants: [
      "purposeId1": Bool,
      "purposeId2": Bool,
      // more purposes here
    ]
  )
  // more vendors here
]
```
The `vendorGrant` attribute is derived from `purposeGrants` and will be `true` if all purposes are also `true`.
* Removed the _bounce effect_ from the `MessageWebView` to improve on the UX while interacting with the consent message or the Privacy Manager.

## 5.2.1 (May, 27, 2020)
* Introduce the configurable timeout. You now can configure a timeout in which either the consent message must be shown or the consent data should be returned to the app (`onConsentReady`) by setting the attribute `.messageTimeoutInSeconds: TimeInterval`. Just make sure to set it _before_ calling `loadMessage` or `loadPrivacyManager`. #145
* Fixed an issue that would in some cases show the consent message for logged in users. #144

## 5.2.0 (May, 15, 2020)
* Added the method `customConsentTo` to `GDPRConsentViewController`. It's now possible to programatically consent the current user to a list of vendors, categories and legitimate interest caregories. The ids passed will be appended to the list of already accepted vendors, categories and leg. int. categories. The method is asynchronous so you must pass a completion handler that will receive back an instance of `GDPRUserConsent` in case of success or it'll call the delegate method `onError` in case of failure. It's important to notice, this method is intended to be used for **custom** vendors and purposes only. For IAB vendors and purposes it's still required to get consent via the consent message or privacy manager. #139
* Fix an issue preventing consent data from being completely removed when calling `clearAllData` #141
* Removed one (and hopfeully the last one) retaining cycle from our SDK #136


## 5.1.0 (April, 16, 2020)
This is big one. We're moving more and more towards a stable API, so bare with us.

* Fixed an issue that'd prevent the user to save consents from the privacy manager with the action _Save & Exit_ #118
* Added `legitimateInterestCategories: [String]` to `GDPRUserConsent` class #121
* Added `specialFeatures: [String]` to `GDPRUserConsent` class #121
* Updated the AuthExample app to use SDKv5 #116
* Disabled zooming and pinch zooming actions on the message webview #114
* Changed the delegate method from `onAction(_ action: GDPRAction, consents: PMConsents?)` to `onAction(_ action: GDPRAction)`. The consents is now part of `GDPRAction` and it's encoded into `Data`. 462e9b6
* `GDPRUserConsent.tcfData` has changed types from `[String: StringOrInt]` to `SPGDPRArbitraryJson`. It can be used as a dictionary by calling its `.dictionaryValue -> [String: Any]?` property.

## 5.0.3 (April, 03, 2020)
* Storing IAB consent data ealier by persisting it at the very first http call #109
* Added Swiftlint pod and to GitHub workflow #107
* Fixed a ton of lint issues including one forced unwrap #107
* Fixed an issue that was causing the Example app to crash on iPad 75e5472

## 5.0.2 (March, 26, 2020)
* support type changes in nativeMessageJSON

## 5.0.1 (March, 23, 2020)
* added support to [TCFv2](https://github.com/InteractiveAdvertisingBureau/GDPR-Transparency-and-Consent-Framework/blob/master/TCFv2/IAB%20Tech%20Lab%20-%20CMP%20API%20v2.md#in-app-details) for native message
* updated swift version to 5.0
* removed all warnings during build time
* deprecated `consentUIWillShow` in favor of `gdprConsentUIWillShow`

## 5.0.0 (January, 11, 2020)
* added support to [TCFv2](https://github.com/InteractiveAdvertisingBureau/GDPR-Transparency-and-Consent-Framework/blob/master/TCFv2/IAB%20Tech%20Lab%20-%20CMP%20API%20v2.md#in-app-details). The public API remained the same and the upgrade from v4 to v5 should require no development effort.

## 4.1.2 (January, 13, 2020)
* Fixed compatibility with Xcode 10.x

## 4.1.1 (January, 10, 2020)
* Fixed authId message

## 4.1.0 (January, 05, 2020)
Wow, that's huge! Behold the native message!
Now you are be able to build your own consent message using naive elements and layout. It's a lot to cover in one CHANGELOG entry so please refer to the this nice [wiki](https://github.com/SourcePointUSA/ios-cmp-app/wiki/Rendering-consent-message-natively) our team put together.

## 4.0.1 (January, 27, 2020)
* expanded `GDPRPropertyName` to accept property names with dashes (-)

## 4.0.0 (January, 17, 2020)
Alright ladies and gentlemen, what your're that's not a regular release... THAT'S A FULL-ON REWRITE 🔥
There are many small changes in the public API so instead of listing them here we kindly ask you to check the [README](https://github.com/SourcePointUSA/ios-cmp-app/blob/develop/README.md). It should provide you with everything you need to get up and running with the changes.

Long story short we have:
* Fixed a naming conflict issue uncovered when using both GPDR and [CCPA](https://github.com/SourcePointUSA/CCPA_iOS_SDK) SDKs
* Got rid of Reachability dependency
* Completely re-wrote the way we load the consent message and Privacy Manager. I don't mean to brag but we have seen an huge performance boost!

As usual, if you see something wrong or have a question feel free to create an issue in our repo or contact us via slack directly.

## 3.1.0 (December, 4, 2019)
* Added support to Carthage
* In order to maintain compliance even in the event of an outage on our side, we’re now clearing all local consent information of a user on onErrorOccurred. This behaviour is opt-in be default but can be opted-out by setting flag .shouldCleanConsentOnError = false
* changed initialisation params from siteId and siteName to propertyId and property (after all, it makes no sense to have “site” inside our apps…)
* fix two memory leaks due to retaining cycle and WKWebView (thanks to [@victorbenning](https://github.com/victorbenning))
* Improved test coverage

## 3.0.0 (October, 4, 2019)
Oh wow, time flies when we're having fun huh? This is a major release and, with major releases comes major ~~responsibilities~~ changes.

### New Message script
Our Web Team worked pretty hard to slim down our consent message platform and improve its perfomance. In this release we make use of the new message script.

**It's important to notice, SDK version 3 onwards will only be compatible with messages built using the new message builder.**

### Consent message lifecycle
* Moved the main message lifecycle callbacks (`onMessageReady`, `onInteractionComplete` and `onErrorOccurred`)to the `ConsentDelegate` protocol.
* Renamed `onInteractionComplete` to `onConsentReady` to better reflect the meaning of that callback.

TODO: Add a flowchart on how the lifecycle callbacks work (order and conditions)

### Plug & Play Privacy Manager
Prior to this release, there was no way to show the Privacy Manager programmatically, without relying on setting up a tricky scenario on our Dashboard.

We've changed that (keep reading).

### Constructor changes
In order to support the Plug & Play Privacy Manager and the `ConsentDelegate` protocol, we needed to add extra parameters to the constructor. The additional parameters are:
* `siteId`: a `Number` representing the property id - available on the dashboard
* `privacyManagerId`: a `String` representing the id of the Privacy Manager you wish to show - available on the dashboard
* `consentDelegate`: a `ConsentDelegate` compliant object.
* `showPM`: a boolean indicating if you wish to load the consent message or the Privacy Manager.

### Other improvements
* Reduced the amount of network calls
* Improved our timeout mechanism
* Simplified the Javascript Interface

---

## 2.4.1 (August, 16, 2019)
* Check for the GDPR status on every message load
* Raise iOS min version support from 8 to 9

## 2.4.0 (June, 27, 2019)
* Implement Identity feature
* Versioning of in-app web page

## 2.3.1 (May, 20, 2019)
* Fix an issue on iPads that when rotating the device would prevent the user from scrolling on the WebView
* Added `ConsentViewController.enableNewPM`. When called passing `true`, will switch to the new (experimental) Privacy Manager.

## 2.3.0 (May, 20, 2019)
* `ConsentViewController.getCustom*Consents` now always return an collection of Consents rather than an `Optional`
* Pod is able to be built on Swift 5 projects (thanks to @pwallrich)
* The example app is now simplied and the README has been updated

## 2.2.4 (April 20, 2019)
* Moved  the API calls on secondary thread to keep main thread independent and free for UI opertaion.

## 2.2.3 (April 09, 2019)
* fix an issue that'd crash the client app if subclassing `ConsentViewController`

## 2.2.2 (April 08, 2019)
* add the `ConsentViewController.messageTimeoutInSeconds` - used to controll the timeout between first load of the webview and `onMessageReady` callback

## 2.1.2 (April 08, 2019)
* fixed the interface for Objective-C, allowing the ConsentViewController to be used in Obj-c projects.

## 2.1.1 (April 04, 2019)
* fixed in which on iOS >= 11 the message background veil wouldn't cover the entire screen

## 2.1.0 (March 29, 2019)
* load the webview in a separate function and call onMessageReady when the message is ready to be shown.
* no longer add/remove the view from the superview. it's up to the parent to decide if/when the view should be added (we recommend using onMessageReady to add it and onInteractionComplete to remove it)

## 2.0.1 (March 21, 2019)
* We now call `done()` always **after** `onErrorOccurred`

## 2.0.0 (March 15, 2019)
Look at that, we barely released version 1.x and we're already launching v2.0 🎉

This is a major release that includes several bug fixes and improved stability.
* Much better error handling.
* Major internal refactoring and code simplification.
* Dramatically reduce forced optional unwrapping.

Having all those great advantages does come with a price. However, it's a rather small one. I promise.

The Migration Guide below will tell you all you need to know about using v2.0 coming from
v1.x

### Migration Guide

* Constructors:
  * New convenience constructor has changed from `init(accountId: , siteName: )` to `init(accountId: , siteName: , stagingCampaign: Bool)`.
  * If you need full control of the endpoints' urls, there're still [other constructors](https://github.com/SourcePointUSA/ios-cmp-app/blob/master/ConsentViewController/Classes/ConsentViewController.swift#L147) that can be used.
  * It now `throws` an error implementing the [`ConsentViewControllerError`](https://github.com/SourcePointUSA/ios-cmp-app/blob/master/ConsentViewController/Classes/ConsentViewControllerError.swift#L10) protocol.
* Custom Consents:
  * The getters for singular custom consent (`getPurposeConsent` and `getCustomVendorConsent`) were removed.
  * `getPurposeConsents` was renamed to `getCustomPurposeConsents`
  * Both `getCustomPurposeConsents` and `getCustomVendorConsents` no longer receive any params and will return `[PurposeConsent]` and `[VendorConsent]` respectively.
  * [`PurposeConsent` and `VendorConsent`](https://github.com/SourcePointUSA/ios-cmp-app/blob/master/ConsentViewController/Classes/Consent.swift) classes introduced.
* Error Handling:
  * Several Errors subclasses were introduced in order to make debugging easier and the framework more robust.
  * When instantiating `ConsentViewController` or when calling one of the custom consent _getters_ you need to catch on `ConsentViewControllerError`
  * Since we have to conform to `WKUIDelegate`, we can't just throw an exception when something goes bad in the WebView. We introduced  `ConsentViewController#onErrorOccurred` callback for that matter. Faulty internet connection or a bad setup campaign will no longer crash your app.
* Gone for good:
* The properties `page`, `isInternalStage`, `isStage` and `msgJSON` were either removed or became private.
* The callback function `onReceiveMessageData` has been removed.

For more information make sure to check [Usage section of our README](https://github.com/SourcePointUSA/ios-cmp-app/#usage).
