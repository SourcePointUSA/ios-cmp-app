//
//  UserDefaultsExtensionSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 06/03/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

@testable import ConsentViewController
import Nimble
import Quick

class CodableMock: Codable, Equatable {
    let attribute: Int
    init(_ attr: Int) {
        attribute = attr
    }
    static func == (lhs: CodableMock, rhs: CodableMock) -> Bool {
        lhs.attribute == rhs.attribute
    }
}

class UserDefaultsExtension: QuickSpec {
    override func spec() {
        describe("UserDefaults") {
            it("can store and retrieve Codable objects") {
                let original = CodableMock(42)
                UserDefaults.standard.setObject(original, forKey: "a_codable")
                let stored = UserDefaults.standard.object(ofType: CodableMock.self, forKey: "a_codable")
                expect(stored) == original
            }
        }
    }
}
