//
//  Consent.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 13.03.19.
//

import Foundation

public class Consent: Codable, CustomStringConvertible {
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

    public var description: String { return "Consent(id: \(id), name: \(name))" }
}

public class VendorConsent: Consent {
    public override var description: String { return "VendorConsent(id: \(id), name: \(name))" }
}

public class PurposeConsent: Consent {
    public override var description: String { return "PurposeConsent(id: \(id), name: \(name))" }
}
