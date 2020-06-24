//
//  MessageWebViewController.swift
//  GDPRConsentViewController
//
//  Created by Andre Herculano on 05.12.19.
//

import UIKit
import WebKit

/**
 MessageWebViewController is responsible for loading the consent message and privacy manager through a webview.

 It not only knows how to render the message and pm but also understands how to react to their different events (showing, user action, etc)
 */
class MessageWebViewController: GDPRMessageViewController, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler, GDPRConsentDelegate {
    static let MESSAGE_HANDLER_NAME = "GDPRJSReceiver"

    lazy var webview: WKWebView? = {
        let config = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        guard let scriptSource = try? String(
            contentsOfFile: Bundle(for: GDPRConsentViewController.self).path(forResource:
                MessageWebViewController.MESSAGE_HANDLER_NAME, ofType: "js")!)
            else {
            consentDelegate?.onError?(error: UnableToLoadJSReceiver())
            return nil
        }
        let script = WKUserScript(source: scriptSource, injectionTime: .atDocumentStart, forMainFrameOnly: true)
        userContentController.addUserScript(script)
        userContentController.add(self, name: MessageWebViewController.MESSAGE_HANDLER_NAME)
        config.userContentController = userContentController
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
        wv.allowsBackForwardNavigationGestures = true
        return wv
    }()

    let propertyId: Int
    let pmId: String
    let consentUUID: GDPRUUID

    var isSecondLayerMessage = false
    var consentUILoaded = false
    var isPMLoaded = false
    let timeout: TimeInterval
    var connectivityManager: Connectivity = ConnectivityManager()

    init(propertyId: Int, pmId: String, consentUUID: GDPRUUID, timeout: TimeInterval) {
        self.propertyId = propertyId
        self.pmId = pmId
        self.consentUUID = consentUUID
        self.timeout = timeout
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = webview
    }

    func gdprConsentUIWillShow() {
        if !consentUILoaded {
            consentUILoaded = true
            consentDelegate?.gdprConsentUIWillShow?()
        }
    }

    func onMessageReady() {
        gdprConsentUIWillShow()
        consentDelegate?.messageWillShow?()
    }

    func onPMReady() {
        gdprConsentUIWillShow()
        consentDelegate?.gdprPMWillShow?()
        isPMLoaded = true
    }

    func closePrivacyManager() {
        isPMLoaded = false
        consentDelegate?.gdprPMDidDisappear?()
    }

    func closeMessage() {
        consentDelegate?.messageDidDisappear?()
    }

    func closeConsentUIIfOpen() {
        isPMLoaded ? closePrivacyManager() : closeMessage()
        if consentUILoaded { consentUIDidDisappear() }
    }

    func consentUIDidDisappear() {
        consentDelegate?.consentUIDidDisappear?()
    }

    func onError(error: GDPRConsentViewControllerError?) {
        consentDelegate?.onError?(error: error)
        closeConsentUIIfOpen()
    }

    func showPrivacyManagerFromMessageAction() {
        isSecondLayerMessage = true
        closeMessage()
        loadPrivacyManager()
    }

    func cancelPMAction() {
        isSecondLayerMessage ?
            goBackAndClosePrivacyManager() :
            closeConsentUIIfOpen()
    }

    func goBackAndClosePrivacyManager() {
        isSecondLayerMessage = false
        webview?.goBack()
        closePrivacyManager()
        onMessageReady()
    }

    func onAction(_ action: GDPRAction) {
        switch action.type {
        case .ShowPrivacyManager:
            consentDelegate?.onAction?(action)
            showPrivacyManagerFromMessageAction()
        case .PMCancel:
            consentDelegate?.onAction?(
                GDPRAction(type: isSecondLayerMessage ? .PMCancel : .Dismiss, id: action.id, payload: action.payload)
            )
            cancelPMAction()
        default:
            consentDelegate?.onAction?(action)
            closeConsentUIIfOpen()
        }
    }

    func load(url: URL) {
        if connectivityManager.isConnectedToNetwork() {
            webview?.load(URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: timeout))
        } else {
            onError(error: NoInternetConnection())
        }
    }

    override func loadMessage(fromUrl url: URL) {
        load(url: url)
    }

    func pmUrl() -> URL? {
        return URL(string: "https://notice.sp-prod.net/privacy-manager/index.html?message_id=\(pmId)&site_id=\(propertyId)&consentUUID=\(consentUUID)")
    }

    override func loadPrivacyManager() {
        guard let url = pmUrl() else {
            onError(error: URLParsingError(urlString: "PMUrl"))
            return
        }
        load(url: url)
    }

    /// :nodoc:
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

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        if let error = error as? URLError, error.code == .timedOut {
            onError(error: MessageTimeout(url: error.failingURL, timeout: timeout))
        }
    }

    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard
            let body = message.body as? [String: Any?],
            let name = body["name"] as? String
        else {
            onError(error: MessageEventParsingError(message: Optional(message.body).debugDescription))
            return
        }

        switch name {
        case "onMessageReady":
            onMessageReady()
        case "onPMReady":
            onPMReady()
        case "onAction":
            guard
                let payload = body["body"] as? [String: Any],
                let typeString = payload["type"] as? Int,
                let actionPayload = payload["payload"] as? [String: Any],
                let actionJson = try? SPGDPRArbitraryJson(actionPayload),
                let payloadData = try? JSONEncoder().encode(actionJson),
                let actionType = GDPRActionType(rawValue: typeString)
            else {
                onError(error: MessageEventParsingError(message: Optional(message.body).debugDescription))
                return
            }
            onAction(GDPRAction(type: actionType, id: payload["id"] as? String, payload: payloadData))
        case "onError":
            let payload = body["body"] as? [String: Any] ?? [:]
            let error = payload["error"] as? [String: Any] ?? [:]
            onError(error: WebViewError(
                code: error["code"] as? Int,
                title: error["title"] as? String,
                stackTrace: error["stackTrace"] as? String
            ))
        default:
            print(message.body)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        consentDelegate = nil
        if let contentController = webview?.configuration.userContentController {
            contentController.removeScriptMessageHandler(forName: MessageWebViewController.MESSAGE_HANDLER_NAME)
            contentController.removeAllUserScripts()
        }
    }
}

// we implement this protocol to disable the zoom when the user taps twice on the screen
extension MessageWebViewController: UIScrollViewDelegate {
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
}
