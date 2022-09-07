//
//  SPDateCreated.swift
//  Pods
//
//  Created by Andre Herculano on 31.08.22.
//

import Foundation

struct SPDateCreated: Codable, Equatable {
    static let format: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return formatter
    }()

    let originalDateString: String
    let date: Date

    static func now() -> SPDateCreated {
        SPDateCreated(date: Date())
    }

    private init(date: Date) {
        self.date = date
        originalDateString = SPDateCreated.format.string(from: date)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        originalDateString = try container.decode(String.self)
        date = SPDateCreated.format.date(from: originalDateString)!
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(originalDateString)
    }
}
