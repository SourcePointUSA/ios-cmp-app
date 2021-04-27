//
//  MessageResponse.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 15.03.21.
//

import Foundation

protocol Defaultable: Decodable & CaseIterable & RawRepresentable
where RawValue: Decodable, AllCases: BidirectionalCollection { }
extension Defaultable {
    init(from decoder: Decoder) throws {
        self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? Self.allCases.last!
    }
}

enum MessageCategory: Int, Codable, Defaultable, Equatable {
    case gdpr = 1
    case ccpa = 2
    case ios14 = 4
    case unknown
}

enum MessageSubCategory: Int, Decodable, Defaultable, Equatable {
    case PM = 2
    case TCFv2 = 5
    case NativeInApp = 6
    case PMOTT = 7
    case NonTCF = 8
    case PMNonTCF = 9
    case ios = 10
    case CCPAOTT = 11
    case unknown
}

enum Message: Equatable {
    case native(_ message: SPJson)
    case web(_ message: SPJson)
    case unknown
}
extension Message: Decodable {
    init(from decoder: Decoder) throws {
        self = .unknown
    }

    init(type: MessageSubCategory, decoder: Decoder) throws {
        switch type {
        case .NativeInApp:
            self = .native(try SPJson.init(from: decoder))
        default:
            self = .web(try SPJson.init(from: decoder))
        }
    }
}

enum Consent: Equatable {
    case gdpr(consents: SPGDPRConsent)
    case ccpa(consents: SPCCPAConsent)
    case unknown
}
extension Consent: Codable {
    func encode(to encoder: Encoder) throws {
        switch self {
        case .ccpa(let consents): try consents.encode(to: encoder)
        case .gdpr(let consents): try consents.encode(to: encoder)
        default: break
        }
    }

    init(from decoder: Decoder) throws {
        if let consent = try? SPGDPRConsent.init(from: decoder) {
            self = .gdpr(consents: consent)
        } else if let consent = try? SPCCPAConsent.init(from: decoder) {
            self = .ccpa(consents: consent)
        } else {
            self = .unknown
        }
    }
}

struct MessageMetaData: Decodable, Equatable {
    let categoryId: MessageCategory
    let subCategoryId: MessageSubCategory
    let messageId: Int
}

struct Campaign: Equatable {
    let type: SPCampaignType
    var url: URL?
    var message: Message?
    let userConsent: Consent
    let applies: Bool?
    let messageMetaData: MessageMetaData?
}

extension Campaign: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        type = try container.decode(SPCampaignType.self, forKey: .type)
        applies = try container.decodeIfPresent(Bool.self, forKey: .applies)
        messageMetaData = try container.decodeIfPresent(MessageMetaData.self, forKey: .messageMetaData)
        userConsent = try Consent(from: try container.superDecoder(forKey: .userConsent))
        if let metaData = messageMetaData {
            message = try Message(type: metaData.subCategoryId, decoder: try container.superDecoder(forKey: .message))
            url = try container.decodeIfPresent(URL.self, forKey: .url)
        }
    }

    enum Keys: CodingKey {
        case type, message, userConsent, applies, messageMetaData, url
    }
}

struct MessagesResponse: Decodable, Equatable {
    let propertyId: Int
    let campaigns: [Campaign]
    let localState: SPJson
}
