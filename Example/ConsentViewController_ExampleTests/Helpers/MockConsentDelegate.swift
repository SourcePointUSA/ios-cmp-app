//
//  MockConsentDelegate.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 16.06.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
@testable import ConsentViewController

class MockConsentDelegate: SPDelegate {
    func onAction(_ action: SPAction, from controller: SPMessageViewController) {

    }

    func onSPUIReady(_ viewController: UIViewController) {

    }

    func onSPUIFinished() {

    }

    var isConsentUIWillShowCalled = false
    var isConsentUIDidDisappearCalled = false
    var isOnErrorCalled = false
    var isOnActionCalled = false
    var isOnConsentReadyCalled = false
    var isMessageWillShowCalled = false
    var isMessageDidDisappearCalled = false
    var isGdprPMWillShowCalled = false
    var isGdprPMDidDisappearCalled = false

    var onActionCalledWith: SPAction!

    public func gdprConsentUIWillShow() {
        isConsentUIWillShowCalled = true
    }

    public func consentUIDidDisappear() {
        isConsentUIDidDisappearCalled = true
    }

    public func onError(error: SPError) {
        isOnErrorCalled = true
    }

    public func onAction(_ action: SPAction) {
        isOnActionCalled = true
        onActionCalledWith = action
    }

    public func onConsentReady(consentUUID: SPConsentUUID, userConsent: SPGDPRConsent) {
        isOnConsentReadyCalled = true
    }

    public func messageWillShow() {
        isMessageWillShowCalled = true
    }

    public func messageDidDisappear() {
        isMessageDidDisappearCalled = true
    }

    public func gdprPMWillShow() {
        isGdprPMWillShowCalled = true
    }

    public func gdprPMDidDisappear() {
        isGdprPMDidDisappearCalled = true
    }
}
