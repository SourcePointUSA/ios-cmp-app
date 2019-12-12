//
//  ConsentDelegate.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 11.12.19.
//

@objc public protocol ConsentDelegate {
    @objc func consentUIWillShow()
    @objc optional func messageWillShow()
    @objc optional func pmWillShow()
    @objc optional func pmDidDisappear()
    @objc optional func messageDidDisappear()
    @objc optional func onAction(_ action: Action)
    @objc func consentUIDidDisappear()
    @objc optional func onConsentReady(consents: [Consent])
    @objc optional func onError(error: ConsentViewControllerError?)
}
