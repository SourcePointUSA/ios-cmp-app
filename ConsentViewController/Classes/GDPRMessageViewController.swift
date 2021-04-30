//
//  GDPRMessageViewController.swift
//  GDPRConsentViewController
//
//  Created by Andre Herculano on 11.12.19.
//

import UIKit
import WebKit

@objc public protocol GDPRMessageUIDelegate {
    var consentDelegate: SPDelegate? { get }
    func loadMessage(fromUrl url: URL)
    func loadPrivacyManager()
}

/// The `GDPRMessageViewController` is the class responsible for rendering the consent
/// message and privacy manager.
/// - Note: at the moment we only have one child of `MessageViewController`
///  (`MessageWebViewController`) but the idea is to be able to swap the webview
///  with any other class that knows how to render a consent message and a privacy manager.
///  Eg. a native message view controller
@objcMembers open class GDPRMessageViewController: UIViewController, GDPRMessageUIDelegate {
    weak public var consentDelegate: SPDelegate?
    public func loadMessage(fromUrl url: URL) {}
    public func loadPrivacyManager() {}
}
