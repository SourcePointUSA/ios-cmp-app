//
//  SPDateCreated.swift
//  Pods
//
//  Created by Andre Herculano on 31.08.22.
//

import Foundation

public struct SPDateCreated: Codable, Equatable {
    static let format: SPDateFormatter = {
        if #available(iOS 11.0, *) {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [ .withFullDate, .withFullTime, .withFractionalSeconds, .withTimeZone ]
            return formatter
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            return formatter
        }
    }()

    let originalDateString: String
    let date: Date

    private init(date: Date) {
        self.date = date
        originalDateString = Self.format.string(from: date)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        originalDateString = try container.decode(String.self)
        date = Self.format.date(from: originalDateString) ?? Date()
    }

    static func now() -> SPDateCreated {
        SPDateCreated(date: Date())
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(originalDateString)
    }
}

protocol SPDateFormatter {
    func string(from date: Date) -> String
    
    func date(from string: String) -> Date?
}

extension DateFormatter: SPDateFormatter { }
extension ISO8601DateFormatter: SPDateFormatter { }
