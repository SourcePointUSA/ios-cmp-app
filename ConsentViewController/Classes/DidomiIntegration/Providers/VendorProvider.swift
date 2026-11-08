//
//  VendorProvider.swift
//  ConsentViewController
//
//  Created by Claude on 27/08/2026.
//

import Didomi
import Foundation

protocol VendorProvider {
    func getVendors() -> [Vendor]
}

struct DidomiVendorProvider: VendorProvider {
    func getVendors() -> [Vendor] {
        Didomi.shared.getRequiredVendors()
    }
}
