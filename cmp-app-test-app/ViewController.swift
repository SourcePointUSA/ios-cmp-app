//
//  ViewController.swift
//  cmp-app-test-app
//
//  Created by Dmitri Rabinowitz on 8/13/18.
//  Copyright © 2018 Sourcepoint. All rights reserved.
//

import UIKit
class ViewController: UIViewController {
    var consentWebView: ConsentWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("creating consent web view controller")
        consentWebView = ConsentWebView()
        print("adding consent web view as subview")
        view.addSubview(consentWebView.view)
    }
}

