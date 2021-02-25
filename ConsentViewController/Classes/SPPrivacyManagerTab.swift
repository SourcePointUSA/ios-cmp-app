//
//  PrivacyManagerTab.swift
//  ConsentViewController
//
//  Created by Vilas on 28/12/20.
//

import Foundation

/// Supported privacy manager tabs in PM
@objc public enum SPPrivacyManagerTab: Int {
    case Default
    case Purposes
    case Vendors
    case Features

    public typealias RawValue = String
    public var rawValue: RawValue {
        switch self {
        // having it empty string instructs the rendering app to use the defult tab of PM or the pm tab specified in the "Show Options" action
        case .Default:
            return ""
        case .Purposes:
            return "purposes"
        case .Vendors:
            return "vendors"
        case .Features:
            return "features"
        }
    }

    public init?(rawValue: RawValue) {
        switch rawValue {
        case "":
            self = .Default
        case "purposes":
            self = .Purposes
        case "vendors":
            self = .Vendors
        case "features":
            self = .Features
        default:
            return nil
        }
    }
}
