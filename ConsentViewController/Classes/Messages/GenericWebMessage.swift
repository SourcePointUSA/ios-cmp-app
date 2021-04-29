//
//  GDPRWebMessage.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 03.03.21.
//

import Foundation
import WebKit

protocol SPRenderingApp {
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

@objcMembers public class SPMessageViewController: UIViewController, SPRenderingApp, MessageController {
    weak var messageUIDelegate: SPMessageUIDelegate?
    public var campaignType: SPCampaignType
    public var messageId: Int?

    init(messageId: Int?, campaignType: SPCampaignType, delegate: SPMessageUIDelegate?) {
        self.campaignType = campaignType
        self.messageUIDelegate = delegate
        self.messageId = messageId
        super.init(nibName: nil, bundle: nil)
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

@objcMembers class SPWebMessageViewController: SPMessageViewController, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler, UIScrollViewDelegate {
    var timeout: TimeInterval?
    var webviewConfig: WKWebViewConfiguration? { nil }
    let url: URL
    let contents: SPJson

    lazy var webview: WKWebView? = {
        if let config = self.webviewConfig {
            let wv = WKWebView(frame: .zero, configuration: config)
            if #available(iOS 11.0, *) {
                wv.scrollView.contentInsetAdjustmentBehavior = .never
            }
            wv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            wv.translatesAutoresizingMaskIntoConstraints = true
            wv.uiDelegate = self
            wv.navigationDelegate = self
            wv.scrollView.delegate = self
            wv.scrollView.alwaysBounceVertical = false
            wv.scrollView.bounces = false
            wv.isOpaque = false
            wv.backgroundColor = .clear
            wv.allowsBackForwardNavigationGestures = false
            return wv
        }
        return nil
    }()

    init(url: URL, messageId: Int?, contents: SPJson, campaignType: SPCampaignType, delegate: SPMessageUIDelegate?) {
        self.url = url
        self.contents = contents
        super.init(messageId: messageId, campaignType: campaignType, delegate: delegate)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        /*
         we need to add this piece of logic because of a bug on iOS 12/13 regarding the Keyboard shifiting the view up after hiding.
         The root cause of issue is WKScrollview in WKWebview will be changed automatically content offset fit with height of keyboard in case keyboard is showed
         but it didn't reset in case keyboard is hidden.
         webkit forum issue link - https://bugs.webkit.org/show_bug.cgi?id=192564
         with iOS version 13.4 Apple fixed this issue
         */
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        view = webview
    }

    func keyboardWillHide(notification: NSNotification) {
        // move back the root view origin to zero
        if #available(iOS 12.0, *) {
            webview?.scrollView.setContentOffset(.zero, animated: true)
        }
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        fatalError("not implemented")
    }

    // handles links with "target=_blank", forcing them to open in Safari
    // swiftlint:disable:next line_length
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        guard let url = navigationAction.request.url else { return nil }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
        return nil
    }

    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        var spError: SPError = WebViewError(campaignType: campaignType, code: nil, title: error.localizedDescription)
        if let error = error as? URLError {
            switch error.code {
            case .timedOut:
                spError = ConnectionTimeOutError(url: error.failingURL, timeout: timeout, campaignType: campaignType)
            case .networkConnectionLost, .notConnectedToInternet:
                spError = NoInternetConnection(campaignType: campaignType)
            default:
                spError = WebViewError(campaignType: campaignType, code: error.code.rawValue, title: error.localizedDescription)
            }
        }
        messageUIDelegate?.onError(spError)
    }
}

@objcMembers class GenericWebMessageViewController: SPWebMessageViewController {
    static let MESSAGE_HANDLER_NAME = "SPJSReceiver"

    override var webviewConfig: WKWebViewConfiguration? {
        let config = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        guard let path = Bundle.framework.path(forResource: Self.MESSAGE_HANDLER_NAME, ofType: "js"),
              let scriptSource = try? String(contentsOfFile: path)
        else {
            messageUIDelegate?.onError(UnableToLoadJSReceiver(campaignType: campaignType))
            return nil
        }
        let script = WKUserScript(source: scriptSource, injectionTime: .atDocumentStart, forMainFrameOnly: true)
        userContentController.addUserScript(script)
        userContentController.add(self, name: GenericWebMessageViewController.MESSAGE_HANDLER_NAME)
        config.userContentController = userContentController
        return config
    }

    var isFirstLayerMessage = true

    override func loadMessage() {
        print("LOADING:", url)
        webview?.load(URLRequest(url: url))
    }

    override func loadPrivacyManager(url: URL) {
        webview?.load(URLRequest(url: url))
    }

    override func closePrivacyManager() {
        if let canGoBack = webview?.canGoBack, canGoBack == true {
            webview?.goBack()
        } else {
            messageUIDelegate?.action(SPAction(type: .Dismiss), from: self)
        }
    }

    func getActionFrom(body: SPJson) -> SPAction? {
        guard
            let type = SPActionType(rawValue: body["type"]?.intValue ?? 0)
        else { return nil }
        return SPAction(
            type: type,
            id: body["id"]?.stringValue,
            campaignType: campaignType,
            consentLanguage: body["consentLanguage"]?.stringValue,
            pmPayload: body["payload"] ?? SPJson(),
            pmurl: URL(string: body["pm_url"]?.stringValue ?? "")
        )
    }

    func handleMessagePreload() {
        guard
            let messageData = try? JSONSerialization.data(withJSONObject: contents.dictionaryValue as Any, options: .fragmentsAllowed),
            let jsonString = String(data: messageData, encoding: .utf8) else {
            messageUIDelegate?.onError(UnableToInjectMessageIntoRenderingApp(campaignType: campaignType))
            return
        }
        DispatchQueue.main.async {
            self.webview?.evaluateJavaScript("""
                window.SDK.loadMessage(\(jsonString));
            """)
        }
    }

    override func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if
            let messageBody = try? SPJson(message.body),
            let eventName = RenderingAppEvents(rawValue: messageBody["name"]?.stringValue ?? ""),
            let body = messageBody["body"]
        {
            print("[RenderingApp]", messageBody)
            switch eventName {
            case .readyForPreload: handleMessagePreload()
            case .onMessageReady: messageUIDelegate?.loaded(self)
            case .onAction:
                if let action = getActionFrom(body: body) {
                    messageUIDelegate?.action(action, from: self)
                    if action.type == .ShowPrivacyManager {
                        isFirstLayerMessage = false
                    }
                } else {
                    messageUIDelegate?.onError(
                        InvalidOnActionEventPayloadError(campaignType: campaignType, eventName.rawValue, body: body.description)
                    )
                }
            case .onError: messageUIDelegate?.onError(RenderingAppError(campaignType: campaignType, body["error"]?.stringValue ?? ""))
            case .onPMReady:
                if isFirstLayerMessage {
                    messageUIDelegate?.loaded(self)
                }
            case .unknown: break
            }
        } else {
            print("[RenderingApp] UnknownBody(\(message.body))")
        }
    }
}
