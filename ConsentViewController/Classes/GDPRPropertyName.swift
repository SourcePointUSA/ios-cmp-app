//
//  PropertyName.swift
//  GDPRConsentViewController
//
//  Created by Andre Herculano on 19.12.19.
//

import Foundation

/// GDPRPropertyName is the exact name of your property as created in SourcePoint's dashboard.
/// - Important: notice that it can only contain letters, numbers, . (dots), : (semicolons) and / (slashes). The constructor will validate upon that and throw an error otherwise.
@objcMembers open class GDPRPropertyName: NSObject, Codable {
    
    /// Up and lowercase letters, dots, semicollons, numbers and dashes
    static let validPattern = "^[a-zA-Z.:/0-9-]*$"
    
    private static func validate(_ string: String) throws -> String {
        let regex = try NSRegularExpression(pattern: validPattern, options: [])
        if regex.matches(in: string, options: [], range: NSMakeRange(0, string.count)).isEmpty {
            throw InvalidArgumentError(message: "PropertyName can only include letters, numbers, '.', ':', '-' and '/'. \(string) passed is invalid")
        } else {
            return string
        }
    }
    
    let rawValue: String
    
    /// - Parameter _: the exact name of your property as created in SourcePoint's dashboard.
    /// - Throws: `InvalidArgumentError` if the property name contain anything other than letters, numbers, . (dots), : (semicolons) and / (slashes).
    public init(_ rawValue: String) throws {
        let validRawValue = try GDPRPropertyName.validate(rawValue)
        self.rawValue = "https://" + validRawValue
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.rawValue = try GDPRPropertyName.validate(try container.decode(String.self))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
}
