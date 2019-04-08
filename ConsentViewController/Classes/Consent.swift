//
//  Consent.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 13.03.19.
//

import Foundation

/// Consent class represents a custom consent with id and name
@objcMembers open class Consent: NSObject, Codable {
    public let id: String
    public let name: String

    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }

    enum CodingKeys : String, CodingKey {
        case id = "_id"
        case name
    }
    open override var description: String { return "Consent(id: \(id), name: \(name))" }
}

@objcMembers open class VendorConsent: Consent {
    open override var description: String { return "VendorConsent(id: \(id), name: \(name))" }
}

@objcMembers open class PurposeConsent: Consent {
    open override var description: String { return "PurposeConsent(id: \(id), name: \(name))" }
}
