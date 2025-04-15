//
//  SPNativeUI.swift
//  Pods
//
//  Created by Vilas on 01/04/21.
//

import Foundation
import UIKit

@objcMembers class SPNativeFont: NSObject, Codable {
    enum Keys: CodingKey {
        case fontSize, fontWeight, color, fontFamily
    }

    let fontSize: CGFloat
    let fontWeight: String
    let color: String
    let fontFamily: String

    init(fontSize: CGFloat, fontWeight: String, fontFamily: String, color: String) {
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.fontFamily = fontFamily
        self.color = color
    }

    required init(from decoder: Decoder) throws {
        let style = Constants.UI.StandartStyle()
        let container = try decoder.container(keyedBy: Keys.self)
        fontSize = try container.decodeIfPresent(CGFloat.self, forKey: .fontSize) ?? style.font.fontSize
        fontWeight = try container.decodeIfPresent(String.self, forKey: .fontWeight) ?? style.font.fontWeight
        fontFamily = try container.decodeIfPresent(String.self, forKey: .fontFamily) ?? style.font.fontFamily
        color = try container.decodeIfPresent(String.self, forKey: .color) ?? style.font.color
    }
}

@objcMembers class SPNativeStyle: NSObject, Codable {
    enum Keys: CodingKey {
        case backgroundColor, font, onFocusBackgroundColor, onUnfocusBackgroundColor,
             onFocusTextColor, onUnfocusTextColor, activeBackgroundColor, activeFont
    }

    let backgroundColor: String
    let font: SPNativeFont
    let onFocusBackgroundColor: String
    let onUnfocusBackgroundColor: String
    let onFocusTextColor: String
    let onUnfocusTextColor: String
    let activeBackgroundColor: String
    let activeFont: SPNativeFont

    override init() {
        let style = Constants.UI.StandartStyle()
        backgroundColor = style.backgroundColor
        font = style.font
        onFocusBackgroundColor = style.onFocusBackgroundColor
        onUnfocusBackgroundColor = style.onUnfocusBackgroundColor
        onFocusTextColor = style.onFocusTextColor
        onUnfocusTextColor = style.onUnfocusTextColor
        activeBackgroundColor = style.activeBackgroundColor
        activeFont = style.activeFont
    }

    required init(from decoder: Decoder) throws {
        let style = Constants.UI.StandartStyle()
        let container = try decoder.container(keyedBy: Keys.self)
        backgroundColor = try container.decodeIfPresent(String.self, forKey: .backgroundColor) ?? style.backgroundColor
        font = try container.decodeIfPresent(SPNativeFont.self, forKey: .font) ?? style.font
        onFocusBackgroundColor = try container.decodeIfPresent(String.self, forKey: .onFocusBackgroundColor) ?? style.onFocusBackgroundColor
        onUnfocusBackgroundColor = try container.decodeIfPresent(String.self, forKey: .onUnfocusBackgroundColor) ?? style.onUnfocusBackgroundColor
        onFocusTextColor = try container.decodeIfPresent(String.self, forKey: .onFocusTextColor) ?? style.onFocusTextColor
        onUnfocusTextColor = try container.decodeIfPresent(String.self, forKey: .onUnfocusTextColor) ?? style.onUnfocusTextColor
        activeBackgroundColor = try container.decodeIfPresent(String.self, forKey: .activeBackgroundColor) ?? style.activeBackgroundColor
        activeFont = try container.decodeIfPresent(SPNativeFont.self, forKey: .activeFont) ?? style.activeFont
    }
}

enum SPNativeUIType: Int, Equatable {
    case unknown, NativeView, NativeText, NativeButton, LongButton, Slider, NativeImage
}
extension SPNativeUIType: Decodable {
    public typealias RawValue = String

    public var rawValue: String {
        switch self {
        case .NativeView: return "NativeView"
        case .NativeText: return "NativeText"
        case .NativeButton: return "NativeButton"
        case .LongButton: return "LongButton"
        case .Slider: return "Slider"
        case .NativeImage: return "NativeImage"
        default: return "unknown"
        }
    }

    public init(rawValue: String) {
        switch rawValue {
        case "NativeView": self = .NativeView
        case "NativeText": self = .NativeText
        case "NativeButton": self = .NativeButton
        case "LongButton": self = .LongButton
        case "Slider": self = .Slider
        case "NativeImage": self = .NativeImage
        default: self = .unknown
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.init(rawValue: try container.decode(String.self))
    }
}

class SPNativeUISettings: NSObject, Decodable {
    enum Key: CodingKey {
        case style
    }

    let style: SPNativeStyle

