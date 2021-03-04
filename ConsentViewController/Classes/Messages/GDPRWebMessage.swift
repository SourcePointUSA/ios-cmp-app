//
//  GDPRWebMessage.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 03.03.21.
//

import Foundation
import WebKit

@objcMembers class SPMessageViewController: UIViewController, SPRenderingApp {
    weak var messageUIDelegate: SPMessageUIDelegate?
    var contents: SPJson = SPJson()

    func loadMessage(_ jsonMessage: SPJson) {
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

    override func loadMessage(_ jsonMessage: SPJson) {
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

@objcMembers class GDPRWebMessageViewController: SPWebMessageViewController {
    static let MESSAGE_HANDLER_NAME = "SPJSReceiver"
    static let PM_BASE_URL = URL(string: "https://cdn.privacy-mgmt.com/privacy-manager/index.html")!

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
        userContentController.add(self, name: GDPRWebMessageViewController.MESSAGE_HANDLER_NAME)
        config.userContentController = userContentController
        return config
    }

    // swiftlint:disable force_try
    override func loadMessage(_ jsonMessage: SPJson) {
        let jsonString = String(data: try! JSONSerialization.data(withJSONObject: jsonMessage.dictionaryValue as Any, options: .fragmentsAllowed), encoding: .utf8)!
        self.contents = jsonMessage
        webview?.load(URLRequest(url: URL(string: "http://localhost:8080/?preload_message=true")!))
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            print("LOADING: ", jsonString)
            self.webview?.evaluateJavaScript("""
                window.SDK.loadMessage(\(jsonString))
            """)
        }
        messageUIDelegate?.loaded()
    }

    override func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.name, message.body)
    }
}
