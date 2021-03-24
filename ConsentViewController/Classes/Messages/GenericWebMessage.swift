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
    func loadPrivacyManager()
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

@objcMembers public class SPMessageViewController: UIViewController, SPRenderingApp {
    weak var messageUIDelegate: SPMessageUIDelegate?
    let contents: SPJson
    var campaignType: CampaignType

    init(contents: SPJson, campaignType: CampaignType, delegate: SPMessageUIDelegate?) {
        self.contents = contents
        self.campaignType = campaignType
        self.messageUIDelegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func loadMessage() {
        fatalError("not implemented")
    }

    func loadPrivacyManager(url: URL) {
        fatalError("not implemented")
    }

    func loadPrivacyManager() {
        fatalError("not implemented")
    }

    func closePrivacyManager() {
        fatalError("not implemented")
    }
}

@objcMembers class SPWebMessageViewController: SPMessageViewController, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler, UIScrollViewDelegate {
    var timeout: TimeInterval?
    var webviewConfig: WKWebViewConfiguration? { nil }

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
        var spError: SPError = WebViewError(code: nil, title: error.localizedDescription)
        if let error = error as? URLError {
            switch error.code {
            case .timedOut:
                spError = ConnectionTimeOutError(url: error.failingURL, timeout: timeout)
            case .networkConnectionLost, .notConnectedToInternet:
                spError = NoInternetConnection()
            default:
                spError = WebViewError(code: error.code.rawValue, title: error.localizedDescription)
            }
        }
        messageUIDelegate?.onError(spError)
    }
}

@objcMembers class GenericWebMessageViewController: SPWebMessageViewController {
    static let MESSAGE_HANDLER_NAME = "SPJSReceiver"
    static let PM_BASE_URL = URL(string: "https://cdn.privacy-mgmt.com/privacy-manager/index.html")!
    static let GDPR_RENDERING_APP_URL = URL(string: "https://notice.sp-prod.net/?preload_message=true")!

    override var webviewConfig: WKWebViewConfiguration? {
        let config = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        guard let path = Bundle.framework.path(forResource: Self.MESSAGE_HANDLER_NAME, ofType: "js"),
              let scriptSource = try? String(contentsOfFile: path)
        else {
            messageUIDelegate?.onError(UnableToLoadJSReceiver())
            return nil
        }
        let script = WKUserScript(source: scriptSource, injectionTime: .atDocumentStart, forMainFrameOnly: true)
        userContentController.addUserScript(script)
        userContentController.add(self, name: GenericWebMessageViewController.MESSAGE_HANDLER_NAME)
        config.userContentController = userContentController
        return config
    }

    override func loadMessage() {
        webview?.load(URLRequest(url: GenericWebMessageViewController.GDPR_RENDERING_APP_URL))
    }

    override func loadPrivacyManager() {
        loadPrivacyManager(url: GenericWebMessageViewController.PM_BASE_URL)
    }

    override func loadPrivacyManager(url: URL) {
        webview?.load(URLRequest(url: url))
    }

    override func closePrivacyManager() {
        if let canGoBack = webview?.canGoBack,
           canGoBack == true {
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
            consentLanguage: body["consentLanguage"]?.stringValue,
            pmPayload: (try? SPJson(body["payload"] as Any)) ?? SPJson(),
            pmurl: URL(string: body["pm_url"]?.stringValue ?? "")
        )
    }

    override func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if
            let messageBody = try? SPJson(message.body),
            let eventName = RenderingAppEvents(rawValue: messageBody["name"]?.stringValue ?? ""),
            let body = messageBody["body"]
        {
            print("[RenderingApp]", messageBody)
            switch eventName {
            case .readyForPreload:
                // TODO: remove the force_try
                // swiftlint:disable:next force_try
                let jsonString = String(data: try! JSONSerialization.data(withJSONObject: contents.dictionaryValue as Any, options: .fragmentsAllowed), encoding: .utf8)!
                DispatchQueue.main.async {
                    self.webview?.evaluateJavaScript("""
                        window.SDK.loadMessage("\(self.campaignType.rawValue)",\(jsonString));
                    """)
                }
            case .onMessageReady: messageUIDelegate?.loaded(self)
            case .onAction:
                if let action = getActionFrom(body: body) {
                    messageUIDelegate?.action(action, from: self)
                } else {
                    messageUIDelegate?.onError(
                        InvalidOnActionEventPayloadError(eventName.rawValue, body: body.description)
                    )
                }
            case .onError: messageUIDelegate?.onError(SPError())
            case .onPMReady: break
            case .unknown: break
            }
        } else {
            print("[RenderingApp] UnknownBody(\(message.body))")
        }
    }
}
