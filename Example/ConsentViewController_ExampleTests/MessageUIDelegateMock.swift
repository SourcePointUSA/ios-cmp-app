//
//  MessageUIDelegateMock.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 11.05.23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
@testable import ConsentViewController

class MockedGenericWebMessageViewController: GenericWebMessageViewController {
    var mockIsBeingPresented = false
    override var isBeingPresented: Bool { mockIsBeingPresented }
}

class MessageUIDelegateSpy: SPMessageUIDelegate {
    var loadedCallCount: Int = 0
    var loadedWasCalled = false
    var onErrorWasCalled = false
    var actionCalledWith: SPAction?
    var onLoaded: ((UIViewController?) -> Void)?

    func loaded(_ controller: UIViewController) {
        (controller as? MockedGenericWebMessageViewController)?.mockIsBeingPresented = true
        loadedWasCalled = true
        loadedCallCount += 1
        onLoaded?(controller)
    }

    func action(_ action: ConsentViewController.SPAction, from controller: UIViewController) {
        actionCalledWith = action
    }

    func onError(_ error: ConsentViewController.SPError) {
        onErrorWasCalled = true
    }

    func finished(_ vcFinished: UIViewController) {}

    func onMessageInactivityTimeout() {}
}
