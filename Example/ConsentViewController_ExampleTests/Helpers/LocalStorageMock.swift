//
//  GDPRLocalStorageMock.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 10.06.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

@testable import ConsentViewController
import Foundation

class LocalStorageMock: SPLocalStorage {
    var gdprChildPmId: String?
    var ccpaChildPmId: String?
    var userData = SPUserData()
    var localState: SPJson?
    var nonKeyedLocalState = SPJson()
    var storage: Storage = InMemoryStorageMock()
    var tcfData: [String: Any]? = [:]
    var usPrivacyString: String?
    var propertyId: Int?
    var spState: SourcepointClientCoordinator.State?

    var clearWasCalled = false

    required init(storage: Storage = InMemoryStorageMock()) {
        self.storage = storage
    }

    func clear() {
        clearWasCalled = true
        storage = InMemoryStorageMock()
    }
}
