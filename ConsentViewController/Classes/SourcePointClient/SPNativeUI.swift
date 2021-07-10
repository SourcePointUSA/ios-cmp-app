//
//  SPNativeUI.swift
//  Pods
//
//  Created by Vilas on 01/04/21.
//

import Foundation
import UIKit

// swiftlint:disable nesting

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
    case unknown, NativeView, NativeText, NativeButton, LongButton, Slider
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
        default: self = .unknown
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.init(rawValue: try container.decode(String.self))
    }
}

class SPNativeUISettings: NSObject, Decodable {
    let style: SPNativeStyle?
}

class SPNativeUISettingsText: SPNativeUISettings {
    let text: String

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        text = try container.decode(String.self, forKey: .text)
        try super.init(from: decoder)
    }

    enum Keys: CodingKey {
        case text
    }
}

class SPNativeUI: NSObject, Decodable {
    let id: String
    let type: SPNativeUIType

    public enum CodingKeys: CodingKey {
        case id, type
    }
}

class SPNativeView: SPNativeUI {
    var children: [SPNativeUI] = []
    let settings: SPNativeUISettings

    func byId(_ id: String) -> SPNativeUI? {
        children.first { $0.id == id }
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
            default:
                children.append(try tempComponentsContainer.decode(SPNativeUI.self))
            }
        }
        try super.init(from: decoder)
    }

    enum CodingKeys: String, CodingKey {
        case children, settings
    }
}

class SPNativeText: SPNativeUI {
    let settings: SPNativeUISettingsText

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        settings = try container.decode(SPNativeUISettingsText.self, forKey: .settings)
        try super.init(from: decoder)
    }

    enum CodingKeys: String, CodingKey {
        case settings
    }
}

class SPNativeButton: SPNativeUI {
    let settings: SPNativeUISettingsText

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        settings = try container.decode(SPNativeUISettingsText.self, forKey: .settings)
        try super.init(from: decoder)
    }

    enum CodingKeys: String, CodingKey {
        case settings
    }
}

class SPNativeLongButton: SPNativeUI {
    class Settings: SPNativeUISettings {
        let onText, offText, onSubText, offSubText: String

        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: Keys.self)
            onText = try container.decode(String.self, forKey: .onText)
            offText = try container.decode(String.self, forKey: .offText)
            onSubText = try container.decode(String.self, forKey: .onSubText)
            offSubText = try container.decode(String.self, forKey: .offSubText)
            try super.init(from: decoder)
        }

        enum Keys: CodingKey {
            case onText, offText, onSubText, offSubText
        }
    }

    let settings: Settings

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        settings = try container.decode(Settings.self, forKey: .settings)
        try super.init(from: decoder)
    }

    enum CodingKeys: String, CodingKey {
        case settings
    }
}

class SPNativeSlider: SPNativeUI {
    class Settings: SPNativeUISettings {
        let onText, offText: String

        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: Keys.self)
            onText = try container.decode(String.self, forKey: .onText)
            offText = try container.decode(String.self, forKey: .offText)
            try super.init(from: decoder)
        }

        enum Keys: CodingKey {
            case onText, offText
        }
    }

    let settings: Settings

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        settings = try container.decode(Settings.self, forKey: .settings)
        try super.init(from: decoder)
    }

    enum CodingKeys: String, CodingKey {
        case settings
    }
}
