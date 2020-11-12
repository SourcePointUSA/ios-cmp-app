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
    let consentUUID: GDPRUUID
    var queryItems: [URLQueryItem]?
    var isSecondLayerMessage = false
    var consentUILoaded = false
    var isPMLoaded = false
    let timeout: TimeInterval
    var connectivityManager: Connectivity = ConnectivityManager()
    let messageLanguage: MessageLanguage

    init(propertyId: Int, pmId: String, consentUUID: GDPRUUID, messageLanguage: MessageLanguage, timeout: TimeInterval) {
        self.propertyId = propertyId
        self.pmId = pmId
        self.consentUUID = consentUUID
        self.messageLanguage = messageLanguage
        self.timeout = timeout
        super.init(nibName: nil, bundle: nil)
        self.queryItems = [URLQueryItem(name: "site_id", value: "\(propertyId)"), URLQueryItem(name: "consentUUID", value: consentUUID)]
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

    func getPMIdFromMessage(action: GDPRAction) {
        if let payloadData = try? JSONDecoder().decode(SPGDPRArbitraryJson.self, from: action.payload), let pm_url = payloadData["pm_url"]?.stringValue {
            if let urlComponents = URLComponents(string: pm_url)?.queryItems {
                for queryItem in urlComponents {
                    if queryItem.name == "message_id" {
                        self.pmId = queryItem.value ?? ""
                    } else if queryItem.name == "pmTab" {
                        self.queryItems?.append(URLQueryItem(name: queryItem.name, value: queryItem.value))
                    }
                }
            }
        }
    }

    func onAction(_ action: GDPRAction) {
        switch action.type {
        case .ShowPrivacyManager:
            consentDelegate?.onAction?(action)
            getPMIdFromMessage(action: action)
            showPrivacyManagerFromMessageAction()
        case .PMCancel:
            consentDelegate?.onAction?(
                GDPRAction(type: isSecondLayerMessage ? .PMCancel : .Dismiss, id: action.id, consentLanguage: action.consentLanguage, payload: action.payload)
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
        load(url: URL(string: "\(url.absoluteString)&consentLanguage=\(messageLanguage.rawValue)")!)
    }

    func pmUrl() -> URL? {
        var pmUrlComponents = URLComponents(string: "https://notice.sp-prod.net/privacy-manager/index.html")
        pmUrlComponents?.queryItems = queryItems
        return pmUrlComponents?.url
    }

    override func loadPrivacyManager() {
        self.queryItems?.append(URLQueryItem(name: "message_id", value: pmId))
        self.queryItems?.append(URLQueryItem(name: "consentLanguage", value: messageLanguage.rawValue))
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
        if let error = error as? URLError {
            switch error.code {
            case .timedOut:
                onError(error: MessageTimeout(url: error.failingURL, timeout: timeout))
            default:
                onError(error: WebViewError(code: error.code.rawValue, title: error.localizedDescription))
            }
        } else {
            onError(error: GeneralRequestError(nil, nil, error))
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
                let consentLanguage = payload["consentLanguage"] as? String ?? "",
                let typeString = payload["type"] as? Int,
                let actionPayload = payload["payload"] as? [String: Any],
                let actionJson = try? SPGDPRArbitraryJson(actionPayload),
                let payloadData = try? JSONEncoder().encode(actionJson),
                let actionType = GDPRActionType(rawValue: typeString)
            else {
                onError(error: MessageEventParsingError(message: Optional(message.body).debugDescription))
                return
            }
            onAction(GDPRAction(type: actionType, id: payload["id"] as? String, consentLanguage: consentLanguage, payload: payloadData))
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