    init(style: SPNativeStyle = SPNativeStyle()) {
        self.style = style
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        style = try container.decodeIfPresent(SPNativeStyle.self, forKey: .style) ?? SPNativeStyle()
    }
}

class SPNativeUISettingsText: SPNativeUISettings {
    enum Keys: CodingKey {
        case text
    }

    var text: String

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        text = try container.decode(String.self, forKey: .text)
        try super.init(from: decoder)
    }
}

class SPNativeUI: NSObject, Decodable {
    public enum CodingKeys: CodingKey {
        case id, type
    }

    let id: String
    let type: SPNativeUIType

    init(id: String, type: SPNativeUIType) {
        self.id = id
        self.type = type
    }
}

class SPNativeView: SPNativeUI {
    enum CodingKeys: String, CodingKey {
        case children, settings
    }

    var children: [SPNativeUI] = []
    let settings: SPNativeUISettings

    init() {
        settings = SPNativeUISettings()
        super.init(id: "", type: .NativeView)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        settings = try container.decode(SPNativeUISettings.self, forKey: .settings)
        var componentsContainer = try container.nestedUnkeyedContainer(forKey: .children)
        var tempComponentsContainer = componentsContainer
        while !componentsContainer.isAtEnd {
            let componentContainer = try componentsContainer.nestedContainer(keyedBy: SPNativeUI.CodingKeys.self)
            let type = try componentContainer.decode(SPNativeUIType.self, forKey: .type)
            switch type {
            case .NativeView:
                children.append(try tempComponentsContainer.decode(SPNativeView.self))

            case .NativeText:
                children.append(try tempComponentsContainer.decode(SPNativeText.self))

            case .NativeButton:
                children.append(try tempComponentsContainer.decode(SPNativeButton.self))

            case .LongButton:
                children.append(try tempComponentsContainer.decode(SPNativeLongButton.self))

            case .Slider:
                children.append(try tempComponentsContainer.decode(SPNativeSlider.self))

            case .NativeImage:
                children.append(try tempComponentsContainer.decode(SPNativeImage.self))

            default:
                children.append(try tempComponentsContainer.decode(SPNativeUI.self))
            }
        }
        try super.init(from: decoder)
    }

    func byId(_ id: String) -> SPNativeUI? {
        children.first { $0.id == id }
    }
}

class SPNativeText: SPNativeUI {
    enum CodingKeys: String, CodingKey {
        case settings
    }

    let settings: SPNativeUISettingsText

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        settings = try container.decode(SPNativeUISettingsText.self, forKey: .settings)
        try super.init(from: decoder)
    }
}

class SPNativeButton: SPNativeUI {
    enum CodingKeys: String, CodingKey {
        case settings
    }

    let settings: SPNativeUISettingsText

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        settings = try container.decode(SPNativeUISettingsText.self, forKey: .settings)
        try super.init(from: decoder)
    }
}

class SPNativeImage: SPNativeUI {
    class Settings: SPNativeUISettings {
        enum Keys: CodingKey {
            case src, url
        }

        let src: URL?

        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: Keys.self)
            src = try? container.decodeIfPresent(URL.self, forKey: .url) ?? (try? container.decodeIfPresent(URL.self, forKey: .src))
            try super.init(from: decoder)
        }
    }

    enum CodingKeys: String, CodingKey {
        case settings
    }

    let settings: Settings

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        settings = try container.decode(Settings.self, forKey: .settings)
        try super.init(from: decoder)
    }
}

class SPNativeLongButton: SPNativeUI {
    class Settings: SPNativeUISettings {
        let onText, offText, customText: String
        let text: String?

        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: Keys.self)
            onText = try container.decode(String.self, forKey: .onText)
            offText = try container.decode(String.self, forKey: .offText)
            customText = try container.decode(String.self, forKey: .customText)
            text = try? container.decodeIfPresent(String.self, forKey: .text)
            try super.init(from: decoder)
        }

        enum Keys: CodingKey {
            case onText, offText, customText, text
        }
    }

    enum CodingKeys: String, CodingKey {
        case settings
    }

    let settings: Settings

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        settings = try container.decode(Settings.self, forKey: .settings)
        try super.init(from: decoder)
    }
}

class SPNativeSlider: SPNativeUI {
    class Settings: SPNativeUISettings {
        enum Keys: CodingKey {
            case leftText, rightText
        }

        let rightText, leftText: String

        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: Keys.self)
            leftText = try container.decode(String.self, forKey: .leftText)
            rightText = try container.decode(String.self, forKey: .rightText)
            try super.init(from: decoder)
        }
    }

    enum CodingKeys: String, CodingKey {
        case settings
    }

    let settings: Settings

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        settings = try container.decode(Settings.self, forKey: .settings)
        try super.init(from: decoder)
    }
}
