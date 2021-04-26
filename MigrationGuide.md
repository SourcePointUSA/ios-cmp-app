# Migrating from v5 to v6
We know, we know, change means more work. But it's for a good reason (in fact, several good reasons). Just to give you an idea:

1. The SDK now supports CCPA, GDPR and the new ATT pre-prompt message. You won't need to integrate with multiple SDKs!
2. We no longer instantiate a `UIViewController` if there's no message being displayed.
3. We managed to remove one network call, down from 3 to 2. That means your users will see a message faster.

This guide is here to help you migrate your app to the latest version of our SDK.

## Starting with the initialisation:

From this:
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
To this:
```swift
lazy var consentManager: SPConsentManager = { SPConsentManager(
    accountId: 22,
    propertyName: try! SPPropertyName("mobile.multicampaign.demo"),
    campaigns: SPCampaigns(
        gdpr: SPCampaign(environment: .Public)
    ),
    delegate: self
)}()
```

* `GDPRConsentViewController` has been renamed to `SPConsentManager` and this is a good sign. We no longer instantiate a `UIViewController` unless there's a message to be displayed.
* `SPCampaigns` will accept up to 3 campaigns: `gdpr`, `ccpa`, and `ios14` (ATT pre-prompt). They are all of the type `SPCampaign` and are all optional. 
* `propertyId` is no longer required.
* `PMId` has been moved to `.loadGDPRPrivacyManager` or `.loadCCPAPrivacyManager`. See below. 

## Loading the Privacy Manager:
From:
```swift
.loadPrivacyManager()
```
To:
```swift
.loadGDPRPrivacyManager(withId: String, tab: SPPrivacyManagerTab)
// or
.loadCCPAPrivacyManager(withId: String, tab: SPPrivacyManagerTab)
```

## Delegate methods

### `gdprConsentUIWillShow()`
Changed to:
```swift
onSPUIReady(_ controller: SPMessageViewController)
```
The `onSPUIReady` might be called multiple times, one for each message returned by the scenario.

### `onAction(_ action: GDPRAction)`
Changed to:
```swift
onAction(_ action: SPAction, from controller: SPMessageViewController)
```
The `onAction` method hasn't changed much apart from having on extra parameter indicating the `ViewController` in which the user took that action. 

### `consentUIDidDisappear()`
Changed to:
```swift
onSPUIFinished(_ controller: SPMessageViewController)
```
The `onSPUIReady` might be called multiple times, one for each message that needs to be removed from View stack.

### `onConsentReady(gdprUUID: GDPRUUID, userConsent: GDPRUserConsent)`
Changed to:
```swift
onConsentReady(consents: SPUserData) {
```
* The SDK _might_ call the method `onConsentReady` multiple times (if there are multiple messages being displayed one after the other) however this is not very likely to happen since a real world scenario shouldn't return a CCPA and a GDPR message in the same user journey. 
* We have incorporated all consent data into `SPUserData`, composed of `gdpr: SPGDPRConsent?` and `ccpa: SPCCPAConsent?` attributes. Note those attributes are optional since a user might only have consents of a single legislation or even none (depending on which campaigns are set up).

### `onError(error: GDPRConsentViewControllerError)`
Changed to:
```swift
onError(error: SPError)
```
