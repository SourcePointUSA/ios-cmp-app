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
        // swiftlint:disable:next force_unwrapping
        self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? Self.allCases.last!
    }
}

public typealias SPWebConsentPayload = String

enum MessageCategory: Int, Codable, Defaultable, Equatable {
    case gdpr = 1
    case ccpa = 2
    case ios14 = 4
    case unknown

    var campaignType: SPCampaignType {
        switch self {
        case .gdpr:
            return .gdpr

        case .ccpa:
            return .ccpa

        case .ios14:
            return .ios14

        default:
            return .unknown
        }
    }
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
    case NativePMOTT = 14
    case unknown
}

struct Message: Codable, Equatable {
    enum CodingKeys: String, CodingKey {
        case categories, language
        case messageJson = "message_json"
        case messageChoices = "message_choice"
        case propertyId = "site_id"
    }

    var messageJson: MessageJson
    let categories: [GDPRCategory]?
    let messageChoices: SPJson
    let propertyId: Int
    let language: String?
    var category: MessageCategory = .unknown
    var subCategory: MessageSubCategory = .unknown

    init(category: MessageCategory, subCategory: MessageSubCategory, decoder: Decoder) throws {
        try self.init(from: decoder)
        self.category = category
        self.subCategory = subCategory
        let container = try decoder.container(keyedBy: CodingKeys.self)
        messageJson = try MessageJson(type: subCategory, campaignType: category.campaignType, decoder: try container.superDecoder(forKey: .messageJson))
    }
}

enum MessageJson: Equatable {
    case nativePM(_ message: PrivacyManagerViewData)
    case native(_ message: SPNativeMessage)
    case web(_ message: SPJson)
    case unknown
}

extension MessageJson: Codable {
    enum CodingKeys: String, CodingKey {
        case message_json_string
    }

    init(from decoder: Decoder) throws {
        self = .unknown
    }

    init(type: MessageSubCategory, campaignType: SPCampaignType, decoder: Decoder) throws {
        switch type {
            case .NativePMOTT:
                self = .nativePM(try PrivacyManagerViewData(from: try MessageJson.messageFromStringified(decoder)))

            case .NativeInApp:
                let nativeMessage: SPNativeMessage = try MessageJson.messageFromStringified(decoder)
                nativeMessage.campaignType = campaignType
                self = .native(nativeMessage)

            default:
                self = .web(try SPJson(from: decoder))
        }
    }

    static func messageFromStringified<T: Decodable>(_ decoder: Decoder) throws -> T {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let stringifiedMessage = try container.decode(String.self, forKey: .message_json_string)
        // swiftlint:disable:next force_unwrapping
        return try JSONDecoder().decode(T.self, from: stringifiedMessage.data(using: .utf8)!)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
            case .web(let message):
                try container.encode(message)

            default:
                try container.encodeNil()
        }
    }
}

enum Consent: Equatable {
    case gdpr(consents: SPGDPRConsent)
    case ccpa(consents: SPCCPAConsent)
    case unknown
}
extension Consent: Codable {
    init(from decoder: Decoder) throws {
        if let consent = try? SPGDPRConsent(from: decoder) {
            self = .gdpr(consents: consent)
        } else if let consent = try? SPCCPAConsent(from: decoder) {
            self = .ccpa(consents: consent)
        } else {
            self = .unknown
        }
    }

    func encode(to encoder: Encoder) throws {
        switch self {
        case .ccpa(let consents): try consents.encode(to: encoder)
        case .gdpr(let consents): try consents.encode(to: encoder)
        default: break
        }
    }
}

struct MessageMetaData: Equatable {
    let categoryId: MessageCategory
    let subCategoryId: MessageSubCategory
    let messageId: String
    let messagePartitionUUID: String?
}

extension MessageMetaData: Decodable {
    enum CodingKeys: String, CodingKey {
        case categoryId, subCategoryId, messageId
        case messagePartitionUUID = "prtnUUID"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        categoryId = try container.decode(MessageCategory.self, forKey: .categoryId)
        subCategoryId = try container.decode(MessageSubCategory.self, forKey: .subCategoryId)
        messageId = String(try container.decode(Int.self, forKey: .messageId))
        messagePartitionUUID = try container.decodeIfPresent(String.self, forKey: .messagePartitionUUID)
    }
}

struct Campaign: Equatable {
    let type: SPCampaignType
    var url: URL?
    var message: Message?
    let userConsent: Consent
    let messageMetaData: MessageMetaData?
    let consentStatus: ConsentStatus?
    let dateCreated: SPDateCreated?
}

extension Campaign: Decodable {
    enum Keys: CodingKey {
        case type, message, messageMetaData, url, consentStatus, dateCreated
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        type = try container.decode(SPCampaignType.self, forKey: .type)
        messageMetaData = try container.decodeIfPresent(MessageMetaData.self, forKey: .messageMetaData)
        userConsent = try Consent(from: decoder)
        consentStatus = try? container.decodeIfPresent(ConsentStatus.self, forKey: .consentStatus) ?? ConsentStatus(from: decoder)
        dateCreated = try container.decodeIfPresent(SPDateCreated.self, forKey: .dateCreated)
        if let metaData = messageMetaData {
            message = try Message(category: metaData.categoryId, subCategory: metaData.subCategoryId, decoder: try container.superDecoder(forKey: .message))
            url = try container.decodeIfPresent(URL.self, forKey: .url)
        }
    }
}

struct MessagesResponse: Decodable, Equatable {
    let propertyId: Int
    let campaigns: [Campaign]
    let localState: SPJson
    let nonKeyedLocalState: SPJson
}

struct MessageResponse: Equatable {
    let message: Message
    let messageMetaData: MessageMetaData
}

extension MessageResponse: Decodable {
    enum Keys: CodingKey {
        case message, messageMetaData
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        messageMetaData = try container.decode(MessageMetaData.self, forKey: .messageMetaData)
        message = try Message(
            category: messageMetaData.categoryId,
            subCategory: messageMetaData.subCategoryId,
            decoder: try container.superDecoder(forKey: .message)
        )
    }
}

// MARK: - used for Unit Tests
extension MessagesResponse {
    init(propertyId: Int, localState: SPJson, campaigns: [Campaign], nonKeyedLocalState: SPJson) {
        self.propertyId = propertyId
        self.localState = localState
        self.campaigns = campaigns
        self.nonKeyedLocalState = nonKeyedLocalState
    }
}

extension Message {
    init(propertyId: Int, language: String?, category: MessageCategory, subCategory: MessageSubCategory,
         messageChoices: SPJson, webMessageJson: SPJson, categories: [GDPRCategory]?) throws {
        self.propertyId = propertyId
        self.messageChoices = messageChoices
        self.category = category
        self.subCategory = subCategory
        self.messageJson = .web(webMessageJson)
        self.language = language
        self.categories = categories
    }
}
