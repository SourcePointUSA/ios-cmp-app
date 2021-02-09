//
//  GDPRMessage.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 25.01.20.
//

import Foundation

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

@objc public class MessageAttribute: NSObject, Codable {
    public let text: String
    public let style: AttributeStyle
    public let customFields: CustomFields

    public init(text: String, style: AttributeStyle, customFields: CustomFields) {
        self.text = text
        self.style = style
        self.customFields = customFields
    }
}

@objc public class MessageAction: MessageAttribute {
    public let choiceId: Int
    public let choiceType: SPActionType

    public init(text: String, style: AttributeStyle, customFields: CustomFields, choiceId: Int, choiceType: SPActionType) {
        self.choiceId = choiceId
        self.choiceType = choiceType
        super.init(text: text, style: style, customFields: customFields)
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        try self.init(
            text: container.decode(String.self, forKey: .text),
            style: container.decode(AttributeStyle.self, forKey: .style),
            customFields: container.decode(CustomFields.self, forKey: .customFields),
            choiceId: container.decode(Int.self, forKey: .choiceId),
            choiceType: container.decode(SPActionType.self, forKey: .choiceType)
        )
    }

    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)

        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(choiceId, forKey: .choiceId)
        try container.encode(choiceType, forKey: .choiceType)
    }

    enum CodingKeys: String, CodingKey {
        case text, style, customFields, choiceId, choiceType
    }
}

@objc public class GDPRMessage: NSObject, Codable {
    public let title: MessageAttribute
    public let body: MessageAttribute
    public let actions: [MessageAction]
    public let customFields: CustomFields

    public init(title: MessageAttribute, body: MessageAttribute, actions: [MessageAction], customFields: CustomFields) {
        self.title = title
        self.body = body
        self.actions = actions
        self.customFields = customFields
    }
}
