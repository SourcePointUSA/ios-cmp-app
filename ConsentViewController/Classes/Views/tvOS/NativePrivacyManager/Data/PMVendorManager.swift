//
//  PMVendorManager.swift
//  ConsentViewController-tvOS
//
//  Created by Andre Herculano on 29.07.21.
//

import Foundation

protocol PMVendorManager: AnyObject {
    associatedtype VendorType: Hashable
    var onConsentsChange: () -> Void { get set }
    var vendors: Set<VendorType> { get }
    var acceptedVendorsIds: Set<String> { get set }

    func onVendorOn(_ vendor: GDPRVendor)
    func onVendorOff(_ vendor: GDPRVendor)
}
