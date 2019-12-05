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
