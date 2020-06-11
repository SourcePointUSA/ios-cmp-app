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
        wv.scrollView.delegate = self
        wv.uiDelegate = self
        wv.navigationDelegate = self
        wv.isOpaque = false
        wv.backgroundColor = .clear
        wv.allowsBackForwardNavigationGestures = true
        return wv
    }()
    
    let propertyId: Int
    let pmId: String
    let consentUUID: GDPRUUID
    
    var consentUILoaded = false
    var isPMLoaded = false

    var lastChoiceId: String?
    
    init(propertyId: Int, pmId: String, consentUUID: GDPRUUID) {
        self.propertyId = propertyId
        self.pmId = pmId
        self.consentUUID = consentUUID
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        webview.navigationDelegate = nil
        webview.uiDelegate = nil
        webview.scrollView.delegate = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = webview
    }
    
    func gdprConsentUIWillShow() {
        if(!consentUILoaded) {
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
        closeMessage()
        loadPrivacyManager()
    }
    
    func cancelPMAction(consents: PMConsents?) {
        webview.canGoBack ?
            goBackAndClosePrivacyManager():
            onConsentReady(gdprUUID: consentUUID, consents:consents)
    }

    private func onConsentReady(gdprUUID: GDPRUUID, consents: PMConsents?) {
        consentDelegate?.onConsentReady?(gdprUUID: gdprUUID, userConsent: GDPRUserConsent(
            acceptedVendors: consents?.vendors.accepted ?? [],
            acceptedCategories: consents?.categories.accepted ?? [],
            euconsent: (try? ConsentString(consentString: UserDefaults.standard.string(forKey: GDPRConsentViewController.EU_CONSENT_KEY) ?? "")) ?? ConsentString.empty
        ))
        closeConsentUIIfOpen()
    }
    
    func goBackAndClosePrivacyManager() {
        webview.goBack()
        closePrivacyManager()
        onMessageReady()
    }
    
    func onAction(_ action: GDPRAction, consents: PMConsents?) {
        consentDelegate?.onAction?(action, consents: consents)
        switch action.type {
            case .ShowPrivacyManager:
                showPrivacyManagerFromMessageAction()
            case .PMCancel:
                cancelPMAction(consents: consents)
            default:
                closeConsentUIIfOpen()
        }
    }
    
    func load(url: URL) {
        let connectvityManager = ConnectivityManager()
        if connectvityManager.isConnectedToNetwork() {
            webview.load(URLRequest(url: url))
        } else {
            onError(error: NoInternetConnection())
        }
    }
    
    override func loadMessage(fromUrl url: URL) {
        load(url: url)
    }
    
    func pmUrl() -> URL? {
        return URL(string: "https://gdpr-inapp-pm.sp-prod.net/?privacy_manager_id=\(pmId)&site_id=\(propertyId)&consentUUID=\(consentUUID)")
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
    
    func getPMConsentsIfAny(_ payload: [String: Any]) -> PMConsents {
        guard
            let consents = payload["consents"] as? [String: Any],
            let vendors = consents["vendors"] as? [String: Any],
            let purposes = consents["categories"] as? [String: Any],
            let acceptedVendors = vendors["accepted"] as? [String],
            let rejectedVendors = vendors["rejected"] as? [String],
            let acceptedPurposes = purposes["accepted"] as? [String],
            let rejectedPurposes = purposes["rejected"] as? [String]
        else {
            return PMConsents(
                vendors: PMConsent(accepted: [], rejected: []),
                categories: PMConsent(accepted: [], rejected: [])
            )
        }
        return PMConsents(
            vendors: PMConsent(accepted: acceptedVendors, rejected: rejectedVendors),
            categories: PMConsent(accepted: acceptedPurposes, rejected: rejectedPurposes)
        )
    }
    
    func getChoiceId (_ payload: [String: Any]) -> String? {
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

// we implement this protocol to disable the zoom when the user taps twice on the screen
extension MessageWebViewController: UIScrollViewDelegate {
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
}
