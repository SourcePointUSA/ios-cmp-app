//
//  MockPurposeProvider.swift
//  ConsentViewController_ExampleTests
//
//  Created by Claude on 27/08/2026.
//

@testable import ConsentViewController
import Didomi
import Foundation

class MockPurposeProvider: PurposeProvider {
    var purposes: [Purpose] = []

    func getPurposes() -> [Purpose] {
        purposes
    }
}
