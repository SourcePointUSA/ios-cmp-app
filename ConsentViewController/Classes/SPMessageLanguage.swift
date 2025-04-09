//
//  MessageLanguage.swift
//  ConsentViewController
//
//  Created by Vilas on 01/12/20.
//

// swiftlint:disable cyclomatic_complexity

import Foundation

/// Languages supported by Message and PM
@objc public enum SPMessageLanguage: Int, Codable {
    case Albanian
    case Arabic
    case Basque
    case Bosnian_Latin
    case Bulgarian
    case Catalan
    case Chinese_Simplified
    case Chinese_Traditional
    case Croatian
    case Czech
    case Danish
    case Dutch
    case English
    case Estonian
    case Finnish
    case French
    case Galician
    case Georgian
    case German
    case Greek
    case Hebrew
    case Hindi
    case Hungarian
    case Indonesian
    case Italian
    case Japanese
    case Korean
    case Latvian
    case Lithuanian
    case Macedonian
    case Malay
    case Maltese
    case Norwegian
    case Polish
    case Portuguese_Brazil
    case Portuguese_Portugal
    case Romanian
    case Russian
    case Serbian_Cyrillic
    case Serbian_Latin
    case Slovak
    case Slovenian
    case Spanish
    case Swahili
    case Swedish
    case Tagalog
    case Thai
    case Turkish
    case Ukrainian
    case Vietnamese
    case Welsh
    case BrowserDefault

    public typealias RawValue = String

    public var rawValue: RawValue {
        switch self {
        case .Albanian: return "sq"
        case .Arabic: return "ar"
        case .Basque: return "eu"
        case .Bosnian_Latin: return "bs"
        case .Bulgarian: return "bg"
        case .Catalan: return "ca"
        case .Chinese_Simplified: return "zh"
        case .Chinese_Traditional: return "zh-hant"
        case .Croatian: return "hr"
        case .Czech: return "cs"
        case .Danish: return "da"
        case .Dutch: return "nl"
        case .English: return "en"
        case .Estonian: return "et"
        case .Finnish: return "fi"
        case .French: return "fr"
        case .Galician: return "gl"
        case .Georgian: return "ka"
        case .German: return "de"
        case .Greek: return "el"
        case .Hebrew: return "he"
        case .Hindi: return "hi"
        case .Hungarian: return "hu"
        case .Indonesian: return "id"
        case .Italian: return "it"
        case .Japanese: return "ja"
        case .Korean: return "ko"
        case .Latvian: return "lv"
        case .Lithuanian: return "lt"
        case .Macedonian: return "mk"
        case .Malay: return "ms"
        case .Maltese: return "mt"
        case .Norwegian: return "no"
        case .Polish: return "pl"
        case .Portuguese_Brazil: return "pt-br"
        case .Portuguese_Portugal: return "pt-pt"
        case .Romanian: return "ro"
        case .Russian: return "ru"
        case .Serbian_Cyrillic: return "sr-cyrl"
        case .Serbian_Latin: return "sr-latn"
        case .Slovak: return "sk"
        case .Slovenian: return "sl"
        case .Spanish: return "es"
        case .Swahili: return "sw"
        case .Swedish: return "sv"
        case .Tagalog: return "tl"
        case .Thai: return "th"
        case .Turkish: return "tr"
        case .Ukrainian: return "uk"
        case .Vietnamese: return "vi"
        case .Welsh: return "cy"
        case .BrowserDefault: return ""
        }
    }

    public init?(rawValue: RawValue) {
        switch rawValue.lowercased() {
        case "sq": self = .Albanian
        case "ar": self = .Arabic
        case "eu": self = .Basque
        case "bs": self = .Bosnian_Latin
        case "bg": self = .Bulgarian
        case "ca": self = .Catalan
        case "zh": self = .Chinese_Simplified
        case "zh-hant": self = .Chinese_Traditional
        case "hr": self = .Croatian
        case "cs": self = .Czech
        case "da": self = .Danish
        case "nl": self = .Dutch
        case "en": self = .English
        case "et": self = .Estonian
        case "fi": self = .Finnish
        case "fr": self = .French
        case "gl": self = .Galician
        case "ka": self = .Georgian
        case "de": self = .German
        case "el": self = .Greek
        case "he": self = .Hebrew
        case "hi": self = .Hindi
        case "hu": self = .Hungarian
        case "id": self = .Indonesian
        case "it": self = .Italian
        case "ja": self = .Japanese
        case "ko": self = .Korean
        case "lv": self = .Latvian
        case "lt": self = .Lithuanian
        case "mk": self = .Macedonian
        case "ms": self = .Malay
        case "mt": self = .Maltese
        case "no": self = .Norwegian
        case "pl": self = .Polish
        case "pt-br": self = .Portuguese_Brazil
        case "pt-pt": self = .Portuguese_Portugal
        case "ro": self = .Romanian
        case "ru": self = .Russian
        case "sr-cyrl": self = .Serbian_Cyrillic
        case "sr-latn": self = .Serbian_Latin
        case "sk": self = .Slovak
        case "sl": self = .Slovenian
        case "es": self = .Spanish
        case "sw": self = .Swahili
        case "sv": self = .Swedish
        case "tl": self = .Tagalog
        case "th": self = .Thai
        case "tr": self = .Turkish
        case "uk": self = .Ukrainian
        case "vi": self = .Vietnamese
        case "cy": self = .Welsh
        case "": self = .BrowserDefault
        default: return nil
        }
    }
}

// swiftlint:enable cyclomatic_complexity
