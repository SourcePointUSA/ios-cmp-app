//
//  MockVendorProvider.swift
//  ConsentViewController_ExampleTests
//
//  Created by Claude on 27/08/2026.
//

@testable import ConsentViewController
import Didomi
import Foundation

class MockVendorProvider: VendorProvider {
    var vendors: [Vendor] = []

    func getVendors() -> [Vendor] {
        vendors
    }
}
