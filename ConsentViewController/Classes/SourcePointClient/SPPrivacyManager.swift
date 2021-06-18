//
//  PMMessage.swift
//  Pods
//
//  Created by Vilas on 01/04/21.
//

import Foundation
import UIKit

@objcMembers class SPNativeFont: NSObject, Codable {
    let fontSize: CGFloat
    let fontWeight: String
    let color: String?
    let fontFamily: String
}

@objcMembers class SPNativeStyle: NSObject, Codable {
    let backgroundColor: String?
    let width: Int?
    let font: SPNativeFont?
    let onFocusBackgroundColor: String?
    let onUnfocusBackgroundColor: String?
    let onFocusTextColor: String?
    let onUnfocusTextColor: String?
    let activeBackgroundColor: String?
    let activeFont: SPNativeFont?
}

enum SPNativeUIType: Int, Equatable {
    case unknown, View, Text, Button, LongButton, Slider
}
extension SPNativeUIType: Decodable {
    public typealias RawValue = String

    public var rawValue: String {
        switch self {
        case .View: return "View"
        case .Text: return "Text"
        case .Button: return "Button"
        case .LongButton: return "LongButton"
        case .Slider: return "Slider"
        default: return "unknown"
        }
    }

    public init(rawValue: String) {
        switch rawValue {
        case "View": self = .View
        case "Text": self = .Text
        case "Button": self = .Button
        case "LongButton": self = .LongButton
        case "Slider": self = .Slider
        default: self = .unknown
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.init(rawValue: try container.decode(String.self))
    }
}

class SPNativeUI: NSObject, Decodable {
    let id: String
    let type: SPNativeUIType
    let style: SPNativeStyle?

    public enum CodingKeys: CodingKey {
        case id, type, style
    }
}

class SPNativeView: SPNativeUI {
    var components: [SPNativeUI] = []

    func byId(_ id: String) -> SPNativeUI? {
        components.first { $0.id == id }
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var componentsContainer = try container.nestedUnkeyedContainer(forKey: .components)
        var tempComponentsContainer = componentsContainer
        while !componentsContainer.isAtEnd {
            let componentContainer = try componentsContainer.nestedContainer(keyedBy: SPNativeUI.CodingKeys.self)
            let type = try componentContainer.decode(SPNativeUIType.self, forKey: .type)
            switch type {
            case .View:
                components.append(try tempComponentsContainer.decode(SPNativeView.self))
            case .Text:
                components.append(try tempComponentsContainer.decode(SPNativeText.self))
            case .Button:
                components.append(try tempComponentsContainer.decode(SPNativeButton.self))
            case .LongButton:
                components.append(try tempComponentsContainer.decode(SPNativeLongButton.self))
            case .Slider:
                components.append(try tempComponentsContainer.decode(SPNativeSlider.self))
            default:
                components.append(try tempComponentsContainer.decode(SPNativeUI.self))
            }
        }
    }

    enum CodingKeys: String, CodingKey {
        case components
    }
}

class SPNativeText: SPNativeUI {
    let text: String

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decode(String.self, forKey: .text)
        try super.init(from: decoder)
    }

    enum CodingKeys: String, CodingKey {
        case text
    }
}

class SPNativeButton: SPNativeUI {
    let text: String

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decode(String.self, forKey: .text)
        try super.init(from: decoder)
    }

    enum CodingKeys: String, CodingKey {
        case text
    }
}

class SPNativeLongButton: SPNativeUI {
    let onText, offText, onSubText, offSubText: String

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        onText = try container.decode(String.self, forKey: .onText)
        offText = try container.decode(String.self, forKey: .offText)
        onSubText = try container.decode(String.self, forKey: .onSubText)
        offSubText = try container.decode(String.self, forKey: .offSubText)
        try super.init(from: decoder)
    }

    enum CodingKeys: String, CodingKey {
        case onText, offText, onSubText, offSubText
    }
}

class SPNativeSlider: SPNativeUI {
    let offText, onText: String

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        offText = try container.decode(String.self, forKey: .offText)
        onText = try container.decode(String.self, forKey: .onText)
        try super.init(from: decoder)
    }

    enum CodingKeys: String, CodingKey {
        case offText, onText
    }
}
