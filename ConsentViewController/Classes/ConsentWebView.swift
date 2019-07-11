//
//  ConsentWebView.swift
//  Pods
//
//  Created by Andre Herculano on 11.07.19.
//

import WebKit

public protocol ConsentWebViewHandler {
    func willShowMessage()
    func didGetConsentData(euconsent: String, consentUUID: String)
}

@objcMembers open class ConsentWebView: WKWebView, WKScriptMessageHandler, WKUIDelegate, WKNavigationDelegate {
    static func getJSReceiverScript() -> WKUserScript {
//        let scriptSource = try! String(contentsOfFile: Bundle(for: ConsentWebView.self).path(forResource: "JSReceiver", ofType: "js")!)
        let script = """
            (function () {
                console.log("[JSReceiver] Loading JSReceiver.js file");
                function postToWebView (name, body) {
                    window.webkit.messageHandlers.JSReceiver.postMessage({ name: name, body: body });
                }
                window.JSReceiver = {
                    onReceiveMessageData: function (messageData) {
        //                        postToWebView('onReceiveMessageData', JSON.parse(messageData));
                        postToWebView('onReceiveMessageData', { foo: 'bar' });
                    },
                    onMessageChoiceSelect: function (choiceType) {
        //                        postToWebView('onMessageChoiceSelect', { choiceType: choiceType });
                    },
                    onErrorOccurred: function (errorType) {
        //                        postToWebView('onErrorOccurred', { errorType: errorType });
                    },
                    sendConsentData: function (euconsent, consentUUID) {
                        postToWebView('onInteractionComplete', { euconsent: euconsent, consentUUID: consentUUID });
                    },
                    onPrivacyManagerChoiceSelect: function (choiceData) {
        //                        postToWebView('onPrivacyManagerChoiceSelect', { choiceData: choiceData });
                    },
                    onMessageChoiceError: function (errorObj) {
        //                        postToWebView('onMessageChoiceError', { error: errorObj.error });
                    }
                };
            })();
        """
        return WKUserScript(source: script, injectionTime: .atDocumentStart, forMainFrameOnly: false)
    }

    public var consentWebViewHandler: ConsentWebViewHandler?

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public init(frame: CGRect, consentWebViewDelegate: ConsentWebViewHandler) {
        consentWebViewHandler = consentWebViewDelegate
        super.init(frame: frame, configuration: WKWebViewConfiguration())
        uiDelegate = self
        navigationDelegate = self
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never;
        }
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        translatesAutoresizingMaskIntoConstraints = true
        isOpaque = false
        backgroundColor = .clear
        allowsBackForwardNavigationGestures = true
        configuration.preferences.javaScriptEnabled = true
        configuration.userContentController.addUserScript(ConsentWebView.getJSReceiverScript())
        configuration.userContentController.add(self, name: "JSReceiver")
    }

    private func handleMessage(withName name: String, andBody body: [String:Any?]) {
        switch name {
        case "onReceiveMessageData":
            guard
                let shouldShowMessage = body["shouldShowMessage"] as? Bool,
                let consentUUID = body["consentUUID"] as? String,
                let euconsent = body["euconsent"] as? String
                else { fallthrough }
            shouldShowMessage ?
                consentWebViewHandler?.willShowMessage() :
                consentWebViewHandler?.didGetConsentData(euconsent: euconsent, consentUUID: consentUUID)
        case "onInteractionComplete":
            guard
                let euconsent = body["euconsent"] as? String,
                let consentUUID = body["consentUUID"] as? String
            else { fallthrough }
            consentWebViewHandler?.didGetConsentData(euconsent: euconsent, consentUUID: consentUUID)
        default:
            print("ON ERROR STUB")
        }
    }

    /// :nodoc:
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard
            let messageBody = message.body as? [String: Any],
            let name = messageBody["name"] as? String,
            let body = messageBody["body"] as? [String: Any?]
        else { return }
        handleMessage(withName: name, andBody: body)
    }

    /// :nodoc:
    // handles links with "target=_blank", forcing them to open in Safari
    public func webView(_ webView: WKWebView,
                        createWebViewWith configuration: WKWebViewConfiguration,
                        for navigationAction: WKNavigationAction,
                        windowFeatures: WKWindowFeatures) -> WKWebView? {
        guard let url = navigationAction.request.url else { return nil }

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
        return nil
    }

    // https://stackoverflow.com/questions/49911060/how-to-disable-ios-11-and-ios-12-drag-drop-in-wkwebview
    private func disableDragAndDropInteraction() {
        if #available(iOS 11.0, *) {
            let webScrollView = subviews.compactMap { $0 as? UIScrollView }.first
            let contentView = webScrollView?.subviews.first(where: { $0.interactions.count > 1 })
            guard let dragInteraction = (contentView?.interactions.compactMap { $0 as? UIDragInteraction }.first) else { return }
            contentView?.removeInteraction(dragInteraction)
        }
    }

    open override func didMoveToSuperview() {
        disableDragAndDropInteraction()
    }

    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
