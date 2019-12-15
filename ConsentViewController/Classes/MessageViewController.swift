//
//  MessageViewController.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 11.12.19.
//

import UIKit
import WebKit

protocol MessageUIDelegate {
    func loadMessage(fromUrl url: URL)
    func loadPrivacyManager()
}

class MessageViewController: UIViewController, MessageUIDelegate {
    var consentDelegate: ConsentDelegate?
    func loadMessage(fromUrl url: URL) {}
    func loadPrivacyManager() {}
}
