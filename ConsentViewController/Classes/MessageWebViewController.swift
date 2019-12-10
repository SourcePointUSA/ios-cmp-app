//
//  MessageWebViewController.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 05.12.19.
//

import UIKit
import WebKit

enum Action {
    case ShowPrivacyManager, AcceptAll, RejectAll, Dismiss
    case PMCancel, PMAction // TODO: Change PM actions according to new PM
}

let Actions: [Int: Action] = [
    11: .AcceptAll,
    12: .ShowPrivacyManager,
    13: .RejectAll,
    15: .Dismiss,
    98: .PMCancel, // TODO: Change PM actions according to new PM
    99: .PMAction
]

protocol MessageDelegate {
    func onMessageReady()
    func onConsentReady()
    func onError(error: ConsentViewControllerError?)
}

protocol MessageUIDelegate {
    func loadMessage(fromUrl url: URL?)
    func loadPrivacyManager(withId pmId: String, andPropertyId propertyId: Int)
}

class MessageWebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler, MessageUIDelegate, MessageDelegate {
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
    
    var messageDelegate: MessageDelegate? = nil
    
    var hasOpenedPMDirectly = false
    
    override func loadView() {
        view = webview
    }
    
    func onMessageReady() {
        print("onMessageReady: MessageWebView")
        messageDelegate?.onMessageReady()
    }
    
    func onConsentReady() {
        print("onConsentReady: MessageWebView")
        messageDelegate?.onConsentReady()
    }
    
    func onError(error: ConsentViewControllerError?) {
        print("onError: MessageWebView - \(error?.localizedDescription ?? "<unknown>")")
        messageDelegate?.onError(error: error)
    }
    
    func onAction(_ action: Action) {
        switch action{
        case .ShowPrivacyManager:
            // TODO: get pmId and propId from somewhere else
            loadPrivacyManager(withId: "5c0e81b7d74b3c30c6852301", andPropertyId: 2372)
        case .PMCancel:
            hasOpenedPMDirectly ?
                onConsentReady() :
                navigateBackToMessage()
        default:
            onConsentReady()
        }
    }
    
    func loadMessage(fromUrl url: URL?) {
        guard let url = url else {
            onConsentReady()
            return
        }
        print("loading: \(url)")
        webview.load(URLRequest(url: url))
    }
    
    func loadPrivacyManager(withId pmId: String, andPropertyId propertyId: Int) {
        let pmUrl = URL(string: "https://pm.sourcepoint.mgr.consensu.org/?privacy_manager_id=\(pmId)&site_id=\(propertyId)")!
        webview.load(URLRequest(url: pmUrl))
    }
    
    func navigateBackToMessage() {
        webview.goBack()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        onError(error: ConsentsAPIError())
    }
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard
            let message = message.body as? [String: Any?],
            let name = message["name"] as? String
        else {
            onError(error: ConsentsAPIError())
            return
        }
        
        switch name {
            case "onMessageReady":
                onMessageReady()
            case "onAction":
                guard
                    let payload = message["body"] as? [String: Any],
                    let actionType = payload["type"] as? Int,
                    let action = Actions[actionType]
                else {
                    onError(error: ConsentsAPIError())
                    return
                }
                onAction(action)
            case "onMessageEvent":
                print(message)
            default:
                onError(error: ConsentsAPIError())
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        messageDelegate = nil
        let contentController = webview.configuration.userContentController
        contentController.removeScriptMessageHandler(forName: MessageWebViewController.MESSAGE_HANDLER_NAME)
        contentController.removeAllUserScripts()
    }
}
