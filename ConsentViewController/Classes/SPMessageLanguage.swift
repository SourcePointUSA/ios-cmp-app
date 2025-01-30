//
//  MessageLanguage.swift
//  ConsentViewController
//
//  Created by Vilas on 01/12/20.
//

import Foundation

/// Languages supported by Message and PM
@objc public enum SPMessageLanguage: Int, Codable {
    case Basque
    case BrowserDefault
    case English
    case Bulgarian
    case Catalan
    case Chinese
    case Croatian
    case Czech
    case Danish
    case Dutch
    case Estonian
    case Finnish
    case French
    case Gaelic
    case German
    case Greek
    case Hebrew
    case Hungarian
    case Icelandic
    case Indonesian
    case Italian
    case Japanese
    case Korean
    case Latvian
    case Lithuanian
    case Macedonian
    case Malay
    case Norwegian
    case Polish
    case Portuguese
    case Romanian
    case Russian
    case Serbian_Cyrillic
    case Serbian_Latin
    case Slovakian
    case Slovenian
    case Spanish
    case Swedish
    case Tagalog
    case Turkish

    public typealias RawValue = String

    public var rawValue: RawValue {
        switch self {
        // having it empty string instructs the rendering app to use the browser's locale
        case .BrowserDefault:
            return ""
        case .English:
            return "EN"
        case .Basque:
            return "EUS"
        case .Bulgarian:
            return "BG"
        case .Catalan:
            return "CA"
        case .Chinese:
            return "ZH"
        case .Croatian:
            return "HR"
        case .Czech:
            return "CS"
        case .Danish:
            return "DA"
        case .Dutch:
            return "NL"
        case .Estonian:
            return "ET"
        case .Finnish:
            return "FI"
        case .French:
            return "FR"
        case .Gaelic:
            return "GD"
        case .German:
            return "DE"
        case .Greek:
            return "EL"
        case .Hebrew:
            return "HE"
        case .Hungarian:
            return "HU"
        case .Icelandic:
            return "IS"
        case .Indonesian:
            return "ID"
        case .Italian:
            return "IT"
        case .Japanese:
            return "JA"
        case .Korean:
            return "KO"
        case .Latvian:
            return "LV"
        case .Lithuanian:
            return "LT"
        case .Macedonian:
            return "MK"
        case .Malay:
            return "MS"
        case .Norwegian:
            return "NO"
        case .Polish:
            return "PL"
        case .Portuguese:
            return "PT"
        case .Romanian:
            return "RO"
        case .Russian:
            return "RU"
        case .Serbian_Cyrillic:
            return "SR-CYRL"
        case .Serbian_Latin:
            return "SR-LATN"
        case .Slovakian:
            return "SK"
        case .Slovenian:
            return "SL"
        case .Spanish:
            return "ES"
        case .Swedish:
            return "SV"
        case .Tagalog:
            return "TL"
        case .Turkish:
            return "TR"
        }
    }
    // swiftlint:disable:next cyclomatic_complexity function_body_length
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "":
            self = .BrowserDefault
        case "EN":
            self = .English
        case "EUS":
            self = .Basque
        case "BG":
            self = .Bulgarian
        case "CA":
            self = .Catalan
        case "ZH":
            self = .Chinese
        case "HR":
            self = .Croatian
        case "CS":
            self = .Czech
        case "DA":
            self = .Danish
        case "NL":
            self = .Dutch
        case "ET":
            self = .Estonian
        case "FI":
            self = .Finnish
        case "FR":
            self = .French
        case "GD":
            self = .Gaelic
        case "DE":
            self = .German
        case "EL":
            self = .Greek
        case "HE":
            self = .Hebrew
        case "HU":
            self = .Hungarian
        case "IS":
            self = .Icelandic
        case "ID":
            self = .Indonesian
        case "IT":
            self = .Italian
        case "JA":
            self = .Japanese
        case "KO":
            self = .Korean
        case "LV":
            self = .Latvian
        case "LT":
            self = .Lithuanian
        case "MK":
            self = .Macedonian
        case "MS":
            self = .Malay
        case "NO":
            self = .Norwegian
        case "PL":
            self = .Polish
        case "PT":
            self = .Portuguese
        case "RO":
            self = .Romanian
        case "RU":
            self = .Russian
        case "SR-CYRL":
            self = .Serbian_Cyrillic
        case "SR-LATN":
            self = .Serbian_Latin
        case "SK":
            self = .Slovakian
        case "SL":
            self = .Slovenian
        case "ES":
            self = .Spanish
        case "SV":
            self = .Swedish
        case "TL":
            self = .Tagalog
        case "TR":
            self = .Turkish

        default:
            return nil
        }
    }
}
