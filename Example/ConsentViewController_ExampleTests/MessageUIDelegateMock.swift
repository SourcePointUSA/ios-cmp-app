//
//  MessageUIDelegateMock.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 11.05.23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
@testable import ConsentViewController

class MessageUIDelegate: SPMessageUIDelegate {
    var loadedWasCalled = false
    var onErrorWasCalled = false

    func loaded(_ controller: UIViewController) {
        loadedWasCalled = true
    }

    func action(_ action: ConsentViewController.SPAction, from controller: UIViewController) {}

    func onError(_ error: ConsentViewController.SPError) {
        onErrorWasCalled = true
    }

    func finished(_ vcFinished: UIViewController) {}
}
