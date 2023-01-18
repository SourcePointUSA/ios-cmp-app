//
//  GDPRWebMessage.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 03.03.21.
//

import Foundation
import UIKit

@objc public protocol SPRenderingApp {
    func loadMessage()
    func loadPrivacyManager(url: URL)
    func closePrivacyManager()
}

enum RenderingAppEvents {
    case readyForPreload, onMessageReady, onPMReady, onAction, onError
    case unknown(String?)
}

extension RenderingAppEvents: Equatable {}

extension RenderingAppEvents: RawRepresentable {
    typealias StringLiteralType = String

    typealias RawValue = String

    init?(rawValue: String) {
        switch rawValue {
        case "readyForPreload": self = .readyForPreload
        case "onMessageReady": self = .onMessageReady
        case "onPMReady": self = .onPMReady
        case "onAction": self = .onAction
        case "onError": self = .onError
        case let event: self = .unknown(event)
        }
    }

    var rawValue: String {
        switch self {
        case .readyForPreload: return "readyForPreload"
        case .onMessageReady: return "onMessageReady"
        case .onPMReady: return "onPMReady"
        case .onAction: return "onAction"
        case .onError: return "onError"
        case let .unknown(event): return event ?? ""
        }
    }
}

extension RenderingAppEvents: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        self.init(rawValue: value)!
    }
}

@objc public protocol MessageController {
    func loadMessage()
    func loadPrivacyManager(url: URL)
    func closePrivacyManager()
}

@objc public protocol SPMessageView: SPRenderingApp, MessageController {
    var messageUIDelegate: SPMessageUIDelegate? { get set }
    var campaignType: SPCampaignType { get set }
    var messageId: String { get set }
    var timeout: TimeInterval { get set }
}

@objcMembers public class SPMessageViewController: UIViewController, SPMessageView {
    public weak var messageUIDelegate: SPMessageUIDelegate?
    public var campaignType: SPCampaignType
    public var messageId: String = ""
    public var timeout: TimeInterval = 10.0

    init(messageId: String, campaignType: SPCampaignType, timeout: TimeInterval, delegate: SPMessageUIDelegate?, nibName: String? = nil) {
        self.campaignType = campaignType
        self.messageUIDelegate = delegate
        self.messageId = messageId
        self.timeout = timeout
        super.init(nibName: nibName, bundle: Bundle.framework)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func loadMessage() {
        fatalError("not implemented")
    }

    public func loadPrivacyManager(url: URL) {
        fatalError("not implemented")
    }

    public func closePrivacyManager() {
        fatalError("not implemented")
    }
}
