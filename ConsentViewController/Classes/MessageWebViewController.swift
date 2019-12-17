//
//  MessageWebViewController.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 05.12.19.
//

import UIKit
import WebKit

class MessageWebViewController: MessageViewController, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler, ConsentDelegate {
    static let MESSAGE_HANDLER_NAME = "JSReceiver"

    lazy var webview: WKWebView = {
        let config = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        let scriptSource = try! String(contentsOfFile: Bundle(for: ConsentViewController.self).path(forResource: MessageWebViewController.MESSAGE_HANDLER_NAME, ofType: "js")!)
        let script = WKUserScript(source: scriptSource, injectionTime: .atDocumentStart, forMainFrameOnly: true)
        userContentController.addUserScript(script)
        userContentController.add(self, name: MessageWebViewController.MESSAGE_HANDLER_NAME)
        config.userContentController = userContentController
        let wv = WKWebView(frame: .zero, configuration: config)
        if #available(iOS 11.0, *) {
            wv.scrollView.contentInsetAdjustmentBehavior = .never;
        }
        wv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        wv.translatesAutoresizingMaskIntoConstraints = true
        wv.uiDelegate = self
        wv.navigationDelegate = self
        wv.isOpaque = false
        wv.backgroundColor = .clear
        wv.allowsBackForwardNavigationGestures = true
        return wv
    }()
    
    private let propertyId: Int
    private let pmId: String
    private let consentUUID: UUID?
    
    private var consentUILoaded = false
    
    init(propertyId: Int, pmId: String, consentUUID: UUID?) {
        self.propertyId = propertyId
        self.pmId = pmId
        self.consentUUID = consentUUID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = webview
    }
    
    func consentUIWillShow() {
        if(!consentUILoaded) {
            consentUILoaded = true
            consentDelegate?.consentUIWillShow()
        }
    }
    
    func onMessageReady() {
        consentUIWillShow()
        consentDelegate?.messageWillShow?()
    }
    
    func onPMReady() {
        consentUIWillShow()
        consentDelegate?.pmWillShow?()
    }
    
    func closeConsentUIIfOpen() {
        if(consentUILoaded) { consentUIDidDisappear() }
    }

    func consentUIDidDisappear() {
        consentDelegate?.consentUIDidDisappear()
    }
    
    func onError(error: ConsentViewControllerError?) {
        closeConsentUIIfOpen()
        consentDelegate?.onError?(error: error)
    }
    
    func showPrivacyManagerFromMessageAction() {
        consentDelegate?.messageDidDisappear?()
        loadPrivacyManager()
    }
    
    func cancelPMAction() {
        webview.canGoBack ?
            navigateBackToMessage():
            closeConsentUIIfOpen()
    }
    
    func navigateBackToMessage() {
        webview.goBack()
        consentDelegate?.pmDidDisappear?()
    }
    
    func onAction(_ action: Action) {
        consentDelegate?.onAction?(action)
        switch action {
            case .ShowPrivacyManager:
                showPrivacyManagerFromMessageAction()
            case .PMCancel:
                cancelPMAction()
            default:
                closeConsentUIIfOpen()
        }
    }
    
    private func load(url: URL) {
        if ConnectivityManager.shared.isConnectedToNetwork() {
            webview.load(URLRequest(url: url))
        } else {
            onError(error: NoInternetConnection())
        }
    }
    
    override func loadMessage(fromUrl url: URL) {
        load(url: url)
    }
    
    func pmUrl() -> URL? {
        let uuid = consentUUID?.uuidString.lowercased() ?? ""
        return URL(string: "https://pm.sourcepoint.mgr.consensu.org/?privacy_manager_id=\(pmId)&site_id=\(propertyId)&consentUUID=\(uuid)"
        )
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
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        guard let url = navigationAction.request.url else { return nil }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
        return nil
    }
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard
            let body = message.body as? [String: Any?],
            let name = body["name"] as? String
        else {
            onError(error: MessageEventParsingError(message: message.description))
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
                    let actionType = payload["type"] as? Int,
                    let action = Action(rawValue: actionType)
                else {
                    onError(error: MessageEventParsingError(message: message.description))
                    return
                }
                onAction(action)
            case "onError":
                onError(error: WebViewError())
            default:
                print(message)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        consentDelegate = nil
        let contentController = webview.configuration.userContentController
        contentController.removeScriptMessageHandler(forName: MessageWebViewController.MESSAGE_HANDLER_NAME)
        contentController.removeAllUserScripts()
    }
}
