//
//  MMSPrivacyManagerViewResponse.swift
//  Pods
//
//  Created by Andre Herculano on 31.05.21.
//

import Foundation

struct MMSMessageResponse {
    class MessageSettings: SPStringifiedJSON {
        var vendorListId: String = ""

        required init(from decoder: Decoder) throws {
            try super.init(from: decoder)
            guard let vListId = self[Keys.vendorListId.rawValue] as? String else {
                throw DecodingError.dataCorruptedError(in: try decoder.unkeyedContainer(), debugDescription: "Could not parse/find vendorListId in MMS response")
            }
            vendorListId = vListId
        }

        // swiftlint:disable:next nesting
        enum Keys: String, CodingKey {
            case vendorListId = "vendorList"
        }
    }

    let messageJson: SPStringifiedJSON
    let messageSettings: MessageSettings

    enum Keys: String, CodingKey {
        case messageJson = "message_json"
        case messageSettings = "message_settings"
    }
}

extension MMSMessageResponse: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        messageJson = try SPStringifiedJSON(from: container.superDecoder(forKey: .messageJson))
        messageSettings = try MessageSettings(from: container.superDecoder(forKey: .messageSettings))
    }
}
