//
//  GDPRMessageUiDelegateMock.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 17.06.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
@testable import ConsentViewController

class GDPRUIDelegateMock: GDPRMessageUIDelegate {
    weak var consentDelegate: SPDelegate?
    var loadMessageCalled = false
    var loadPrivacyManagerCalled = false
    var loadMessageCalledWith: URL?

    init(_ consentDelegate: SPDelegate) {
        self.consentDelegate = consentDelegate
    }

    func loadMessage(fromUrl url: URL) {
        loadMessageCalled = true
        loadMessageCalledWith = url
    }

    func loadPrivacyManager() {
        loadPrivacyManagerCalled = true
    }
}
