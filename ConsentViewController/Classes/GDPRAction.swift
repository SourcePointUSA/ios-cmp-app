//
//  Action.swift
//  GDPRConsentViewController
//
//  Created by Andre Herculano on 11.12.19.
//

import Foundation

/// User actions. Its integer representation matches with what SourcePoint's endpoints expect.
@objc public enum GDPRActionType: Int, Codable, CaseIterable, CustomStringConvertible {
    case SaveAndExit = 1
    case PMCancel = 2
    case AcceptAll = 11
    case ShowPrivacyManager = 12
    case RejectAll = 13
    case Dismiss = 15

    public var description: String {
        switch self {
        case .AcceptAll: return "AcceptAll"
        case .RejectAll: return "RejectAll"
        case .ShowPrivacyManager: return "ShowPrivacyManager"
        case .SaveAndExit: return "SaveAndExit"
        case .Dismiss: return "Dismiss"
        case .PMCancel: return "PMCancel"
        default: return "Unknown"
        }
    }
}

/// Action consists of `GDPRActionType` and an id. Those come from each action the user can take in the ConsentUI
@objcMembers public class GDPRAction: NSObject {
    public let type: GDPRActionType
    public let id: String?
    public let consentLanguage: String?
    public let payload: Data
    public var publisherData: [String: SPGDPRArbitraryJson?] = [:]

    public override var description: String {
        """
        GDPRAction(type: \(type), id: \(id ?? ""), consentLanguage: \(consentLanguage ?? ""), \
        payload: \(String(data: payload, encoding: .utf8) ?? ""), publisherData: \(String(describing: publisherData))
        """
    }

    public override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? GDPRAction else {
            return false
        }
        return other.type == type &&
            other.id == id &&
            other.consentLanguage == consentLanguage &&
            other.payload == payload &&
            other.publisherData == publisherData
    }

    public init(type: GDPRActionType, id: String? = nil, consentLanguage: String? = nil, payload: Data = "{}".data(using: .utf8)!) {
        self.type = type
        self.id = id
        self.consentLanguage = consentLanguage
        self.payload = payload
    }
}

/// Languages supported for Message and PM
public enum MessageLanguage: String {
    case English = "EN"
    case Bulgarian = "BG"
    case Catalan = "CA"
    case Chinese = "ZH"
    case Croatian = "HR"
    case Czech = "CS"
    case Danish = "DA"
    case Dutch = "NL"
    case Estonian = "ET"
    case Finnish = "FI"
    case French = "FR"
    case Gaelic = "GD"
    case German = "DE"
    case Greek = "EL"
    case Hungarian = "HU"
    case Icelandic = "IS"
    case Italian = "IT"
    case Japanese = "JA"
    case Latvian = "LV"
    case Lithuanian = "LT"
    case Norwegian = "NO"
    case Polish = "PL"
    case Portuguese = "PT"
    case Romanian = "RO"
    case Russian = "RU"
    case Serbian_Cyrillic = "SR-CYRL"
    case Serbian_Latin = "SR-LATN"
    case Slovakian = "SK"
    case Slovenian = "SL"
    case Spanish = "ES"
    case Swedish = "SV"
    case Turkish = "TR"
}
