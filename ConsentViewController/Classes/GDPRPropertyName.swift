//
//  PropertyName.swift
//  GDPRConsentViewController
//
//  Created by Andre Herculano on 19.12.19.
//

import Foundation

/// SPPropertyName is the exact name of your property as created in SourcePoint's dashboard.
/// - Important: notice that it can only contain letters, numbers, . (dots), : (semicolons),
///  - (dashes) and / (slashes). The constructor will validate upon that and throw an error otherwise.
@objcMembers open class SPPropertyName: NSObject, Codable {
    /// Up and lowercase letters, dots, semicollons, numbers and dashes
    static let validPattern = "^[a-zA-Z.:/0-9-]*$"

    private static func validate(_ string: String) throws -> String {
        let regex = try NSRegularExpression(pattern: validPattern, options: [])
        if regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.count)).isEmpty {
            throw InvalidArgumentError(message: "PropertyName can only include letters, numbers, '.', ':', '-' and '/'. \(string) passed is invalid")
        } else {
            return string
        }
    }

    let rawValue: String
    public override var description: String {
        rawValue.replacingOccurrences(of: "https://", with: "")
    }

    /// - Parameter rawValue: the exact name of your property as created in SourcePoint's dashboard.
    /// - Throws: `InvalidArgumentError` if the property name contain anything other than letters, numbers, . (dots), : (semicolons) and / (slashes).
    public init(_ rawValue: String) throws {
        let validRawValue = try SPPropertyName.validate(rawValue)
        self.rawValue = "https://" + validRawValue
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.rawValue = try SPPropertyName.validate(try container.decode(String.self))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }

    public override func isEqual(_ object: Any?) -> Bool {
        if let other = object as? SPPropertyName {
            return other.rawValue == rawValue
        } else {
            return false
        }
    }
}
