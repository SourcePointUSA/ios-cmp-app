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

    lazy var webview: WKWebView = {
        let config = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        let scriptSource = try! String(contentsOfFile: Bundle(for: GDPRConsentViewController.self).path(forResource: MessageWebViewController.MESSAGE_HANDLER_NAME, ofType: "js")!)
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
    private let consentUUID: GDPRUUID
    
    private var consentUILoaded = false
    private var lastChoiceId: String?
    
    init(propertyId: Int, pmId: String, consentUUID: GDPRUUID) {
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
            consentDelegate?.consentUIWillShow?() //**deprecated**
            consentDelegate?.gdprConsentUIWillShow?()
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
        consentDelegate?.consentUIDidDisappear?()
    }
    
    func onError(error: GDPRConsentViewControllerError?) {
        consentDelegate?.onError?(error: error)
        closeConsentUIIfOpen()
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
    
    func onAction(_ action: GDPRAction, consents: PMConsents?) {
        consentDelegate?.onAction?(action, consents: consents)
        switch action.type {
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
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        guard let url = navigationAction.request.url else { return nil }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
        return nil
    }
    
    private func getPMConsentsIfAny(_ payload: [String: Any]) -> PMConsents {
        guard
            let consents = payload["consents"] as? [String: Any],
            let vendors = consents["vendors"] as? [String: Any],
            let purposes = consents["categories"] as? [String: Any],
            let acceptedVendors = vendors["accepted"] as? [String],
            let acceptedPurposes = purposes["accepted"] as? [String]
        else {
            return PMConsents(
                vendors: PMConsent(accepted: []),
                categories: PMConsent(accepted: [])
            )
        }
        return PMConsents(
            vendors: PMConsent(accepted: acceptedVendors),
            categories: PMConsent(accepted: acceptedPurposes)
        )
    }
    
    private func getChoiceId (_ payload: [String: Any]) -> String? {
        // Actions coming from the PM do not have a choiceId.
        // since we store the last non-null choiceId, the lastChoiceId
        // will be either the choiceId of "Show Options" action when coming from the message
        // or null if coming from the PM opened directly
        lastChoiceId = payload["id"] as? String? ?? lastChoiceId
        return lastChoiceId
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
                    let actionTypeRaw = payload["type"] as? Int,
                    let actionType = GDPRActionType(rawValue: actionTypeRaw)
                else {
                    onError(error: MessageEventParsingError(message: Optional(message.body).debugDescription))
                    return
                }
                onAction(GDPRAction(type: actionType, id: getChoiceId(payload)), consents: getPMConsentsIfAny(payload))
            case "onError":
                onError(error: WebViewError())
            default:
                print(message.body)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        consentDelegate = nil
        let contentController = webview.configuration.userContentController
        contentController.removeScriptMessageHandler(forName: MessageWebViewController.MESSAGE_HANDLER_NAME)
        contentController.removeAllUserScripts()
    }
}
