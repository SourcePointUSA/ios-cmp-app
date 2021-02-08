//
//  MockConsentDelegate.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 16.06.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
@testable import ConsentViewController

class MockConsentDelegate: GDPRConsentDelegate {
    var isConsentUIWillShowCalled = false
    var isConsentUIDidDisappearCalled = false
    var isOnErrorCalled = false
    var isOnActionCalled = false
    var isOnConsentReadyCalled = false
    var isMessageWillShowCalled = false
    var isMessageDidDisappearCalled = false
    var isGdprPMWillShowCalled = false
    var isGdprPMDidDisappearCalled = false

    var onActionCalledWith: GDPRAction!

    public func gdprConsentUIWillShow() {
        isConsentUIWillShowCalled = true
    }

    public func consentUIDidDisappear() {
        isConsentUIDidDisappearCalled = true
    }

    public func onError(error: GDPRConsentViewControllerError) {
        isOnErrorCalled = true
    }

    public func onAction(_ action: GDPRAction) {
        isOnActionCalled = true
        onActionCalledWith = action
    }

    public func onConsentReady(consentUUID: SPConsentUUID, userConsent: SPGDPRUserConsent) {
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
