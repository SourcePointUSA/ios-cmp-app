//
//  PrivacyManagerRequestresponse.swift
//  Pods
//
//  Created by Vilas on 15/04/21.
//

import Foundation

@objc public enum SPCategoryType: Int, Equatable {
    case IAB_PURPOSE, unknown
}

extension SPCategoryType: Codable {
    public typealias RawValue = String

    public var rawValue: String {
        switch self {
        case .IAB_PURPOSE: return "IAB_PURPOSE"
        default: return "unknown"
        }
    }

    public init(rawValue: String) {
        switch rawValue {
        case "IAB_PURPOSE": self = .IAB_PURPOSE
        default: self = .unknown
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.init(rawValue: try container.decode(String.self))
    }
}

@objcMembers class VendorListCategory: Codable {
    let _id, name, description: String
    let type: SPCategoryType?
}

extension VendorListCategory: Equatable {
    static func == (lhs: VendorListCategory, rhs: VendorListCategory) -> Bool {
        lhs._id == rhs._id
    }
}

@objcMembers class SPPrivacyManagerResponse: NSObject, Decodable {
    let categories: [VendorListCategory]
    let message: SPNativeView

    enum CodingKeys: String, CodingKey {
        case categories
        case message = "message_json"
    }
}
