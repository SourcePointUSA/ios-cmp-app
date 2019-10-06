//
//  ConsentMessageDelegate.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 01.10.19.
//

import Foundation

@objc public protocol ConsentDelegate {
    func onMessageReady(controller: ConsentViewController)
    func onConsentReady(controller: ConsentViewController)
    func onErrorOccurred(error: ConsentViewControllerError)
}
