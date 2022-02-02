//
//  SPNativeMessage.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 25.01.20.
//

import Foundation

@objc public class SPNativeMessage: NSObject, Decodable, SPMessageView {
    /// Used to notify the `SPConsentManager` about its different lifecycle events.
    public weak var messageUIDelegate: SPMessageUIDelegate?

    /// Indicates the type of the campaign for this message
    /// - SeeMore: `SPCampaignType`
    public var campaignType: SPCampaignType

    /// The id of the message received from the server
    public var messageId: String = ""

    /// Unused by the native message
    public var timeout: TimeInterval = 10.0

    public func loadMessage() {
        messageUIDelegate?.loaded?(self)
    }

    /// no-op the SPNativeMessage class is not responsible for loading the Privacy Manager
    /// The will get a call to `onSPUIReady(_ controller: UIViewController)` when the PM
    /// is ready to be displayed
    public func loadPrivacyManager(url: URL) {
    }

    /// no-op the SPNativeMessage class is not responsible for loading the Privacy Manager
    /// The will get a call to `onSPUIFinished(_ controller: UIViewController)` when the PM
    /// is ready to be closed
    public func closePrivacyManager() {
    }

    public typealias CustomFields = [String: String]

    @objc public class AttributeStyle: NSObject, Codable {
        public let fontFamily: String
        public let fontSize: Int
        public let color: String
        public let backgroundColor: String

        public init(fontFamily: String, fontSize: Int, color: String, backgroundColor: String) {
            self.fontFamily = fontFamily
            self.fontSize = fontSize
            self.color = color
            self.backgroundColor = backgroundColor
        }
    }

    @objc public class Attribute: NSObject, Codable {
        public let text: String
        public let style: AttributeStyle
        public let customFields: CustomFields

        public init(text: String, style: AttributeStyle, customFields: CustomFields) {
            self.text = text
            self.style = style
            self.customFields = customFields
        }
    }

    @objc public class Action: Attribute {
        public let choiceType: SPActionType
        let url: URL?
        public var pmId: String? {
            if let url = url {
                return URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems?.first(where: {
                    $0.name == "message_id"
                })?.value
            }
            return nil
        }

        public init(text: String, style: AttributeStyle, customFields: CustomFields, choiceType: SPActionType, url: URL?) {
            self.choiceType = choiceType
            self.url = url
            super.init(text: text, style: style, customFields: customFields)
        }

        required convenience init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            try self.init(
                text: container.decode(String.self, forKey: .text),
                style: container.decode(AttributeStyle.self, forKey: .style),
                customFields: container.decode(CustomFields.self, forKey: .customFields),
                choiceType: container.decode(SPActionType.self, forKey: .choiceType),
                url: container.decodeIfPresent(URL.self, forKey: .url)
            )
        }

        public override func encode(to encoder: Encoder) throws {
            try super.encode(to: encoder)

            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(choiceType, forKey: .choiceType)
        }

        enum CodingKeys: String, CodingKey { // swiftlint:disable:this nesting
            case text, style, customFields, choiceType, url
        }
    }

    public let title: Attribute
    public let body: Attribute
    public let actions: [Action]
    public let customFields: CustomFields

    public init(title: Attribute, body: Attribute, actions: [Action], customFields: CustomFields) {
        self.title = title
        self.body = body
        self.actions = actions
        self.customFields = customFields
        campaignType = .unknown
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(Attribute.self, forKey: .title)
        body = try container.decode(Attribute.self, forKey: .body)
        actions = try container.decode([Action].self, forKey: .actions)
        customFields = try container.decode(CustomFields.self, forKey: .customFields)
        campaignType = .unknown
    }

    enum CodingKeys: String, CodingKey {
        case title, body, actions, customFields
    }
}
