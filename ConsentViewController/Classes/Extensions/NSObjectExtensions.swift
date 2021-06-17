//
//  NSObjectExtensions.swift
//  ConsentViewController
//
//  Created by Fedko Dmytro on 09.06.2021.
//

import Foundation

@objc extension NSObject {
    public func toJSON() -> String? {
        var result: String?
        if self is Encodable {
            if let obj = self as? SPUserData {
                result = toJSON(withEncodableObject: obj)
            } else if let obj = self as? SPGDPRConsent {
                result = toJSON(withEncodableObject: obj)
            }
        }
        return result
    }

    @nonobjc private func toJSON<T: Encodable>(withEncodableObject obj: T) -> String? {
        if let data = try? JSONEncoder().encode(obj) {
            return String(data: data, encoding: .utf8)
        } else {
            return nil
        }
    }
}
