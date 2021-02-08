//
//  GDPRUserDefaultsSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 06/03/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import ConsentViewController

class CodableMock: Codable, Equatable {
    static func == (lhs: CodableMock, rhs: CodableMock) -> Bool {
        return lhs.attribute == rhs.attribute
    }
    let attribute: Int
    init(_ attr: Int) {
        attribute = attr
    }
}

class GDPRLocalStorageSpec: QuickSpec {
    override func spec() {
        describe("UserDefaults") {
            it("can store and retrieve Codable objects") {
                let original = CodableMock(42)
                UserDefaults.standard.setObject(original, forKey: "a_codable")
                let stored = UserDefaults.standard.object(ofType: CodableMock.self, forKey: "a_codable")
                expect(stored).to(equal(original))
            }
        }
    }
}
