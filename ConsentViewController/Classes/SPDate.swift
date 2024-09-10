//
//  SPDate.swift
//  Pods
//
//  Created by Andre Herculano on 31.08.22.
//

import Foundation

public struct SPDate: Codable, Equatable {
    static let format: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    let originalDateString: String
    let date: Date

    init(date: Date) {
        self.date = date
        originalDateString = Self.format.string(from: date)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        originalDateString = try container.decode(String.self)
        date = Self.format.date(from: originalDateString) ?? Date() // TODO: potentially throw an error here...
    }

    static func now() -> SPDate {
        SPDate(date: Date())
    }

    static func distantFuture() -> SPDate {
        SPDate(date: .distantFuture)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(originalDateString)
    }
}
