//
//  SPWebMessageViewController.swift
//  ConsentViewController-iOS
//
//  Created by Andre Herculano on 21.05.21.
//

import Foundation
import WebKit

@objcMembers class SPWebMessageViewController: SPMessageViewController, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler, UIScrollViewDelegate {
    var webviewConfig: WKWebViewConfiguration? { nil }
    let url: URL
    let contents: Data

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

    init(url: URL, messageId: String, contents: Data, campaignType: SPCampaignType, timeout: TimeInterval, delegate: SPMessageUIDelegate?) {
        self.url = url
        self.contents = contents
        super.init(messageId: messageId, campaignType: campaignType, timeout: timeout, delegate: delegate)
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

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url,
           let scheme = url.scheme?.lowercased(),
           scheme != "https",
           scheme != "http",
           UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
        }
        decisionHandler(.allow)
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

    override func viewWillDisappear(_ animated: Bool) {
        messageUIDelegate = nil
        if let contentController = webview?.configuration.userContentController {
            contentController.removeScriptMessageHandler(forName: GenericWebMessageViewController.MESSAGE_HANDLER_NAME)
            contentController.removeAllUserScripts()
        }
    }

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
        webview?.load(URLRequest(url: url, timeoutInterval: timeout))
    }

    override func loadPrivacyManager(url: URL) {
        webview?.load(URLRequest(url: url, timeoutInterval: timeout))
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
            campaignType: campaignType,
            consentLanguage: body["consentLanguage"]?.stringValue,
            pmPayload: body["payload"] ?? SPJson(),
            pmurl: URL(string: body["pm_url"]?.stringValue ?? ""),
            customActionId: body["customActionId"]?.stringValue
        )
    }

    func handleMessagePreload() {
        guard
            let jsonString = String(data: contents, encoding: .utf8) else {
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
