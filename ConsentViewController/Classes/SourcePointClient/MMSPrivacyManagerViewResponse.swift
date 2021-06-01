//
//  MMSPrivacyManagerViewResponse.swift
//  Pods
//
//  Created by Andre Herculano on 31.05.21.
//

import Foundation

struct MMSPrivacyManagerViewResponse {
    class MessageSettings: SPStringifiedJSON {
        var vendorListId: String = ""

        required init(from decoder: Decoder) throws {
            try super.init(from: decoder)
            vendorListId = self[Keys.vendorListId.rawValue] as! String
        }

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

extension MMSPrivacyManagerViewResponse: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        messageJson = try SPStringifiedJSON(from: container.superDecoder(forKey: .messageJson))
        messageSettings = try MessageSettings(from: container.superDecoder(forKey: .messageSettings))
    }
}
