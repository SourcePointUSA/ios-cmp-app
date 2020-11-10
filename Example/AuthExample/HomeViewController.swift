//
//  HomeViewController.swift
//  AuthExample
//
//  Created by Andre Herculano on 19.06.19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import WebKit

class HomeViewController: UIViewController {

    @IBOutlet weak var webview: WKWebView!

    var authId: String?

    override func viewDidLoad() {
        let script = WKUserScript(source: """
            document.cookie="authId=\(authId!)"
        """, injectionTime: .atDocumentStart, forMainFrameOnly: true)
        webview.configuration.userContentController.addUserScript(script)
        webview.load(URLRequest(url: URL(string: "http://localhost:8080")!))
    }
}
