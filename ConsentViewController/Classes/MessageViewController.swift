//
//  MessageViewController.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 11.12.19.
//

import UIKit
import WebKit

@objc public protocol MessageUIDelegate {
    func loadMessage(fromUrl url: URL)
    func loadPrivacyManager()
}

/// The `MessageViewController` is the class responsible for rendering the consent message and privacy manager.
/// - Note: at the moment we only have one child of `MessageViewController` (`MessageWebViewController`) but the idea is to be able to swap the webview with any other class that knows how to render a consent message and a privacy manager. Eg. a native message view controller
@objcMembers open class MessageViewController: UIViewController, MessageUIDelegate {
    var consentDelegate: ConsentDelegate?
    public func loadMessage(fromUrl url: URL) {}
    public func loadPrivacyManager() {}
}
