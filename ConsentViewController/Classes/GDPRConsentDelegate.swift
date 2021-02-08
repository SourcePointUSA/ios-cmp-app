//
//  ConsentDelegate.swift
//  GDPRConsentViewController
//
//  Created by Andre Herculano on 11.12.19.
//

import Foundation

/**
 ConsentDelegate encapsulates all SDKs lifecycle methods.
 
 Have a look at [SDKs Lifecycle](https://github.com/SourcePointUSA/CCPA_iOS_SDK/wiki/SDKs-Lifecycle-methods)
*/
@objc public protocol GDPRConsentDelegate {
    /// called when there's a consent Message to be shown or before the PM is shown ***deprecated***
    @objc optional func consentUIWillShow()

    /// called when there's a consent Message to be shown or before the PM is shown
    @objc optional func gdprConsentUIWillShow()

    /// called when there's a consent Message to be shown or before the PM is shown
    @objc optional func consentUIWillShow(message: GDPRMessage)

    /// called when the consent message is about to show
    @objc optional func messageWillShow()

    /// called when the privacy manager is about to show
    @objc optional func gdprPMWillShow()

    /// called when the privacy manager is closed
    @objc optional func gdprPMDidDisappear()

    /// called when the consent message is closed
    @objc optional func messageDidDisappear()

    /// called when the user takes an action in the consent ui (message/PM)
    /// - Parameters:
    ///   - action: the user action
    @objc optional func onAction(_ action: GDPRAction)

    /// called when the consent ui is closed
    @objc optional func consentUIDidDisappear()

    /// called when we finish getting the consent profile from SourcePoint's endpoints
    /// - Parameters:
    ///  - consentUUID: is the uuid we give to that user internally. Notice this is not the same as authId
    ///  - userConsent: is the data structure encapsulating the consent status, rejected vendors and purposes
    @objc optional func onConsentReady(consentUUID: SPConsentUUID, userConsent: SPGDPRUserConsent)

    /// the `onError` function can be called at any moment during the SDKs lifecycle
    @objc optional func onError(error: GDPRConsentViewControllerError)
}
