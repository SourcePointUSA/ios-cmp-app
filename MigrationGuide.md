# Migrate to v6 (Unified SDK)
In this guide we will cover how to migrate your app to the latest version of Sourcepoint's SDK (v6). While this migration means more work for you, it also allows for multiple improvements. Below are some reasons to migrate to the latest version of our SDK:

1. Your organization no longer needs to integrate with multiple SDKs! The latest version of our SDK supports CCPA, GDPR and ATT pre-prompt message.
2. No longer instantiate a `UIViewController` if there is no message being displayed.
3. End-users will see a message faster by removing one network call (down from 3 to 2).

## Initialisation:

**Previous version**:
```swift
lazy var consentViewController: GDPRConsentViewController = { return GDPRConsentViewController(
    accountId: 22,
    propertyId: 7639,
    propertyName: try! GDPRPropertyName("tcfv2.mobile.webview"),
    PMId: "122058",
    campaignEnv: .Public,
    consentDelegate: self
)}()
```
**v6 (Unified SDK)**:
```swift
lazy var consentManager: SPConsentManager = { SPConsentManager(
    accountId: 22,
    propertyName: try! SPPropertyName("mobile.multicampaign.demo"),
    campaigns: SPCampaigns(
        gdpr: SPCampaign()
    ),
    delegate: self
)}()
```

* `GDPRConsentViewController` has been renamed to `SPConsentManager`. We no longer instantiate a `UIViewController` unless there is a message to be displayed.
* `SPCampaigns` will accept up to 3 campaigns: `gdpr`, `ccpa`, and `ios14` (ATT pre-prompt). They are all of the type `SPCampaign` and are all optional.
* `propertyId` is no longer required.
* `PMId` has been moved to `.loadGDPRPrivacyManager` or `.loadCCPAPrivacyManager`. See below.

## Load Privacy Manager:
**Previous version**:
```swift
.loadPrivacyManager()
```
**v6 (Unified SDK)**:
```swift
.loadGDPRPrivacyManager(withId: String, tab: SPPrivacyManagerTab)
// or
.loadCCPAPrivacyManager(withId: String, tab: SPPrivacyManagerTab)
```

## Delegate methods

### `gdprConsentUIWillShow()`
Changed to:
```swift
onSPUIReady(_ controller: UIViewController)
```
The `onSPUIReady` might be called multiple times, one for each message returned by the scenario.

***

### `onAction(_ action: GDPRAction)`
**v6 (Unified SDK)**:
```swift
onAction(_ action: SPAction, from controller: UIViewController)
```
The `onAction` method hasn't changed much apart from having on extra parameter indicating the `ViewController` in which the user took that action.

***

### `consentUIDidDisappear()`
**v6 (Unified SDK)**:
```swift
onSPUIFinished(_ controller: UIViewController)
```
The `onSPUIFinished` might be called multiple times, one for each message that needs to be removed from View stack.

***

### `onConsentReady(gdprUUID: GDPRUUID, userConsent: GDPRUserConsent)`
**v6 (Unified SDK)**:
```swift
onConsentReady(consents: SPUserData) {
```
* The SDK _might_ call the method `onConsentReady` multiple times (if there are multiple messages being displayed one after the other) however this is not very likely to happen since a real world scenario should not return a CCPA and a GDPR message in the same end-user journey.
* We have incorporated all consent data into `SPUserData`, composed of `gdpr: SPGDPRConsent?` and `ccpa: SPCCPAConsent?` attributes. Note those attributes are optional since an end-user might only have consent on a single legislation or even none (depending on which campaigns are set up).

***

### `onError(error: GDPRConsentViewControllerError)`
**v6 (Unified SDK)**:
```swift
onError(error: SPError)
```
