//
//  SPConsentable.swift
//  Pods
//
//  Created by Andre Herculano on 29.02.24.
//

import Foundation

protocol Consentable {
    var id: String { get }
    var consented: Bool { get }
}

@objcMembers public class SPConsentable: NSObject, Consentable, Codable {
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case consented
    }

    public let id: String
    public let consented: Bool

    override open var description: String {
        "SPConsentable(id: \(id), consented: \(consented))"
    }

    public init(id: String, consented: Bool) {
        self.id = id
        self.consented = consented
    }

    override public func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? SPConsentable else { return false }

        return other.id == id && other.consented == consented
    }
}
