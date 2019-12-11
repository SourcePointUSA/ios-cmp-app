//
//  ConsentDelegate.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 11.12.19.
//

import Foundation

@objc public protocol ConsentDelegate {
    func onMessageReady()
    func onPMReady()
    func onConsentReady()
    func onError(error: ConsentViewControllerError?)
}
