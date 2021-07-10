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

    var isOnSPUIFinishedCalled = false
    var isOnSPUIReadyCalled = false
    var isOnErrorCalled = false
    var isOnActionCalled = false
    var isOnConsentReadyCalled = false

    var onActionCalledWith: SPAction!

    public func onError(error: SPError) {
        isOnErrorCalled = true
    }

    func onAction(_ action: SPAction, from controller: SPMessageViewController) {
        isOnActionCalled = true
    }

    func onSPUIReady(_ controller: SPMessageViewController) {
        isOnSPUIReadyCalled = true
    }

    func onSPUIFinished(_ controller: SPMessageViewController) {
        isOnSPUIFinishedCalled = true
    }

    public func onConsentReady(userData: SPUserData) {
        isOnConsentReadyCalled = true
    }
}
