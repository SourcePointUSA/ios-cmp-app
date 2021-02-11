//
//  ConsentDelegate.swift
//  GDPRConsentViewController
//
//  Created by Andre Herculano on 11.12.19.
//

import Foundation
import UIKit

@objc public protocol SPConsentUIDelegate {
    /// called when the user takes an action in the SP UI
    /// - Parameters:
    ///   - action: the user action
    @objc func onAction(_ action: SPAction)
}

@objc public protocol SPConsentDelegate {
    /// called when there's a consent Message to be shown
    @objc func onSPUIReady(_ viewController: UIViewController)

    /// called when the SP UI is finished and can be dismissed
    @objc func onSPUIFinished()

    /// called after the user takes an action and the SDK receives consent data back from the server
    /// - Parameters:
    ///  - consents: is the gdpr consent profile
    @objc(onGDPRConsentReady:) optional func onConsentReady(consents: SPGDPRConsent)

    /// called after the user takes an action and the SDK receives consent data back from the server
    /// - Parameters:
    ///  - consents: is the gdpr consent profile
    @objc(onCCPAConsentReady:) optional func onConsentReady(consents: SPCCPAConsent)

    /// called if something goes wrong during the entire lifecycle of the SDK
    @objc optional func onError(error: SPError)
}

/**
 Have a look at [SDKs Lifecycle](https://github.com/SourcePointUSA/CCPA_iOS_SDK/wiki/SDKs-Lifecycle-methods)
 */
@objc public protocol SPDelegate: SPConsentUIDelegate, SPConsentDelegate {}
