//
//  GDPRLocalStorageMock.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 10.06.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
@testable import ConsentViewController

class GDPRLocalStorageMock: SPLocalStorage {
    var userData: SPUserData = SPUserData()
    var localState: SPJson = SPJson()
    var storage: Storage = InMemoryStorageMock()
    var tcfData: [String: Any]? = [:]
    var usPrivacyString: String?

    var clearWasCalled = false

    func clear() {
        clearWasCalled = true
        storage = InMemoryStorageMock()
    }

    required init(storage: Storage = InMemoryStorageMock()) {
        self.storage = storage
    }
}
