//
//  GDPRLocalStorageMock.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 10.06.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
@testable import ConsentViewController

class GDPRLocalStorageMock: GDPRLocalStorage {
    var storage: Storage = InMemoryStorageMock()
    var consentUUID: SPConsentUUID = ""
    var meta: String = "{}"
    var authId: String?
    var tcfData: [String: Any] = [:]
    var userConsents: SPGDPRConsent = SPGDPRConsent.empty()
    var consentsProfile: ConsentsProfile?

    var clearWasCalled = false

    func clear() {
        clearWasCalled = true
        storage = InMemoryStorageMock()
    }

    required init(storage: Storage = InMemoryStorageMock()) {
        self.storage = storage
    }
}
