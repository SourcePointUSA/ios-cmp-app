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
    static let MESSAGE_HANDLER_NAME = "SPJSReceiver"
    static let PM_BASE_URL = URL(string: "https://cdn.privacy-mgmt.com/privacy-manager/index.html")!

    lazy var webview: WKWebView? = {
        let config = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        guard let path = Bundle.framework.path(forResource: Self.MESSAGE_HANDLER_NAME, ofType: "js"),
              let scriptSource = try? String(contentsOfFile: path)
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
        wv.allowsBackForwardNavigationGestures = false
        return wv
    }()

    let propertyId: Int
    var pmId: String
    var pmTab: PrivacyManagerTab
    let consentUUID: SPConsentUUID
    var isSecondLayerMessage = false
    var consentUILoaded = false
    var isPMLoaded = false
    let timeout: TimeInterval
    var connectivityManager: Connectivity = ConnectivityManager()
    let messageLanguage: MessageLanguage

    init(propertyId: Int, pmId: String, consentUUID: SPConsentUUID, messageLanguage: MessageLanguage, pmTab: PrivacyManagerTab, timeout: TimeInterval) {
        self.propertyId = propertyId
        self.pmId = pmId
        self.consentUUID = consentUUID
        self.messageLanguage = messageLanguage
        self.pmTab = pmTab
        self.timeout = timeout
        super.init(nibName: nil, bundle: nil)
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

    func onError(error: GDPRConsentViewControllerError) {
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

    func updatePMParamsFromAction(_ action: SPAction) {
        if let payloadData = try? JSONDecoder().decode(SPJson.self, from: action.payload).get(),
           let pm_url = payloadData["pm_url"]?.stringValue,
           let urlComponents = URLComponents(string: pm_url)?.queryItems {
            pmId = urlComponents.first { $0.name == "message_id" }?.value ?? pmId
            pmTab = PrivacyManagerTab.init(rawValue: urlComponents.first { $0.name == "pmTab" }?.value ?? pmTab.rawValue) ?? .Default
        }
    }

    func onAction(_ action: SPAction) {
        switch action.type {
        case .ShowPrivacyManager:
            consentDelegate?.onAction?(action)
            updatePMParamsFromAction(action)
            showPrivacyManagerFromMessageAction()
        case .PMCancel:
            consentDelegate?.onAction?(
                SPAction(type: isSecondLayerMessage ? .PMCancel : .Dismiss, id: action.id, consentLanguage: action.consentLanguage, payload: action.payload)
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
        guard let messageUrl = url.appendQueryItem([
            "consentLanguage": messageLanguage.rawValue,
            "consentUUID": consentUUID
        ]) else {
            onError(error: InvalidURLError(urlString: url.absoluteString))
            return
        }
        load(url: messageUrl)
    }

    func pmQueryParams() -> [URLQueryItem] {
        return [
            URLQueryItem(name: "site_id", value: String(propertyId)),
            URLQueryItem(name: "consentUUID", value: consentUUID),
            URLQueryItem(name: "message_id", value: pmId),
            URLQueryItem(name: "pmTab", value: pmTab.rawValue)
        ]
    }

    func pmUrl() -> URL? {
        var urlComponents = URLComponents(url: MessageWebViewController.PM_BASE_URL, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = pmQueryParams()
        return urlComponents?.url
    }

    override func loadPrivacyManager() {
        guard let url = pmUrl() else {
            let queryString = pmQueryParams().reduce("?") { $0 + "\($1.name)=\($1.value ?? "")&" }
            let error = InvalidURLError(urlString: MessageWebViewController.PM_BASE_URL.absoluteString + queryString)
            onError(error: error)
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
        var spError: GDPRConsentViewControllerError = WebViewError(code: nil, title: error.localizedDescription)
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
        onError(error: spError)
    }

    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard
            let body = message.body as? [String: Any?],
            let name = body["name"] as? String
        else {
            let eventBody = message.body as? [String: Any?]
            let eventName = eventBody?["name"] as? String
            onError(error: InvalidEventPayloadError(eventName, body: eventBody?.debugDescription))
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
                let consentLanguage = payload["consentLanguage"] as? String?,
                let typeString = payload["type"] as? Int,
                let actionPayload = payload["payload"] as? [String: Any],
                let actionJson = try? SPJson(actionPayload),
                let payloadData = try? JSONEncoder().encode(actionJson).get(),
                let actionType = SPActionType(rawValue: typeString)
            else {
                onError(error: InvalidOnActionEventPayloadError(name, body: body["body"]?.debugDescription))
                return
            }
            onAction(SPAction(type: actionType, id: payload["id"] as? String, consentLanguage: consentLanguage, payload: payloadData))
        case "onError":
            let payload = body["body"] as? [String: Any] ?? [:]
            let error = payload["error"] as? [String: Any] ?? [:]
            onError(error: RenderingAppError(error["code"] as? String))
        default:
            /// TODO: This should not trigger the `onError` but we should notifiy our custom metrics endpoint
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
