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
    @objc func onAction(_ action: SPAction, from controller: UIViewController)
}

@objc public protocol SPConsentDelegate {
    /// called when there's a consent Message to be shown
    @objc func onSPUIReady(_ controller: UIViewController)

    /// called when the native message object is received and ready to be used
    @objc optional func onSPNativeMessageReady(_ message: SPNativeMessage)

    /// called when the SP UI is finished and can be dismissed
    @objc func onSPUIFinished(_ controller: UIViewController)

    /// called after the user takes an action and the SDK receives consent data back from the server
    /// - Parameters:
    ///  - consents: is the consent profile
    @objc optional func onConsentReady(userData: SPUserData)

    /// called if something goes wrong during the entire lifecycle of the SDK
    @objc optional func onError(error: SPError)
}

/**
 Have a look at [SDKs Lifecycle](https://github.com/SourcePointUSA/CCPA_iOS_SDK/wiki/SDKs-Lifecycle-methods)
 */
@objc public protocol SPDelegate: SPConsentUIDelegate, SPConsentDelegate {}
